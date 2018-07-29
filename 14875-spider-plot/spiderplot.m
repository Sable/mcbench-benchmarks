function [varargout] = spiderplot(X, axisMax, axisMin, colors)
%SPIDERPLOT creates a spider (radar) plot of input matrix columns.
%
%  Usage:
%  SPIDERPLOT(X), where X is a M times N matrix,
%  plots N radar plots to a figure with M axis.
%  SPIDERPLOT(X [MxN], AXISMAX [Mx1], AXISMIN [Mx1], COLORS [Nx1 or Nx3])
%  uses AXISMIN and AXISMAX to scale the axis, and COLORS as the colors
%  of the radar plots.
%  To use default values, pass [] to AXISMIN, AXISMAX, and COLORS.
%
%  This function uses GLYPHPLOT from Statistics Toolbox.
%
%  HOLD doesn't work, sorry.
%
%  Example
%    h = spiderplot(magic(5)+10, [35 40 45 50 55], ...
%       [0 2 4 6 8], ['r' 'g' 'b']');
%    set(h.axis, 'LineWidth', 2);
%    set(h.plots, 'LineWidth', 2);
%
%    Martti Kesäniemi <martti.kesaniemi@mathworks.com>
%    Copyright 2007 The MathWorks, Inc.
%    This function is not supported by The MathWorks, Inc.
%    It is provided 'as is' without any guarantee of
%    accuracy or functionality.

% Check input, set default values if needed
if nargin < 1
    X = magic(5);
end;
dims = size(X);

if (nargin < 2)||(isempty(axisMax))
    axisMax = max(X(:))*ones(dims(1),1)*(1+eps);
    axisMax = ceil(axisMax ./ 10.^floor(log10(axisMax))) .*...
        10.^floor(log10(axisMax));
else
    axisMax = axisMax(:);
    if numel(axisMax) ~= dims(1)
        error('Input size mismatch');
    end;
    if any(axisMax < max(X,[],2))
        error('axisMax has to be larger than the corresponding data');
    end;
end;

if (nargin < 3)||(isempty(axisMin))
    if min(X(:)) < 0
        axisMin = min(X(:))*ones(dims(1),1)*(1+eps);
        axisMin = floor(axisMin ./ 10.^floor(log10(axisMin))) .*...
            10.^floor(log10(axisMin));
    else
        axisMin = zeros(dims(1),1);
    end;
else
    axisMin = axisMin(:);
    if (numel(axisMin) ~= dims(1))
        error('Input size mismatch');
    end;
    if any(axisMin > min(X,[],2))
        error('axisMin has to be smaller than the corresponding data');
    end;
end;

if (nargin < 4)||(isempty(colors))
    colors = get(0, 'DefaultAxesColorOrder');
end;
cLen = size(colors);
if (cLen(2) ~= 1)&&(cLen(2) ~= 3)
    error('Wrong size of color matrix');
end;
cLen = cLen(1);

% Scale X
for i=1:dims(1)
    X(i,:) = X(i,:)-axisMin(i);
    X(i,:) = X(i,:) / (axisMax(i) - axisMin(i));
end;

% Plot axis
clf;
h_a = glyphplot(ones(1,dims(1)), 'Standardize', 'off', 'ObsLabels', '', ...
    'Glyph', 'star');
hold on;
delete(h_a(1));
set(h_a(2), 'Color', 'k');

% Set labels
x = get(h_a(2), 'XData');
y = get(h_a(2), 'YData');
labels = zeros(length(x)/3, 1); 
labeldots = zeros(length(x)/3, 1); 
for i=1:(length(x)/3),
    labels(i) = text((x(i*3-1)-1)*1.1+1, (y(i*3-1)-1)*1.1+1, ...
        sprintf('%g .. %g',axisMin(i), axisMax(i)));
    labeldots(i) = plot(x(i*3-1), y(i*3-1), 'k.');
end;

% Plot glyphs
h = zeros(dims(1), 2);
for i=1:dims(2),
    h(i,:) = glyphplot(X(:,i)', 'Standardize', 'off', 'ObsLabels', '', ...
        'Glyph', 'star');
    delete(h(i,2));
    set(h(i,1), 'Color', colors(mod(i-1,cLen)+1,:));
end;
hold off;

% return handles
if nargout>0
    varargout{1} = struct('axis', h_a(2), ...
        'plots', h(:,1), 'labels', labels, 'labeldots', labeldots);
end;


