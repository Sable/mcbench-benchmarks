function imslice(fh,settings)
% IMSLICE   Selects and plots one row or column of a cdata-based plot.
%   Function IMSLICE can be applied to any figure containing a graphical
%   object having a cdata property. When calling IMSLICE with the syntax:
%
%       >> imslice(fh);
%
%   IMSLICE examines the content of the children of the figure having the
%   handle fh in order to find graphical elements having a cdata property.
%   Each of these elements can then be clicked with either the left mouse
%   button (to produce a slice plot at a given x-position, along the
%   y-axis) or with the right mouse button (to produce a slice plot at a
%   given y-position, along the x-axis). Default for fh is gcf.
%
%   When the mouse is clicked, a line marker is plotted on top of the
%   current plot to indicate the position of the slice. A new figure is
%   openned, containing the slice plot with the position of the slice as
%   the title. Closing this figure erases the line marker.
%
%   Properties of the line marker can be set using the syntax:
%
%       >> imslice(fh,settings);
%
%   where settings is a structure containing the line marker's properties.
%   By default, settings is:
%
%       settings.linewidth = 3
%       settings.color = 'g'

% (c) 2006 François Bouffard
%          fbouffard@gmail.com

% =========================================================================
% -- Main function
% =========================================================================

% Defaults
if nargin < 2
    settings.linewidth = 3;
    settings.color = 'g';
end;
if nargin == 0; fh = gcf; end;

% Finding every objects having the cdata property in fh
ca = get(fh,'children');
cobj = [];
for k = 1:length(ca)
    c = get(ca(k),'children');
    for kk = 1:length(c)
        if isprop(c(kk),'cdata')
            cobj = [cobj c(kk)];
        end;
    end;
end;

% Assigning slicefcn as the ButtonDownFcn of each of those objects
set(cobj,'ButtonDownFcn',{@slicefcn,settings});

end

% =========================================================================
% -- slicefcn : Called everytime a cdata object is clicked on
% =========================================================================
function slicefcn(h,e,settings)

% Retrieving basic information about the current cdata object
ac = get(h,'Parent');                       % ac : cdata object axis
fc = get(ac,'Parent');                      % fc : cdata object figure
button = get(fc,'SelectionType');
current_pt = get(ac,'CurrentPoint');
x = current_pt(1,1);
y = current_pt(1,2);
xdata = get(h,'xdata');
ydata = get(h,'ydata');
cdata = get(h,'cdata');

% Correcting for image xdata/ydata of type [1 max]
if length(xdata) == 2 && strcmp(get(h,'type'),'image'); xdata = xdata(1):xdata(2); end;
if length(ydata) == 2 && strcmp(get(h,'type'),'image'); ydata = ydata(1):ydata(2); end;

% Create slice figure if it does not exist yet
fs = getappdata(ac,'slicefigure');          % fs : slice figure
if isempty(fs)
    fs = figure;
    ipos = get(fs,'Position');
    set(fs,'Position',ipos + [15 -15 0 0]);
    as = axes;                              % as : slice axes
else
    as = get(fs,'Children');
end

% Update slice figure information
setappdata(ac,'slicefigure',fs);
setappdata(ac,'settings',settings);

% Redraw slice marker and plot slice in slice window
if strcmpi(button,'normal')
    % Left click : vertical slice
    % xidx : slice number
    % x    : slice position
    xidx = interp1(xdata,1:length(xdata),x,'nearest','extrap');
    plot_slice(ac,as,xdata,ydata,cdata,xidx,1);
else
    % Right click: horizontal slice
    % yidx : slice number
    %    y : slice position
    yidx = interp1(ydata,1:length(ydata),y,'nearest','extrap');
    plot_slice(ac,as,xdata,ydata,cdata,yidx,2);
end;

% Making sure the slice marker is deleted if the slice figure is closed
set(fs,'DeleteFcn',{@closeslicefigure,ac});

end

% =========================================================================
% -- deleteslicemarker : Properly deletes a slice marker
% =========================================================================
function deleteslicemarker(p)

% Deleting the slice marker if it currently exists
if ishandle(p); delete(p); end;

end

% =========================================================================
% -- closeslicefigure : Properly closes a slice figure
% =========================================================================
function closeslicefigure(h,e,ac)

if ishandle(ac)
    % Delete the slice marker first
    deleteslicemarker(getappdata(ac,'slicemarker'));
    % Remove reference to the slice figure
    setappdata(ac,'slicefigure',[]); 
end

end

% =========================================================================
% -- drawslicemarker : Draws a new slice marker
% =========================================================================
function p = drawslicemarker(ac,pos,dim)

% If the cdata object's figure was closed, don't bother
if ~ishandle(ac); return; end;

% Delete any slice marker
deleteslicemarker(getappdata(ac,'slicemarker'));

% Selecting the cdata object's axes
axes(ac); hold on;

settings = getappdata(ac,'settings');
if dim == 1
    % Vertical marker
    p = plot([pos pos],ylim,settings);
else
    % Horizontal marker
    p = plot(xlim,[pos pos],settings);
end;

hold off;

% Storing slicemarker information
setappdata(ac,'slicemarker',p);

end

% =========================================================================
% -- plot_slice : Plots a data slice in the specified axes
% =========================================================================
function plot_slice(ac,as,xdata,ydata,cdata,idx,dim)

% Deleting any existing slice marker
deleteslicemarker(getappdata(ac,'slicemarker'));

% If the cdata object is a color picture, 3 plots will be made in r,g,b
if size(cdata,3) == 3;
    set(ah,'NextPLot','ReplaceChildren','ColorOrder',[1 0 0; 0 1 0; 0 0 1]);
end;

% Selecting the data to plot according to dim
if dim == 1
    C = squeeze(cdata(:,idx,:));
    a = ydata; v = xdata;
    pos = xdata(idx);
else
    C = squeeze(cdata(idx,:,:));
    a = xdata; v = ydata;
    pos = ydata(idx);
end;

% Creating a new slice marker
drawslicemarker(ac,pos,dim);

% Selecting the slice axes
axes(as);

% Actual plot
axes(as);
plot(a,C);
xlim([a(1) a(end)]);
title(sprintf('Slice %d at axis value %0.2f',idx,v(idx)));
xlabel('<-- Previous [left click/arrow]           [right click/arrow] Next -->');

% Setting plot_other_slice as the slice figure's ButtonDownFcn
set(as,'ButtonDownFcn',{@plot_other_slice,ac,as,xdata,ydata,cdata,idx,dim,'button'});
set(get(as,'Parent'),'KeyPressFcn',{@plot_other_slice,ac,as,xdata,ydata,cdata,idx,dim,'key'});

end

% =========================================================================
% -- plot_other_slice : executed on button click in the slice figure to
%                       rapidly proceed to the previous or next slice
% =========================================================================
function plot_other_slice(h,e,ac,as,xdata,ydata,cdata,idx,dim,type)
switch type
    case 'button'
        button = get(get(as,'Parent'),'SelectionType');
        switch button
            case {'normal'}
                previous_slice;
            case {'alt'}
                next_slice;
            case {'open'}
                title(sprintf('This was a double-click:\nimslice cannot tell which mouse button you clicked'))
        end
    case 'key'
        switch e.Key
            case {'leftarrow','uparrow','pageup'}
                previous_slice;
            case {'rightarrow','downarrow','pagedown'}
                next_slice;
        end
end
    function next_slice
        if (dim == 1 && idx < length(xdata)) || (dim == 2 && idx < length(ydata))
            plot_slice(ac,as,xdata,ydata,cdata,idx+1,dim);
        end
    end
    function previous_slice
        if idx > 1
            plot_slice(ac,as,xdata,ydata,cdata,idx-1,dim);
        end
    end
end
