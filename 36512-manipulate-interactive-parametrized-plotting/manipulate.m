function manipulate(mathfunc_full, XYLim, varargin)
%% MANIPULATE - Plot graphics with interactively manipulable parameters
% MANIPULATE   by itself, it displays the plot of a sinusoidal function with
% four slider controlling four parameters
% MANIPULATE(MATHFUNC, XYLIM, PARAM1, PARAM2, ...)
%  MATHFUNC is an 1 x 3 cell array in the following form:
%   {FUNC X INIT_PARAM}
%   ------------------
%   FUNC: the handle of a function that accepts two inputs: x and params,
%   and returns the corresponding y value(s) of this parametrized curve.
%   X:    the initial x values, must be a vector.
%   INIT_PARAMS: the initial parameters for the parametrized curve.
%
%  XYLIM is an 1 x 2 cell array in the following form:
%   {XLIM YLIM}
%   -----------
%   XLIM: an 1 x 2 double array describing the range of the x axis
%   YLIM: an 1 x 2 double array describing the range of the y axis
%
%   * If XYLIM is an empty cell array, then the axes will automatically
%   resize to fit the plot
%   
%  PARAM1, PARAM2, ... are cell arrays that could take one of the four forms:
%   {ITHPARAM}
%   {ITHPARAM, TAGS}
%   {ITHPARAM, LOWER, UPPER}
%   {ITHPARAM, TAG, LOWER, UPPER}
%    -----------------------------
%    ITHPARAM is a single integer ranged from 1 to numel(INIT_PARAMS). It
%    indicates which parameter should be manipulated.
%    TAG is a string used for labelling the slider
%    LOWER and UPPER are the lower and upper limit of the parameter,
%    respectively. They must be real numbers.
%  * The number of PARAMNs must not exceed numel(INIT_PARAMS);
%  * ITHPARAM must be different for each PARAMN.
% 
% EXAMPLES:
% ---------
% (1):
%    manipulate({@(x,param)(param(1)*x+param(2)),[-10:10],[2 0]},{[-10 10],[-10 10]}, {1,'Slope',1 10}, {2,'Shift',-5 5})
%    
%    MATHFUNC = {@(x,param)(param(1)*x+param(2)): 
%       Displays the plot for function "y = ax + b". x takes the values of
%       -10:10; a and b are initialized to 2 and 0, respectively;
%    XYLIM = {[-10 10],[-10 10]}:
%       Both the XLim and YLim of the axes are manually set to [-10 10];
%    PARAM1 = {1,'Slope',1 10},
%    PARAM2 = {2,'Shift',-5 5}:
%        Both a and b are manipulated. a ('Slope') ranges from 1 to 10, and b
%       ('Shift') ranges from -5 to 5
%
% (2):
%   manipulate({@(x,param)(cos(param(2)*sin(param(1)*x))),[-4*pi:0.1*pi:4*pi],[1 1]},{}, {2,0, 2*pi})
%
%   Displays the plot for function "y = cos(b*sin(a*x))". x ranges from
%   -4pi~4pi; a and b are both initially set to 1;
%   The axes are automatically rescaled to fit the plot;
%   Only the second parameter (b, ranged 0 ~ 2pi) is manipulated. No labels will be shown.
%
% Stellari Studio, 2012
% Mingjing Zhang, Vision and Media Lab @ Simon Fraser University
%

%% Constants
slider_thickness = 20;
slider_spacing = 10;

tag_width = 100;
paramval_width = 50;

%% Argument Checking
if nargin == 0
    % If no input is detected, then engage demo mode.
    x = -4*pi:0.01*pi:4*pi;
    init_params = [1 pi/2 pi/2 1];
    
    n_params2man = 4;
    params2man = [1 2 3 4];         % The parameters to manipulate
    tags = {'Amplitude','Angular Frequency', 'Phase', 'Shift'};
    lowers = [0 0 0 -3];
    uppers = [4 2*pi 2*pi 4];
    
    mathfunc = @my_sin;
    
    XLim = [-15 15];
    YLim = [-5 5];
    LimMode = 'Manual';         % Fix the XLim and YLim of the axes
    
else
    % If there is some input, then use the input functions and parameters
    % - Check mathfunc -
    if numel(mathfunc_full)~=3
        error('Manipulate(): incorrect MATHFUNC.');
    else
        mathfunc = mathfunc_full{1};
        x = mathfunc_full{2};
        init_params = mathfunc_full{3};
    end
    
    % - Check XYLim -
    if numel(XYLim)~=2
        XLim = [0 1];   % Will not be used 
        YLim = [0 1];
       LimMode = 'Auto'; 
    else
        XLim = XYLim{1};
        YLim = XYLim{2};
        LimMode = 'Manual';
    end
    
    % - Check Param List -
    n_params2man = numel(varargin);
    params2man = zeros(1,n_params2man);
    tags = cell(1,n_params2man);
    lowers = ones(1,n_params2man).*0.01;
    uppers = ones(1,n_params2man);
    
    for i = 1:n_params2man
        this_param = varargin{i};
        n_this_param = numel(this_param);
        
        if n_this_param == 0
            continue;
        elseif n_this_param == 1
            params2man(i) = this_param{1};
        elseif n_this_param == 2
            params2man(i) = this_param{1};
            tags{i} = this_param{2};
        elseif n_this_param == 3
            params2man(i) = this_param{1};
            lowers(i) = this_param{2};
            uppers(i) = this_param{3};
        elseif n_this_param >= 4
            params2man(i) = this_param{1};
            tags{i} = this_param{2};
            lowers(i) = this_param{3};
            uppers(i) = this_param{4};
        end
    end
end

%% Calculate the initial function value
init_y = mathfunc(x, init_params);

%% Prepare the figure and axes

monitor_pos = get(0, 'MonitorPositions');

fig_h = figure('CloseRequestFcn',@figureCloseReq_Callback);

% A little trick to make sure the axes is not expanded as the figure
% resizes
axes_h = axes('Parent',fig_h,'Units','pixels');

axes_pos_p = get(axes_h,'Position');

figure_pos = get(fig_h,'Position');

figure_pos(4) =  figure_pos(4) + (n_params2man+1)* (slider_thickness + slider_spacing);

if figure_pos(4) + figure_pos(2) > monitor_pos(4) - 100
    % Make sure that the figure header is always visible
    figure_pos(2) = monitor_pos(4) - figure_pos(4) - 100;
end

set(fig_h, 'Position', figure_pos);

% set(axes_h, 'Units', 'normalized');

%% Start plotting!!
           
plot_h = plot(x, init_y);

set(axes_h,'XLim', XLim, 'XLimMode', LimMode, 'YLim', YLim, 'YLimMode', LimMode);

set(plot_h,'UserData', init_params);

slider_h = zeros(1,n_params2man);

for i = 1:n_params2man    
    % Nicely arrange the sliders and texts 
    start_pos = [axes_pos_p(1), axes_pos_p(2) + axes_pos_p(4) + ...
        (n_params2man + 1 - i).*(slider_spacing + slider_thickness)];
    tag_h(i) = uicontrol('style','text','Units','pixels', ...
        'Position',[start_pos, tag_width, slider_thickness], ...
        'String', tags{i});
    slider_h(i) = uicontrol('Style','Slider', ...
        'Position', [start_pos+[tag_width 0] axes_pos_p(3)-(tag_width+paramval_width), slider_thickness], ...
        'Min', lowers(i), ...
        'Max', uppers(i), ...
        'Value', init_params(i));
    paramval_h(i) = uicontrol('style','text','Units','pixels',...
        'Position',[start_pos+[axes_pos_p(3)-paramval_width,0],paramval_width, slider_thickness], ...
        'String', num2str(init_params(i)));
%     cur_slider = slider_h(i);
    slider_timer(i) = timer('TimerFcn', {@slider_updater,slider_h(i), i},...
    'ExecutionMode','fixedRate',...
    'Period', 1./20, 'BusyMode', 'queue','UserData',params2man(i));
    start(slider_timer(i));
end

set(axes_h, 'Units', 'normalized');

    function slider_updater(obj, event, cur_slider_h, iParam)
        % SLIDER_UPDATER
        
        % This persistent variable is a relic from the time when
        % slider_updater was still a stand alone function.
        persistent last_slider_value
        
        %% Step 1: Get the current value
        cur_slider_value = get(cur_slider_h, 'Value');
        
        %% Step 2: If the slider value is not changed, then do nothing
        if cur_slider_value == last_slider_value
            return;
        end
        
        last_slider_value = cur_slider_value; % Store the last slider value
        
        %% Step 3: Do the mathematics
        x = get(plot_h,'XData');
        params = get(plot_h,'UserData');
        params(iParam) = last_slider_value;
        y = mathfunc(x, params);
        
        %% Step 4: Update the graphics
        set(plot_h, 'YData', y);
        set(plot_h, 'UserData', params);
        set(paramval_h(iParam), 'String', num2str(params(iParam)));
        drawnow;
        
    end
%% A demonstration sinusoidal function
    function y = my_sin(x,params)
        % my_sin sinusoidal function
        % y = my_sin(x, params) returns
        %   y = params(1) * sin(params(2)* x + params(3)) + params(4)
        %   All angles are represented in radians
        y = params(1) * sin(params(2)* x + params(3)) + params(4);
    end

%% Delete the timers when the window is closed
    function figureCloseReq_Callback(obj, event)
        for i = 1:n_params2man 
            stop(slider_timer(i));
            delete(slider_timer(i));
        end
        closereq;
    end

end

