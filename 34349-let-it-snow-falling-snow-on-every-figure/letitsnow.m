function letitsnow(figure_hdl, sf_color)
% LETITSNOW - Make the figure snow!
%
% Usage:
% ------
% letitsnow              -  Create snow in the CURRENT figure. If no figure
%                           exists, an empty figure will be created.
% letitsnow(figure_hdl)  -  Create snow in the figure represented by
%                           figure_hdl
% letitsnow(figure_hdl, color) - Create snow with the specified color
%                                'color' is a scalar ranged 0~1 
%
% How to stop the snow
% -----
% Press 's' on the figure or directly close the figure
%
% Mingjing Zhang @ Simon Fraser University, Canada
% Copyright(C)Stellari Studio, 2011

%% Update History
% -------------------------------------------------------------------------
% Date                  Updater                 Modification
% -------------------------------------------------------------------------
% Dec 19, 2010          M. Zhang                wrote it
%%

%% TODO:
% The frost effect

%% Error Check
if ~exist('figure_hdl', 'var')||isempty(figure_hdl)
    figure_hdl = gcf;
%     axes
end
if ~exist('sf_color', 'var') || isempty(sf_color)
    sf_color = 0.9;
end

if strcmp(get(figure_hdl, 'UserData'), 'sn0w1ng')
    return;
end
%% Constant Declaration
fps = 25;
% - For snowflakes -
num_snowflakes = 120;
snowflakes_size = 11;
snowflakes_color = sf_color.*[1 1 1];
height_range = 3;

snow_timer = timer('TimerFcn', @updateSnow_Callback_nest,...
    'ExecutionMode','fixedRate',...
    'Period', 1./fps, 'BusyMode', 'queue');

% Position of snowflakes
snowflakes_x = rand(1, num_snowflakes);

snowflakes_y = rand(1, num_snowflakes);
snowflakes_y = (snowflakes_y .* height_range.^3).^(1/3)+1;
snowflakes_pos = [snowflakes_x; snowflakes_y];

% Velocity of snowflakes
snowflakes_v = rand(1, num_snowflakes).*0.1 + 0.1;  % (distance per second)
snowflakes_theta = (rand(1, num_snowflakes).*60 + 240).*pi/180;
snowflakes_vel = [snowflakes_v.*cos(snowflakes_theta); snowflakes_v.*sin(snowflakes_theta)];

% parameters for the frost image (not implemented for this version)
% frost_image_res = [300 400];
% frost_image_data = ones(frost_image_res(1), frost_image_res(2), 3);
% frost_alpha_data = zeros(frost_image_res); %rand(frost_image_res).*0.4+0.6;
% frost_snowpile_top = ones(1, frost_image_res(2)).*frost_image_res(1);

% direction_vectors = [1 0;1 -1;0 -1;-1 -1;-1 0;-1 1;0 1;1 1];

%% Create two axes (above all the existing axes, if any)
% Modify the figure (just a little bit)
original_figure_title = get(figure_hdl, 'Name');
set(figure_hdl, 'Name', [original_figure_title ' - Happy Holidays!'],...
                'Renderer', 'opengl',...
                'UserData','sn0w1ng',...
                'KeyReleaseFcn', @figureKeyUp_Callback, ...
                'CloseRequestFcn', @figureCloseReq_Callback);
            
% The axes for the snowing effect
snow_axes_hdl = axes('Parent', figure_hdl, ...
                     'Units', 'normalized', ...
                     'Position', [0 0 1 1], ...
                     'Color', [0 0 0], ...
                     'XLim', [0 1], ...
                     'YLim', [0 1], ...
                     'NextPlot','add', ...
                     'Visible', 'off', ...
                     'XTick', [], ...
                     'YTick', []);

% The axes for the frost effect (not implemented for this version)        
frost_axes_hdl = axes('Parent', figure_hdl, ...
                     'Units', 'normalized', ...
                     'Position', [0 0 1 1], ...
                     'Color', [0 0 0], ...
                     'XLim', [0 1], ...
                     'YLim', [0 1], ...
                     'NextPlot','add', ...
                     'Visible', 'off', ...
                     'XTick', [], ...
                     'YTick', []);

%% Create the image objects
snow_plot_hdl = zeros(1,4);

% One snowflake is virtually four different markers overlapped
snow_plot_hdl(1) = plot(snowflakes_x, snowflakes_y, 'h', 'MarkerSize',snowflakes_size);
snow_plot_hdl(2) = plot(snowflakes_x, snowflakes_y, 'x', 'MarkerSize',snowflakes_size);
snow_plot_hdl(3) = plot(snowflakes_x, snowflakes_y, '+', 'MarkerSize',snowflakes_size.*3/4);
snow_plot_hdl(4) = plot(snowflakes_x, snowflakes_y, 's', 'MarkerSize',snowflakes_size.*3/5);

set(snow_plot_hdl, 'Color', snowflakes_color);
% set(snow_plot_hdl, 'Color', snowflakes_color, 'XDataSource', 'snowflakes_x', 'YDataSource', 'snowflakes_y');

% frost_image_hdl = image([0 1], [0 1], frost_image_data, ...
%                         'Parent', frost_axes_hdl,...
%                         'AlphaData', frost_alpha_data, ...
%                         'Visible', 'on');
% frost_alpha_data(150, 200) = 1;
start_time = tic;
last_time = toc(start_time);
uistack(snow_axes_hdl, 'top');
uistack(frost_axes_hdl, 'top');

% Start the falling snow!
start(snow_timer);

%% TimerFcn Callback function for updating the falling snow 
    function updateSnow_Callback_nest(obj, event)
        current_time = toc(start_time);
        elapsed_time = current_time - last_time;
        
        % Update the position
        snowflakes_pos = snowflakes_pos + snowflakes_vel.*elapsed_time;
        
        % Find the snowflakes falling on the ground, and let them reappear
        % from the top of the sky.
        ind_snowflakes_outofbound = snowflakes_pos(2,:)<-0.05;
        snowflakes_pos(2, ind_snowflakes_outofbound) = snowflakes_pos(2, ind_snowflakes_outofbound) + 1.1;
        
        % Update the x/y data source
        snowflakes_x = snowflakes_pos(1,:);
        snowflakes_y = snowflakes_pos(2,:);
        %         refreshdata(snow_plot_hdl, 'caller'); % BROKEN IN R2012b
        set(snow_plot_hdl, 'XData', snowflakes_x, 'YData', snowflakes_y);
        drawnow;
        last_time = current_time;
        
    end
%% KeyReleaseFcn: stop the snow when 's' is pressed
    function figureKeyUp_Callback(obj, event)
        key = get(figure_hdl, 'CurrentKey');
        if strcmp(key, 's')
            stopsnow;
            set(figure_hdl, 'KeyReleaseFcn', []);
        end
    end

%% CloseRequestFcn: stop the snow when the figure window is closed
    function figureCloseReq_Callback(obj, event)
        if strcmp(get(figure_hdl, 'UserData'), 'sn0w1ng')
            stopsnow;
        end
        closereq;
    end

%% Clean up function
    function stopsnow()
        if isvalid(snow_timer)
            stop(snow_timer);
            delete(snow_timer);
            delete(snow_axes_hdl);
            delete(frost_axes_hdl);
        end

        set(figure_hdl, 'UserData', []);
        set(figure_hdl, 'Name', original_figure_title);
    end
end
