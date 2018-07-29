function [STRUCT] = matlabtetris(varargin)
%MATLABTETRIS A MATLAB version of the classic game Tetris.
% The goal is to fill as many horizontal lines on the game board as 
% possible by manipulating the pieces as they fall into place.  As more
% lines are filled, gameplay speeds up.  More points are awarded the more
% lines are filled at once, and as a function of the current level.
%
% Pushing the following keys has the listed effect:
%
% Key     Effect
% ------------------
% n       Starts a new game in the middle of any game.
% p       Pauses/Unpauses game play.
% s       Starts the new game (alternative to pushing the start button).
%
% Other tips:
%
% To move the piece, use the arrow keys.
% The up arrows rotates a piece clockwise, shift+up, counter clockwise.
% Clicking on the preview window hides/unhides the preview (next piece).
% Click on the level (1) before starting a game to choose start level.  If
% the first level is too slow, try starting out at a higher level, up to 9. 
% The desired starting level may also be passed in as an argument when 
% first calling the game.  For example, 
%
%       matlabetetris(7)
%
% starts the game at level 7.
%
% Also, calling
%
%       A = matlabtetris;
%
% returns the handle/data structure.  Handles are lower-case, data 
% uppercase.  This can be useful for troubleshooting, etc.
%
% This game changes the state of the random generator.
% This game tries to write the high score to a file named:
%
%       TETRIS_HIGH_SCORE.mat
%
% Author: Matt Fig
% Date: 1/11/2012  
% Version 2.1 

try
    rng('shuffle');  % So each game is not the same! RNG is new in r2011a.
catch  %#ok
    rand('twister',sum(100*clock));  %#ok Should work back to r2006a.
end

f_clr = [.741 .717 .42]; % Allows for easy change.  Figure color.
S.fig = figure('units','pixels',...
               'name','Tetris',...
               'menubar','none',...
               'numbertitle','off',...
               'position',[100 100 650 720],...
               'color',f_clr,...
               'keypressfcn',@fig_kpfcn2,...%
               'closereq',@fig_clsrqfcn,...%
               'busyaction','cancel',...
               'renderer','opengl',...
               'windowbuttondownfcn',@fig_wbdfcn,...
               'resizefcn',@fig_rszfcn);
S.pbt = uicontrol('units','pix',...
                  'style','pushbutton',...
                  'position',[420 30 200 100],...
                  'fontweight','bold',...
                  'fontsize',20,...
                  'string','Start',...
                  'callback',@pbt_call,...
                  'enable','off',...
                  'busyaction','cancel');
S.axs = axes('units','pix',...
             'position',[420 460 200 200],...
             'ycolor',f_clr,...
             'xcolor',f_clr,...
             'color',f_clr,...
             'xtick',[],'ytick',[],...
             'xlim',[-.1 7.1],...
             'ylim',[-.1 7.1],...
             'visible','off'); % This axes holds the preview.
r_col = [.85 .95 1]; % The color of the rectangles.
S.rct = rectangle('pos',[0 0 7 7],...
                  'curvature',.3,...
                  'facecolor',r_col,...
                  'edgecolor','r',...
                  'linewidth',2); % This is used below the preview.
S.tmr = timer('Name','Tetris_timer',...
              'Period',1,... % 1 second between moves time.
              'StartDelay',1,... %
              'TasksToExecute',50,... % Will be restarted many times.
              'ExecutionMode','fixedrate',...
              'TimerFcn',@game_step); % Function def. below.
S.axs(2) = axes('units','pix',...
                'position',[410 130 220 320],...
                'ycolor',f_clr,...
                'xcolor',f_clr,...
                'xtick',[],'ytick',[],...
                'xlim',[-.1 1.1],...
                'ylim',[-.1 1.1],...
                'visible','off'); % Points/Lines holder
S.rct(2) = rectangle('pos',[0 0 1 1],...
                     'curvature',.3,...
                     'facecolor',r_col,...
                     'edgecolor','r',...
                     'linewidth',2); % Holds the current stats.
S.DSPDIG(1) = digits(35,5,-50,'Lines');
set(S.DSPDIG(1).ax,'pos',[500 170 0 0]+get(S.DSPDIG(1).ax,'pos'));
S.DSPDIG(2) = digits(35,8,10,'Points');
set(S.DSPDIG(2).ax,'pos',[438 260 0 0]+get(S.DSPDIG(2).ax,'pos'));
S.DSPDIG(3) = digits(35,3,-90,'Level');
set(S.DSPDIG(3).ax,'pos',[540 350 0 0]+get(S.DSPDIG(3).ax,'pos'));
set(S.DSPDIG(3).ax,'visible','on')
digits(S.DSPDIG(3),sprintf('%i',1))
S.axs(3) = axes('units','pix',...
                'position',[30 30 360 630],...
                'ycolor',f_clr,...
                'xcolor',f_clr,...
                'xtick',[],'ytick',[],...
                'xlim',[-1 11],...
                'ylim',[-1 20],...
                'color',f_clr,...
                'visible','off'); % The main board
% Template positions for the patch objects (bricks) in both axes.
X = [0 .2 0;.2 .8 .2;.2 .8 .8;.8 .2 .8;1 .2 1;0 .2 1;0 .2 0];
Y = [0 .2 0;.2 .2 .2;.8 .8 .2;.8 .8 .8;1 .2 1;1 .2 0;0 .2 0];
g1 = repmat([.9 .65 .4],[1,1,3]); % Grey color used throughout.
S.PRVPOS{1} = [1.5 2.5 3.5 4.5;3 3 3 3]; % Positions of the previews.
S.PRVPOS{2} = [2 3 3 4;2.5 2.5 3.5 2.5]; % 1-I,2-T,3-L,4-J,5-Z,6-S,7-O
S.PRVPOS{3} = [2 3 4 4;2.5 2.5 2.5 3.5];
S.PRVPOS{4} = [2 2 3 4;3.5 2.5 2.5 2.5];
S.PRVPOS{5} = [2 3 3 4;3.5 3.5 2.5 2.5];
S.PRVPOS{6} = [2 3 3 4;2.5 2.5 3.5 3.5];
S.PRVPOS{7} = [2.5 2.5 3.5 3.5;3.5 2.5 3.5 2.5];
% Make the board boarders.
for jj = [-1 10]
    Xi = X + jj;
    
    for ii = -1:19
        patch(Xi,Y+ii,g1,...
              'edgecolor','none',...
              'handlevis','callback') % Don't need these handles.
    end
end

for ii = 0:9
    patch(X+ii,Y-1,g1,'edgecolor','none','handlevis','callback')
end

S.pch = zeros(10,20); % These hold the handles to the patches.

for jj = 0:19 % Make the board squares.
    for ii = 0:9
        if rand<.05 % This simply puts random squares on the board.
            % If you have an older version without BSXFUN, use the second
            % line below and comment out the first line below - IF ERROR.
            R = bsxfun(@minus,.5 + rand(1,1,3)*.5,[0,.25,.5]); % See note! 
% R = repmat(.5 + rand(1,1,3)*.5,[1,3,1])-repmat([0,.25,.5],[1,1,3]);
            S.pch(ii+1,jj+1) = patch(X+ii,Y+jj,R,'edgecolor','none');
            % drawnow   % On faster systems this can look neat.
        else
            S.pch(ii+1,jj+1) = patch(X+ii,Y+jj,'w','edgecolor','w');
        end
    end
end
% Hold the colors of the pieces, and board index where each first appears.
S.PCHCLR = {reshape([1 .75 .5 0 0 0 0 0 0],1,3,3),...
            reshape([0 0 0 1 .75 .5 0 0 0],1,3,3),...
            reshape([0 0 0 0 0 0 1 .75 .5],1,3,3),...
            reshape([1 .75 .5 1 .75 .5 0 0 0],1,3,3),...
            reshape([1 .75 .5 0 0 0 1 .75 .5],1,3,3),...
            reshape([0 0 0 1 .75 .5 1 .75 .5],1,3,3),...
            reshape([.5 .25 0 .5 .25 0 .5 .25 0],1,3,3)}; % Piece colors.
% S.PCHIDX holds the location where each piece first appears on the board.
S.PCHIDX = {194:197,[184 185 186 195],[184 185 186 196],...
            [184 185 186 194],[194 195 185 186],[184 195 185 196],...
            [185 186 195 196]};
S.MAKPRV = true;  % Make a preview or not.
S.CURPRV = []; % Holds current preview patches.
S.PRVNUM = []; % Holds the preview piece number, 1-7.
make_preview;  % Call the function which chooses the piece to go next.
S.BRDMAT = false(10,20); % The matrix game board.
S.CURROT = 1; % Holds the current rotation of the current piece.
S.PNTVCT = [40 100 300 800]; % Holds the points per number of lines.
S.CURLVL = 1; % The current level.
S.CURLNS = 0; % The current number of lines
S.STPTMR = 0; % Kills timer when user is pushing keyboard buttons.
S.SOUNDS = load('splat'); % Used for landing/line sound effect.
S.plr = audioplayer(S.SOUNDS.y,S.SOUNDS.Fs); % player for sounds.
S.CURSCR = 0; % Holds the current score during play.
S.PLRLVL = 1; % The level the player chooses to start...
% These next two dictate how fast the game increases its speed and also how
% many lines the player must score to go up a level, respectively.  The
% first value shoould be on (0,1].  Smaller values increase speed faster.
% No error handling is provided if you use bad values!
S.LVLFAC = .825;  % Percent of previous timerdelay. 
S.CHGLVL = 5; % Increment level every S.CHGLVL lines.

if nargin && isnumeric(varargin{1})
    S.PLRLVL = min(round(max(varargin{1},1)),9);  % Starting level.
    digits(S.DSPDIG(3),sprintf('%i',S.PLRLVL))
end

try
    SCR = load('TETRIS_HIGH_SCORE.mat');
    S.CURHSC = SCR.SCR; % The user has a previous High Score.
catch  %#ok
    S.CURHSC = 0;
end

set(S.fig,'name',['Tetris',' High Score - ', sprintf('%i',S.CURHSC)])
set([S.DSPDIG(:).ax,S.axs(:).',S.pbt,S.DSPDIG(:).tx],...
    'units','norm','fontunits','norm')  % So we can resize the figure.
set(S.pbt,'enable','on') % Turn the game on now that we are ready...

if nargout
    STRUCT = S; % Returns the structure if user requests.
end


    function [] = make_preview(varargin)
    % This function chooses which piece is going next and displays it.
        if nargin
            S.PRVNUM = varargin{1};
        else
            S.PRVNUM = ceil(rand*7); % Randomly choose one of the pieces.
        end

        if ~isempty(S.CURPRV)
            delete(S.CURPRV) % Delete previous preview.
        end

        if S.MAKPRV
            C = S.PCHCLR{S.PRVNUM};  % User wants to show the preview.
        else
            C = r_col;
        end

        for kk = 1:4  % Create a new preview.
            S.CURPRV(kk) = patch(X+S.PRVPOS{S.PRVNUM}(1,kk),...
                                 Y+S.PRVPOS{S.PRVNUM}(2,kk),...
                                 C,'edgecolor','none',...
                                 'parent',S.axs(1));
        end
    end


    function [] = pbt_call(varargin)
    % Callback for the 'Start' ('Pause', 'Continue') button.
        switch get(S.pbt,'string')
            case 'Start'
                set(S.pch(:),'facecol','w','edgecol','w'); % Clear board.
                set(S.pbt,'string','Pause'); % Changle pushbutton label.
                digits(S.DSPDIG(3),sprintf('%i',S.PLRLVL)) % Show Level.
                ND = round(1000*S.LVLFAC^(S.PLRLVL-1))/1000;% Update Timer.
                set(S.tmr,'startdelay',ND,'period',ND);
                digits(S.DSPDIG(2),sprintf('%i',0)) % Score and Lines
                digits(S.DSPDIG(1),sprintf('%i',0))
                S.CURLNS = 0; % New Game -> start at zero.
                S.CURLVL = S.PLRLVL; % Set the level to players choice.
                S.CURSCR = 0; % New Game -> start at zero.
                play_tet; % Initiate Gameplay.
            case 'Pause'
                stop_tet;  % Stop the timer, set the callbacks
                set([S.fig,S.pbt],'keypressfcn',@fig_kpfcn2)
                set(S.pbt,'string','Continue')
            case 'Continue'
                set(S.pbt,'string','Pause')
                start_tet;  % Restart the timer.
            otherwise
        end
    end


    function [] = play_tet()
    % Picks a next piece and puts the preview in correct axes.
        S.PNM = S.PRVNUM; % Hold this for keypresfcn.
        S.CUR = S.PCHIDX{S.PRVNUM}; % Current loc. of current piece.
        S.COL = S.PCHCLR{S.PRVNUM}; % Transfer correct color.
        S.CURROT = 1; % And initial rotation number.
        set(S.pch(S.CUR),'facec','flat','cdata',S.COL,'edgecol','none')

        if any(S.BRDMAT(S.CUR))
            disp('....Game over....')
            clean_tet;  % Clean up the board.
            set([S.fig,S.pbt],'keypressfcn',@fig_kpfcn2)
            return
        else
            S.BRDMAT(S.CUR) = true; % Now update the matrix...
        end

        make_preview;  % Set up the next piece.
        start_tet;     % Start the timer.
    end


    function [] = game_step(varargin)
    % Timerfcn, advances the current piece down the board
        if S.STPTMR && nargin  % Only timer calls with args...
            return  % So that timer can't interrupt FIG_KPFCN!
        end

        col = ceil(S.CUR/10); % S.CUR defined in play_tet.
        row = rem(S.CUR-1,10) + 1;  % These are for the board matrix.

        if any(col==1)  % Piece is at the bottom of the board.
            stop_tet;
            check_rows;
            play_tet;
        else
            ur = unique(row);  % Check to see if we can drop it down

            for kk = 1:length(ur)
                if (S.BRDMAT(ur(kk),min(col(row==ur(kk)))-1))
                    stop_tet;
                    check_rows;
                    play_tet;
                    return
                end
            end

            mover(-10)  % O.k. to drop the piece... do it.
        end
    end


    function [] = fig_kpfcn(varargin)
    % Figure (and pushbutton) keypressfcn
        S.STPTMR = 1;  % Stop timer interrupts.  See GAME_STEP

        if strcmp(varargin{2}.Key,'downarrow')
            game_step; % Just call another step.
            S.STPTMR = 0;  % Unblock the timer.
            return
        end

        col = ceil(S.CUR/10); % S.CUR defined in play_tet.
        row = rem(S.CUR-1,10) + 1;  % These index into board matrix.

        switch varargin{2}.Key
            case 'rightarrow'
                % Without this IF, the piece will wrap around!
                if max(row)<=9
                    uc = unique(col);  % Check if object to the right.

                    for kk = 1:length(uc)
                        if (S.BRDMAT(max(row(col==uc(kk)))+1,uc(kk)))
                            S.STPTMR = 0;
                            return
                        end
                    end

                    mover(1)   % O.k. to move.
                end
            case 'leftarrow'
                if min(row)>=2
                    uc = unique(col);  % Check if object to the left

                    for kk = 1:length(uc)
                        if (S.BRDMAT(min(row(col==uc(kk)))-1,uc(kk)))
                            S.STPTMR = 0;
                            return
                        end
                    end

                    mover(-1)  % O.k. to move.
                end
            case 'uparrow'
                if strcmp(varargin{2}.Modifier,'shift')
                    arg = 1;  % User wants counter-clockwise turn.
                else
                    arg = 0;
                end

                turner(row,col,arg);  % Turn the piece.
            case 'p'
                pbt_call;  % This will set to pause. Next set new ...
                set([S.fig,S.pbt],'keypressfcn',@fig_kpfcn2)% Keypressfcn 
            case 'n'
                quit_check;  % User might want to quit the game.
            otherwise
        end

        S.STPTMR = 0;  % Unblock the timer.
    end


    function [] = fig_kpfcn2(varargin)
    % Callback handles the case when 's' or 'p' is pressed if 
    % the game is paused or at game start.
        tmp = strcmp(get(S.pbt,'string'),{'Start','Continue'});
        
        if tmp(1)
            if strcmp(varargin{2}.Key,'s')
                pbt_call;  % User wants to start a game.
            end
        else 
            if tmp(2)
                if any(strcmp(varargin{2}.Key,...
                       {'1','2','3','4','5','6','7'}))
                    make_preview(str2double(varargin{2}.Key));
                    return
                end
            end
            
            if strcmp(varargin{2}.Key,'p')
                pbt_call;  % User wants to pause/unpause.
            end

            if strcmp(varargin{2}.Key,'n')
                quit_check;  % Perhaps user wants to quit.
            end
        end
    end


    function [] = mover(N)
    % Common task. Moves a piece on the board.
        S.BRDMAT(S.CUR) = false; % S.CUR, S.COL defined in play_tet.
        S.BRDMAT(S.CUR+N) = true; % All checks should be done already.
        S.CUR = S.CUR + N;
        set([S.pch(S.CUR-N),S.pch(S.CUR)],...
            {'facecolor'},{'w';'w';'w';'w';'flat';'flat';'flat';'flat'},...
            {'edgecolor'},{'w';'w';'w';'w';'none';'none';'none';'none'},...
            {'cdata'},{[];[];[];[];S.COL;S.COL;S.COL;S.COL})
    end


    function [] = turner(row,col,arg)
    % Common task. Rotates the pieces once at a time.
    % r is reading left/right, c is reading up/down.
    % For the switch:  1-I,2-T,3-L,4-J,5-Z,6-S,7-O
        switch S.PNM % Defined in play_tet.  Turn depends on shape.
            case 1  
                if any(col>19) || all(col<=2)
                    return
                else
                    if S.CURROT == 1;
                        r = [row(2),row(2),row(2),row(2)];
                        c = [col(2)-2,col(2)-1,col(2),col(2)+1];
                        S.CURROT = 2;
                    elseif all(row>=9)
                        r = 7:10;
                        c = [col(2),col(2),col(2),col(2)];
                        S.CURROT = 1;
                    elseif all(row==1)
                        r = 1:4;
                        c = [col(2),col(2),col(2),col(2)];
                        S.CURROT = 1;
                    else
                        r = [row(2)-1,row(2),row(2)+1,row(2)+2];
                        c = [col(2),col(2),col(2),col(2)];
                        S.CURROT = 1;
                    end
                end
            case 2
                if sum(col==1)==3
                    return
                end

                if arg
                    S.CURROT = mod(S.CURROT+1,4)+1;
                end

                switch S.CURROT
                    case 1
                        r = [row(2),row(2),row(2),row(2)+1];
                        c = [col(2)-1,col(2),col(2)+1,col(2)];
                    case 2
                        if sum(row==1)==3
                            r = [1 2 3 2];
                            c = [col(2),col(2),col(2),col(2)-1];
                        else
                            r = [row(2)-1,row(2),row(2),row(2)+1];
                            c = [col(2),col(2),col(2)-1,col(2)];
                        end
                    case 3
                        r = [row(2)-1,row(2),row(2),row(2)];
                        c = [col(2),col(2),col(2)-1,col(2)+1];
                    case 4
                        if sum(row==10)==3
                            r = [9 9 8 10];
                            c = [col(2)+1,col(2),col(2),col(2)];
                        else
                            r = [row(2)-1,row(2),row(2),row(2)+1];
                            c = [col(2),col(2),col(2)+1,col(2)];
                        end
                end

                S.CURROT = mod(S.CURROT,4) + 1;
            case 3
                if sum(col==1)==3
                    return
                end

                if arg
                    S.CURROT = mod(S.CURROT+1,4)+1;
                end

                switch S.CURROT
                    case 1
                        r = [row(2),row(2),row(2),row(2)+1];
                        c = [col(2)+1,col(2),col(2)-1,col(2)-1];
                    case 2
                        if sum(row==1)==3
                            r = [1:3 1];
                            c = [col(2),col(2),col(2),col(2)-1];
                        else
                            r = [row(2)-1,row(2),row(2)-1,row(2)+1];
                            c = [col(2),col(2),col(2)-1,col(2)];
                        end
                    case 3
                        r = [row(2)-1,row(2),row(2),row(2)];
                        c = [col(2)+1,col(2),col(2)+1,col(2)-1];
                    case 4
                        if sum(row==10)==3
                            r = [10 9 10 8];
                            c = [col(2)+1,col(2),col(2),col(2)];
                        else
                            r = [row(2)-1,row(2),row(2)+1,row(2)+1];
                            c = [col(2),col(2),col(2),col(2)+1];
                        end
                end

                S.CURROT = mod(S.CURROT,4) + 1;
            case 4
                if sum(col==1)==3
                    return
                end

                if arg
                    S.CURROT = mod(S.CURROT+1,4)+1;
                end

                switch S.CURROT
                    case 1
                        r = [row(2),row(2),row(2),row(2)+1];
                        c = [col(2)-1,col(2),col(2)+1,col(2)+1];
                    case 2
                        if sum(row==1)==3
                            r = [1 2 3 3];
                            c = [col(2),col(2),col(2),col(2)-1];
                        else
                            r = [row(2)-1,row(2),row(2)+1,row(2)+1];
                            c = [col(2),col(2),col(2),col(2)-1];
                        end
                    case 3
                        r = [row(2)-1,row(2),row(2),row(2)];
                        c = [col(2)-1,col(2),col(2)-1,col(2)+1];
                    case 4
                        if sum(row==10)==3
                            r = [8 9 8 10];
                            c = [col(2)+1,col(2),col(2),col(2)];
                        else
                            r = [row(2)-1,row(2),row(2)-1,row(2)+1];
                            c = [col(2),col(2),col(2)+1,col(2)];
                        end
                end

                S.CURROT = mod(S.CURROT,4) + 1;
            case 5
                if any(col(2)>19) || sum(col==1)==2
                    return
                elseif S.CURROT==1;
                    r = [row(2),row(2),row(2)-1,row(2)-1];
                    c = [col(2)+1,col(2),col(2),col(2)-1];
                    S.CURROT = 2;
                else
                    if sum(row==10)==2
                        r = [10 9 9 8];
                        c = [col(2)-1,col(2)-1,col(2),col(2)];
                    else
                        r = [row(2)-1,row(2),row(2),row(2)+1];
                        c = [col(2),col(2),col(2)-1,col(2)-1];
                    end

                    S.CURROT = 1;
                end
            case 6
                if any(col(2)>19)|| sum(col==1)==2
                    return
                elseif S.CURROT==1;
                    r = [row(2)+1,row(2),row(2)+1,row(2)];
                    c = [col(2)-1,col(2),col(2),col(2)+1];
                    S.CURROT = 2;
                else
                    if sum(row==1)==2
                        r = [1 2 2 3];
                        c = [col(2)-1,col(2)-1,col(2),col(2)];
                    else
                        r = [row(2)-1,row(2),row(2),row(2)+1];
                        c = [col(2)-1,col(2),col(2)-1,col(2)];
                    end
                    S.CURROT = 1;
                end
            otherwise
                return % The O piece.
        end

        ind = r + (c-1)*10; % Holds new piece locations.
        tmp = S.CUR; % Want to call SET last! S.CUR defined in play_tet.
        S.BRDMAT(S.CUR) = false;

        if any(S.BRDMAT(ind)) % Check if any pieces are in the way.
            S.BRDMAT(S.CUR) = true;
            return
        end

        S.BRDMAT(ind) = true;
        S.CUR = ind; % S.CUR, S.COL defined in play_tet.
        set([S.pch(tmp),S.pch(ind)],...
            {'facecolor'},{'w';'w';'w';'w';'flat';'flat';'flat';'flat'},...
            {'edgecolor'},{'w';'w';'w';'w';'none';'none';'none';'none'},...
            {'cdata'},{[];[];[];[];S.COL;S.COL;S.COL;S.COL});
    end


    function [] = check_rows()
    % Checks if any row(s) needs clearing and clears it (them).
        TF = all(S.BRDMAT); % Finds the rows that are full.

        if any(TF)  % There is a row that needs clearing.
            set(S.pbt,'enable','off')  % Don't allow user to mess it up.
            sm = sum(TF); % How many rows are there?
            B = false(size(S.BRDMAT));  % Temp store to switcheroo.
            B(:,1:20-sm) = S.BRDMAT(:,~TF);
            S.BRDMAT = B;
            TF1 = find(TF); % We only need to drop those rows above.
            L = length(TF1);
            TF = TF1-(0:L-1);
            S.CURLNS = S.CURLNS + L;
            digits(S.DSPDIG(1),sprintf('%i',S.CURLNS))  % Lines display
            S.CURSCR = S.CURSCR+S.PNTVCT(L)*S.CURLVL;
            digits(S.DSPDIG(2),sprintf('%i',S.CURSCR))  % Points display
            play(S.plr,[6000 length(S.SOUNDS.y)])

            for kk = 1:L % Make these rows to flash for effect.
                set(S.pch(:,TF1(:)),'facecolor','r');
                pause(.1)
                set(S.pch(:,TF1(:)),'facecolor','g');
                pause(.1)
            end

            for kk = 1:L % 'Delete' these rows.
                set(S.pch(:,TF(kk):19),...
                    {'facecolor';'edgecolor';'cdata'},...
                    get(S.pch(:,TF(kk)+1:20),...
                    {'facecolor';'edgecolor';'cdata'}));
            end

            if (floor(S.CURLNS/S.CHGLVL)+1)>S.CURLVL % Level display check.
                S.CURLVL = S.CURLVL + 1;
                digits(S.DSPDIG(3),sprintf('%i',S.CURLVL))
                ND = round(get(S.tmr,'startdelay')*S.LVLFAC*1000)/1000;
                ND = max(ND,.001);
                set(S.tmr,'startdelay',ND,'period',ND) % Update timer
            end

            if S.CURSCR>=S.CURHSC  % So that figure name is current.
                S.CURHSC = S.CURSCR;
                set(S.fig,'name',...
                    sprintf('Tetris High Score - %i',S.CURHSC))
            end

            set(S.pbt,'enable','on')  % Now user is o.k. to go.
        else
            if ~isplaying(S.plr)
                play(S.plr,[7500 8500])  % Play our plunk sound.
            end
        end
    end


    function [] = clean_tet()
    % Cleans up the board and board matrix after Game Over.
        stop_tet;  % Stop the timer.

        for kk = 1:20
            set(S.pch(:,kk),'cdata',g1,'edgecol','none')
            drawnow % Gives the nice effect of grey climbing up.
        end

        set(S.pbt,'string','Start')
        S.BRDMAT(:) = false; % Reset the board matrix.
    end


    function [] = start_tet()
    % Sets the correct callbacks and timer for a new game
        set([S.fig,S.pbt],'keypressfcn',@fig_kpfcn)
        start(S.tmr)
    end


    function [] = stop_tet()
    % Sets the correct callbacks and timer to stop game
        stop(S.tmr)
        set([S.fig,S.pbt],'keypressfcn','fprintf('''')')
    end


    function [] = fig_clsrqfcn(varargin)
    % Clean-up if user closes figure while timer is running.
        try  % Try here so user can close after error in creation of GUI.
            warning('off','MATLAB:timer:deleterunning')
            delete(S.tmr)  % We always want the timer destroyed first.
            warning('on','MATLAB:timer:deleterunning')
            SCR = S.CURHSC;

            try
                save('TETRIS_HIGH_SCORE.mat','SCR')
            catch  %#ok
                disp('Unable to save high score. Check permissions.')
            end
        catch %#ok
        end
        
        delete(varargin{1})  % Now we can close it down.
    end


    function [] = fig_wbdfcn(varargin)
    % The WindowButtonDownFcn for the figure.
        if any(gco==[S.rct(1);S.CURPRV(:)]) % Clicked in preview window.
            S.MAKPRV = ~S.MAKPRV;  % Change from current state.
            
            if S.MAKPRV
                set(S.CURPRV,'cdata',S.PCHCLR{S.PRVNUM},'facecolor','flat')
            else
                set(S.CURPRV,'facecolor',r_col)
            end
        elseif any(gco==[S.DSPDIG(3).ax [S.DSPDIG(3).P{:}]])
            % In here user wants to select a starting level.
            if strcmp(get(S.pbt,'string'),'Start')
                tmp = inputdlg('Enter Starting Level',...
                               'Level',1,{sprintf('%i',S.PLRLVL)});
                                
                if ~isempty(tmp)  % User might have closed dialog.           
                    S.PLRLVL = min(round(max(str2double(tmp),1)),9);
                    digits(S.DSPDIG(3),sprintf('%i',S.PLRLVL))
                end
            end
        end
    end


    function [] = fig_rszfcn(varargin)
    % The figure's resizefcn
        pos = get(S.fig,'pos');  % Don't allow distorted shapes...
        rat = 720/650; % This ratio will be hard-coded. Original pix size.
        set(S.fig,'pos',[pos(1) pos(2) pos(4)/rat, pos(4)]);
    end


    function [] = quit_check()
    % Creates a dialog box to check if the user wants to quit.
        QG = questdlg('Are you sure you want to start over?',...
                      'End current game?', ...
                      'Yes', 'No', 'Yes');
        if strcmp(QG,'Yes')
            clean_tet;
            % The call to UICONTROL is necessary if a line has
            % just been scored and the user hits n to start a new
            % game but not otherwise ... mysterious...
            uicontrol(S.pbt)
            pbt_call;
        end
    end


    function [X] = digits(varargin)
    % To create a display, pass in the pixel height desired, the number of
    % digits to create, the offset of the text and string. To update the
    % display, pass in a string representation of the number to display...
    %
    % Example:
    % X = digits(80,2,0,'Points'); % 80 pix tall, 2 digits, 0 offset.
    % for ii = 1:100,digits(X,sprintf('%i',ii)),pause(.1),end

        if isstruct(varargin{1})
            transcriber(varargin{1},varargin{2});  % Change display.
            return
        else
            X.N = varargin{1}; % The pixel height of the numbers.
            X.M = varargin{2}; % The number of numbers.
            X.D = varargin{3}; % The offset of the text, in pixels.
            X.T = varargin{4}; % The display label.
        end

        X.ax = axes('units','pix',...
                    'pos',[0,0,X.N/1.7*X.M,X.N],...
                    'xtick',[],'ytick',[],...
                    'xlim',[0,X.M],'ylim',[0,1.7],...
                    'color',r_col,...
                    'xcolor',r_col,...
                    'ycolor',r_col,...
                    'visible','off');  % Digits displayed on this axes.
        X.tx = text('units','pixels',...
                    'pos',[X.D,X.N+10],...
                    'string',X.T,...
                    'backgroundc','none',...
                    'vertical','baselin',...
                    'fontw','bold',...
                    'fontname','fixedwidth',...
                    'fontsize',20,...
                    'color',[0.39216 .27059 .07451]);  % Create label.
        % X.P holds the basic patch pattern as a template.
        X.P{1}(1) = patch([.175 .275 .725 .825 .725 .275 .175],...
                          [.150 .050 .050 .150 .250 .250 .150],'k');
        X.P{1}(2) = patch([.175 .275 .725 .825 .725 .275 .175],...
                          [.150 .050 .050 .150 .250 .250 .150]+.7,'k');
        X.P{1}(3) = patch([.175 .275 .725 .825 .725 .275 .175],...
                          [.150 .050 .050 .150 .250 .250 .150]+1.4,'k');
        X.P{1}(4) = patch([.150 .050 .050 .150 .250 .250 .150],...
                          [.175 .275 .725 .825 .725 .275 .175],'k');
        X.P{1}(5) = patch([.150 .050 .050 .150 .250 .250 .150],...
                          [.175 .275 .725 .825 .725 .275 .175]+.7,'k');
        X.P{1}(6) = patch([.150 .050 .050 .150 .250 .250 .150]+.70,...
                          [.175 .275 .725 .825 .725 .275 .175],'k');
        X.P{1}(7) = patch([.150 .050 .050 .150 .250 .250 .150]+.70,...
                          [.175 .275 .725 .825 .725 .275 .175]+.70,'k');
        set(X.P{1},'edgecolor','none')

        for ww = 2:X.M
            for yy = 1:7
                X.P{ww}(yy) = patch('xdata',...
                                    get(X.P{1}(yy),'xdata')+(ww-1),...
                                    'ydata',get(X.P{1}(yy),'ydata'),...
                                    'facecolor','k',...
                                    'edgecolor','none');% Making digits!
            end
        end

        X.PAT = {[1 3 4 5 6 7],... % 0.. Hold the pattern to each digit...
                 [6 7],...         % used as an index into X.P
                 [1 2 3 4 7],...   % 2
                 [1 2 3 6 7],...   % 3
                 [2 5 6 7],...     % 4
                 [1 2 3 5 6],...   % 5
                 [1 2 4 5 6],...   % 6
                 [3 6 7],...       % 7
                 1:7,...           % 8
                 [2 3 5 6 7]};     % 9
        transcriber(X,'0')

        
        function [] = transcriber(X,C)
        % This deals with making the numbers. Nested to DIGITS.
            if length(C)>X.M  % Display more digits than available!
                C = repmat('9',1,X.M);
            else
                C = [repmat('!',1,X.M-length(C)),C];  % Pad them to left.
            end

            for xx = 1:X.M
                set(X.P{xx}(:),'facecolor','none') % Clean it up first.

                if ~strcmp('!',C(xx))
                    set(X.P{xx}(X.PAT{str2double(C(xx))+1}),...
                        'facecolor',[.1 .4 .1])  % Set correct display.
                end
            end
        end
    end
end