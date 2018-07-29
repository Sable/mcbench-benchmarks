function playerstruct = IPDshell(varargin)
%
% playerstruct = IPDshell
% playerstruct = IPDshell('nodisp')
%
% GENERAL:
%   IPDshell (iterated prisoner dilemma) runs the prisoner's dilemma game
%   between two personalities at a time, 20 times. Each personality is a 
%   MATLAB function that must take the form:
%
%   function response = personalityname(n,p)
%
%   The shell passes the personality function the current iteration, n,
%   (i.e. the number of times that the two personalities have been playing
%   the game +1) and the amount of points scored by their opponent on the
%   previous iteration, p. On the first iteration, p = -1.
%   (From the number of points scored, it can be inferred both what your 
%   personality did, and what the opponent personality did.)
%   
%   The personality is required to respond when called with either of two
%   strings:
%               'cooperate'     or     'defect'
%   The string must be the only output of the function.
%
%   Note: The more personalities that are used, the better the gauge of the
%       actual validity of all the personalities. Some personalities are
%       highly exploitable, so small sample sizes can skew results.
%
% SETUP:
%   (1) Place the file IPDshell.m into an empty directory.
%   (2) Each player places a folder in this directory, and the name of this
%       folder will be the player's name.
%   (3) In each player's folder they should place as many personality
%       functions as they wish, but only personality functions may be
%       placed in the player's folder. (see INSTRUCTIONS on how to create
%       an appropriate personality function)
%   (4) Once SETUP(1-3) is complete, run IPDshell in the command window.
%
%       >> IPDshell;
%
%       (IPDshell will return the structure containing all the player data
%       after the matches are completed.)
%
%       Also, displayed to the command window will be all of the matches
%       played and the scoring after each round. To supress this display,
%       as it may be cumbersome when playing large competitions, use the
%       command:
%
%       >> IPDshell('nodisp');
%
% RULES:
%   Each personality tries to score the most number of points against each
%   opponent personality during each match. P1 (a personality that is in
%   the match) will say 'cooperate' or 'defect', as will P2. Points are
%   then awarded to P1 and P2 based on the combination of their answers.
%   Below is the chart the scoring is based on:
%
%                                P2
%                       cooperate   defect
%
%             cooperate   3 - 3     0 - 5
%         P1 
%              defect     5 - 0     1 - 1
%
%
%   The scoring rubric gives points according to (P1 - P2). The decision to
%   cooperate or defect will be made by both parties 20 times in
%   succession. Each time a decision must be made, the  personality is
%   supplied with two pieces of information that may be used to make their
%   decision, or that may be ignored. (1)The number of times they have
%   played the game with this particular opponent, and (2)The number of
%   points their opponent scored the last time they played.
%
%   The maximum score in a competition for any personality is 100 points,
%   earning 5 points during each of the 20 decisions by defecting when the
%   opponent cooperates.
%
%   Games are played 20 times between two personalities, which constitutes
%   a match. Matches are played between every personality available,
%   however, personalities made by the same player do not play matches
%   against each other to avoid collusion.
%
%   Deciding the competition winner:
%   The personality that scores the most average points per match is the
%   most successful, and so the player who employs that personality is
%   declared the winner.
%
%   v1.02
%   %%% ZCD 2006 %%%


% Build player structure
[playerstruct] = BuildPlayerStruct;
% Get the schedules of personalities that will be playing against each
% other in an array, schedule.
schedule = BuildMatchSchedule(playerstruct);
schedsize = size(schedule); % BUGFIX: Must use # of rows in case of 1 match

% ============= Begin the competition: ==============
for mn=1:schedsize(1) % number of matches  (mn = match number) 
    
    % reset scoring matrix
    ScoreMat = [-1 -1];
    
    % Pick out the appropriate match from schedule.
    match = schedule(mn,:);
    
    % Begin particular match
    for n=1:20              % 20 rounds
        
        % Evaluate each player personality. Do not use the last 2 characters of
        % the personality name, '.m' This is where the personality makes
        % the decision to cooperare or defect, and their function is
        % called.
        % ----
        response{1} = eval( [playerstruct(match(1)).personality(1:end-2),'(n,ScoreMat(end,2))'] );
        response{2} = eval( [playerstruct(match(2)).personality(1:end-2),'(n,ScoreMat(end,1))'] );
        % ----

        % score the outcomes:
        if isequal('cooperate',response{1}) & isequal('cooperate',response{2})
            ScoreMat(n,1)=3; ScoreMat(n,2)=3;
        elseif isequal('defect',response{1}) & isequal('cooperate',response{2})
            ScoreMat(n,1)=5; ScoreMat(n,2)=0;
        elseif isequal('cooperate',response{1}) & isequal('defect',response{2})
            ScoreMat(n,1)=0; ScoreMat(n,2)=5;
        elseif isequal('defect',response{1}) & isequal('defect',response{2})
            ScoreMat(n,1)=1; ScoreMat(n,2)=1;
        else
            error(' ======= There is an uncooperative personality. ======= ');
        end

    end                 % end round
    
    % keep score for each personality, and track number of matches played
    playerstruct(match(1)).score = sum(ScoreMat(:,1)) + playerstruct(match(1)).score;
    playerstruct(match(1)).nummatches = playerstruct(match(1)).nummatches + 1;
    playerstruct(match(2)).score = sum(ScoreMat(:,2)) + playerstruct(match(2)).score;
    playerstruct(match(2)).nummatches = playerstruct(match(2)).nummatches + 1;
    
    % Allow user to turn off display
    if isempty(varargin)
        GraphicDisplay(playerstruct,ScoreMat,match);
    elseif isequal(varargin{1},'nodisp')
        % Supress match scores display to command window.
    else
        error('=== Invalid input to IPDshell ===');
    end
    
end                     % end match
% ============= END COMPETITION ===============

% Display final results.
Results(playerstruct);

    
 



% -----------------------------------------------------
function [playerstruct] = BuildPlayerStruct
%
% Builds the structure containing player names and personalities from the
% player files. File names are player names and function names are
% personality names. Each index in playerstruct corrisponds to a
% personality. Each index in playerstruct has the following fields:
%
% playerstruct
% .playername   :   name of the player that this personality belongs to
% .playerdir    :   directory path that the personality is in
% .personality  :   name of the personality
% .score        :   total number of points earned by this personality
% .nummatches   :   number of matches that this personality played
%
%
% %%% ZCD 2006 %%%


% Put all contents of the directory into 'files'
files = dir(cd);
% Count the number of total personalities (equal to length(playerstruct)
% once the playerstruct is built.
np = 0;
% Count the number of players.
nplayer = 0;    % as of v1.01 this is unused

% Obtain the contents of the player directories, search for player
% directories, and load player names and player personalities into the
% structure playerstruct.
for n=1:length(files)
    % if the entry in files is a directory and not a path...
    if (files(n).isdir)  &  (files(n).name(1)~='.')
        % We found another player
        nplayer = nplayer+1;
        
        % Obtain all personalities in the player's file
        playerfiles = dir( strcat(cd,'\',files(n).name,'\*m') );
        
        for k=1:length(playerfiles)
            np = np+1; % We found another personality
            % Get the player's name (same as their folder's name)
            playerstruct(np).playername = files(n).name;
            playerstruct(np).playerdir = strcat(cd,'\',playerstruct(np).playername);
         
            % Put all the names of the personalities in the field
            % 'personality'
            playerstruct(np).personality = playerfiles(k).name;
            
            % Keep fields for scores and total number of games played
            playerstruct(np).score = 0;
            playerstruct(np).nummatches = 0;

        end
        % Empty out playerfiles for the next player
        clear playerfiles

        % Add the player folders to the MATLAB path
        addpath(playerstruct(np).playerdir);
    end
end


% -----------------------------------------------------
function GraphicDisplay(playerstruct,ScoreMat,match)
%
fprintf('\n\n  %s  %s \n',playerstruct(match(1)).playername,...
    playerstruct(match(2)).playername);
fprintf('  %s  %s \n', playerstruct(match(1)).personality(1:end-2),...
    playerstruct(match(2)).personality(1:end-2));
disp(ScoreMat);


% -----------------------------------------------------
function schedule = BuildMatchSchedule(playerstruct)
%
% This builds the schedule of matches to be played. It checks each
% personality against each other, looking for weather the playername
% is the same. If playernames are the same, the corrisponding match is not
% placed into schedule.
% Schedule is a nx2 array where each row is one match to be played, and
% each column is the index in playerstruct of the two personalities playing.
%
%
% %%% ZCD 2006 %%%

% Initialize schedule variable
schedule = [];

for h = 1:length(playerstruct)
    % Don't recount any of the personalities, they have been checked
    % already by the i loop in the past h iteration. So, now we can start
    % checking from h+1. This also avoids repeat matches.
    for i = (h+1) : length(playerstruct)
        % if the h player's maker is not the same as the i players maker...
        if ~strcmp(playerstruct(h).playername , playerstruct(i).playername)
            
            % ...they should play each other
            schedule(end+1,:) = [h i];
        end
    end
end
        
% -----------------------------------------------------
function Results(playerstruct)
%
% This function displays the results of the competition in a bar graph,
% sorted from highest scoring personality to lowest. If there are more than
% 6 personalities only the top 5 appear in the bar graph, the rest apear as
% names and scores only. If there are more than 20, only the top 20 are
% shown.
%
% This function takes the argument, playerstruct, created in function
% BuildPlayerStruct.
%
% %%% ZCD 2006 %%%

h1 = figure('name','IPD RESULTS','NumberTitle','off');

% Calculate average score and assign it to Y. Assign the corrisponding name
% and assign it to X.
for i=1:length(playerstruct)
    Y(i) = playerstruct(i).score / playerstruct(i).nummatches;
    X{i} = [playerstruct(i).playername,': ',playerstruct(i).personality(1:end-2)];
end
% Total number of competitors in cnum
cnum = length(Y);

% Sort Y, but retain the corrisponding name in Xsrt.
[Ysrt IX] = sort( Y, 'descend' );
for i=1:length(Y)
    indsort = IX(i);
    Xsrt(i) = X(indsort);
end

if length(Y)<=6
    bar(Y)
    colormap summer    
    set( gca, 'XTickLabel', X );    
else    
    Ym = [Ysrt(1:5) 0];
    Xm = Xsrt(1:5); Xm{6} = 'Field';
    bar(Ym)
    colormap summer
    set( gca, 'XTickLabel', Xm );
    for i=6:length(Y)
        % Define placement of text string
        text( 5.6, Ysrt(1)-(i-6.5)*(Ysrt(1)/15),...
            [ Xsrt{i} ' - '  num2str(Ysrt(i)) ],...
            'BackGroundColor', 'w', 'FontWeight', 'bold' );
        if i==20
            cnum = i;
            break
        end
    end
    set( gcf, 'Position', [70  373  1502  547] );
end

if length(Y)<21
    title( [ 'Rank Order and Score of All ', num2str(cnum), ' Competitors' ] );
else
    title( [ 'Rank Order and Score of Top ', num2str(cnum), ' Competitors' ] );
end

ylabel('Average Points Earned by Personality');
grid on;







