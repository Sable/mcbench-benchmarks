function moverotateobj(action)
%moverotateobj(action)
%
%Called when an object is clicked on
%whos ButtonDownFcn = moverotateobj('BtnDown')
%
%This is can be done by using
%   set(h,'ButtonDownFcn','moverotateobj(''BtnDown'')')
%where h is handle vector or typing
%moverotateobj('On') does this automatically
%moverotateobj('Off') takes it off
%
%moverotateobj by its self turns the property 'On'
%if it is 'Off' or turns it 'Off' if it is 'On'
%
%Copy-Left, Alejandro Sanchez-Barba, 2005

if nargin==0
    hFig = gcf;
    ud = get(hFig,'UserData');
    if isfield(ud,'manual')
        if strcmp(ud.manual,'On')
            action = 'Off';
        else %off
            action = 'On';
        end
    else
        action = 'On';
    end
end
eval(action)
return

%-----------------------------------------------------------
function BtnDown
hFig = gcf;
Button = get(hFig,'SelectionType');
ud = get(hFig,'UserData');
ud.Button = Button;
ud.hAx = get(hFig,'CurrentAxes');
ud.CurrentPoint = get(ud.hAx,'CurrentPoint');
ud.hObj = get(hFig,'CurrentObject');
set(ud.hObj,'Selected','On')
ud.ObjType = get(ud.hObj,'Type');
switch ud.Button
    case 'normal' %Move
        setptr(hFig,'closedhand');
    case 'alt' %Rotate
        setptr(hFig,'rotate');
        ud.hLine = line('XData',[],'YData',[], ...
            'Parent',ud.hAx,'Color','k');
        ud.Orig = ud.CurrentPoint;
    otherwise
        return
end %switch
ud.xmode = get(ud.hAx,'XLimMode');
ud.ymode = get(ud.hAx,'YLimMode');
set(ud.hAx,'XLimMode','manual')
set(ud.hAx,'YLimMode','manual')
set(hFig,'UserData',ud)
set(hFig,'WindowButtonMotionFcn','moverotateobj(''BtnMotion'')',...
   'WindowButtonUpFcn', 'moverotateobj(''BtnUp'')');
return

%-----------------------------------------------------------
function BtnMotion
hFig = gcf;
ud = get(hFig,'UserData');
hObj = ud.hObj;
ObjType = ud.ObjType;
switch ObjType
    case 'line'
        x = get(hObj,'XData');
        y = get(hObj,'YData');
    case 'text'
        pos = get(hObj,'Position');
        x = pos(1);
        y = pos(2);
    otherwise
        error('Unknown Object');
end %switch
hAx = ud.hAx;
LastPoint = ud.CurrentPoint;
CurrentPoint = get(hAx,'CurrentPoint');
Button = ud.Button;
switch Button
    case 'normal' %Move
        %Calculate Difference
        dx = CurrentPoint(1,1) - LastPoint(1,1); 
        dy = CurrentPoint(1,2) - LastPoint(1,2);
        x = x + dx;
        y = y + dy;
        %Update position on Plot
        switch ObjType
            case 'line'
                set(hObj,'XData',x,'YData',y)
            case 'text'
                set(hObj,'Position',[x,y])
            otherwise
                error('Unknown Object')
        end %switch
    case 'alt' %Rotate
        xline = [ud.Orig(1,1),CurrentPoint(1,1)];
        yline = [ud.Orig(1,2),CurrentPoint(1,2)];
        set(ud.hLine,'XData',xline,'YData',yline)
        u1 = CurrentPoint(1,1) - ud.Orig(1,1);
        v1 = CurrentPoint(1,2) - ud.Orig(1,2);
        th1 = atan2(v1,u1);
        u2 = LastPoint(1,1) - ud.Orig(1,1);
        v2 = LastPoint(1,2) - ud.Orig(1,2);
        th2 = atan2(v2,u2);
        theta = th1 - th2;
%         disp([th1,th2,theta]*180/pi)
        switch ObjType
            case 'line'
                rot = [cos(theta) -sin(theta); ...
                    sin(theta) cos(theta)];
                vec = [x(:)-ud.Orig(1,1),y(:)-ud.Orig(1,2)];
                newvec = (rot*vec')';
                x = newvec(:,1) + ud.Orig(1,1);
                y = newvec(:,2) + ud.Orig(1,2);
                set(hObj,'XData',x,'YData',y)
            case 'text'
                thetaold = get(hObj,'Rotation');
                thetanew = thetaold + theta*180/pi;
                set(hObj,'Rotation',thetanew)
            otherwise
                error('Unknown Object')
        end %switch
end %switch
ud.CurrentPoint = CurrentPoint;
set(hFig,'UserData',ud)
return

%-----------------------------------------------------------
function BtnUp
hFig = gcf;
setptr(hFig,'arrow');
set(hFig,'WindowButtonMotionFcn','');
ud = get(hFig,'UserData');
ud.xmode = get(ud.hAx,'XLimMode');
ud.ymode = get(ud.hAx,'YLimMode');
set(ud.hObj,'Selected','Off')
if strcmp(ud.xmode,'auto')
    set(ud.hAx,'XLimMode','auto')
end
if strcmp(ud.ymode,'auto')
    set(ud.hAx,'YLimMode','auto')
end
if strcmp(ud.Button,'alt')
    set(ud.hLine,'XData',[],'YData',[])
end
return

%-----------------------------------------------------------
function On
hFig = gcf;
ud = get(hFig,'UserData');
ud.hAx = get(hFig,'CurrentAxes');
ud.manual = 'On';
set(hFig,'UserData',ud)
h = get(ud.hAx,'Children');
set(h,'ButtonDownFcn','moverotateobj(''BtnDown'')')
return

%-----------------------------------------------------------
function Off
hFig = gcf;
ud = get(hFig,'UserData');
ud.hAx = get(hFig,'CurrentAxes');
ud.manual = 'Off';
set(hFig,'UserData',ud)
h = get(ud.hAx,'Children');
set(h,'ButtonDownFcn','')
set(hFig,'WindowButtonMotionFcn','',...
            'WindowButtonUpFcn','');
return

