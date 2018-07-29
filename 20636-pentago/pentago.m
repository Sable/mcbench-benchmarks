
function Pentago()
% PENTAGO     The Mind Twisting Strategy Board Game
%
% Written by: Dan C. Massie, 9 July 2008
% Objective:  Get five of your game pieces in a row.
% Game Play:  White goes first. Place a game piece on any unoccupied square,
%             then twist one of the four quadrants a quarter turn clockwise
%             or counter-clockwise. First player to get five in a row wins.
%             White is played by the human, black by the computer.
% Background: This game was invented in 2003 by Tomas Floden of Sweden. 
%             It is sold as a board game by MindTwisterUSA.com. It has won
%             numerous awards including the prestigious Mensa Select Award.
global handles;     % Graphics handles used by various functions
global board;       % The board matrix. -1=Black, 1=White, 0=Empty
global lines;       % The lines matrix. Defines lines of 5-in-a-row
global turn;        % Keeps track of whose turn it is. -1=Black, 1=White
InitializeLines();  % Initialize the 5-in-a-row line definitions
InitializeBoard();  % Initialize the game board
return;




function InitializeLines()
% INITIALIZELINES   Creates a 3D matrix of line locations on the board
global lines;
lines = zeros(6,6,32);
linenum = 0;
% horizontal lines
for i = [1:6]
    linenum = linenum + 1;
    lines(i,[1:5],linenum) = ones(1,5);
end
for i = [1:6]
    linenum = linenum + 1;
    lines(i,[2:6],linenum) = ones(1,5);
end
% vertical lines
for i = [1:6]
    linenum = linenum + 1;
    lines([1:5],i,linenum) = ones(5,1);
end
for i = [1:6]
    linenum = linenum + 1;
    lines([2:6],i,linenum) = ones(5,1);
end
% diagonal lines
lines([1:5],[1:5],25) = eye(5);
lines([2:6],[2:6],26) = eye(5);
lines([1:5],[2:6],27) = eye(5);
lines([2:6],[1:5],28) = eye(5);
lines([1:5],[1:5],29) = flipud(eye(5));
lines([2:6],[2:6],30) = flipud(eye(5));
lines([1:5],[2:6],31) = flipud(eye(5));
lines([2:6],[1:5],32) = flipud(eye(5));
return;



function InitializeBoard()
% INITIALIZEBOARD   Creates the game board and graphics handles.
global handles;
global board;
global turn;
% Create board matrix
board = zeros(6,6);
% Create figure and handle list
handles = [];
% Draw the board
screensize = get(0,'ScreenSize');
handles(1) = figure;
set(handles(1),'Name','PENTAGO');
set(handles(1),'Toolbar','none');
set(handles(1),'Position',[screensize(3)/2-150,screensize(4)/2-150,300,300]);
axis off; axis square;
% Define colors
green = [0.5 0.8 0.5];
black = [0 0 0];
tan = [.9 0.8 0.5];
white = [1 1 1];
piececolor = {black, tan, white};
% Draw background & pieces,
handles(2) = patch([0 0 8 8],[0 -8 -8 0],green);
cnt = 3;
for i = [1:6]
    for j = [1:6]
        handles(cnt) = patch([i,i,i+1,i+1],[-j,-j-1,-j-1,-j],piececolor{board(j,i)+2});
        set(handles(cnt),'ButtonDownFcn',{@Callback_Piece,j,i})
        cnt = cnt + 1;
    end
end
% Draw red lines
handles(39) = line([4 4],[-1 -7],'LineWidth',2,'Color',[1 0 0]);
handles(40) = line([1 7],[-4 -4],'LineWidth',2,'Color',[1 0 0]);
% Draw status text
handles(41) = text(4,-7.5,'Initializing','HorizontalAlignment','center');
set(handles(41),'FontWeight','bold');
% Draw arrows
handles(42) = text(7.5,-1.5,'\rightarrow','HorizontalAlignment','center','FontSize',12,'FontWeight','bold','Rotation',-90);
handles(43) = text(6.5,-0.5,'\leftarrow','HorizontalAlignment','center','FontSize',12,'FontWeight','bold');
handles(44) = text(1.5,-0.5,'\rightarrow','HorizontalAlignment','center','FontSize',12,'FontWeight','bold');
handles(45) = text(0.7,-1.5,'\rightarrow','HorizontalAlignment','center','FontSize',12,'FontWeight','bold','Rotation',-90);
handles(46) = text(0.7,-6.5,'\leftarrow','HorizontalAlignment','center','FontSize',12,'FontWeight','bold','Rotation',-90);
handles(47) = text(1.5,-7.5,'\rightarrow','HorizontalAlignment','center','FontSize',12,'FontWeight','bold');
handles(48) = text(6.5,-7.5,'\leftarrow','HorizontalAlignment','center','FontSize',12,'FontWeight','bold');
handles(49) = text(7.5,-6.5,'\leftarrow','HorizontalAlignment','center','FontSize',12,'FontWeight','bold','Rotation',-90);
for i = [1:8], set(handles(41+i),'ButtonDownFcn',{@Callback_Arrow,i}); end
% White goes first. 1=White, -1=Black
turn = 1;
EnableArrows('off')
Wait();
return;




function Wait()
% WAIT              Handles events that occur after a move has been made.
global board;
global turn;
% Test the board for a winning line
win = TestForWin(board);
% Determine who wins
if ~win
    % If no one has won, go to next turn
    if turn < 0  %black's (computer) turn
        EnableArrows('off');
        EnablePieces('off');
        DisplayStatus('Black''s Turn...');
        drawnow;
        arrow = SolveBlackMove();
        AnimateBlackMove(arrow);
        win = TestForWin(board);
        if ~win
            turn = turn*(-1); % swtich to white's turn
            DisplayStatus('White''s Turn');
            EnablePieces('on');
        end
    else
        DisplayStatus('White''s Turn');
    end
end
% Ask for a new game if somebody has won
if win
    button = questdlg('Would you like to play again?','Game Over','Yes','No','Yes');
    if strcmp(button,'Yes')
        board = zeros(6,6);
        turn = 1;
        DisplayStatus('White''s Turn');
        DrawBoard();
        EnableArrows('off');
        EnablePieces('on');
    end
end
% If no body has one, wait for next button click event
return;




function Callback_Piece(src,eventdata,row,col)
% CALLBACK_PIECE    This function is executed whenever an enabled piece is
%                   clicked on. Updates board matrix based on the click.
global board;
global turn;
if board(row,col)~=0
    disp('Invalid Move');
else
    board(row,col) = turn;
    DrawBoard();
    ColorArrows('red');
    EnablePieces('off');
    EnableArrows('on');
end
return;




function Callback_Arrow(src,eventdata,arrow)
% CALLBACK_ARROW    This function is executed whenever an enabled arrow is
%                   clicked on. Updated board matrix based on the click.
global board;
global turn;
ColorArrows('black');
if turn>0,  % white's turn
    board = TwistQuad(arrow,board);
    DrawBoard();
    turn = turn*(-1); % swith to black's turn
else    % black's turn (if black is computer, this code never reached)
    %white's turn is next
    DisplayStatus('White''s Turn');
    turn = turn*(-1);
end
Wait();
return;




function best_arrow = SolveBlackMove() 
% SOLVEBLACKMOVE    This is the game's AI brain. This function determines
%                   what the computer's next move should be. Looks two
%                   moves ahead: black's move, and then white's potential
%                   subsequent move.
global board;
global lines;
% Caculate the stength of each possible next move for each player.
% Keep a running tab of the best move(s).
move_history = [];  % row, col, arrow1, arrow2, white_score_1st_move, black_score_1st_move, white_score_2nd_move, black_score_2nd_move 
for arrow1 = 1:8  % for each (immediate) twist
    % The workboard is an image of the board to use when solving next move
    workboard1 = board;
    workboard1 = TwistQuad(arrow1,workboard1);
    [max_white_score1,white_empty_space_rows1,white_empty_space_cols1, ...
        max_black_score1,black_empty_space_rows1,black_empty_space_cols1] = EvaluateBoard(workboard1);
    % First, look at what happens when black moves offensively. Skip this
    % step on the first move (when black has no pieces out)
    if max_black_score1 > 0
      for i = 1:length(black_empty_space_rows1)
        % for each (subsequent) twist
        white_score_list = [];
        black_score_list = [];
        for arrow2 = 1:8
            workboard2 = workboard1;
            workboard2(black_empty_space_rows1(i),black_empty_space_cols1(i)) = -1; % place a black piece, and see what happens
            workboard2 = TwistQuad(arrow2,workboard2);
            [max_white_score2,white_empty_space_rows2,white_empty_space_cols2, ...
                max_black_score2,black_empty_space_rows2,black_empty_space_cols2] = EvaluateBoard(workboard2);
            white_score_list(end+1) = max_white_score2;
            black_score_list(end+1) = max_black_score2;
        end
        % save the move sequence and the scores for this move
        move_history(end+1,:) = [black_empty_space_rows1(i),black_empty_space_cols1(i), ...
                                 arrow1,arrow2,max_white_score1,max_black_score1, ...
                                 max(white_score_list),max(black_score_list)];
      end
    end
    % Next, look at what happens when black moves defensively
    for i = 1:length(white_empty_space_rows1)
        % for each (subsequent) twist
        white_score_list = [];
        black_score_list = [];
        for arrow2 = 1:8
            workboard2 = workboard1;
            workboard2(white_empty_space_rows1(i),white_empty_space_cols1(i)) = -1; % place a black piece, and see what happens
            workboard2 = TwistQuad(arrow2,workboard2);
            [max_white_score2,white_empty_space_rows2,white_empty_space_cols2, ...
                max_black_score2,black_empty_space_rows2,black_empty_space_cols2] = EvaluateBoard(workboard2);
            white_score_list(end+1) = max_white_score2;
            black_score_list(end+1) = max_black_score2;
        end
        % save the move sequence and the scores for this move
        move_history(end+1,:) = [white_empty_space_rows1(i),white_empty_space_cols1(i), ...
                                 arrow1,arrow2,max_white_score1,max_black_score1, ...
                                 max(white_score_list),max(black_score_list)];
    end
end
% Looking at the move history, choose a move that benefits black the most
% and/or retracts from white the most. If black is being aggressive, he 
% will look for the move that benefit's him currently and in the next move, 
% regardless of white's next move. If black is being conservative, he will
% look for the move that prevents white from getting a high move score.
% The trick is knowing when to be aggressive and when to be conservative.
max_white_1st_move = max(move_history(:,5));
min_white_1st_move = min(move_history(:,5));
max_black_1st_move = max(move_history(:,6));
min_black_1st_move = min(move_history(:,6));
max_white_2nd_move = max(move_history(:,7));
min_white_2nd_move = min(move_history(:,7));
max_black_2nd_move = max(move_history(:,8));
min_black_2nd_move = min(move_history(:,8));
% First, find the moves that maximize black's score (aggressive choice)
aggressive_moves1 = find(move_history(:,6)==max_black_1st_move);
aggressive_moves2 = find(move_history(:,8)==max_black_2nd_move);    
aggressive_moves12 = incommon(aggressive_moves1,aggressive_moves2);
% Second, find the moves that minimize white's score (conservative choice)
conservative_moves1 = find(move_history(:,5)==min_white_1st_move);
conservative_moves2 = find(move_history(:,7)==min_white_2nd_move);
conservative_moves12 = incommon(conservative_moves1,conservative_moves2);
% The best move is the one that simultaneously maximizes black and
% minimizes white. (aggressive)
best_aggressive_moves_1_2 = incommon(aggressive_moves1,conservative_moves2);
% if there is an immediate winning move, choose that
if max_black_1st_move == 5
    best_moves = aggressive_moves1;
elseif max_black_1st_move == 4 & max_black_2nd_move == 5
    best_moves = aggressive_moves12;
% otherwise choose the best aggressive move, if one exists
elseif ~isempty(best_aggressive_moves_1_2)
    best_moves = best_aggressive_moves_1_2;
% otherwise choose the best conservative move, which is one that minimizes
% white's score for the longest period of time, if one exists
elseif ~isempty(conservative_moves12)
    best_moves = conservative_moves12;
% otherwise choose the next best conservative move
else
    best_moves = conservative_moves1;
end
% If more than one best move exists, pick one at random
best_index = ceil(rand*length(best_moves));
best_move = best_moves(best_index);
best_row = move_history(best_move,1);
best_col = move_history(best_move,2);
best_arrow = move_history(best_move,3);
% The row and col are post-twist coordinates. Place piece on board.
blacks_move = zeros(6,6);
blacks_move(best_row,best_col) = -1;
% Finally, twist the quad back to get the pre-twist coordinates
if mod(best_arrow,2)==0, move_back = -1;
else move_back = 1; end
blacks_move = TwistQuad(best_arrow + move_back, blacks_move);
% Update the board per black's move. Return arrow for animation.
board = board + blacks_move;      
return;
 



function [listC] = incommon(listA,listB)
% INCOMMON          Find the values in common between two vectors
listC = [];
if ~isempty(listA)
    for i = 1:length(listA)
        if any(listB==listA(i))
            listC(end+1) = listA(i);
        end
    end
end
return;




function [max_white_score,white_empty_space_rows,white_empty_space_cols, ...
          max_black_score,black_empty_space_rows,black_empty_space_cols] = EvaluateBoard(board)
% EVALUATEBOARD    	Find the best moves for both white and black for the given board 
global lines;
% Find the scores for each line on the board, for each piece (black and white)
[white_scores,black_scores] = BoardScore(board);
% Calculate the best moves for black
    % find the lines that are best choice for black (if black were on offensive)
    best_black_lines = (white_scores==0).*(black_scores); % Only look at possible 5-in-a-row locations
    max_black_score = max(max(best_black_lines));         % Best lines are those where 5-in-a-row is closest
    max_black_lines = find(best_black_lines==max_black_score); 
    % find the empty spaces on the max black lines
    black_empty_space_rows = [];
    black_empty_space_cols = [];
    for i = 1:length(max_black_lines)
        empty_spaces = xor(lines(:,:,max_black_lines(i)),(lines(:,:,max_black_lines(i)).*board)~=0);
        num_empty_spaces = sum(sum(empty_spaces));
        if num_empty_spaces == 0, empty_spaces = (board==0); end % Immediate win. Pick any empty space
        empty_space_locs = find(empty_spaces==1);
        for j = 1:length(empty_space_locs)
            % calculate the col
            black_empty_space_cols(end+1) = ceil(empty_space_locs(j)/6);
            % calculate the row
            black_empty_space_rows(end+1) = mod(empty_space_locs(j),6);
            if black_empty_space_rows(end) == 0, black_empty_space_rows(end) = 6; end
        end
    end
% Calculate the best moves for white
    % find the lines that are best choice for white (if white were on offensive)
    best_white_lines = (black_scores==0).*(white_scores); % Only look at possible 5-in-a-row locations
    max_white_score = max(max(best_white_lines));         % Best lines are those where 5-in-a-row is closest
    max_white_lines = find(best_white_lines==max_white_score); 
    % find the empty spaces on the max black lines
    white_empty_space_rows = [];
    white_empty_space_cols = [];
    for i = 1:length(max_white_lines)
        empty_spaces = xor(lines(:,:,max_white_lines(i)),(lines(:,:,max_white_lines(i)).*board)~=0);
        num_empty_spaces = sum(sum(empty_spaces));
        if num_empty_spaces == 0, empty_spaces = (board==0); end % Immediate win. Pick any empty space
        empty_space_locs = find(empty_spaces==1);
        % calculate the col
        for j = 1:length(empty_space_locs)
            % calculate the col
            white_empty_space_cols(end+1) = ceil(empty_space_locs(j)/6);
            % calculate the row
            white_empty_space_rows(end+1) = mod(empty_space_locs(j),6);
            if white_empty_space_rows(end) == 0, white_empty_space_rows(end) = 6; end
        end
    end    
return;





function [white_score,black_score] = BoardScore(board)
% BOARDSCORE    	Calculate the "score" or advantage of each player. This
%                   function is used by the computer to evaluate the 
%                   relative strenght of moves.
global lines;
% check all the lines on the board
for i = 1:32
    white_score(i,1) = sum(sum((lines(:,:,i).*board)>0));
    black_score(i,1) = sum(sum((lines(:,:,i).*board)<0));
end
return;




function [win] = TestForWin(board)
% TESTFORWIN        Tests the board matrix for five in a row.
global handles;
global lines;
win = 0;
white_win = 0;
black_win = 0;
% check all the lines on the board
for i = 1:32
    linesum = sum(sum(lines(:,:,i).*board));
    if linesum == 5, white_win = 1; end
    if linesum == -5, black_win = 1; end
end
if white_win > 0 & black_win > 0, DisplayStatus('Tie Game!'); win=1;
elseif white_win > 0, DisplayStatus('White Wins!'); win=1;
elseif black_win > 0, DisplayStatus('Black Wins!'); win=1;
end
if all(all(board~=0)), DisplayStatus('Draw Game!'); win=1; end
if win  % Flash the text
    for i=1:3
        pause(0.5);
        set(handles(41),'Color',[1 0 0]);
        pause(0.5);
        set(handles(41),'Color',[0 0 0]);
    end
end
return;




function newboard = TwistQuad(arrow,board)
% TWISTQUAD         Updates the board matrix based on which arrow was
%                   selected to twist a quadrant.
quad(:,:,1) = board([1:3],[4:6]);
quad(:,:,2) = board([1:3],[1:3]);
quad(:,:,3) = board([4:6],[1:3]);
quad(:,:,4) = board([4:6],[4:6]);
switch arrow
    case 1, quad(:,:,1) = rot90(quad(:,:,1),-1);
    case 2, quad(:,:,1) = rot90(quad(:,:,1));
    case 3, quad(:,:,2) = rot90(quad(:,:,2),-1);
    case 4, quad(:,:,2) = rot90(quad(:,:,2));
    case 5, quad(:,:,3) = rot90(quad(:,:,3),-1);
    case 6, quad(:,:,3) = rot90(quad(:,:,3));
    case 7, quad(:,:,4) = rot90(quad(:,:,4),-1);
    case 8, quad(:,:,4) = rot90(quad(:,:,4));
end
newboard = [];
newboard([1:3],[4:6]) = quad(:,:,1);
newboard([1:3],[1:3]) = quad(:,:,2); 
newboard([4:6],[1:3]) = quad(:,:,3); 
newboard([4:6],[4:6]) = quad(:,:,4); 
return;





function AnimateBlackMove(arrow)
% ANIMATEBLACKMOVE  This function steps through a sequence of drawing
%                   commands to animate the black player's (computer) move.
global board;
pause(1)
DrawBoard();
ColorArrows('red');
pause(1)
board = TwistQuad(arrow,board);
DrawBoard();
ColorArrows('black');
return;



function DrawBoard()
% DRAWBOARD         This utility function changes the color of the game pieces
%                   to reflect the "board" matrix state.
global handles;
global board;
% Define colors
black = [0 0 0];
tan = [.9 0.8 0.5];
white = [1 1 1];
piececolor = {black, tan, white};
% Draw background, pieces, and lines
cnt = 3;
for i = [1:6]
    for j = [1:6]
        set(handles(cnt),'FaceColor',piececolor{board(j,i)+2});
        cnt = cnt + 1;
    end
end
return;



function DisplayStatus(str)
% DISPLAYSTATUS     This utility function updates the status text at the
%                   bottom of the game board.
global handles;
set(handles(41),'String',str);
return;



function ColorArrows(str)
% COLORARROWS       This utility function changes the color of the arrows
%                   on the game board.
global handles;
switch str
    case 'red'
        arrowcolor = [1 0 0];
    case 'black'
        arrowcolor = [0 0 0];
    otherwise
end
for i = [1:8], set(handles(41+i),'Color',arrowcolor); end
return;



function EnableArrows(str)
% ENABLEARROWS      This utility function enables or disables the arrows
global handles;
for i = [1:8], set(handles(41+i),'HitTest',str); end
return;



function EnablePieces(str)
% ENABLEPIECES      This utility function enables or disables the game peices
global handles;
for i = [3:38], set(handles(i),'HitTest',str); end
return;




