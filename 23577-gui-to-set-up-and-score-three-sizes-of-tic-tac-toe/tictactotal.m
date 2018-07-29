function tictactotal
% Creates a tic-tac-toe game board and markers for two players
% and manages their play. Board can be 3x3, 4x4 or 5x5. The program
% determines and announces winners, and tallies their scores.
%
% This app uses a single structure (called 'ttt') to hold and
% communicate all data. Throughout, it uses the paradigm
%   ttt = func(ttt);
% Thus, no appdata, userdata, or guidata is required.
% No callbacks are used either.
%
% Consider adding interest to 4x4 or 5x5 games (which are now
% impossible to win) by a scoring system which gives points
% for runs of 3 or even 2, and/or contiguous blocks owned by
% one player. I haven't had time to work on that and probably won't.
%
%    Geoff Dutton, The MathWorks, Inc., April 2009

% Generate a structure to hold the application's data.
% Start by labelling the major parts of the structure.
ttt.players.role = 'Data specifying each of two players';
ttt.board.role = 'Data specifying the state of the playing board';
ttt.games.role = 'Data specifying the state of games played';

% Create the figure and initial game parameters
ttt = createFigure(ttt);
% Initialize data for two players.
ttt = createPlayers(ttt);
% Create player labels under board that also indicate who plays
ttt = labelPlayer(ttt,1);
ttt = labelPlayer(ttt,2);
% Generate bitmap data to identify winning moves
ttt = createRunPatterns(ttt);
% Set up play
turn = 1;           % turn indicates which player goes next

% Enter outer event loop that keeps the games going
while true
    % Has the GUI been deleted?
    if ~ishandle(ttt.board.figure)  % Should use ISHGHANDLE?
        return
    end
    % Play game only while Play button is down
    waitfor(ttt.games.playing,'Value',1)
    % Has the GUI been deleted while waiting?
    if ~ishandle(ttt.board.figure)  % Should use ISHGHANDLE?
        return
    end
    % Create the board; its size depends on popup ttt.board.sizectrl
    ttt = newGame(ttt,turn);
    play = ttt.board.play;
    bsize = ttt.board.size;
    % Start and manage a game when Play btn goes down and stays down
    while get(ttt.games.playing,'Value')
        try
            evt = waitforbuttonpress;
        if evt 
            continue         % Ignore keystrokes
        end
        catch
            return
        end
        % Where was the last mouse click wrt the axes?
        pxy = get(ttt.board.axes,'CurrentPoint');
        px = pxy(1,1);
        py = pxy(1,2);
        % Make sure that mouse click was in the axes
        if px < 0 || px > 1 || py < 0 || py > 1
            continue
        end
        % Convert px,py to centerpoint and row & col
        [row col cenx ceny] = squareLocation(px,py,bsize);
        if ttt.board.data(row,col)    % Square already occupied
            shake(ttt.board.figure,1) % Signal uh-uh, try again
            continue
        end
        % Add token to mark legitimate move
        color = ttt.players(turn).color;
        newToken(color, cenx, ceny, bsize);
        ttt.board.data(row,col) = turn;
        % Analyze the board to see if this is a winning move
        ttt = findWinningRun(ttt,turn);
        % If someone won, the board will contain fractional values
        % To find them, zero every board value that is integer
        mboard = mod(ttt.board.data,1);
        % There is a winner if mboard's sum is nonzero
        if sum(sum(mboard))
            % Get row, col list of nonzero entries
            [rows cols] = find(mboard);
            % Ignore middle cell(s) and get 1st & last centerpoints
            [row col cenx1 ceny1] = squareLocation(...
                 cols(1),rows(1),bsize);     
            [row col cenx2 ceny2] = squareLocation(...
                 cols(bsize),rows(bsize),bsize); 
            % Draw a line between the centerpoints of the end cells
            lcolor = color + 0.5*(1 - color);
            line([cenx1 cenx2],[ceny1 ceny2],...
                'Color',lcolor,'LineWidth',4)
            drawnow
            % Give a nod!
            shake(ttt.board.figure,2)
            % Score the game and announce winner in scorebox
            ttt = announceWinner(ttt,turn);
           % Turn off game (Play togglebutton)
            set(ttt.games.playing,'Value',0);
         end
        % Rotate turn and update colors for player labels 
        set(ttt.players(turn).label,...
            'ForegroundColor',ttt.board.disablecolor)
        turn = 3-turn;
        set(ttt.players(turn).label,...
            'ForegroundColor',ttt.players(turn).color)        
        play = play + 1;
        if play >= bsize * bsize;
            break
        end
    end     % Round of play
    % Turn off the game
    set(ttt.games.playing,'Value',0)
end     % Outer loop
end     % Main function

    function ttt = createFigure(ttt)
        % Provide necessary defaults
        ttt.games.count = 0;
        ttt.board.color = [.9 .9 1];
        ttt.board.backcolor = [.85 .85 .95];
        ttt.board.disablecolor = [.6 .6 .6];
        % Create figure which will hold a panel, an axes, 
        % graphics, and uicontrols
        ttt.board.figure = ...
                figure('Color',ttt.board.backcolor,...
                      'Units','pixels',...
                      'Position',[500 400 500 525],...
                      'Resize','off',...
                      'Name','Tic-Tac-Total',...
                      'NumberTitle','off',...
                      'MenuBar','none');
        % Create a panel to hold the axes
        ttt.board.panel = ...
            uipanel(ttt.board.figure,'Title','',...
                         'Units','normalized',...
                         'Position',[.05 .1 .9, .8],...
                         'BackgroundColor', ttt.board.color,...
                         'BorderType','etchedin');
        % Create an axes to hold the graphics
        ttt.board.axes = ...
            axes('Color','none',...
                 'Parent',ttt.board.panel,...
                 'XLim',[0 1],...
                 'YLim',[0 1],...
                 'DataAspectRatio',[1 1 1],...
                 'GridLineStyle','none',...
                 'XTick',[],...
                 'Ytick',[],...
                 'Xcolor',ttt.board.color,...
                 'YColor',ttt.board.color,...
                 'MinorGridLineStyle','none',...
                 'Units','normalized',...
                 'Position',[0 0 1 1]);
        % Create a control for board size
        ttt.board.sizectrl = ...
            uicontrol('Style','popup',...
                      'Parent',ttt.board.figure,...
                      'Units','normalized',...
                      'Position',[.05 .9 .1 .05],...
                      'BackgroundColor',ttt.board.color,...
                      'String',{'3' '4' '5'},...
                      'Value',1);
        % Create label for the size control. No handle is needed
        uicontrol('Style','text',...
                  'Parent',ttt.board.figure,...
                  'Units','normalized',...
                  'Position',[.05 .95 .2 .04],...
                  'BackgroundColor',[.85 .85 .95],...
                  'String','Board size',...
                  'HorizontalAlignment','left',...
                  'FontWeight','bold',...
                  'FontSize',10);

        % Create a togglebutton to start and stop play
        ttt.games.playing = ...
            uicontrol('Style','togglebutton',...
                      'Parent',ttt.board.figure,...
                      'Units','normalized',...
                      'Position',[.85 .95 .1 .04],...
                      'BackgroundColor',ttt.board.color,...
                      'String','Play',...
                      'FontWeight','bold',...
                      'FontSize',10,...
                      'Min',0,...
                      'Max',1,...
                      'Value',0);        

    end


    function ttt = newGame(ttt,turn)
    % Initializes a game when Play button is pressed
    
        x = get(ttt.board.sizectrl,'Value');
        ttt.board.size = x + 2;
        ttt.board.data = zeros(ttt.board.size);
        ttt.board.play = 0;
        ttt.games.count = ttt.games.count+1;
        drawboard(ttt)
        set(ttt.players(turn).label,...
            'ForegroundColor',ttt.players(turn).color)
        set(ttt.players(3-turn).label,...
            'ForegroundColor',ttt.board.disablecolor);

    end


    function drawboard(ttt)
    % Generate a playing board at the requested size, 
    % removing all debris from the axes first but not reseting it.
    
        % Clear the axes first
        cla;
        % Etch in the lines between squares
       lineclr = [.5 .2 .1];
        for stroke = 1:ttt.board.size-1
            offset = stroke/ttt.board.size;
            line([.01 .99],[offset offset],'Color',lineclr,'LineWidth',3)
            line([offset offset],[.01 .99],'Color',lineclr,'LineWidth',3)
        end
    end

    function [row col cenx ceny] = squareLocation(x,y,n)
    % Returns row and column of in 3-by-3 grid of a normalized x,y point
    % px and py > 0 and < 1; 2 < n < 6
    
        % Calling with point or cell coordinates?
        if x < 1
            row = floor(n*y + 1);
            col = floor(n*x + 1);
        else
            row = y;
            col = x;
        end
        cenx = (col - 1)/n + 1/(2*n);
        ceny = (row - 1)/n + 1/(2*n);
    end


    function ttt = createPlayers(ttt)
    % Create a structure to hold data for two players
    
    ttt.players(1).color = [.5 .1 .5];  % purplish
    ttt.players(2).color = [.1 .6 .1];  % greenish
    ttt.players(1).loc = [.2 .01];  % x,y origin
    ttt.players(2).loc = [.6 .01];  % x,y origin
    ttt.players(1).score = 0;  % points so far
    ttt.players(2).score = 0 ; % points so far
    ttt.players(1).name = 'Player 1';  % name label
    ttt.players(2).name = 'Player 2';  % name label
    end


    function ttt = labelPlayer(ttt,num)
    % Creates a label for a player below board in player's color.
    
        pos(1) = ttt.players(num).loc(1);
        pos(2) = ttt.players(num).loc(2);
        pos(3) = .25;
        pos(4) = .035;
        if num == 1
            color = ttt.players(1).color;
        else
            color = ttt.board.disablecolor;
        end
        % Create edit text box for a player's name
        ttt.players(num).label = ...
            uicontrol('Style','edit',...
                      'Units','Normalized',...
                      'Position',pos,...
                      'String',ttt.players(num).name,...
                      'FontWeight','bold',...
                      'FontSize',10,...
                      'ForegroundColor',color,...
                      'BackgroundColor',ttt.board.color,...
                      'Min',0,...
                      'Max',1);
        % Create static text field for player's won game count
        pos(2) = pos(2) + .045;
        pos(3) = .065;
        ttt.players(num).scorecard = ...
            uicontrol('Style','text',...
                      'Units','Normalized',...
                      'Position',pos,...
                      'String','0',...
                      'FontWeight','bold',...
                      'FontSize',10,...
                      'ForegroundColor',ttt.players(num).color,...
                      'BackgroundColor',ttt.board.backcolor);
        % Create label for this field
        pos(1) = pos(1)+pos(3);
        pos(3) = .2;
        ttt.players(num).scorebox = ...
            uicontrol('Style','text',...
                      'Units','Normalized',...
                      'Position',pos,...
                      'String','Games won',...
                      'FontWeight','bold',...
                      'FontSize',10,...
                      'ForegroundColor',ttt.players(num).color,...
                      'BackgroundColor',ttt.board.backcolor);
    end


    function newToken(color, cenx, ceny, boardsize)
    % Adds a token to board when player clicks a blank square.
    
        msize = 1/(boardsize+2);
        pos(1) = cenx - msize/2;
        pos(2) = ceny - msize/2;
        pos(3) = msize;
        pos(4) = msize;
        rectangle('Curvature',[.3 .3],...
                  'Position',pos,...
                  'EdgeColor','none',...
                  'FaceColor',color);
    end

    function shake(hfig,dir)
    % Shakes figure side-to-side to indicate illegal play
    
        beep
        if dir < 1 
            dir = 1;
        elseif dir > 2
            dir = 2;
        end
        fpos = get(hfig,'Position');
        fpos1 = fpos;
        fpos2 = fpos;
        fpos1(dir) = fpos(dir) - 5;
        fpos2(dir) = fpos(dir) + 5;
        for nod = 1:4
            set(hfig,'Position',fpos1)
            drawnow
            pause(.05)
            set(hfig,'Position',fpos2)
            drawnow
            pause(.05)
        end
        set(hfig,'Position',fpos)
        drawnow
    end


    function ttt = findWinningRun(ttt,player)
    % Look for scoring patterns for the current player. A winning run
    % is a complete run horizontally, vertically or diagonally.
    % Eventually, for boards of order 4 and 5, minor runs of 3 and 4 
    % will also count, but this isn't computed here yet.
    
        bsize = ttt.board.size;
        % Make logical array with 1's for players tokens, zeros elsewhere
        board = ttt.board.data;
        bmap = eq(board,player);
        runs = ttt.games.patterns(bsize-2).runs;
        tests = size(runs,3);
%        tests = 2*size+2;
        % Iterate through tests until a winnnig pattern is found
        winner = 0;
        for test = 1:tests
            pattern = bmap & runs(:,:,test);
            if sum(sum(pattern)) == bsize
                % Update board cells in the winning run with 
                % fractional value to code the test that succeeded
                board(pattern) = board(pattern) + (test/100);
                ttt.board.data = board;
                ttt.games.winner = player;
                return
            end
        end
    end


    function ttt = announceWinner(ttt,player)
    % Keeps track of outcomes for players when someone wins
    
    score = ttt.players(player).score + 1; 
    set(ttt.players(player).scorecard,'String',num2str(score));
    ttt.players(player).score = score;
    end
    

    function ttt = createRunPatterns(ttt)
    % Generates data that encodes patterns of winning moves. 
    % The analyzer of this data currently does not look for
    % smaller patterns in larger games. If it did, the larger
    % games might actually be worth playing.

    % Winning moves for boardsize 3 (3x3x8 matrix)   
    ttt.games.patterns(1).runs = cat(3, ...
        [1 1 1; 0 0 0; 0 0 0],...
        [0 0 0; 1 1 1; 0 0 0],...
        [0 0 0; 0 0 0; 1 1 1],...
        [1 0 0; 1 0 0; 1 0 0],...
        [0 1 0; 0 1 0; 0 1 0],...
        [0 0 1; 0 0 1; 0 0 1],...
        [1 0 0; 0 1 0; 0 0 1],...
        [0 0 1; 0 1 0; 1 0 0]);
  
    % Winning moves for boardsize 4 (4x4x10 matrix)
    ttt.games.patterns(2).runs = cat(3, ...
        [1 1 1 1; 0 0 0 0; 0 0 0 0; 0 0 0 0],...
        [0 0 0 0; 1 1 1 1; 0 0 0 0; 0 0 0 0],...
        [0 0 0 0; 0 0 0 0; 1 1 1 1; 0 0 0 0],...
        [0 0 0 0; 0 0 0 0; 0 0 0 0; 1 1 1 1],...
        [1 0 0 0; 1 0 0 0; 1 0 0 0; 1 0 0 0],...
        [0 1 0 0; 0 1 0 0; 0 1 0 0; 0 1 0 0],...
        [0 0 1 0; 0 0 1 0; 0 0 1 0; 0 0 1 0],...
        [0 0 0 1; 0 0 0 1; 0 0 0 1; 0 0 0 1],...
        [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1],...
        [0 0 0 1; 0 0 1 0; 0 1 0 0; 1 0 0 0]);
    
    % Winning moves for boardsize 5 (5x5x12 matrix)
    ttt.games.patterns(3).runs = cat(3, ...
        [1 1 1 1 1; 0 0 0 0 0; 0 0 0 0 0; 0 0 0 0 0; 0 0 0 0 0],...
        [0 0 0 0 0; 1 1 1 1 1; 0 0 0 0 0; 0 0 0 0 0; 0 0 0 0 0],...
        [0 0 0 0 0; 0 0 0 0 0; 1 1 1 1 1; 0 0 0 0 0; 0 0 0 0 0],...
        [0 0 0 0 0; 0 0 0 0 0; 0 0 0 0 0; 1 1 1 1 1; 0 0 0 0 0],...
        [0 0 0 0 0; 0 0 0 0 0; 0 0 0 0 0; 0 0 0 0 0; 1 1 1 1 1],...
        [1 0 0 0 0; 1 0 0 0 0; 1 0 0 0 0; 1 0 0 0 0; 1 0 0 0 0],...
        [0 1 0 0 0; 0 1 0 0 0; 0 1 0 0 0; 0 1 0 0 0; 0 1 0 0 0],...
        [0 0 1 0 0; 0 0 1 0 0; 0 0 1 0 0; 0 0 1 0 0; 0 0 1 0 0],...
        [0 0 0 1 0; 0 0 0 1 0; 0 0 0 1 0; 0 0 0 1 0; 0 0 0 1 0],...
        [0 0 0 0 1; 0 0 0 0 1; 0 0 0 0 1; 0 0 0 0 1; 0 0 0 0 1],...
        [1 0 0 0 0; 0 1 0 0 0; 0 0 1 0 0; 0 0 0 1 0; 0 0 0 0 1],...
        [0 0 0 0 1; 0 0 0 1 0; 0 0 1 0 0; 0 1 0 0 0; 1 0 0 0 0]);
    end
