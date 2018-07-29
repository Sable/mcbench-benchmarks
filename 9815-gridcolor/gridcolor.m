function gridcolor(varargin)
%
% function gridcolor([h_axes], [xcolor],  [ycolor],  [zcolor])
%
% Use this function to change the color of gridlines to a color different to the label and box
% color, which is currently not implemented in Matlab. 
% (-> http://www.mathworks.com/support/solutions/data/1-1PAYMC.html?solution=1-1PAYMC)
%
% Input parameters (all optional)
% -------------------------------
% hAx                   Handle of axis resp. array of handles to several axes, first arg. if specified
% xyzcolor              Color specification (e.g. 'r' or [1 0 0])
%
% Syntax
% ------
% gridcolor             Change/update the current axis (gca) with the default grid color (cstd)
% gridcolor(hAx)        Change/update axis(axes) with handle(s) hAx with the default grid color (cstd)
% gridcolor(hAx, col)   Change/update axis(axes) (hAx) with grid color col (e.g. 'r' or [1 0 0])
%
% Notes
% -----
% This function creates a second "empty" axis, which only contains the grid lines, as suggested
% in the Matlab support page. Additionally this "grid" axis is linked to the original axis to
% enable correct behavior during zooming and paning.
% From version 0.99 it is also possible to issue commands like "grid on" or "set(gca,'xminorGrid','on')",
% which will update the axis accordingly
%
% The list of 
% linked properties includes everything I can think of, which may "disalign" the two axes. The 
% linking updates the second axis automatically, so you should be able to do all sorts of zooming, 
% paning, changing axis limits, axis directions, etc. If you are experiencing unwanted changes in 
% the overall display of your plot (e.g. dataaspectratio ...) you may want to take out some of the 
% properties in this line.  
%
% For Matlab 6 (or lower) gridcolor will not notice any changes on the axis (e.g. 'xlim')
% If you do change these parameters you will have to call gridcolor again, to update the gridlines !!!
%
% Example (execute one command after the other ...)
% -------------------------------------------------
% plot([1 20],[1 50],'k');
% gridcolor('r')
% set(gca,'gridlinestyle','-','minorgridlinestyle',':'); grid on
% set(gca,'xminorgrid','on')
% view(3); gridcolor([1 0 0],'g','b')
% 
% Author
% ------
% Sebastian Hoelz
% IFM-GEOMAR
% s[->Insert my family name<-]ATifm-geomar.de
% 
% Version 0.95 - 10.06.2009
%   Color of box was still displayed incorrectly ... hopefully fixed correctly this time.
%   Added some more relevant properties to link ...
%
% Version 0.94 - 10.01.2009
%   Color of box was displayed incorrectly due to wrong stacking.
%   Changed: ax2('color','w'),uistack(ax2,'bottom'),ax1('color','none')
%
% Version 0.93 - 01.09.2008
%   Included bug fix, which was caused by Matlabs version command
%   Gridstate (on/off) is now transfered from ax1->ax2, before turning it off for ax1 (s. lines 120ff.)
%
% Version 0.92 - 10.08.2006
%   Changed the stack order of the reference axis (now bottom) and the "color-axis" (now top)
%   Removed the linkaxis-command for Matlab 6.5 and lower, since it does not exist in this version
%
% Version 0.91 - 31.01.2006
%   Original Release
    
    cstd = [.8 .8 .8];       % Standard color
    persistent show_only_once
    
    % Parsing input with recursive calls to this function, 
    % if less than 4 input arguments are supplied
    % ----------------------------------------------------
    error(nargchk(0, 4, nargin))
    
    if nargin==0
        gridcolor(gca); return
        
    elseif nargin>=1 && nargin<4
        a1 = varargin{1};
        if iscolor(a1)
            % First argument seems to be a color spec. !!!
            gridcolor(gca,varargin{:}); return
            
        elseif length(a1)>1
            % First argument might be an array with handles of axes
            for i=1:length(a1); gridcolor(a1(i),varargin{2:end}); end; return
            
        else
            % Check if argument is an axis handle
            if ~ishandle(a1) || ~strcmpi(get(a1,'type'),'axes'); error('Input argument is not an axis handle'); end
            if nargin == 1
                % See if grid-axis already exists (-> axis is updated without color change!)
                ax2 = getappdata(a1,'hGridAxis');
                if ~isempty(ax2) && ishandle(ax2); cxyz=get(ax2,{'xcolor','ycolor','zcolor'}); 
                else cxyz={cstd, cstd, cstd}; end
                gridcolor(a1,cxyz{:}); return
                
            elseif nargin == 2
                gridcolor(a1,varargin{2},varargin{2},varargin{2}); return
                
            elseif nargin == 3
                gridcolor(a1,varargin{2},varargin{3},cstd); return
            end
        end
    end
    
    % Get / create grid axis
    ax1 = varargin{1};
    ax2 = getappdata(ax1,'hGridAxis');
    if isempty(ax2)
        ax2 = copyobj(ax1,get(ax1,'parent'));
        setappdata(ax1,'hGridAxis',ax2)
        uistack(ax2,'top')
        set(ax2,'xticklabel','','yticklabel','','zticklabel','','handlevisibility','off','hittest','off','color','none')
        set(ax1,'deletefcn',{@hGridAxis_delete, ax2})
        CreatePropertyListener(ax1,ax2)
    end
        
    set(ax2,'xcolor',varargin{2},'ycolor',varargin{3},'zcolor',varargin{4},'handlevisibility','off','hittest','off')
    
    % Set linked properties
    if any(exist('linkprop','file') == [2 5])     
        % Matlab version 7 (or higher)
        hlink = linkprop([ax2 ax1],{'CameraPosition','CameraUpVector','CameraTarget','CameraViewAngle',  ...
            'xscale','yscale','zscale','xlim','ylim','zlim','xdir','ydir','zdir', ...
            'xtick','ytick','ztick','tickdir','ticklength', ...
            'XAxisLocation','YAxisLocation', ...
            'PlotBoxAspectRatio','Dataaspectratio','position','units','Projection','box','linewidth','visible'});

        setappdata(ax1,'axes_linkprop',hlink);
        
    else
        % Matlab 6.5 and lower, will probably not work ...
        set(ax2,{'CameraPosition','CameraUpVector', 'gridlinestyle','minorgridlinestyle',...
            'xscale','yscale','zscale','xlim','ylim','zlim', 'xdir','ydir','zdir'}, ...
            get(ax1, {'CameraPosition','CameraUpVector','gridlinestyle','minorgridlinestyle',...
            'xscale','yscale','zscale','xlim','ylim','zlim', 'xdir','ydir','zdir'}))
        if isempty(show_only_once)
            warning('GridColor:OldMatlabVersion', ...
                '\n\t"gridcolor" will only work properly for Matlab 7.0 or higher. \n\tNo support for Matlab 6.x or lower.')
            show_only_once = 1;
        end
    end
end
    
% ------------------------    
function out = iscolor(in)
    % See if input argument is a valid Matlab color specification
	out = (ischar(in) && any(strcmpi(in,{'y','m','c','r','g','b','w','k'}))) || (isnumeric(in) && length(in)==3 &&  all(in>=0) && all(in<=1)); 
end

% ---------------------------    
function hGridAxis_delete(varargin)
    try delete(varargin{3}); end
end
    
function CreatePropertyListener(ax1,ax2)
    % This is adapted from Yair Altman's submission "PropListener" (see FEX)
    % Create property listener for grid-calls
    h_ax1 = handle(ax1);
    props = {'XGrid' 'YGrid' 'ZGrid' 'XMinorGrid' 'YMinorGrid' 'ZMinorGrid' 'MinorGridLineStyle' 'GridLineStyle'};
    event = 'PropertyPostSet';
    callback = {@UpdateGridStyle,ax1,ax2,props};

    for i = 1:length(props); hSrc(i) = h_ax1.findprop(props{i}); end

    hl = handle([]);
    hl = handle.listener(h_ax1, hSrc, event, callback);

    % Persist property listeners (or remove if empty callback)
    p = findprop(h_ax1, 'Listeners__');
    if (isempty(p))
        p = schema.prop(h_ax1, 'Listeners__', 'handle vector');
        set(p,  'AccessFlags.Serialize', 'off', 'AccessFlags.Copy', 'off', 'FactoryValue', [], 'Visible', 'off');
    end

    % filter out any non-handles
    h_ax1.Listeners__ = h_ax1.Listeners__(ishandle(h_ax1.Listeners__));
    h_ax1.Listeners__ = [h_ax1.Listeners__; hl];
end

function UpdateGridStyle(varargin)
    
    ax1 = varargin{3}; h_ax1 = handle(ax1);
    ax2 = varargin{4};
    props = varargin{5};
    
    set(ax2, props, get(ax1,props))
    
%     % 
%     tmp = h_ax1.Listeners__;
%     h_ax1.Listeners__ = [];
%     set(ax1,'xgrid','off', 'ygrid','off','zgrid','off','xminorgrid','off','yminorgrid','off','zminorgrid','off')
%     h_ax1.Listeners__ = tmp;
    
end
    
