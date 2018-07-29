function [] = showroom(varargin)
% SHOWROOM - Revolves a 3D plot showroom-style.
%
% This function was especially designed to provide for those moments when you just created a
% stunning 3D plot, and feel the need to sit back and admire the result for a moment. The
% animation mimicks a cliché revolving automobile showroom, hence the name.
%
% Syntax:
%   SHOWROOM           Revolves the current plot at the default speed for one revolution
%   SHOWROOM(N)        Revolves N times
%   SHOWROOM(N, V)     Revolves N times with angular speed V (deg / sec)
%
% - By default one revolution (N = 1) is performed at 30 degrees per second (V = 30).
% - When no figure is active at the moment, a standard peaks plot is generated.
% - A button press or click on the figure terminates the animation prematurely.
% - For counterclockwise movement, enter a negative value for V.
% - For 2D views and views with elevations close to 90 degrees this function happens to
%   cause a psychedelic flip-effect.
%
% Jasper Menger (j.t.menger@alumnus.utwente.nl), November 2005

% Get the user inputs
N = 1;    % Default number of revolutions
V = 30;   % Default revolution speed
if numel(varargin) > 1
    % Both speed and revolutions provided
    N = round(varargin{1});
    V = varargin{2};
elseif numel(varargin) == 1
    % Only revolutions provided
    N = varargin{1};
end

% Create a peaks plot when no figure is active
I_fig = get(0,'CurrentFigure');
if not(numel(I_fig))
    figure;
    colormap('winter');
    hold on; grid on;
    surf(peaks);
    axis vis3d;
    view(3);
else
    figure(I_fig);
end

% Current view
drawnow;
[Az, El] = view;
El       = ceil(El);
% Start and end angle
Az_start = Az;
Az_stop  = Az_start + sign(V) * N * 360;
% First guess of plotting time
dT = 0.01;

% Enable user termination
click_ax_old  = get(gca, 'ButtonDownFcn');
click_fg_old  = get(gca, 'ButtonDownFcn');
press_fg_old  = get(gcf, 'KeyPressFcn');
userfield_old = get(gcf, 'UserData');
command_new   = 'set(gcf, ''UserData'', true)';
set(gcf, 'UserData'     , false);
set(gca, 'ButtonDownFcn', command_new);
set(gcf, 'ButtonDownFcn', command_new);
set(gcf, 'KeyPressFcn'  , command_new);

% Animation loop!
Az    = Az_start;
abort = false;
while (abort == false) && abs(Az - Az_start) < abs(Az_stop - Az_start)
    % Check for abort command
    abort = get(gcf, 'UserData');
    % Start stopwatch
    tic;
    % Increase the angle
    dAz = V * dT;
    Az  = Az + dAz;
    % Change the view
    view([Az, El]);
    drawnow;
    % Stop stopwatch
    dT = toc;
end

% Restore old values
view([Az_start, El]);
set(gca, 'ButtonDownFcn', click_ax_old);
set(gcf, 'ButtonDownFcn', click_fg_old);
set(gcf, 'KeyPressFcn'  , press_fg_old);
set(gcf, 'UserData'     , userfield_old);