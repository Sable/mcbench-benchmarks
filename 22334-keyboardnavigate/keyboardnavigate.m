function keyboardnavigate(option)
% KEYBOARDNAVIGATE allows to navigate in a plot using the keyboard
%   KEYBOARDNAVIGATE with no arguments toggles the navigation state.
%   KEYBOARDNAVIGATE ON turns keyboard navigation 'on' for the current figure.
%   KEYBOARDNAVIGATE OFF turns keyboard navigation 'off' in the current figure.
%
%   This function is useful when exploring different regions of a plot
%   (e.g., time series or images). The zoom function with the mouse can be 
%   inconvenient at times. 
%
%   Nonetheless, any zooming is in respect to the mouse pointer. If the 
%   pointer is outside the axes limits, zoom is relative to the centre of
%   the plot. Note that zooming changes the axes limits, which may cut-off
%   some of the features in the plot.
%
%
%   Keys are as follows:
%     Home:           Reset axes limit to automatic, 2D-view
%     Esc:            Reset axes limit to automatic, 2D-view
%
%     Page-Up:        Decrease axis limits (Zoom-in) by 20%
%     Page-Down:      Increase axis limits (Zoom-out) by 20%
%
%     Left-arrow:     Pan to the left (in X-direction)  by 20%
%     Right-arrow:    Pan to the right(in X-direction)  by 20%
%     Up-arrow:       Pan up (in Y-direction) by 20%
%     Down-arrow:     Pan down (in Y-direction) by 20%
%
%     SHIFT-Left:     Decrease X-axis limits (X-Zoom-in)  by 20%
%     SHIFT-Right:    Increase X-axis limits (X-Zoom-out) by 20%
%     SHIFT-Up:       Decrease Y-axis limits (Y-Zoom-in)  by 20%
%     SHIFT-Down:     Increase Y-axis limits (Y-Zoom-out) by 20%
%
%     CTRL+Home:      Reset axes limit to automatic, 3D-view
%     CTRL+Arrowkeys: Tilt and rotate view
%     x               View Y-Z plane
%     y               View X-Z plane
%     z               View X-Y plane    
%
%   In 3D plots you have the additional features
%     +               Pan up in Z-direction by 20%
%     -               Pan down in Z-direction by 20%
%
%
% Example 1:
%   t = 0:pi/100:20*pi;
%   y = sin(t)+(rand(size(t))-.5)/2;
%   plot(t,y)
%   keyboardnavigate on
%
% Example 2:
%   surf(peaks)
%   axis vis3d
%   keyboardnavigate on

% By A. Wüstefeld, Nov. 2008
% splitlab@gmx.net






fig = get(0,'CurrentFigure');
ax  = get(fig,'CurrentAxes');



if nargin==0,
    if strcmp(get(fig, 'KeyPressFcn'), '@navigateKeyPress')
        keyboardnavigate('off');
    else
        keyboardnavigate('on');
    end

elseif nargin==1
    switch option
        case 'off'
            set(fig, 'KeyPressFcn', '');
        case 'on'
            if isempty(get(fig, 'WindowButtonMotionFcn'))
               set(fig, 'WindowButtonMotionFcn', '%this is a Dummy-line only to update the current point property in the current axes!');
            end
            oldKeyPressFcn=get(fig, 'KeyPressFcn');
            if ~isempty(oldKeyPressFcn);
                warning('keyboardnavigate:OldFunctionExist', ...
                    'The existing keypress function for this figure will be deleted!\nYour old function was : "%s"',char(oldKeyPressFcn))
            end
            set(fig, 'KeyPressFcn',  @navigateKeyPress)
            set(fig, 'Pointer','fleur')
    end
else
    error('keyboardnavigate:Arguments','Too many arguments for keyboardnaviagte')
end







%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function navigateKeyPress(src,evnt)

ax = get(src, 'CurrentAxes');

% Check if we have a X-Y plot
v    = view(ax);
isaxes2D = abs(v(3,3))==1;


if length(evnt.Modifier) == 1 & strcmp(evnt.Modifier{:}, 'control')
    switch evnt.Key
        case {'home'}
            axis(ax,'auto');
            view(3)
        case 'rightarrow'
            camorbit(-10,0,'camera')
        case 'leftarrow'
            camorbit(10,0,'camera')
        case 'uparrow'
            camorbit(0,-10,'camera')
        case 'downarrow'
            camorbit(0,10,'camera')
    end

elseif length(evnt.Modifier) == 1 & strcmp(evnt.Modifier{:}, 'shift')
    xx = xlim;
    yy = ylim;

    point = get(gca,'CurrentPoint');
    point = point(1,:);
    inAxes = ...
        xx(1)<=point(1) && point(1)<=xx(2) &&  ...
        yy(1)<=point(2) && point(2)<=yy(2);
    
    switch evnt.Key
        case 'rightarrow'
            if inAxes
                Xlimit = xx - [point(1)-xx(1) (point(1)-xx(2))] /5;
            else
                Xlimit = (xx - [diff(xx) -diff(xx)] /5);
            end
            xlim(Xlimit);
            
        case 'leftarrow'
            if inAxes
                Xlimit = xx + [point(1)-xx(1) (point(1)-xx(2))] /5;
            else
                Xlimit = (xx + [diff(xx) -diff(xx)] /5);
            end
            xlim(Xlimit);
            
        case 'uparrow'
            if inAxes
                Ylimit = yy + [point(2)-yy(1) (point(2)-yy(2))] /5;
            else
                Ylimit = (yy + [diff(yy) -diff(yy)] /5);
            end
            ylim(Ylimit);
            
        case 'downarrow'
            if inAxes
                Ylimit = yy - [point(2)-yy(1) (point(2)-yy(2))] /5;
            else
                Ylimit = (yy - [diff(yy) -diff(yy)] /5);
            end
            ylim(Ylimit);
    end
    
elseif length(evnt.Modifier) == 0 ;%Normal mode; no modifier pressed
    switch evnt.Key
        case {'home','escape'}
            axis(ax,'auto');
            view(2)

        case 'rightarrow'
            xx = xlim;
            xlim(xx+diff(xx)/5)


        case 'leftarrow'
            xx=xlim;
            xlim(xx-diff(xx)/5)


        case 'uparrow'
            yy=ylim;
            ylim(yy+diff(yy)/5)


        case 'downarrow'
            yy=ylim;
            ylim(yy-diff(yy)/5)


        case 'pageup'    %zoom in by 20%
            xx = xlim;
            yy = ylim;
            zz = zlim;
            point = get(gca,'CurrentPoint');
            point = point(1,:);
            inAxes = ...
                xx(1)<=point(1) && point(1)<=xx(2) &&  ...
                yy(1)<=point(2) && point(2)<=yy(2) &&  ...
                zz(1)<=point(3) && point(3)<=zz(2);

            if inAxes
                Xlimit = xx + [point(1)-xx(1) (point(1)-xx(2))] /5;
                Ylimit = yy + [point(2)-yy(1) (point(2)-yy(2))] /5;
                Zlimit = zz + [point(3)-zz(1) (point(3)-zz(2))] /5;
            else
                Xlimit = (xx + [diff(xx) -diff(xx)] /5);
                Ylimit = (yy + [diff(yy) -diff(yy)] /5);
                Zlimit = (zz + [diff(zz) -diff(zz)] /5);
            end
            if isaxes2D
                axis([Xlimit Ylimit])
            else
                axis([Xlimit Ylimit Zlimit]) %zoom in by 20%
            end


        case 'pagedown' %zoom out by 20%
            xx = xlim;
            yy = ylim;
            zz = zlim;
            point = get(gca,'CurrentPoint');
            point = point(1,:);

            inAxes = ...
                xx(1)<=point(1) && point(1)<=xx(2) &&  ...
                yy(1)<=point(2) && point(2)<=yy(2) &&  ...
                zz(1)<=point(3) && point(3)<=zz(2);

            %             inAxes=1;
            if inAxes
                Xlimit = xx - [point(1)-xx(1) (point(1)-xx(2))] /5;
                Ylimit = yy - [point(2)-yy(1) (point(2)-yy(2))] /5;
                Zlimit = zz - [point(3)-zz(1) (point(3)-zz(2))] /5;
            else
                Xlimit = (xx - [diff(xx) -diff(xx)] /5);
                Ylimit = (yy - [diff(yy) -diff(yy)] /5);
                Zlimit = (zz - [diff(zz) -diff(zz)] /5);
            end
            if isaxes2D
                axis([Xlimit Ylimit])
            else
                axis([Xlimit Ylimit Zlimit]) %zoom in by 20%
            end

        otherwise
            if ~isaxes2D
                switch evnt.Character
                    case '+'
                        zz = zlim;
                        zlim(zz-diff(zz)/5)
                    case '-'
                        zz=zlim;
                        zlim(zz+diff(zz)/5)
                end
            end
            switch evnt.Character
                case 'z'
                    view(0,90);
                case 'y'
                    view(0,0);
                case 'x'
                    view(90,0);
            end


    end
end