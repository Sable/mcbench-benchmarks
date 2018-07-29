function ZYahtzee(np)
% Play text-based Yahtzee!
%
% ZYAHTZEE
% ZYAHTZEE(n), where n is the number of players.
%
% All standard Yahtzee rules apply.
%
% On your turn, you may roll the dice up to 3 times, although you may stop
% and score after your first or second roll. The 1st roll will be done
% automatically and displayed next to the "your roll" field. The 1st roll
% of each turn is of 5 6-sided dice. For your 2nd or 3rd rolls you may keep
% any or all of the dice of your previous roll. Select which rolls to keep
% by entering their die number(s) in the prompt. (You are now no longer
% required to enter spaces when deciding which dice to hold, i.e.,
% entering 125 will hold dice numbers 1, 2, and 5.)
%
% In addition to entering numbers in the prompt, you may enter "all" to
% hold all dice, enter to reroll all dice or "quit" to exit the game.
%
% Once you have held all dice or taken 3 rolls on this turn, you select the
% category to apply the roll to, and earn points accordingly. Your score
% sheet will be updated according to standard Yahtzee rules. You will be
% allowed 13 total turns per game.
%
% Good luck, and good dice.
%
% For more information see the official rules at:
% http://www.hasbro.com/common/instruct/Yahtzee.pdf
%
% Technical Note: You may wish to randomize the seed of MATLAB's random
% number generators prior to playing to avoid games that are the same, or
% even insert a randomization line at the beginning of this code.
%
%
% %%% ZCD June 2010 %%%
%

% Edits (ZCD) July 2010:
%   * fixed spelling error in game board
%   * do not accept bad die number inputs (instead of ignoring them)
%   * added statistics "easter egg"
%   * added multi-player versus capability
%   * automatically score final roll
% Edits (ZCD) August 2010:
%   * fixed improper Yahtzee points allocations in versus mode
%   * adjusted figure location on stats display
% Edits (ZCD) September 2010:
%   * added features to stats bonus display
%   * will save scores to appropriate directory (even when not in that dir)
% Edits (ZCD) February 2011:
%   * there is now no need to include spaces when entering held die numbers


% check inputs
if nargin == 0
    np=1;
elseif ~(np>0 && real(np) && numel(np)==1)
    error('Invalid input for number of players.')
end
% display variable for multiple players
pz = [np 1:np-1];

% set up initial points array
points = ones(13,np)*NaN;
% roll variable
roll = zeros(1,5);

% main game loop runs 13 rounds, with 3 throws per round
for r = 1:13
    % run one round loop per player
    for p = 1:np
    % when playing with multiple players, briefly show the previous
    % player's updated board
    if np>1 && ~(p==1 && r==1)
        clc
        dispPoints(points(:,pz(p)),zeros(1,5),0,pz(p));
        pause(1.5)
    end
        
    % initialize our rerolls variable
    rerolls = 1:5;
    % set up for a bonus yatzee
    bflag = 0; strbonus = '';
    
    for t = 1:3
        % throw the dice
        roll(rerolls) = randi(6,[1 length(rerolls)]);
        % show the user the game state
        dispPoints(points(:,p),roll,t,p);
        
        % --- do special yahtzee things ---
        % check for yahtzee
        fq = hist(roll,1:6);
        if any(fq==5)
            if isnan(points(13,p))
                points(13,p) = 50;
                dispPoints(points(:,p),roll,t,p);
                % be excited about the yahtzee
                disp(' ');disp('YAHTZEE!');disp(' ');pause(3);
                break;
            elseif points(13,p)>0
                points(13,p) = points(13,p)+100;
                dispPoints(points(:,p),roll,t,p);
                disp(' ');
                disp(['BONUS YAHTZEE' repmat('!!',[1 (points(13,p)-50)/100])]);
                disp(' ');pause(3);
                bflag = 1;
                strbonus = 'BONUS ';
                action = 'all';
            elseif points(13,p)==0
                bflag = 1;
                action = 'all';
                disp(' ')
                disp('Seems like you shouldn''t have taken a zero for Yahtzees.')
                disp(' ');pause(3);           
            end
        end        
        % there are special restrictions when the joker scoring
        % for bonus yahtzees are in effect
        if bflag
            % you must fill the top if its available
            if isnan(points(roll(1)))
                points(roll(1),p) = scoreLogic(roll,roll(1));
                break;
            end
        end
        % --- end special yahtzee things ---
        
        
        % obtain the user action
        if t<3 && ~bflag
            keepflag = 1;
            while keepflag
                action = input('Which die numbers do you keep?   ','s');
                % separate each character by a space
                sAction = blanks(2*length(action)); % long row of blanks
                sAction(1:2:end) = action;          % interleave with choies
                % check for bad inputs
                [actstr cf] = str2num(sAction);
                if ( isempty(setdiff(actstr,1:5)) && cf ) || any(strcmp(action,{'','all','quit'}))
                    % accept this input if it is a (legit die # AND we can
                    % do a succesful number conversion on it) OR its a
                    % special word ('' all or quit).
                    keepflag = 0;
                else
                    disp('invalid die number')
                end
            end
        end
        % take user action
        switch action
            case 'all'
                rerolls = [];
            case 'quit'
                return;
            otherwise
                % obtain which die indicies we are to reroll
                % rerolls = setxor(str2num(action),1:5);
                rerolls = setxor(str2num(sAction),1:5);
        end
        
        % get the score placement
        if t==3 || isempty(rerolls) || bflag
            catflag = 1;        % viable category choice
            % make sure this is an appropriate category
            while catflag
                % if this is the final turn, we know the category
                if sum(isnan(points(:,p))) == 1
                    catflag = 0;
                    catg = find(isnan(points(:,p)));
                    points(catg,p) = scoreLogic(roll,catg,bflag);
                    pause(1.5);
                else
                    % ask user for category
                    response = input(['Mark ' strbonus 'score in which category?   '],'s');
                    % the only valid string here is 'quit' which exits the
                    % game now
                    if strcmpi(response,'quit')
                        return;
                    else
                        catg = str2double(response);
                    end
                    % if we are in the right category range and do not yet have
                    % a score for that category we allow the assignment
                    if catg>0 && catg<14 && isnan(points(catg,p))
                        catflag = 0;
                        % get the category score
                        points(catg,p) = scoreLogic(roll,catg,bflag);
                    else
                        disp('invalid category')
                    end
                end
            end
            break;
        end
        
    end % throw loop
    end % player loop
end     % round loop


% --- End game operations ---
clc
gtotal = zeros(1,np);
for p=1:np
    % give final accounting to the player
    gtotal(p) = dispPoints(points(:,p),zeros(1,5),0,p);
end
for p=1:np
    % run score records
    highScores(gtotal(p),points(13,p),[np p])
end
if np>1
    % interleave player no and score
    c = [1:np;gtotal];
    s = sprintf('Player%d: %d,  ',c(:));
    disp(s(1:end-3)); disp(' ')
    disp(['PLAYER ' num2str(find(gtotal==max(gtotal))) ' WINS' repmat('!',[1 np])])
    disp(' ')   
end
% ---------------------------






    function score = scoreLogic(roll,cat,joker)
        score = 0;
        % how many points is this roll worth to this category?
        switch cat
            case {1 2 3 4 5 6}
                score = sum(roll==cat)*cat;
            case 7
                fq = hist(roll,1:6);
                if any(fq>2) || joker, score = sum(roll); end
            case 8
                fq = hist(roll,1:6);
                if any(fq>3) || joker, score = sum(roll); end
            case 9
                fq = hist(roll,1:6);
                if all(diff(sort(fq))==[0 0 0 2 1]) || joker
                    score = 25;
                end
            case 10
                if ~isempty( strfind(diff(unique(roll)),[1 1 1]) ) || joker
                    score = 30;
                end
            case 11
                if ~isempty( strfind(diff(unique(roll)),[1 1 1 1]) ) || joker
                    score = 40;
                end
            case 12
                score = sum(roll);
            case 13
                % case dealt with earlier in code
        end 
    end

    function gtotal = dispPoints(points,roll,t,p)
    % display the current game state
        % clear the command window
        if t~=0 clc; end
        
        % displays current points to the user
        slots = {'1: ones';'2: twos';'3: threes';'4: fours';'5: fives';...
            '6: sixes';'-->bonus (35/63)';'-->Top Subtotal';'7: set';'8: quads';...
            '9: boat';'10: 4-straight';'11: 5-straight';'12: Chance';...
            '13: YAHTZEE';'-->Bottom Subtotal';'-->Grand Total'};
        % top subtotal
        top = nansum(points(1:6));
        % do we have a bonus?
        if top<63, b=0; else b=35; end
        % bottom subtotal
        bot = nansum(points(7:13));
        
        gtotal = top+b+bot;
        
        % concatenate all our points information according to the
        % description in the slots variable
        disp(' ')
        disp(['PLAYER: ' num2str(p)])
        disp([slots,num2cell( [points(1:6);b;top+b;points(7:13);bot;gtotal] )])
        disp(' ')
        if t~=0
            disp(['Roll  ' num2str(t) '/3'])
            fprintf('Your Roll:    %d   %d   %d   %d   %d\n',roll)
            fprintf('Die Number:  (1) (2) (3) (4) (5)\n')
        end
    end



    function highScores(total,yah,np)
        dirFiles = dir(strrep(mfilename('fullpath'),mfilename,''));
        if ~any(strcmp({dirFiles.name},'YahtzeeRecords.mat'))
            scores = {'Player' 'Score' 'Date' 'Yahtzees' 'Rank'};
        else
            load('YahtzeeRecords')
        end
        
        name = inputdlg('Enter Your Name For Record Keeping',['Player ' num2str(np(2))]);
        if isempty(name), return; end
        name = name{1};
        if length(name)>15
            name = name(1:15);
        end
        
        if yah~=0, yah = mod(yah,99)-49; end
        
        scores(end+1,:) = {name total datestr(now,1) yah ''};
        
        sc = scores(2:end,2);
        [B IX] = sort([sc{:}]','descend');
        
        scores(2:end,:) = scores(IX+1,:);
        scores(2:end,end) = num2cell(1:size(scores,1)-1);
        save([strrep(mfilename('fullpath'),mfilename,'') 'YahtzeeRecords'],'scores');
        
        if size(scores,1)>10
            dispLengthTop = 10;
        else
            dispLengthTop = size(scores,1);
        end
        curRank = find(B==total,1,'last');
        if curRank>=dispLengthTop
            dispLengthNow = [curRank-3:curRank+3];
            if ~isempty(find(dispLengthNow==size(scores,1)))
                dispLengthNow = dispLengthNow(1:find(dispLengthNow==size(scores,1)));
            end
        else
            dispLengthNow = [];
        end
        
        disp(' ');disp(' ');
        disp(scores(1:dispLengthTop,:));
        if ~isempty(dispLengthNow)
            disp('     ...............................');
            disp(scores([1 dispLengthNow],:));
        end
        disp(' ');
        
        % occasionally do some interesting stats
        if rand>0.85 && size(scores,1)>5 && np(1)==1
            % print stats to screen
            disp(' '); disp('Your Statistics:'); disp(' ')
            tg = size(scores,1)-1;
            fprintf('Total games played: %g, Average games per day: %g\n\n',...
                [tg, tg/(etime(datevec(max(datenum(scores(2:end,3)))),...
                datevec(min(datenum(scores(2:end,3)))))/(60*60*24))]);
            disp('Correlation between scores and Yahtzees')
            rho = corrcoef([scores{2:end,2}],[scores{2:end,4}]);
            disp(rho(2))
            disp('Correlation between scores and the date')
            rho = corrcoef([scores{2:end,2}],datenum(scores(2:end,3)));
            disp(rho(2))
            disp('Correlation between scores and rank')
            rho = corrcoef([scores{2:end,2}],[scores{2:end,end}]);
            disp(rho(2))
            disp(' ')
            disp(['Mean of scores: ' num2str(mean([scores{2:end,2}]))])
            disp(['Standard deviation of scores: ' num2str(std([scores{2:end,2}]))])
            disp(' ')
            ny = repmat(unique([scores{2:end,4}]),[2 1]);
            eval(sprintf('disp([''Mean for %d Yahtzees: '' num2str( mean( [scores{[false %d==[scores{2:end,4}]],2}] ) )]), ',ny(:)'))
            disp(' ')
            eval(sprintf('disp( [''Best score for %d Yahtzees: '' num2str(max([scores{[false scores{2:end,4}]==%d,2}]))] ), ',ny(:)'))
            disp(' ')
            disp(['Average Yahtzee''s per game: ' num2str(sum([scores{2:end,4}])/scores{end,end})]);            
            disp(' ')            
            
            % print stats to figure
            hh = figure;
            subplot(3,1,1)
            hist([scores{2:end,2}])
            xlabel('Scores'); ylabel('Frequency')
            subplot(3,1,2)
            d = datenum(scores(2:end,3));
            du = unique(d);
            x = zeros(1,length(du)); xs=x;
            for i=1:length(du)
                x(i) = mean([scores{[false; d==du(i)],2}]);
                xs(i) = std([scores{[false; d==du(i)],2}]);
            end
            if any(xs)
                [bds ibds] = max(x(xs~=0)); bdd = du(xs~=0);
                fprintf(' Best day (with more than 1 game played), %s, has mean score of %g\n',datestr(bdd(ibds)),bds)
                [bds ibds] = min(x(xs~=0)); bdd = du(xs~=0);
                fprintf('Worst day (with more than 1 game played), %s, has mean score of %g\n',datestr(bdd(ibds)),bds)
            end
            ln = pinv([ones(length(x),1) (1:length(x))'])*x';
            plot(x,'-.sb','linewidth',2), hold on
            line(1:length(x),ln(1)+(1:length(x)).*ln(2),'color','r')
            set(gca,'Xtick',[])
            xlabel('Increasing Date (days) \rightarrow'); ylabel('Mean Score')
            legend('day score','linear fit','location','best')
            subplot(3,1,3)
            plist = unique(scores(2:end,1));
            x = zeros(1,length(plist));
            for i=1:length(plist)
                tmp = [scores{boolean([0; strcmpi(plist{i},scores(2:end,1))]),2}];
                x(i) = mean(tmp);
                plist{i} = [plist{i} ': ' num2str(length(tmp))];
            end
            [xb IX] = sort(x(1,:),'descend');
            if length(plist)<=6, lp=length(plist); else lp = 6; end
            bar(xb(1:lp),'r'); xlim([0.5 lp+0.5])
            set(gca,{'xtick','fontsize','xticklabel'},{1:lp,8,plist(IX(1:lp))})
            ylabel('Mean Score'); xlabel('Player: Games Played')
            disp(' ');
        end
    end

end