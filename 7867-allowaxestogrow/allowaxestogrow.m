function allowaxestogrow(f)
% 
% Call allowaxestogrow(f) on a figure f with multiple sub-axes.
% 
% Then, whenever one of the axes is clicked, it zooms to 
% the size of the window (or a preset user-defined size). 
% When clicked again, the axis returns to its original position.
%
% Useful when you have a number of tiny subplots in a figure window,
% and would like to be able to visually inspect them without squinting.
%
% To set the zoomed (large) size for an axis ax:
%   setappdata(ax,'LastPosition',[LEFT BOTTOM WIDTH HEIGHT]);
% For colorbars, [0 0 0.85 1] usually works well.
% 
% Version history:
% 
% 0.40: Use get/setappdata instead of userdata. Use only one button-down 
%       function. Add some extra links between axes for extensibility.
%       Suggestions by Jonas. 2009.05
% 0.32: Ensure invisible patch is created with correct figure parent. 2009.05
% 0.31: Try to preserve plot order better; reorder plots upon shrinking 
%       so that overlay axes, etc. are better respected. Still not perfect --
%       ideally we'd preserve the original exact plot order. 2009.05
%       Preserve plot aspect ratio when creating invisible axes, following
%       suggestion by Jonas. 2009.04
% 
% 0.30: Much simplified by using invisible patches to trap clicks. 
%       Now requires Matlab's OpenGL renderer which may cause side effects 
%       on some systems.
%       Also, allows user to set predefined size for zoomed plot. 
%       Among other things, this makes colorbars finally work well. 2009.02
% 
% 0.22: add workaround for reported bug when axis type is a cell array. 
%       also add click support for patches.  2007.06
% 0.21: add some support for colorbars 2007.06.
% 0.20: modified to support clicks on images and lines following suggestion 
%       from Jessica Louie 2007.05
% 0.11: Added code from Iram Weinstein to keep legends
%       from disappearing. 2005.08
% 0.10: Written by Matthew Caywood, <caywood@phy.ucsf.edu>, 2005.06
% 
% Known bugs:
%
% Possible error if axes are plotted on top of panels. 
% I don't use panels, so I'm not currently supporting them.
% Bugfixes are welcome, though. (reported by Scott Hirsch)
% 
% With multiple axes in a subplot, clicks will sometimes magnify the wrong
% one, making the plot order wonky. For now, just keep clicking and it
% should fix itself.

if nargin==0, f=gcf; end

set(f,'Renderer','OpenGL');

% MSC necessary to avoid an OpenGL renderer bug where axes are flipped
% If you're having rendering problems, comment out the following line:
opengl('OpenGLBitmapZbufferBug',0)

% Cover all subplot axis children of figure f with an identically sized axis 
% containing an invisible patch which triggers an event when clicked.
% Do not add to legends or colorbars.
ch = get(f,'Children');
for i = 1:length(ch)
    ax = ch(i);
    if (strcmp(get(ax,'Type'),'axes')) && ...
       ~strcmp(get(ax,'Tag'),'legend') && ...
       ~strcmp(get(ax,'Tag'),'Colorbar')

        % invisible invisax contains patch p which traps clicks, 
        invisax = axes('Position',get(ax,'Position'), ...
                       'PlotBoxAspectRatioMode',get(ax,'PlotBoxAspectRatioMode'),...
                       'DataAspectRatioMode',get(ax,'DataAspectRatioMode'),...
                       'NextPlot','add');
        % invisax contains a link to ax in appdata
        setappdata(invisax,'VisibleAxes',ax);
        setappdata(invisax,'State',0); % 1 = enlarged, 0 = normal/shrunk
        axis off;
    
        p = patch([0 0 1 1],[0 1 1 0],[0 0 0 0],'w');
        set(p,'FaceAlpha',0);
        set(p,'EdgeAlpha',0);
        set(p,'ButtonDownFcn',@togglesubplot);

        % tag the invisible axes so that they can be manipulated as necessary
        set(p,'Tag','catchPatch')
        setappdata(ax,'catchPatchHandle',p);
        setappdata(ax,'InvisibleAxes',invisax);
        
        % ensure invisible patch gets put on right figure
        % MSC should not be necessary -- may work around 
        % bug when creating figures quickly, at least in R14
        set(invisax,'Parent',f); 
    end
end

% -------------

function togglesubplot(src,eventdata) %#ok

% default size of enlarged axes, modify as necessary
presetaxes = [0.05 0.05 0.9 0.9];

% patch p was clicked, get invisax and ax
p = src;
invisax = get(p,'Parent');
ax = getappdata(invisax,'VisibleAxes');
state = getappdata(invisax,'State');

% get current & last position
currentpos = get(ax,'Position');
futurepos = getappdata(ax,'LastPosition');
if isempty(futurepos), futurepos = presetaxes; end

% swap current & last position
set(ax,'Position',futurepos);
set(invisax,'Position',futurepos);

setappdata(ax,'LastPosition',currentpos);

% get order of parent figure's children
f = get(ax,'Parent');
ch = get(f,'Children');

if state == 1 
    % shrink
    % send invisax and ax to back
    newch = [ch(ax ~= ch & invisax ~= ch) ; invisax ; ax];
    set(f,'Children',newch);
else
    % enlarge
    % change order of parent figure's children so clicked axis 
    % is drawn on top.  But keep legend uppermost, if present.

    % Find a legend for the current subplot, if it exists
    ax = findobj(ax,'type','axes');
    leg = find_legend(ax);

    % move invisax and ax to top, then move legend if present
    newch = [invisax ; ax ; ch(ax ~= ch & invisax ~= ch)];
    if ~isempty(leg)
        newch = [leg ; newch(leg ~= newch)];
    end
    set(f,'Children',newch);
end

setappdata(invisax,'State',~state); % toggle state

%----------------------------------------------------%

function leg = find_legend(ha)
% returns handle to legend
% from legend.m

fig = ancestor(ha,'figure');
ax = findobj(fig,'type','axes');
leg=[];
k=1;
while k<=length(ax) && isempty(leg)
    if islegend(ax(k))
        hax = handle(ax(k));
        if isequal(double(hax.axes),ha)
            leg=ax(k);
        end
    end
    k=k+1;
end

%----------------------------------------------------%

function tf=islegend(ax)
% from legend.m

if length(ax) ~= 1 || ~ishandle(ax)
    tf=false;
else
    tf=isa(handle(ax),'scribe.legend');
end
