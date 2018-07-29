function TexasHoldEmSimulator(varargin)
%--------------------------------------------------------------------------
% Syntax:       TexasHoldEmSimulator;
%               TexasHoldEmSimulator(NumPlayers);
%               TexasHoldEmSimulator(FlopTurnRiverMode);
%               TexasHoldEmSimulator(NumPlayers,FlopTurnRiverMode);
%               TexasHoldEmSimulator(FlopTurnRiverMode,NumPlayers);
%
% Inputs:       NumPlayers is the number of players in the poker game. If
%               not specified, the user is prompted to enter this
%               information during execution.
%
%               FlopTurnRiverMode can be {'Manual','Random'} and specifies
%               whether the user will manually enter the Flop/Turn/River
%               cards or if the program should randomly generate them. If
%               not specified, the user is prompted to enter this
%               information during execution.
%
% Description:  This function interactively simulates the probability of
%               each player winning a hand of Texas Hold'Em Poker given
%               their respective hole cards after 1) the Deal, 2) the Flop,
%               and 3) the Turn. Finally, after the River, this program
%               displays the actual results of the hand.
%
% Method:       Monte Carlo simulation is used to estimate all
%               probabilities of interest.
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         September 15, 2012
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Program constants that you may adjust if desired
%--------------------------------------------------------------------------
%
% Number of Monte Carlo simulations to run
%
NUM_MONTE_CARLO_SIMS = 3000;

%
% Update Monte Carlo plots after every UPDATE_PLOT_SPACING simulations
%
UPDATE_PLOT_SPACING = 100;

%
% Determines whether or not to display percentage values on the Monte Carlo
% plots by default
%
DefaultDisplayPercentages = false; % can be {true,false}

%
% Determines whether or not to play music during program execution
%
PlayMusic = true;  % can be {true,false}

%
% Path + filename + extension to a .wav file to play during Monte Carlo
% execution
%
% Note: monteCarloMusic is played only when PlayMusic = true
%
monteCarloMusic = 'jeopardy.wav'; % must be a .wav file!

%
% Path + filename + extension to a .wav file to play at Showdown
%
% Note: showdownMusic is played only when PlayMusic = true
%
showdownMusic = 'applause.wav'; % must be a .wav file!

%
% Define number of cards added at each step
%
NumHoleCards = 2;
NumFlopCards = 3;
NumTurnCards = 1;
NumRiverCards = 1;

%
% The card strings in descending order of value (Cards{1} is highest card)
%
% Note: Each card string can be any desired length
%
Cards = {'A','K','Q','J','10','9','8','7','6','5','4','3','2'};

%
% The suit symbols in descending order of value (Suits{1} is highest suit)
%
% Note: Each suit string must be a SINGLE CHARACTER
%
Suits = {'S','D','H','C'};

%
% Cell array that describes the valid poker hands
%
% Each row describes a valid poker hand listed in descending order of value
% Row format: {Name string, Description string, Identifier/label string}
% 
% NOTE: Don't change the Identifier/label strings (3rd column) unless you
% are prepared to modify the BestHand() function
%
% NOTE: If you want to create your own hand, you'll have to add a case that
% recognizes your Identifer/label string to the switch statement in the 
% BestHand() function
%
Hands = {'Royal Flush','AKQJ10 of same suit','RF';
         'Straight Flush','5 consecutive cards of same suit','SF';
         'Four of a Kind','4 cards of same number','4K';
         'Full House','3 cards of one number and 2 cards of another number','FH';
         'Flush','5 cards of 1 suit','F';
         'Straight','5 consecutive cards (suit doesn''t matter)','S';
         'Three of a Kind','3 cards of same number','3K';
         'Two Pair','2 cards each of 2 different numbers','2P';
         'One Pair','2 cards of same number','1P';
         'High Card','Highest card in hand','H';
         };

%
% Program name
%
ProgramName = 'TexasHoldEmSimulator v1.0.0';

%
% String to display upon exiting the program via 'Exit'
%
ExitMessageStr = '"Thanks for playing!" - Brian Moore';

%
% Organization of subplots for simulation graphs
%
% Note: If there are more than 8 players, the hand distribution plots for
% players 9+ will not be displayed unless you add rows to SubplotOrgChart
% that define a subplot structure to use in those cases
% 
% The ith row of SubplotOrgChart describes the subplot structure of
% the Monte Carlo simulation figures for i players.
%
% Format: (Assuming i players)
%
% Probability of Winning Plot Location:
%
% subplot(SubplotOrgChart{i,1}, ...
%         SubplotOrgChart{i,2}, ...
%         SubplotOrgChart{i,3})
% 
% Hand Distribution Plot Location (for the jth player, 1 <= j <= i):
%
% subplot(SubplotOrgChart{i,1}, ...
%         SubplotOrgChart{i,2}, ...
%         SubplotOrgChart{i,4}(j))
%
SubplotOrgChart = {1,2,1,2;
                   2,2,[1,2],[3,4];
                   2,2,1,[2,3,4];
                   2,3,[1,2],[3,4,5,6];
                   2,3,1,[2,3,4,5,6];
                   2,4,[2,3],[1,4,5,6,7,8];
                   2,4,1,[2,3,4,5,6,7,8];
                   3,3,5,[1,2,3,4,6,7,8,9]};
%--------------------------------------------------------------------------

% Initialize size variables
NumCards = length(Cards);
NumSuits = length(Suits);
DeckSize = NumCards * NumSuits;
NumHands = size(Hands,1);
MaxPlayersToPlot = size(SubplotOrgChart,1);
outerFnCall = true;

% Set font size based on OS
if strcmpi(getenv('os'),'Windows_NT')
    % Windows computer
    fontSize = 12;
else
    % Mac, presumably
    fontSize = 14;
end

% Load music if requested
monteCarloAudioPlayer = [];
showdownAudioPlayer = [];
if PlayMusic
    if exist(monteCarloMusic,'file')
        [wav Fs Nbits] = wavread(monteCarloMusic);
        monteCarloAudioPlayer = audioplayer(wav,Fs,Nbits);
    end
    if exist(showdownMusic,'file')
        [wav Fs Nbits] = wavread(showdownMusic);
        showdownAudioPlayer = audioplayer(wav,Fs,Nbits);
    end
end

% Process user input
if (nargin == 1)
    if ischar(varargin{1})
        FlopTurnRiverMode = varargin{1};
        NumPlayers = NaN;
    else
        NumPlayers = varargin{1};
        FlopTurnRiverMode = NaN;
    end
elseif (nargin == 2)
    if ischar(varargin{1})
        FlopTurnRiverMode = varargin{1};
        NumPlayers = varargin{2};
    else
        FlopTurnRiverMode = varargin{2};
        NumPlayers = varargin{1};
    end
else
    FlopTurnRiverMode = NaN;
    NumPlayers = NaN;
end

% Print some stuff
DisplayHelp;

%
% Put everything in a try-catch block to allow a graceful exit when user
% types 'Exit'
% 
% Note: All exceptions that do not carry ExitMessageStr are re-thrown
%
try
%--------------------------------------------------------------------------
% Get any information that wasn't passed in the function call
%--------------------------------------------------------------------------
% Get number of players at the table (if necessary)
if isnan(NumPlayers)
    NumPlayers = str2double(ProcessUserInput('How many players at the table? '));
    while ~isfinite(NumPlayers)
        NumPlayers = str2double(ProcessUserInput('Invalid number. Try again: '));
    end
end

% Get FlopTurnRiverMode (if necessary)
if sum(isnan(FlopTurnRiverMode))
    str = ProcessUserInput('Enter Flop/Turn/River Cards Manually? (y or n): ');
    if sum(strcmpi(str,'y'))
        FlopTurnRiverMode = 'Manual';
    else
        FlopTurnRiverMode = 'Random';
    end
end
%--------------------------------------------------------------------------

% Initialize deck
Deck = 1:DeckSize;

%--------------------------------------------------------------------------
% Get everyone's hole cards
%--------------------------------------------------------------------------
PlayersCards = zeros(NumPlayers,NumHoleCards);
for i = 1:NumPlayers
    PlayersCards(i,:) = ParseHoleCards(sprintf('What are Player %s''s hole cards? ',num2str(i)));
end
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Perform Monte Carlo simulations after each betting round
%--------------------------------------------------------------------------
% Simulate winning percentages and hand-distributions based on hole cards
SimulateHand([],'Deal');

% Get the Flop
if strcmpi(FlopTurnRiverMode,'Manual')
    FlopTurnRiver = GetCards('What was the Flop? ',NumFlopCards);
else
    flop = DrawCards(NumFlopCards);
    fprintf(['\nThe Flop was: ' GetHandString(flop) '\n']);
    FlopTurnRiver = flop;
end

% Simulate winning percentages up to (and including) the Flop
SimulateHand(FlopTurnRiver,'Flop');

% Get the Turn
if strcmpi(FlopTurnRiverMode,'Manual')
    FlopTurnRiver = [FlopTurnRiver GetCards('What was the Turn? ',NumTurnCards)];
else
    turn = DrawCards(NumTurnCards);
    fprintf(['\nThe Turn was: ' GetHandString(turn) '\n']);
    FlopTurnRiver = [FlopTurnRiver turn];
end

% Simulate winning percentages up to (and including) the Turn
SimulateHand(FlopTurnRiver,'Turn');
%--------------------------------------------------------------------------

% Get the River
if strcmpi(FlopTurnRiverMode,'Manual')
    FlopTurnRiver = [FlopTurnRiver GetCards('What was the River? ',NumRiverCards)];
else
    river = DrawCards(NumRiverCards);
    fprintf(['\nThe River was: ' GetHandString(river) '\n']);
    FlopTurnRiver = [FlopTurnRiver river];
end

% Determine results of hand
[handRanking handResults] = HandResults(FlopTurnRiver);

%--------------------------------------------------------------------------
% Display hand results
%--------------------------------------------------------------------------
% Play music if requested
if ~isempty(showdownAudioPlayer)
    play(showdownAudioPlayer);
end

% Show the winning hand seperately
line1 = ' The Winner is '; len1 = length(line1);
line2 = ['Player ' num2str(handRanking(1))]; len2 = length(line2);
if (handResults(handRanking(1),1) > NumHands)
    line3 = '| Hand: ???                |'; len3 = length(line3);
else
    line3 = ['| Hand: ' Hands{handResults(handRanking(1),1),1} ' - ' GetHandString(handResults(handRanking(1),2:end)) ' |']; len3 = length(line3);
end
fprintf(sprintf('\n%s',['+' repmat('-',1,floor((len3 - len1 - 2) / 2)) line1 repmat('-',1,ceil((len3 - len1 - 2) / 2)) '+']));
fprintf(sprintf('\n%s',['|' repmat(' ',1,floor((len3 - len2 - 2) / 2)) line2 repmat(' ',1,ceil((len3 - len2 - 2) / 2)) '|']));
fprintf(sprintf('\n%s',line3));
fprintf(sprintf('\n%s\n',['+' repmat('-',1,len3 - 2) '+']));

% Show the rest of the hands
for i = 2:NumPlayers
    if (handResults(handRanking(i),1) > NumHands)
        handStr = '???';
    else
        handStr = [Hands{handResults(handRanking(i),1),1} ' - ' GetHandString(handResults(handRanking(i),2:end))];
    end
    fprintf(['\nPlayer ' num2str(handRanking(i)) '\nHand: ' handStr '\n']);
end
%--------------------------------------------------------------------------

% Ask user if they want to simulate another hand
str = ProcessUserInput('Simulate another hand? (y or n): ');
if sum(strcmpi(str,'y'))
    outerFnCall = false;
    TexasHoldEmSimulator(NumPlayers,FlopTurnRiverMode);
end
catch e
    if ~strcmpi(e.message,ExitMessageStr)
        throw(e);
    end
end

% Goodbye!
if outerFnCall, fprintf(sprintf('\n%s\n\n',ExitMessageStr)); end;

%--------------------------------------------------------------------------
% Nested functions
%--------------------------------------------------------------------------
% Simulate the rest of a hand given the current FlopTurnRiver state
function SimulateHand(flopTurnRiver,dispStr)
    % Play music during simulation if requested
    if ~isempty(monteCarloAudioPlayer)
        play(monteCarloAudioPlayer);
    end
    
    % Save Players cards state
    playersCardsCache = PlayersCards;
    
    % Save deck state
    deckCache = Deck;
    
    % Save FlopTurnRiver state
    flopTurnRiverCache = flopTurnRiver;
    numDraws = NumFlopCards + NumTurnCards + NumRiverCards - length(flopTurnRiver);
    
    % Find locations of hands to fill in
    emptyHandInds = find(PlayersCards == 0);
    
    % Initialize reporting variables
    winCount = zeros(1,NumPlayers);
    handCount = zeros(NumPlayers,NumHands);
    
    % Generate simulation output figure
    if DefaultDisplayPercentages
        boolVal = 1;
    else
        boolVal = 0;
    end
    f = figure('name',[ProgramName ' - Monte Carlo Simulation - After ' dispStr ' - Brian Moore 2012']);
    cb1 = uicontrol(f,'Style','checkbox','Value',boolVal,'String',char(37),'Position',[10 30 60 20],'HorizontalAlignment','left','FontSize',fontSize-2,'Background',get(f,'Color'),'callback',@checkboxCallback);
    cb2 = uicontrol(f,'Style','text','String','','Position',[10 5 500 20],'HorizontalAlignment','left','FontSize',fontSize-2,'Background',get(f,'Color'));
    npp = min(MaxPlayersToPlot,NumPlayers);
    DisplayPercentages = DefaultDisplayPercentages;
    UpdatePlots(f,0);
    
    % Perform Monte Carlo simulation
    for idx = 1:NUM_MONTE_CARLO_SIMS
        % Check if any player hands need to be randomly generated
        if ~isempty(emptyHandInds)
            % Recall original deck state
            Deck = deckCache;
            
            % Randomly generate unknown hands
            for kdx = 1:length(emptyHandInds)
                PlayersCards(emptyHandInds(kdx)) = DrawCards(1);
            end
        end
        
        % Generate rest of FlopTurnRiver randomly
        ftr = [flopTurnRiverCache RandomDraw(numDraws)];
        
        % Determine outcome of hand
        [ranking Results] = HandResults(ftr);
        
        % Save statistics
        winCount(ranking(1)) = winCount(ranking(1)) + 1;
        for iidx = 1:NumPlayers
            handCount(iidx,Results(iidx,1)) = handCount(iidx,Results(iidx,1)) + 1;
        end
        
        % Update graph every once and a while
        if ~mod(idx,UPDATE_PLOT_SPACING)
            if ishandle(f)
                UpdatePlots(f,idx);
            else
                break;
            end
        end
    end
    
    % Stop music if it was playing
    if ~isempty(monteCarloAudioPlayer)
        stop(monteCarloAudioPlayer);
    end
    
    if ishandle(f)
        % Update graphs with final data
        UpdatePlots(f,NUM_MONTE_CARLO_SIMS);
        
        % Wait for user to inspect graphs before continuing
        fprintf('\nPress any key to continue...\n');
        pause;
    end
    
    % Recall initial state
    Deck = deckCache;
    PlayersCards = playersCardsCache;
    
    % Updates simulation plots in figure f
    function UpdatePlots(f,numSimsCompleted)
        % Get current figure
        figure(f);
        colors = hsv(NumPlayers);
        
        % Update victory probability graph
        subplot(SubplotOrgChart{npp,1},SubplotOrgChart{npp,2},SubplotOrgChart{npp,3});
        b = bar(winCount / sum(winCount));
        if DisplayPercentages
            x_loc = get(b,'XData');
            y_height = get(b,'YData');
            arrayfun(@(x,y) text(x,y+0.06,sprintf('%2.1f%s',100*y,char(37)),'FontSize',fontSize-2,'HorizontalAlignment','center'),x_loc,y_height);
        else
            grid on;
        end
        set(gca,'FontSize',fontSize);
        ch = get(b,'Children');
        set(ch,'FaceVertexCData',colors);
        titleStr = ['Probability of Victory After ' dispStr];
        if ~isempty(flopTurnRiverCache), titleStr = [titleStr ' (' GetHandString(flopTurnRiverCache) ')']; end;
        title(titleStr,'FontSize',fontSize);
        ylabel('Probability','FontSize',fontSize);
        xlabel('Player','FontSize',fontSize);
        axis([0 (NumPlayers + 1) 0 1])
        
        % Update hand distribution graphs
        for i_ = 1:npp
            subplot(SubplotOrgChart{npp,1},SubplotOrgChart{npp,2},SubplotOrgChart{npp,4}(i_));
            colormap(hsv(i_+1));
            b = bar(handCount(i_,:) / sum(handCount(i_,:)));
            if DisplayPercentages
                x_loc = get(b,'XData');
                y_height = get(b,'YData');
                arrayfun(@(x,y) text(x+0.1,y+0.06,sprintf('%2.1f%s',100*y,char(37)),'FontSize',fontSize-2,'HorizontalAlignment','center'),x_loc,y_height);
            else
                grid on;
            end
            set(gca,'FontSize',fontSize);
            set(b,'FaceColor',colors(i_,:));
            title(['Player ' num2str(i_) ' (' GetHandString(playersCardsCache(i_,:)) ')'],'FontSize',fontSize);
            ylabel('Probability','FontSize',fontSize);
            xlabel('Hand','FontSize',fontSize);
            set(gca,'XTickLabel',Hands(:,3),'FontSize',fontSize);
            axis([0 (NumHands + 1) 0 1])
        end
        
        % Update simulation count
        set(cb2,'String',[num2str(numSimsCompleted) '/' num2str(NUM_MONTE_CARLO_SIMS) ' Simulations Completed']);
                
        % Force a figure refresh
        drawnow;
    end
    
    % Callback function for when the display percentage checkbox is clicked
    function checkboxCallback(~,~)
        val = get(cb1,'Value');
        if (val == 1)
            DisplayPercentages = true;
        else
            DisplayPercentages = false;
        end
        UpdatePlots(gcf,idx);
    end
end

% Return results of hand
function [ranking result] = HandResults(commonCards)
    % Compute each player's best hand
    result = zeros(NumPlayers,6);
    for jjj = 1:NumPlayers
        if ~isempty(find(PlayersCards(jjj,:) == 0,1))
            result(jjj,:) = [(NumHands + 1) 0 0 0 0 0];
        else
            result(jjj,:) = BestHand([PlayersCards(jjj,:) commonCards]);
        end
    end

    % Figure out who won the hand
    results = sum(result .* repmat(logspace(2,-8,6),NumPlayers,1),2);
    [~,ranking] = sort(results);
end

% Figure out the best hand given hole cards + FlopTurnRiver
function result = BestHand(cards)    
    % Sort cards
    cards = sort(cards);
    
    % Create hand matrix
    handMatrix = zeros(NumSuits,NumCards);
    for idx = 1:length(cards)
        handMatrix(cards(idx)) = 1;
    end
    
    % Get some info for the rest of the checks
    NumCardsPerSuit = sum(handMatrix,2);
    NumEachCard = sum(handMatrix,1);
    ind4 = find(NumEachCard >= 4,1,'first');
    ind3 = find(NumEachCard >= 3,2,'first');
    ind2 = find(NumEachCard >= 2,2,'first');
    indFl = find(NumCardsPerSuit >= 5,1,'first');
    
    % Determine best hand from given cards 
    result = zeros(1,6);
    for jjdx = 1:size(Hands,1)
        switch Hands{jjdx,3}
            case 'RF'
                % Check for Royal Flush
                suitsRF = (sum(handMatrix(:,1:5),2) == 5);
                suitRF = find(suitsRF,1,'first');
                if ~isempty(suitRF)
                    % Found Royal Flush
                    result(1) = jjdx;
                    result(2:6) = suitRF + NumSuits * (0:4);
                    return;
                end
            case 'SF'
                % Check for Straight Flush
                mat = [handMatrix handMatrix(:,1)];
                for suitStFl = 1:NumSuits
                    startInd = strfind(mat(suitStFl,:),ones(1,5));
                    if ~isempty(startInd)
                        % Found Straight Flush
                        result(1) = jjdx;
                        result(2:6) = suitStFl + NumSuits * (startInd(1) + (-1:3));
                        if (startInd(1) == (NumCards - 3))
                            result(6) = result(6) - DeckSize;
                        end
                        return;
                    end
                end
            case '4K'
                % Check for Four of a Kind
                if ~isempty(ind4)
                    % Found Four of a Kind
                    result(1) = jjdx;
                    suits4 = find(handMatrix(:,ind4(1)),4,'first');
                    result(2:5) = (NumSuits * (ind4(1) - 1) + suits4);
                    hand = setdiff(cards,result(2:5));
                    result(6) = hand(1);
                    return;
                end
            case 'FH'
                % Check for Full House
                if ~isempty(ind3)
                    ind23 = setdiff(ind2,ind3(1));
                    if ~isempty(ind23)
                        % Found Full House
                        result(1) = jjdx;
                        suits3 = find(handMatrix(:,ind3(1)),3,'first');
                        suits2 = find(handMatrix(:,ind23(1)),2,'first');
                        result(2:4) = (NumSuits * (ind3(1) - 1) + suits3);
                        result(5:6) = (NumSuits * (ind23(1) - 1) + suits2);
                        return;
                    end
                end
            case 'F'
                % Check for Flush
                if ~isempty(indFl)
                    % Found Flush
                    result(1) = jjdx;
                    cardNumFl = find(handMatrix(indFl(1),:),5,'first');
                    result(2:6) = (NumSuits * (cardNumFl - 1) + indFl(1));
                    return;
                end
            case 'S'
                % Check for Straight
                startInd = strfind([NumEachCard NumEachCard(1)] > 0,ones(1,5));
                if ~isempty(startInd)
                    % Found Straight
                    result(1) = jjdx;
                    if (startInd(1) == (NumCards - 3))
                        for idx = 1:4
                            result(idx + 1) = NumSuits * (startInd(1) + idx - 2) + find(handMatrix(:,startInd(1) + idx - 1),1,'first');
                        end
                        result(6) = find(handMatrix(:,1),1,'first');
                    else
                        for idx = 1:5
                            result(idx + 1) = NumSuits * (startInd(1) + idx - 2) + find(handMatrix(:,startInd(1) + idx - 1),1,'first');
                        end
                    end
                    return;
                end
            case '3K'
                % Check for Three of a Kind
                if ~isempty(ind3)
                    % Found Three of a Kind
                    result(1) = jjdx;
                    suits3 = find(handMatrix(:,ind3(1)),3,'first');
                    result(2:4) = (NumSuits * (ind3(1) - 1) + suits3);
                    hand = setdiff(cards,result(2:4));
                    result(5:6) = hand(1:2);
                    return;
                end
            case '2P'
                % Check for Two Pair
                if (length(ind2) >= 2)
                    % Found Two Pair
                    result(1) = jjdx;
                    suits2a = find(handMatrix(:,ind2(1)),2,'first');
                    suits2b = find(handMatrix(:,ind2(2)),2,'first');
                    result(2:3) = (NumSuits * (ind2(1) - 1) + suits2a);
                    result(4:5) = (NumSuits * (ind2(2) - 1) + suits2b);
                    hand = setdiff(cards,result(2:5));
                    result(6) = hand(1);
                    return;
                end
            case '1P'
                % Check for One Pair
                if ~isempty(ind2)
                    % Found One Pair
                    result(1) = jjdx;
                    suits2 = find(handMatrix(:,ind2(1)),2,'first');
                    result(2:3) = (NumSuits * (ind2(1) - 1) + suits2);
                    hand = setdiff(cards,result(2:3));
                    result(4:6) = hand(1:3);
                    return;
                end
            case 'H'
                % High Card
                result(1) = jjdx;
                result(2:6) = cards(1:5);
                return;
            otherwise
              error('Hand type not supported');
        end
    end
end

% Draw N random cards from the deck (and remove them from deck)
function cards = DrawCards(N)
    inds = randperm(length(Deck),N);
    cards = Deck(inds);
    Deck(inds) = [];
end

% Draw N random cards from the deck (and leave them in deck)
function cards = RandomDraw(N)
    inds = randperm(length(Deck),N);
    cards = Deck(inds);
end

% Parses all user input
function userStr = ProcessUserInput(text)
    userStr = input(sprintf('\n%s',text),'s');
    if strcmpi(userStr,'Help')
        DisplayHelp;
        userStr = ProcessUserInput(text);
    elseif strcmpi(userStr,'Cards')
        DisplayCards;
        userStr = ProcessUserInput(text);
    elseif strcmpi(userStr,'Suits')
        DisplaySuits;
        userStr = ProcessUserInput(text);
    elseif strcmpi(userStr,'Hands')
        DisplayHands;
        userStr = ProcessUserInput(text);
    elseif strcmpi(userStr,'Exit')
        error(ExitMessageStr);
    end
end

% Parses the specified number of cards from user input
function cards = GetCards(text,num)
    cardStr = ProcessUserInput(text);
    cards = zeros(1,num);
    for idx = 1:num
        [c cardStr] = strtok(cardStr,[',',' ']); %#ok
        cardStr = cardStr(2:end);
        cards(idx) = ParseUserCard(c);
    end
end

% Takes a string like 'AH,9D' and converts it to an array of cards
function holeCards = ParseHoleCards(text)
    cardStr = ProcessUserInput(text);
    holeCards = zeros(1,NumHoleCards);
    if ~strcmpi(cardStr,'X')
        for idx = 1:NumHoleCards
            [c cardStr] = strtok(cardStr,[',',' ']); %#ok
            cardStr = cardStr(2:end);
            holeCards(idx) = ParseHoleCard(c);
        end
    end
end

% Converts a single hole card string to a card (allows for 'X')
function holeCard = ParseHoleCard(cardStr)
    if strcmpi(cardStr,'X')
        holeCard = 0;
    else
        holeCard = GetCard(cardStr);
        if (holeCard == 0)
            holeCard = ParseHoleCard(ProcessUserInput(['Card ''' cardStr ''' was invalid. Try entering the card again: ']));
        else
            index = (Deck == holeCard);
            if (sum(index) ~= 1)
                holeCard = ParseHoleCard(ProcessUserInput(['Card ''' cardStr ''' has already been drawn. Try entering the card again: ']));
            else
                Deck(index) = [];
            end
        end
    end
end

% Takes a string like 'AH' and converts it to a card
function card = ParseUserCard(cardStr)
    card = GetCard(cardStr);
    if (card == 0)
        card = ParseUserCard(ProcessUserInput(['Card ''' cardStr ''' was invalid. Try entering the card again: ']));
    else
        index = (Deck == card);
        if (sum(index) ~= 1)
            card = ParseUserCard(ProcessUserInput(['Card ''' cardStr ''' has already been drawn. Try entering the card again: ']));
        else
            Deck(index) = [];
        end
    end
end

% Gets the card associated with a card string
function card = GetCard(cardStr)
    if isempty(cardStr)
        card = 0;
    else
        cardNum = find(strcmpi(Cards,cardStr(1:(end-1))));
        suit = find(strcmpi(Suits,cardStr(end)));
        if ((length(cardNum) ~= 1) || (length(suit) ~= 1))
            card = 0;
        else
            card = suit + (cardNum - 1) * NumSuits;
        end
    end
end

% Gets the card string associated with a card
function cardStr = GetCardString(card)
    if (card == 0)
        cardStr = 'X';
    else
        cardNum = ceil(card / NumSuits);
        suit = card - (cardNum - 1) * NumSuits;
        cardStr = sprintf('%s%s',Cards{cardNum},Suits{suit});
    end
end

% Get the string correpsonding to a given hand
function handStr = GetHandString(hand)
    handStr = '';
    for idx = 1:(length(hand)-1)
        handStr = sprintf('%s%s ',handStr,GetCardString(hand(idx)));
    end
    handStr = sprintf('%s%s',handStr,GetCardString(hand(end)));
end

% Display help information
function DisplayHelp
    fprintf('\n');
    len = length(ProgramName);
    progStr = ['||+--' repmat('-',1,len) '--+||';
               '|||  ' repmat(' ',1,len) '  |||';
               '|||  '    ProgramName    '  |||';
               '|||  ' repmat(' ',1,len) '  |||';
               '||+--' repmat('-',1,len) '--+||'];
    disp(progStr);
    fprintf('\nType ''Cards'' at any prompt to view the valid card symbols\n\n');
    fprintf('Type ''Suits'' at any prompt to view the valid suit symbols\n\n');
    fprintf('Type ''Hands'' at any prompt for a description of the Poker hand hierarchy\n\n');
    fprintf('Type ''Exit'' at any prompt to stop the program\n\n');
    fprintf('Type ''Help'' at any prompt to reprint this information\n\n');
    fprintf(sprintf('%s (e.g., %s%s,%s%s or %s%s %s%s)\n%s (e.g., %s%s X or X,%s%s or X,X)\n', ...
                    'Enter cards in comma/space delimited lists', ...
                    Cards{1}, ...
                    Suits{1}, ...
                    Cards{2}, ...
                    Suits{2}, ...
                    Cards{1}, ...
                    Suits{1}, ...
                    Cards{2}, ...
                    Suits{2}, ...
                    'Use ''X'' to denote an unknown holecard', ...
                    Cards{1}, ...
                    Suits{2}, ...
                    Cards{2}, ...
                    Suits{1}));
end

% Display valid cards
function DisplayCards
    fprintf('\nValid Cards:\n\n');
    for ii = 1:NumCards
        disp(Cards{ii});
    end
end

% Display valid suits
function DisplaySuits
    fprintf('\nValid Suits:\n\n');
    for ii = 1:NumSuits
        disp(Suits{ii});
    end
end

% Display valid poker hands
function DisplayHands
    fprintf('\nValid Poker Hands:\n\n');
    for ii = 1:size(Hands,1)
        disp([Hands{ii,1} ': ' Hands{ii,2}]);
    end
end
%--------------------------------------------------------------------------
end
