function [winner, roundnr] = connect4(player, nmvs, posval)
%CONNECT4([player, nmvs, posval])   Connect-4 game played on a 7x7 board 
%
% Optional input arguments:
%  player .. e.g. 'HC' human vs. computer (default); other options: 'CH', 'CC', 'HH'
%  nmvs ..  minimum number of moves to be evaluated
%  posval .. weights for 1,2, or 3 same-color pieces in an otherwise empty arrays of 4
%
% The program uses a minimax algorithm with brute-force search to a flexible depth of the search tree (however usually not more than 2-3). 
% Evaluation of positions follows the tactic of maximizing the weighted amount of same-color pieces in empty arrays of 4
% It takes a brute-force minimax approach in evaluating all possible move-combinations down to a certain depth 
% The actual depth of evaluation corresponds to the depth reached after computing a predefined minimum number of available moves.
% Despite the usage of only one simple tactic the program appears to show some adequate or even intelligent behavior.
% At each move, the figure title gives information on the round-nr, computed depth, nr of computed moves, assessment of current position, and
% evaluation of the best-possible position at computed depth. Positive/negative values indicate an assumed advantage for player 1/2.

% By Mathias Benedek 09/2011


global INDEX4 EVAL_INDEX CNTR NMVS iDPTH movelist

if nargin < 1
    player = 'HC';  %stabdard setting: human vs. computer
else
    if ~any(strcmpi(player(1),{'C','H'})) && any(strcmpi(player(2),{'C','H'}))
        error('Player-argument must be e.g. for human vs computer ''HC''!')
    end
end
if nargin < 2
    NMVS = [2000 2000];     % minimum number of moves to compute; val < 50 corresponds to depth==1, val < 2800 to depth==2, val> 2800 to depth==3
else
    NMVS = nmvs;
end
if nargin < 3
    v = [1 3 10];   % evaluation v for 1x1+3x0, 2x1+2x0, 3x1+1x0, 4x1 (=4 wins)
    w = [1 3 10];
else
    v = posval{1};
    w = posval{2};
end
if strcmp(player,'CC')
    gamov_announced = 1;    %do not preannounce soon gameover in C-C game
else
    gamov_announced = 0;
end
messbxs = 1;

board = zeros(7,7);

%INDEX4: list all possible sets of 4 adjacent positions in board
row1 = [1:7:22; 8:7:29; 15:7:36; 22:7:43];
col1 = [1:4; 2:5; 3:6; 4:7];
p6 = [0 6 12 18];
p8 = [0 8 16 24];
INDEX4 = [row1; row1+1; row1+2; row1+3; row1+4; row1+5; row1+6;...
    col1; col1+7; col1+14; col1+21; col1+28; col1+35; col1+42;...
    4+p6; 5+p6; 11+p6; 6+p6; 12+p6; 18+p6; 7+p6; 13+p6; 19+p6; 25+p6; 14+p6; 20+p6; 26+p6; 21+p6; 27+p6; 28+p6;...
    4+p8; 3+p8; 11+p8; 2+p8; 10+p8; 18+p8; 1+p8; 9+p8; 17+p8; 25+p8; 8+p8; 16+p8; 24+p8; 15+p8; 23+p8; 22+p8];

% Evaluation indices of player 1 and 2
EVAL_INDEX = {};
mxv = 10^4; %maximal value
EVAL_INDEX{1} = [0 v(1) -v(1) v(1) v(2) 0 -v(1) 0 -v(2) v(1) v(2) 0 v(2) v(3) 0 0 0 0 -v(1) 0 -v(2) 0 0 0 -v(2) 0 -v(3) ...
    v(1) v(2) 0 v(2) v(3) 0 0 0 0 v(2) v(3) 0 v(3) mxv zeros(1,13) ...
    -v(1) 0 -v(2) 0 0 0 -v(2) 0 -v(3) zeros(1,9) -v(2) 0 -v(3) 0 0 0 -v(3) 0 -mxv];
% Evaluation of sets [0 0 0 0], [0 0 0 1], [0 0 0 2], [0 0 1 0], ...
EVAL_INDEX{2} = [0 w(1) -w(1) w(1) w(2) 0 -w(1) 0 -w(2) w(1) w(2) 0 w(2) w(3) 0 0 0 0 -w(1) 0 -w(2) 0 0 0 -w(2) 0 -w(3) ...
    w(1) w(2) 0 w(2) w(3) 0 0 0 0 w(2) w(3) 0 w(3) mxv zeros(1,13) ...
    -w(1) 0 -w(2) 0 0 0 -w(2) 0 -w(3) zeros(1,9) -w(2) 0 -w(3) 0 0 0 -w(3) 0 -mxv];


%Plot game
figure('Units','normalized','Position',[.2 .2 .6 .6], 'NumberTitle','off', 'MenuBar','none', 'Name','4-Wins','Color',[.5 .5 .5]); %,'WindowKeyPressFcn',@keypfcn);
axes('Units','normalized','Position',[.1 .1 .8 .8],'Color',[0 0 .8],'Box','on');
set(gca, 'XTick',[],'YTick',[],'XLim',[0,80],'YLim',[0,80])
hold on;

for row = 1:7
    for col = 1:7
        field(row,col) = plot(10+(col-1)*10, 10+(row-1)*10, 'wo','MarkerSize',35,'LineWidth',2,'MarkerFaceColor',[1 1 1]','MarkerEdgeColor', [0 0 0],'ButtonDownFcn',@click_col);
    end
end
col = {[1 0 0], [1 1 0]};
cnames = {'Red','Yellow'};
drawnow;


%Play game
gameover = 0;
move_rc = [1,1];
roundnr = 0;    %Round number
turn = 1;       %player red => turn==1, player yellow => turn==2
movelist = [];
while ~gameover

    if turn == 1, roundnr = roundnr + 1; end
    CNTR = 0;
    move_rc_last = move_rc;
    [board, move_rc, valD] = next_move(board, turn, player(turn));
    movelist(roundnr, turn) = move_rc(2);

    %Show move
    set(field(move_rc(1), move_rc(2)),'MarkerFaceColor',col{turn},'MarkerEdgeColor',[1 1 1])
    set(field(move_rc_last(1), move_rc_last(2)),'MarkerEdgeColor',[0 0 0])
    v = eval_board(board, turn);
    set(gcf,'Name',['Connect-4   (R: ',num2str(roundnr),', D: ',num2str(iDPTH),', #M: ',num2str(CNTR),', C: ',num2str(v),', P: ',num2str(valD),')'])
    drawnow;

    %Announce soon game-over
    cwins = (turn==2 && valD<-10^3) || (turn==1 && valD>10^3);
    if cwins && strcmp(player(turn), 'C')  && ~gamov_announced && messbxs && iDPTH > 1
        msgbox(['Game over in ',num2str(iDPTH-1),' move(s)'])
        gamov_announced = 1;
    end

    %Check if game is over
    if abs(v) > 10^3
        gameover = 1;
        if messbxs, msgbox([cnames{turn},' wins!']); end
        winner = turn;
    elseif ~any(any(board==0))
        gameover = 1;
        if messbxs, msgbox('Patt!'); end
        winner = 0;
    end

    turn = 3 - turn;
end


function [board, move_rc, valD] = next_move(board, turn, player_act)

if strcmp(player_act, 'H')      %Human move
    [board, move_rc] = get_move(board, turn);
    valD = nan;

elseif strcmp(player_act, 'C')  %Computer-Move
    [board, move_rc, valD] = make_move(board, turn);

end


function [board, move_rc] = get_move(board, turn)
global mymove

mymove = -1;

valid_moves =  find(board(1,:) == 0);
isvalidmove = 0;
while ~isvalidmove
    isvalidmove = any(mymove == valid_moves);
    pause(.01)
end

row = find(board(:,mymove) == 0, 1, 'last');
board(row, mymove) = turn;
move_rc = [8-row, mymove];


function [board, move_rc, valD] = make_move(board, turn)
global CNTR NMVS iDPTH

for iDPTH = 1:10 	% usually depth is no more than 3, but in cases of restricted choices it might go deeper until at least minimum number of moves are used

    v = MTree(board, turn, turn, 1, iDPTH*2);   %a depth of 1 always includes 2 steps/moves
    if turn == 2
        [valD, move] = min(v);
        nopts = length(find(v < 10^3));   %how many reasonable options for moves
    else
        [valD, move] = max(v);
        nopts = length(find(v > 10^3));   %how many reasonable options for moves
    end

    %compute again for increased depth if ..
    if CNTR > NMVS(turn) || abs(valD) > 10^3 || nopts == 1    %.. not already more than k comps, not already lost/won, and more than one option
        break;
    end

end

row = find(board(:,move) == 0, 1, 'last');
board(row, move) = turn;
move_rc = [8-row, move];


function v = MTree(board, turn, turnD, curD, maxD)   %actual turn in game, and turn in current depth, current depth, maximum depth
global CNTR

finalD = curD == maxD;
nfreecell = length(find(board == 0));

v = nan(1,7);   %standard value nan represents full column
for move = 1:7

    board0 = board;
    row = find(board0(:,move) == 0, 1, 'last');  %find lowest free row in selected column

    if ~isempty(row) %column not full
        board0(row, move) = turnD;            % place piece of current color
        v(move) = eval_board(board0, turn);   % evaluate position
        CNTR = CNTR + 1;

        %Go one step deeper..
        if  ~finalD && nfreecell > 1 && ~(abs(v(move)) > 10^3)  % .. if not already maximum depth, free cells available, position is not won

            new_turnD = 3-turnD;
            if turnD == 1
                v(move) = min(MTree(board0, turn, new_turnD, curD+1, maxD));
            else
                v(move) = max(MTree(board0, turn, new_turnD, curD+1, maxD));
            end
        end

    end
end


function val = eval_board(board, i)
global INDEX4 EVAL_INDEX

p = board(INDEX4)*[27; 9; 3; 1]+1;  % Each of the 88 arrays of 4 fields is related to a number of 1-81 indicating the actual combination of pieces

val = sum(EVAL_INDEX{i}(p));        % A weighted sum of all arrays yields the evaluation of the given game


function click_col(scr, event)    % Record click on column
global mymove

p = get(gca,'CurrentPoint');
mymove = round(p(1,1)/10);
