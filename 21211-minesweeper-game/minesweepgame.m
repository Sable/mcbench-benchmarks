function minesweepgame(varargin)
%MINESWEEPGAME Starts a new mine-sweep game
%
%   minesweepgame(m, n, k);
%       starts a mine-sweep game on a m x n field containing k mines.
%
%   Examples:
%       minesweepgame(20, 20, 50);
%
%   minesweepgame(level);
%       starts a mine-sweep game of specified level.
%       'beginner':        9 x 9 field with 10 mines
%       'intermediate':    16 x 16 field with 40 mines
%       'advanced:         16 x 30 field with 99 mines
%
%   Examples:
%       minesweepgame('beginner');  or minesweepgame beginner;
%       minesweepgame('intermediate'); or minesweepgame intermediate;
%       minesweepgame('advanced'); o minesweepgame advanced;
%
%   minesweepgame;
%       starts the game at beginner level.
%
%   Created by Dahua Lin, on Aug 24 for fun.
%

%% main skeleton

% some global shared settings

gamelevels = struct( ...
    'name', {'beginner', 'intermediate', 'advanced'}, ...
    'size', {[9 9], [16 16], [16 30]}, ...
    'nmines', {10, 40, 99})';

mfield_limits = struct( ...
    'hlim', [9 24],  ... % min and max of allowed number of rows
    'wlim', [9 30],  ... % min and max of allowed number of columns
    'nlim', [10, 668]);  % min and max of allowed number of mines

% cell state constants
s_close  = 0;
s_open   = 1;
s_tagged = 2;


% construct the figure (window)

hfig = figure('Tag', 'MineSweepGame', 'Name', 'Mine Sweep Game', ...
    'Visible', 'off', 'Units', 'pixels', ...
    'MenuBar', 'none', 'ToolBar', 'none', 'Resize', 'off');

set(hfig, ...
    'WindowButtonDownFcn', @on_window_mousedown, ...  
    'DeleteFcn', @on_close);

layout = get_layout_spec();
visspec = get_visual_spec();

% create the mine field

mfield = create_minefield(varargin{:});

% start a new game and enter the main-loop
[game, ui, vhmap, htimer] = start_newgame();
on_status_updated();
on_timer();


%% Field creating function

    function fconf = get_field_config(level)
        % Get field configuration of a specified level
        %
        %   fconf has the following fields
        %       - m:        the number of rows
        %       - n:        the number of columns
        %       - k:        the number of mines
        %       - level:    the standard name of level
        %
        
        level = lower(level);
        [b, i] = ismember(level, {gamelevels.name});
        
        if b
            fconf = struct( ...
                'm', gamelevels(i).size(1), ...
                'n', gamelevels(i).size(2), ...
                'k', gamelevels(i).nmines, ...
                'level', gamelevels(i).name);            
        else
            error('minesweepgame:invalidarg', ...
                'Unknown level name %s', level);
        end        
    end


    function check_field_config(m, n, k)
        % Check the validity of a field configuration
        
        % check whether it is integer scalar
        pint = @(x) isnumeric(x) && isscalar(x) && x > 0 && x == fix(x);
        assert(pint(m), 'minesweepgame:invalidarg', ...
            'the number of rows (m) should be a positive integer.');
        assert(pint(n), 'minesweepgame:invalidarg', ...
            'the number of columns (n) should be a positive integer.');
        assert(pint(k), 'minesweepgame:invalidarg', ...
            'the number of mines (k) should be a positive integer.');        
        
        % check value limit
        l = mfield_limits;
        assert(m >= l.hlim(1) && m <= l.hlim(2), 'minesweepgame:invalidarg', ...
            'the number of rows should be between %d and %d', l.hlim(1), l.hlim(2));
        assert(n >= l.wlim(1) && n <= l.wlim(2), 'minesweepgame:invalidarg', ...
            'the number of columns should be between %d and %d', l.wlim(1), l.wlim(2));
        assert(k >= l.nlim(1) && k <= l.nlim(2), 'minesweepgame:invalidarg', ...
            'the number of mines should be between %d and %d', l.nlim(1), l.nlim(2));

        assert(k < m * n, 'minesweepgame:invalidarg', ...
            'the number of mines should be less than the total number of cells.');
    end

    
    function [M, nnm] = deploy_mines(m, n, k)
        % Deploy mines to a field (determine where to place the mines)
        %
        %   M:  the m x n logical matrix of mine indicators
        %   nnm:    the matrix of numbers of neighboring mines
        %
        %   This function uses the pure random way
        %
        
        M = false(m, n);
        M(randsample(m * n, k)) = 1;
        
        nnm = conv2(double(M), [1 1 1; 1 0 1; 1 1 1], 'same');
    end


    function mf = create_minefield(varargin)
        % Create a mine field 

        % get configuration                
        
        if nargin == 0
            fc = get_field_config('beginner');
            
        elseif nargin == 1
            level = varargin{1};
            assert(ischar(level), 'minesweepgame:invalidarg', ...
                'level should be a string');
            fc = get_field_config(level);                                

        elseif nargin == 3
            m = varargin{1};
            n = varargin{2};
            k = varargin{3};            

            check_field_config(m, n, k);            
            fc = struct('m', m, 'n', n, 'k', k, 'level', '');

        else
            error('minesweepgame:invalidarg', 'Invalid input arguments.');
        end

        % deploy mines

        [M, nnm] = deploy_mines(fc.m, fc.n, fc.k);
        
        % group the information to output

        mf = struct( ...
            'nrows', fc.m, ...
            'ncolumns', fc.n, ...
            'nmines', fc.k, ...
            'level', fc.level, ...
            'is_mine', M, ...
            'nnbmines', nnm);
    end


    function mf = recreate_minefield(mf0)
        % create a new mine field with the same configuration as mf0
        
        if ~isempty(mf0.level)
            mf = create_minefield(mf0.level);
        else
            mf = create_minefield(mf0.nrows, mf0.ncolumns, mf0.nmines);
        end
        
    end


%% Game functions

    function g = init_gamestates()
        
        % initialize the states of a game        
        g.maxopen = mfield.nrows * mfield.ncolumns - mfield.nmines;
        g.nopen = 0;                 % the number of open cells
        g.nremain = mfield.nmines;   % the number of untagged mines
        g.status = 'waitstart';
        
        % the map of cell states
        %   0 - close
        %   1 - open
        %   2 - tagged        
        g.smap = zeros(mfield.nrows, mfield.ncolumns);    
        
        % highlighted cell
        g.hlcell = [];
    end


    function restart_game()          
        mfield = recreate_minefield(mfield);
        game = init_gamestates();
        clear_all_gelems();        
        stop(htimer);      
        
        on_status_updated();
        on_timer();
    end


    function [game, ui, vhmap, htimer] = start_newgame()
                
        % initialize game states                
        game = init_gamestates();        
        
        % create UI components
        ui = create_ui_components(hfig, mfield, layout, visspec, gamelevels);        
        
        % initialize visual elements
        vhmap = cell(mfield.nrows, mfield.ncolumns);
        
        % create timer        
        htimer = create_timer();
        
        % set callback
        set_callbacks(ui, htimer);
        
        % show figure
        if strcmp(get(hfig, 'Visible'), 'off')
            movegui(hfig);
            set(hfig, 'Visible', 'on');
        end    
        
    end


    function close_game()
        clear_all_gelems();
        stop(htimer);
        delete(htimer);
    end


    function switch_to_level(level)
        mfield = create_minefield(level);
        
        figure(hfig);
        clf;
        
        stop(htimer);
        delete(htimer);
        [game, ui, vhmap, htimer] = start_newgame();    
        
        on_status_updated();
        on_timer();
    end
    

    function C = get_propagate_cells(i0, j0)
       % get the cells than can be open by propagating from (i0, j0)
       % not including i0, j0
       
       % construct data structures
       m = mfield.nrows;
       n = mfield.ncolumns;
       
       om = false(m, n);
       q = zeros(m * n, 2);
       
       % push (i0, j0) to the queue
       q(1, :) = [i0, j0];
       qi0 = 1;
       qi1 = 1;    
       om(i0, j0) = 1;
       
       % traverse
       while qi0 <= qi1
           
           % pop the first element
           i = q(qi0, 1);
           j = q(qi0, 2);
           qi0 = qi0 + 1;                      
           
           if mfield.nnbmines(i, j) == 0
               % add neighbors               
               nis = [i-1, i-1, i-1, i, i, i+1, i+1, i+1]';
               njs = [j-1, j, j+1, j-1, j+1, j-1, j, j+1]';
               
               % filter out out-of-bound candidates
               bf = nis >= 1 & nis <= m & njs >= 1 & njs <= n;
               nis = nis(bf);
               njs = njs(bf);
               idx = sub2ind([m, n], nis, njs);
               
               % filter out mines and those that have been added to queue
               bf = ~mfield.is_mine(idx) & ~om(idx);
               
               % add remaining candidates to queue
               if any(bf)
                   nis = nis(bf);
                   njs = njs(bf);
                   idx = idx(bf);
                   nn = numel(nis);
                   
                   q(qi1+1:qi1+nn, 1) = nis;
                   q(qi1+1:qi1+nn, 2) = njs;
                   qi1 = qi1 + nn;
                   
                   om(idx) = 1;
               end
           end                                     
       end % while
       
       C = q(2:qi1, :);
       
    end


    function do_open_cell(i, j, allow_propagate)
        % open a cell
        
        if strcmp(game.status, 'waitstart')
            start_timing();
        end        
        
        if game.smap(i, j) == s_close
           vis_open_cell(i, j);
           game.smap(i, j) = s_open;   
           game.nopen = game.nopen + 1;
           
           if ~mfield.is_mine(i, j)
               if allow_propagate && mfield.nnbmines(i, j) == 0
                   % do propagate open
                   C = get_propagate_cells(i, j);
                   for k = 1 : size(C, 1)
                       do_open_cell(C(k,1), C(k,2), false);
                   end
               end
               
               if game.nopen == game.maxopen
                   game.status = 'done';
                   stop(htimer);
               end
           else
               game.status = 'failed';
               stop(htimer);
               
               % reveal the incorrectly-tagged cells
               [ti, tj] = find(game.smap == s_tagged);
               for k = 1 : length(ti)
                   if ~mfield.is_mine(ti(k), tj(k))
                       add_marker(ti(k), tj(k), visspec.x_marker);
                   end
               end                                  
           end
                                 
           on_status_updated();
        end                        
    end


    function do_toggle_tag(i, j)   
        % toggle the tag of a cell     
        
        if strcmp(game.status, 'waitstart')
            start_timing();
        end
        
        if game.smap(i, j) ~= s_open
           if game.smap(i, j) ~= s_tagged
               show_tag(i, j);
               game.smap(i, j) = s_tagged;
               game.nremain = game.nremain - 1;
           else
               vis_close_cell(i, j);
               game.smap(i, j) = s_close;
               game.nremain = game.nremain + 1;
           end   
                      
           on_status_updated();
        end        
    end


    function start_timing()        
        stop(htimer);
        game.status = 'ongoing';
        start(htimer);   
        tic;
    end


%% UI Event callbacks
    
    function set_callbacks(ui, htimer)
        set(ui.hbtnRestart, 'Callback', @on_restart);
        if isfield(ui, 'hpmLevel')
            set(ui.hpmLevel, 'Callback', @on_change_level);
        end
        set(htimer, 'TimerFcn', @on_timer);
    end


    function [i, j] = figpt2ij(pt)
        % convert the figure point coordinate to cell subscripts
        
        x = pt(1);
        y = pt(2);

        fp = get(ui.hfield, 'Position');
        x0 = fp(1);
        x1 = fp(1) + fp(3);
        y0 = fp(2);
        y1 = fp(2) + fp(4);
        
        i = ceil((y1 - y) * mfield.nrows / (y1 - y0));
        j = ceil((x - x0) * mfield.ncolumns / (x1 - x0));        
    end


    function on_window_mousedown(sender, eventdata)  %#ok<INUSD>
        
        cstatus = game.status;                
        if strcmp(cstatus, 'waitstart') || strcmp(cstatus, 'ongoing')
                        
            [i, j] = figpt2ij(get(hfig, 'CurrentPoint'));            

            if (i >= 1 && i <= mfield.nrows && j >= 1 && j <= mfield.ncolumns)
                selty = get(hfig, 'SelectionType');

                if strcmp(selty, 'normal')
                    on_leftclick_cell(i, j);
                else
                    on_rightclick_cell(i, j);
                end
            end
        end        
    end

        
    function on_leftclick_cell(i, j)    
        do_open_cell(i, j, true);
    end


    function on_rightclick_cell(i, j)
        do_toggle_tag(i, j);
    end


    function on_change_level(sender, eventdata) %#ok<INUSD>
        
        ilevel = get(ui.hpmLevel, 'Value');        
        level = gamelevels(ilevel).name;
        
        if ~strcmp(level, mfield.level)
            switch_to_level(level);            
        end        
    end


    function on_timer(sender, eventdata) %#ok<INUSD>
        switch game.status
            case 'ongoing'
                set(ui.htextTime, ...
                    'String', sprintf('%d s', round(toc)), ...
                    'ForegroundColor', visspec.time_color);
            case 'waitstart'
                set(ui.htextTime, ...
                    'String', '0 s', ...
                    'ForegroundColor', visspec.time_color);
        end            
    end


    function on_restart(sender, eventdata) %#ok<INUSD>
        restart_game()
    end


    function on_close(sender, eventdata) %#ok<INUSD>
        close_game();
    end


    function on_status_updated()
        switch game.status
            case {'waitstart', 'ongoing'}
                msg = sprintf('%d / %d', game.nremain, mfield.nmines);
                cr = visspec.status_color;
            case 'done'
                msg = 'Done!';
                cr = visspec.donestatus_color;
            case 'failed'
                msg = 'Failed';
                cr = visspec.failstatus_color;
        end
        
        set(ui.htextStat, 'String', msg, 'ForegroundColor', cr);                
    end



%% Element Visualization

    function vis = get_visual_spec()
        % Returns the default visual specification
        
        tag_marker = {'Marker', 'd', 'MarkerSize', 14, ...
            'MarkerFaceColor', 'g', 'MarkerEdgeColor', 'y', 'LineWidth', 1};        
        mine_marker = {'Marker', 'o', 'MarkerSize', 14, ...
            'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'y', 'LineWidth', 1};        
        x_marker = {'Marker', 'x', 'MarkerSize', 18, ...
            'MarkerEdgeColor', [0.5, 0, 0], 'LineWidth', 2.5};        
        
        vis = struct( ...
            'close_bkcolor', [1 1 1] * 0.2, ... % background color for closed cell
            'highlight_color', [1 1 1] * 0.35, ... % the color for highlighting a cell
            'open_bkcolor',  [1 1 1] * 0.7, ... % background color for open cell
            'digit_font', {{'FontSize', 16}}, ... % properties of digit font
            'status_font', {{'FontSize', 15}}, ... % properties of status font
            'tag_marker', {tag_marker}, ... % the marker for a mine tag
            'mine_marker', {mine_marker}, ...  % the marker properties of a mine
            'x_marker', {x_marker}, ... % the X marker upon mine                
            'status_color', 'k', ... % color for normal status
            'donestatus_color', 'b', ... % color for done status
            'failstatus_color', 'r', ... % color for fail status
            'time_color', 'k' ...   % color for showing time            
        ); 
        
        % the color of digits
        % following the setting in the minesweeper of Microsoft Windows
        vis.digit_colors = [ ...
              0   0 255;    % 1 - blue
             42 148  42;    % 2 - dark green
            255   0   0;    % 3 - red
             42  42 148;    % 4 - dark blue
            128   0   0;    % 5 - dark red
             42 148 148;    % 6 - dark cyan
              0   0   0;    % 7 - black
            128 128 128 ... % 8 - gray
            ] / 255;        % normalize
    end


    function clear_all_gelems()
        % clear all graphic elements
        
        ghs = vertcat(vhmap{:});
        delete(ghs);
        vhmap = cell(size(vhmap));
        
    end


    function clear_gelems_in_cell(i, j)
        % clear the graphic elements in a cell (i, j)        
        
        if ~isempty(vhmap{i, j})
            delete(vhmap{i, j});
            vhmap{i, j} = [];
        end
    end


    function add_gelems_in_cell(i, j, h)
        % add a new graphic element in a cell (i, j)
        
        if isempty(vhmap{i, j})
            vhmap{i, j} = h;
        else
            vhmap{i, j} = [vhmap{i, j}; h];
        end
    end


    function add_marker(i, j, marker)
        % add a marker to a cell (i, j)
        
        axes(ui.hfield);
        add_gelems_in_cell(i, j, line(j-0.5, i-0.5, marker{:}));        
    end


    function show_digit(i, j, x)
        % show a digit in a cell
        if x > 0
            add_gelems_in_cell(i, j, text( ...
                    j-0.5, i-0.15, int2str(x), ...
                    'HorizontalAlignment', 'center', ...
                    'VerticalAlignment', 'baseline', ...
                    'Color', visspec.digit_colors(x, :), ...
                    visspec.digit_font{:}));
        end
    end


    function show_mine(i, j)
        % show a mine in a cell
        add_marker(i, j, visspec.mine_marker);
        add_marker(i, j, visspec.x_marker);
    end


    function show_tag(i, j)
        % show a mine tag in a cell
        add_marker(i, j, visspec.tag_marker);
    end
       

    function vis_close_cell(i, j)
        % visualize the cell(i, j) as closed  
        
        axes(ui.hfield);        
        clear_gelems_in_cell(i, j);                    
    end


    function vis_open_cell(i, j)
        % visualize a cell(i, j) as open 
        
        axes(ui.hfield);
        
        % replace the background color
        clear_gelems_in_cell(i, j);
        add_gelems_in_cell(i, j, rectangle( ...
            'Position', [j-1, i-1, 1, 1], ...
            'FaceColor', visspec.open_bkcolor));
        
        if ~mfield.is_mine(i, j)    % open non-mine
            x = mfield.nnbmines(i, j);
            if x > 0
                show_digit(i, j, x);
            end            
        else                        % open mine
            show_mine(i, j);
        end                        
    end


end

%% GUI Construction
    
function s = get_layout_spec()
% Returns the default layout specification

s = struct( ...
    'cell_h', 25, 'cell_w', 25, ... % size of each cell
    'mg_t', 50, 'mg_b', 50, 'mg_l', 25, 'mg_r', 25, ... % margin
    'btn_y', 10, 'btn_h', 25, 'btn_w', 100, ... % button positions
    'btn_xsep', 10, 'btn_ysep', 15); % button separation
end


function uicomps = create_ui_components(hfig, mfield, s, vis, gamelevels)
% The function to create the ui components on a figure
%
%   hfig - the handle to the figure
%   mfield - the struct representing the mine field
%   s - the layout specification
%   vis - the visual specification
%

% calculate layout
nr = mfield.nrows;
nc = mfield.ncolumns;
level = mfield.level;

field_h = s.cell_h * nr;
field_w = s.cell_w * nc;

% set the position of figure

fig_h = field_h + s.mg_t + s.mg_b;
fig_w = max(field_w, s.btn_w * 2 + s.btn_xsep) + s.mg_l + s.mg_r;

figPos = get(hfig, 'Position');
figPos(2) = figPos(2) + figPos(4) - fig_h;
figPos(3) = fig_w;
figPos(4) = fig_h;
set(hfig, 'Position', figPos);

% create field (axes)

uicomps.hfield = axes('Tag', 'Field', ...
    'Units', 'pixels', 'Position', [s.mg_l, s.mg_b, field_w, field_h], ...
    'XLimMode', 'manual', 'XDir', 'normal', 'XLim', [0, nc], ...
    'YLimMode', 'manual', 'YDir', 'reverse', 'YLim', [0, nr], ...
    'XTickMode', 'manual', 'XTick', [], ...
    'YTickMode', 'manual', 'YTick', [], ...
    'Box', 'on', 'Color', vis.close_bkcolor ...
    );

axes(uicomps.hfield);

% vertical lines
lx = [1:nc - 1; 1:nc - 1; nan(1, nc-1)];
ly = repmat([0; nr; nan], 1, nc - 1);
line(lx(:), ly(:), 'Color', 'k');

% horizontal lines
lx = repmat([0; nc; nan], 1, nr - 1);
ly = [1:nr - 1; 1:nr - 1; nan(1, nr-1)];
line(lx(:), ly(:), 'Color', 'k');

% create buttons

if ~isempty(level)
    level_names = {gamelevels.name};
    [dummy, ilevel] = ismember(level, level_names);
    uicomps.hpmLevel = uicontrol('Style', 'popupmenu', 'Tag', 'pmLevel', ...
        'String', level_names, 'Value', ilevel, ...
        'Units', 'pixels', ...
        'Position', [s.mg_l + s.btn_w + s.btn_xsep, s.btn_y, s.btn_w, s.btn_h]);
end

uicomps.hbtnRestart = uicontrol('Style', 'pushbutton', ...
    'Tag', 'btnRestart', 'String', 'Restart', ...
    'Units', 'pixels', 'Position', [s.mg_l, s.btn_y, s.btn_w, s.btn_h]);

% create status text

stat_y = s.mg_b + field_h + s.btn_ysep;

uicomps.htextStat = uicontrol('Style', 'text', 'Tag', 'textStatus', 'Units', 'pixels', ...
    'String', '', 'Position', [s.mg_l, stat_y, s.btn_w, s.btn_h], vis.status_font{:});

uicomps.htextTime = uicontrol('Style', 'text', 'Tag', 'textTime', 'Units', 'pixels', ...
    'String', '', 'Position', [s.mg_l + s.btn_w + s.btn_xsep, stat_y, s.btn_w, s.btn_h], ...
    vis.status_font{:});

end


function htimer = create_timer()
% create the timer to show game time

htimer = timer('Period', 0.2, ...
    'ExecutionMode', 'fixedRate', 'StartDelay', 1);
end

