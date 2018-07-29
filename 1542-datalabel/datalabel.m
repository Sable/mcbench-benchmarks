function datalabel(state,marker_color);
%datalabel       Interactive labeling of data points on a plot
%   datalabel with no arguments toggles the data tip state
%   datalabel ON turns data tips on for the current figure
%   datalabel OFF turns data tips off for the current figure
%   datalabel('ON',S), where S is a character string specifying
%     a marker and/or color will add the specified marker to
%     the data tip.  Default is red circles: 'ro'
%
%     Click on a line to label the nearest data point.
%     Click and drag on a data tip to move it.
%     Right-Click on a data tip to delete it.
%
%	  Example: 
%            t = 0:pi/50:2.5*pi;
%            y = sin(t);
%            plot(t,y);  %Try plot(y,t), too
%            datalabel on
%        %Click on lines to label values.
%        %Click and drag to move.
%        %Right click to delete.
%            datalabel off
%        %Existing data tips are locked in place; can't add more
%            datalabel('on','.b');  %Add blue dots with next data tips
%
%   smh: 5/02:  Click on text to re-position text relative to data point
%               Click on data point to move to a different value
%

% Written by Scott Hirsch
% shirsch@mathworks.com
% Copyright 2002 The MathWorks, Inc
%


if nargin == 0 | strcmp(state,'on') % Set the WindowButtonDownFcn
    if nargin <2 , 
        marker='o';  %none
        color = 'r';
    else
        %Parse marker string
        colors = 'bgrcmyk';
        markers = '+o*.xsdv^><ph';
        for ii=1:length(marker_color)
            col_ind = strfind(colors,marker_color(ii));
            if ~isempty(col_ind)        %It's a color
                color = marker_color(ii);
            else                        %Try a marker instead
                mark_ind = strfind(markers,marker_color(ii));
                if ~isempty(mark_ind)
                    marker = marker_color(ii);
                end;
            end;
        end;
    end;
    if ~exist('color','var'), color = 'r'; end; %set default
    if ~exist('marker','var'), marker = '.'; end; %set default
    %If the user specifies a color, but no marker, I use a dot.
    
    set(gcf,'WindowButtonDownFcn','datalabel down')
    setappdata(gcf,'Marker',marker);
    setappdata(gcf,'Color',color);
    set(gcf,'DoubleBuffer','on');       %eliminate flicker
    
elseif strcmp(state,'down') % Execute the WindowButtonDownFcn
    htype = get(gco,'Type');
    tag = get(gco,'Tag');
    marker = getappdata(gcf,'Marker');
    color  = getappdata(gcf,'Color');
    
    if strcmp(htype,'line') & ~strcmp(tag,'Dot')     %Line - Add text object
        %This is sloppy, but it works.  The marker is a line named 'Dot'
        
        %Look up nearest value on line.
        
        %User-selected point
        cp = get(gca,'CurrentPoint');
        x = cp(1,1);       %first xy values
        y = cp(1,2);       %first xy values
        
        %Line data
        xl = get(gco,'XData');
        yl = get(gco,'YData');
        
        [xv,yv] = local_nearest(x,xl,y,yl);

        
        %For R13 or higher (MATLAB 6.5), use a background color on the text string
        th = text(xv,yv,['  (' num2str(xv) ',' num2str(yv) ')']);
        v=str2num(version('-release'));
        if v>=13
            set(th,'BackgroundColor','y');
        end;
        
        
        ph = line(xv,yv, ...
            'Color',color, ...
            'Marker',marker, ...
            'Tag','Dot', ...
            'UserData',[gco th], ...
            'LineStyle','none');
        
        mh = uicontextmenu('Tag','DeleteObject', ...
            'Callback','ud = get(gco,''UserData'');delete([gco ud(2)]);');
        
        set([th ph],'UIContextMenu',mh);
        
        set(th,'UserData',[gco ph]);     %Store handle to line
    elseif strcmp(htype,'text') | strcmp(tag,'Dot')
        set(gco,'EraseMode','xor')
        set(gcf,'WindowButtonMotionFcn','datalabel move', ...
            'WindowButtonUpFcn','datalabel up');
    end
    
elseif strcmp(state,'move') % Execute the WindowButtonMotionFcn
    htype = get(gco,'Type');
    tag = get(gco,'Tag');
    if ~isempty(gco) & ~isempty(get(gco,'UserData'))    %Second check catches legend
        %Is this the dot or the text
        if strcmp(htype,'text')             %The text
            th = gco;
            handles = get(gco,'UserData');   
            ph = handles(2);
            slide = 0;      %Don't slide along line; just reposition text
        else                                %The marker
            ph = gco;
            handles = get(gco,'UserData');   
            th = handles(2);
            slide = 1;      %Slide along line to next data point
        end;
        
        cp = get(gca,'CurrentPoint');
        pt = cp(1,[1 2]);
        
        %Constrain to Line
        lh = handles(1);        %Line
        
        x = cp(1,1);       %first xy values
        y = cp(1,2);       %first xy values
        
        if slide            %Move to new data value
            xl = get(lh,'XData');
            yl = get(lh,'YData');
            
            ax = axis;
            
            %Get nearest value
            [xv,yv]=local_nearest(x,xl,y,yl);
            
            set(th,'Position', [xv yv 0],'String',['  (' num2str(xv) ',' num2str(yv) ')'])
            set(ph,'XData',xv,'YData',yv);
        else                %Just move text around.
            set(th,'Position', [x y 0])
        end;
        
        
        drawnow
    end;
elseif strcmp(state,'up') % Execute the WindowButtonUpFcn
    htype = get(gco,'Type');
    tag = get(gco,'Tag');
    if strcmp(htype,'text') | strcmp(tag,'Dot')
        set(gco,'EraseMode','Normal')
        set(gcf,'WindowButtonMotionFcn','')
    end;
elseif strcmp(state,'off') % Unset the WindowButton...Fcns
    set(gcf,'WindowButtonDownFcn','','WindowButtonUpFcn','')
end


function [xv,yv]=local_nearest(x,xl,y,yl)
%Inputs:
% x   Selected x value
% xl  Line Data (x)
% y   Selected y value
% yl  Line Data (y)
%Find nearest value of [xl,yl] to (x,y)
%Special Case: Line has a single non-singleton value
if sum(isfinite(xl))==1
    fin = find(isfinite(xl));
    xv = xl(fin);
    yv = yl(fin);
else
    %Normalize axes
    xlmin = min(xl);
    xlmax = max(xl);
    ylmin = min(yl);
    ylmax = max(yl);
    
	%Process the case where max == min
	if xlmax == xlmin
		xln = (xl - xlmin);
		xn = (x - xlmin);
	else
		%Normalize data
		xln = (xl - xlmin)./(xlmax - xlmin);
		xn = (x - xlmin)./(xlmax - xlmin);
	end
    
	if ylmax == ylmin
		yln = (yl - ylmin);
		yn = (y - ylmin);
	else
		yln = (yl - ylmin)./(ylmax - ylmin);
		yn = (y - ylmin)./(ylmax - ylmin);
	end

	% xln = xl;
    % xn = x;
    % 
    % yln = yl;
    % yn = y;
%     xln = (xl - xlmin)./(xlmax - xlmin);
%     xn = (x - xlmin)./(xlmax - xlmin);
%     
%     yln = (yl - ylmin)./(ylmax - ylmin);
%     yn = (y - ylmin)./(ylmax - ylmin);
    
    %Find nearest point using our friend Ptyhagoras
    a = xln - xn;       %Distance between x and the line
    b = yln - yn;       %Distance between y and the line
    c = (a.^2 + b.^2);  %Distance between point and line
    %Don't need sqrt, since we get same answer anyway
    [junk,ind] = min(c);
    
    %Nearest value on the line
    xv = xl(ind);
    yv = yl(ind);
end;
