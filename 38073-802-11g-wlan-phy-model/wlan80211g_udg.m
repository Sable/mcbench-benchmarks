function [sys, x0, str, ts] = wlan80211g_udg(t, x, u, varargin)
% WLAN80211g_UDG  User-defined graphics for IEEE 802.11g model.
% Plot data u in MATLAB figure.
% u is assumed to be Nx2; first column real-part, second column imag-part.
% Can also pass additional parameters to plot function

% Copyright 2012 anuj saxena.

switch varargin{1}
    case 3
        sys = [];  % mdlOutput - unused
    case 2
        sys = mdlUpdate(t, x, u, varargin{:});
    case 0
        [sys, x0, str, ts] = mdlInitializeSizes;
    case 9
        sys=mdlTerminate;
    otherwise
        feval(varargin{:});
end


% -----------------------------------------------------------
function [sys, x0, str, ts] = mdlInitializeSizes

blk = get_param(gcb, 'parent');

sizes = simsizes;
sizes.NumInputs      = -1;
sizes.NumOutputs     =  0;
sizes.NumSampleTimes =  1;
sys = simsizes(sizes);
x0  = [];           % states
str = '';           % state ordering strings
ts  = [-1 1];       % inherited sample time, fixed in minor steps

% initialize block data
bd = get_param(blk, 'userdata');
bd.firstcall = true;
bd.figTag = blk;
bd.graphicsName = get_param(blk, 'graphicsName');
bd.plotFcnHandle = str2func(bd.graphicsName);
bd.cellArrayMode = strcmp(get_param(blk, 'convertMode'), 'cell array');
set_param(blk, 'userdata', bd);


% ------------------------------------------------------------
function sys = mdlUpdate(t, x, u, flag, params)

% Faster implementation of: blk=gcb;
cs   = get_param(0, 'CurrentSystem');
cb   = get_param(cs, 'CurrentBlock');
sfcn = [cs '/' cb];
blk  = get_param(sfcn, 'parent');
sys  = [];

bd = get_param(blk, 'userdata');

% Need to check for figure every update
bd.fig = findobj('type', 'figure', 'tag', bd.figTag);

if isempty(bd.fig)
    % figure is not open
    
    bd.firstcall = true;
    
else
    % figure is open

    if bd.firstcall
        % get axes handles
        [bd.axes, bd.multiple_axes] = get_axes_handles(bd.fig);
    end
    
    [M, N] = size(u);
    u_complex = u(:, 1:N/2) + j*u(:, N/2+1:N);
    
    input_names = params{1};
    other_params = params{2:length(params)};
    other_params_exist = ~isempty(other_params);
    plot_data = convert_simulink_vector(u_complex, input_names, bd.cellArrayMode);
    
    if other_params_exist
        feval(bd.plotFcnHandle, plot_data, bd.axes, bd.firstcall, other_params);
    else
        feval(bd.plotFcnHandle, plot_data, bd.axes, bd.firstcall)
    end
    
    bd.firstcall = false;

end

set_param(blk, 'userdata', bd);

% ---------------------------------------------------------------
function sys = mdlTerminate
sys = [];

%--------------------------------------------------------------------------
function data = convert_simulink_vector(u, input_names, cellArrayMode);
% CONVERT_SIMULINK_VECTOR
%
% u: Nx1 input vector, containing data corresponding to multiple matrices
%    (see format below)
% input_names: cell array containing names (strings) of the above matrices
%
% u uses format [s1; v1; s2; v2; s2; v3; ...]
% where sn is a scalar, and vn is a (sn x 1) vector
% The nth name in input_names corresponds to vector vn

num_inputs = length(input_names);
if num_inputs == 1
    data = u(2:end, :);
    return
end

length_u = length(u);

if cellArrayMode
    data = cell(1, num_inputs);
else
    data = cell2struct(cell(1, num_inputs), input_names, 2);
end

idx = 1;
for i = 1:num_inputs
    L = u(idx);
    v = u(idx+1 : idx+L, :);
    if cellArrayMode
        data{i} = v;
    else
        data = setfield( data, input_names{i}, v );
    end
    idx = idx + L + 1;
end

%--------------------------------------------------------------------------
function [haxes, multi] = get_axes_handles(fig);
% returns axes handles
% if there is only one axes, axes is a handle
% if more, axes is a structure of handles, with fieldnames corresponding to
% axes tags.
% multi: true if more than one axes
c = get(fig, 'children');
multi = (length(c)>1);
if ~multi
    haxes = c;
else
    t = get(c, 'tag');
    h = num2cell(c);
    x = [t(:).'; h(:).'];
    haxes = struct(x{:});
end
