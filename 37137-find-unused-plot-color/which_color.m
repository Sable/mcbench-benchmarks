function colour = which_color(h_axes)
% choses a color currently not present in the axes. DB V1.1. 2011/06/13
% colour = which_color(h_axes, origin)
% h_axes must be the handle to an axes object. If empty or if an invalid 
% handle gca is used instead. Returns colour as RGB triple.
% Should be used inside a plot command. 
%
% Example1: No line
% figure; hold on
% for k = 1:10
%   line([0 10], [0 k], 'color', which_color(gca))
% end
% 
% Example2: There is already a line present.
% figure; hold on
% line([1 10], [1 0],'color', 'm')
% for k = 1:10
%     line([1 10], [1 k], 'color', which_color(gca))
% end

% Additional files used: 
% Additional m-files used: 
% Additional classes used: 
%
%
%    Date           Version     Author      Remarks
%    2011/08/15     1.0         DB          Erstellung 
%    2012/06/13     1.1         DB          Simplified
%
%  D.Brosig

if nargin < 1 || ~ishandle(h_axes)
    h_axes = gca;
end

% get default color order from main (option)
% default_color       = get(0, 'DefaultAxesColorOrder');

% get color order from currently used axes:
default_color       = get(h_axes, 'ColorOrder');

% find all lines in the current axis and get their color
h_lines             = findall(h_axes,'type','line');
curr_color          = NaN(length(h_lines), 3);
for k = 1:length(h_lines)
    curr_color(k,:) = get(h_lines(k), 'color');
end
% determine set difference between default and current
% and set to the first unused color
[c, in] = setdiff(default_color, curr_color, 'rows');
if isempty(c)
    colour = rand(1, 3);
else
    colour = default_color(min(in), :);
end

