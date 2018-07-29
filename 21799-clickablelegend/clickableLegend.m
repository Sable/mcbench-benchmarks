function varargout = clickableLegend(varargin)
% clickableLegend is a wrapper around the LEGEND function that provides the
% added functionality to turn on and off (hide or show) a set of graphics
% objects (lines or patches) by clicking on an associated text label in the legend. Its usage is
% the same as the <a href="matlab: help legend">LEGEND</a> function with additional optional parameters. For
% further information please see the LEGEND documentation.
%
% ADDITIONAL ARGUMENTS specific to clickableLegend:
% These are passed in as parameter-value pairs
%
% * groups: A vector specifying the group membership for every line object.
%   The grouping parameter lets you have a group of lines represented and
%   controlled by one entry in the legend. This can be useful if you would
%   like to show or hide a group of lines by clicking on one legend entry.
%   CONSIDERATIONS:
%   # The number of unique entries in the group vector must match the
%     number of strings in the legend
%   # When passing a vector of line/patch handles as the first input
%     argument, the vector should contain all lines/patches whose group
%     membership is included in the group vector. ie. the length of the
%     vector of handles must match that of the length of the group vector.
% 
% * displayedLines: A vector of indices corresponding to the lines or groups that
%   should be displayed initially. This option is useful if there are too
%   many lines in the figure and you are only interested in looking at a
%   few at first.
%   Example: clickableLegend(..., 'displayedLines', [4 5 6])
%
% Notes: 
% 1. If you save the figure and re-load it, the toggling functionality
% is not automatically re-enabled. To restore it, simply call clickableLegend
% with no arguments.
%
% 2. To prevent the axis from automatically scaling every time a line is
% turned on and off, issue the command: axis manual
%
% Example 1:
% z = peaks(100);
% plot(z(:,26:5:50))
% grid on;
% axis manual;
% clickableLegend({'Line1','Line2','Line3','Line4','Line5'}, 'Location', 'NorthWest');
%
% Example 2:
% f = plot([1:10;1:2:20]','x'); hold on;
% g = plot(sin([1:10;1:2:20]'),'r-');
% h = plot(11:20,rand(5,10)*5,'b:');
% clickableLegend([f;g;h], {'Line1','Line2','Line3'},...
%   'groups', [1 1 2 2 3 3 3 3 3], 'displayedLines', [2 3]);
%
% hgsave(gcf, 'testfig.fig');
% hgload testfig.fig
% clickableLegend


% Extract any arguments for clickableLegend
ind = find(strcmpi(varargin,'DisplayedLines'));
if ~isempty(ind)
    if ind == nargin
        error('The DisplayedLines parameter value must be specified');
    end
    dispflag = true;
    dispinds = varargin{ind+1};
    varargin(ind:ind+1) = [];
else
    dispflag = false;
end

ind = find(strcmpi(varargin,'groups'));
if ~isempty(ind)
    if ind == nargin
        error('The groups parameter value must be specified');
    end
    groupflag = true;
    groupmem = varargin{ind+1};
    varargin(ind:ind+1) = [];
    
    groups = unique(groupmem);
    firstmem = zeros(size(groups));
    if nargin > 0 && ishandle(varargin{1}(1))
        if strcmpi(get(varargin{1}(1),'Type'),'axes')
            hAxes = varargin{1}(1);
            obj = flipud([findobj(hAxes,'Type','line');findobj(hAxes,'Type','patch')]);
        else % It's a line/patch
            obj = varargin{1};
            for i = 1:length(groups)
                firstmem(i) = find(groupmem==groups(i),1);
            end
            varargin{1} = obj(firstmem);
        end
    else
        hAxes = gca;
        obj = flipud([findobj(hAxes,'Type','line');findobj(hAxes,'Type','patch')]);
    end
else
    groupflag = false;
end

% Create legend as if it was called directly
[varargout{1:nargout(@legend)}] = legend(varargin{:});

% Extract what is needed for the rest of the function and fix varargout
[leghan, objhan, plothan] = varargout{1:3}; 
% objhan: strings
% plothan: graphics objects
varargout = varargout(1:nargout);

% At this point, we can quit and behavior would be equivalent to calling
% just legend.

if ~groupflag % Default group membership
    groupmem = 1:length(plothan);
    obj = plothan;
    groups = groupmem;
end

if dispflag % DisplayedLines parameter was passed in
    hidden = true(1, length(plothan));
    dispinds(dispinds>length(plothan)) = [];
    hidden(dispinds) = false;
end

% Set the callbacks
for i = 1:length(plothan)
    set(objhan(i), 'HitTest', 'on', 'ButtonDownFcn',...
        @(varargin)togglevisibility(objhan(i),obj(groupmem==groups(i))),...
        'UserData', true);
    if dispflag && hidden(i)
        togglevisibility(objhan(i), obj(groupmem==groups(i)));
    end
end


function togglevisibility(hObject, obj)
if get(hObject, 'UserData') % It is on, turn it off
    set(hObject, 'Color', (get(hObject, 'Color') + 1)/1.5, 'UserData', false);
    set(obj,'HitTest','off','Visible','off','handlevisibility','off');
else
    set(hObject, 'Color', get(hObject, 'Color')*1.5 - 1, 'UserData', true);
    set(obj, 'HitTest','on','visible','on','handlevisibility','on');
end
