function datetick2(varargin)
%DATETICK2 Date formatted tick labels, automatically updated when zoomed or panned.
%   Arguments are identical to those of DATETICK. Allows 2 or more
%   subplots, keeps all of them synched using LINKPROP.
%
%   For best results with multiple subplots, call datetick2 from the axis
%   that has the widest range of dates. This functionality could be
%   included, but would probably needlessly bloat the code.
%
%   Example:
%   figure
%   h(1)=subplot(411);
%   plot(now:1:now+100,randn(101,1))
%   h(2)=subplot(412);
%   plot(now:1:now+10,rand(11,1))
%   h(3)=subplot(413);
%   plot(now+20:1:now+30,rand(11,1))
%   h(4)=subplot(414);
%   plot(now-5:1:now+5,rand(11,1))
%   datetick2
%
%   Written by Andy Bliss June 22, 2008. Based in part on DATETICKZOOM from
%   the file exchange by Christophe Lauwerys.
%
%   See also DATETICK, LINKPROP

%the first section of code runs when DATETICK2 is called by the figure
if nargin==2 && isstruct(varargin{2}) && isfield(varargin{2},'Axes') && isscalar(varargin{2}.Axes)
    dtd = getappdata(varargin{2}.Axes,'datetickdata');
    axh = gca; %used to be dtd.axh instead of gca. But after a zoom, we always want the current axes
    if dtd.keep_ticks
        %if we're keeping the ticks
        set(axh,[dtd.ax,'TickMode'],'auto')
        if ~isempty(dtd.dateform)
            datetick(axh,dtd.ax,dtd.dateform,'keeplimits','keepticks')
        else
            datetick(axh,dtd.ax,'keeplimits','keepticks')
        end
    else
        %if we let Matlab choose the best tick positions
        if ~isempty(dtd.dateform)
            datetick(axh,dtd.ax,dtd.dateform,'keeplimits')
        else
            datetick(axh,dtd.ax,'keeplimits')
        end
    end
else
    %this section of code runs the first time DATETICK2 is called

    %initialize dtd
    dtd = [];
    %parse inputs using the datetick parser
    [dtd.axh,dtd.ax,dtd.dateform,dtd.keep_ticks] = parseinputs(varargin);

    %get the handles to other parts of the figure
    dtd.pa=get(dtd.axh,'parent'); %the figure handle
    dtd.kids=get(dtd.pa,'Children'); %all children of the figure
    dtd.axes=[]; %just the axes children of the figure
    for n=1:length(dtd.kids)
        if strcmp(get(dtd.kids(n),'type'),'axes') && ...
                ~strcmp(get(dtd.kids(n),'tag'),'Legend')
            dtd.axes=[dtd.axes dtd.kids(n)];
        end
    end
    %link all the axes together
    dtd.hlink=linkprop(dtd.axes,{[dtd.ax 'lim'];[dtd.ax 'tick']});
    dtd.hlink2=linkprop(dtd.axes,[dtd.ax 'ticklabel']); %for some reason this can't be on the line above

    %set application data and callbacks so the dateticks will update after
    %   pan and zoom
    for n=1:length(dtd.axes)
        setappdata(dtd.axes(n),'datetickdata',dtd);
        set(zoom(dtd.axes(n)),'ActionPostCallback',@datetick2)
        set(pan(get(dtd.axes(n),'parent')),'ActionPostCallback',@datetick2)
    end
    %setting datetick on one axis in the figure will set it on all because
    %   of the linkprop
    datetick(varargin{:})
end





function [axh,ax,dateform,keep_ticks] = parseinputs(v)
%Parse Inputs (this is directly from DATETICK)

% Defaults;
nin = length(v);
dateform = [];
keep_ticks = 0;

% check to see if an axes was specified
if nin > 0 & ishandle(v{1}) & isequal(get(v{1},'type'),'axes') %#ok ishandle return is not scalar
    % use the axes passed in
    axh = v{1};
    v(1)=[];
    nin=nin-1;
else
    % use gca
    axh = gca;
end

% check for too many input arguments
error(nargchk(0,4,nin,'struct'));

% check for incorrect arguments
% if the input args is more than two - it should be either
% 'keeplimits' or 'keepticks' or both.
if nin > 2
    for i = nin:-1:3
        if ~(strcmpi(v{i},'keeplimits') || strcmpi(v{i},'keepticks'))
            error('MATLAB:datetick:IncorrectArgs', 'Incorrect arguments');
        end
    end
end

% Look for 'keeplimits'
%   This section is not needed because we always use keeplimits after zoom.
%   But, I'll leave it in for continuity.
%   keeplimits is not passed back out of parseargs.
for i=nin:-1:max(1,nin-2),
    if strcmpi(v{i},'keeplimits'),
        keep_limits = 1;
        v(i) = [];
        nin = nin-1;
    end
end

% Look for 'keepticks'
for i=nin:-1:max(1,nin-1),
    if strcmpi(v{i},'keepticks'),
        keep_ticks = 1;
        v(i) = [];
        nin = nin-1;
    end
end

if nin==0,
    ax = 'x';
else
    switch v{1}
        case {'x','y','z'}
            ax = v{1};
        otherwise
            error('MATLAB:datetick:InvalidAxis', 'The axis must be ''x'',''y'', or ''z''.');
    end
end
if nin > 1
    % The dateform (Date Format) value should be a scalar or string constant
    % check this out
    dateform = v{2};
    if (isnumeric(dateform) && length(dateform) ~= 1) && ~ischar(dateform)
        error('The Date Format value should be a scalar or string');
    end
end
