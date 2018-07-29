function move(hfl,xp,yp,xd,yd,kkx,kky,xys1,xys2,uf)
% makes move
% hfl - fill handle (circle)
% xp,yp - initial pointer position
% xd,yd - initial coodinaties in fill
% kk - scale coefficient between pixels and units of axes
% uf - update function

global xys sp iscnt mth res hc

xys_old=[xys1;xys2];

no=get(hfl,'Userdata');

ha=get(hfl,'Parent');
xl=get(ha,'Xlim');
yl=get(ha,'Ylim');
dxl=xl(2)-xl(1);
dyl=yl(2)-yl(1);

pl=get(0,'PointerLocation');
xpt=pl(1);
ypt=pl(2);

dx=kkx*(xpt-xp);
dy=kky*(ypt-yp);

% axis limits:
if (xys_old(1,no)+dx)>xl(2)
    dx=xl(2)-xys_old(1,no);
end

if (xys_old(1,no)+dx)<xl(1)
    dx=xl(1)-xys_old(1,no);
end

if (xys_old(2,no)+dy)>yl(2)
    dy=yl(2)-xys_old(2,no);
end

if (xys_old(2,no)+dy)<yl(1)
    dy=yl(1)-xys_old(2,no);
end

% span between markers
nm=length(xys(1,:));



if no~=nm
    if (xys_old(1,no)+dx)>(xys(1,no+1)-sp)
        dx=xys(1,no+1)-sp-xys_old(1,no);
    end
else
    if iscnt
        if (xys_old(1,no)+dx)>(xys(1,1)+dxl-sp)
            dx=xys(1,1)+dxl-sp-xys_old(1,no);
        end
    else
        dx=xl(2)-xys_old(1,no);
    end
end

if no~=1
    if (xys_old(1,no)+dx)<(xys(1,no-1)+sp)
        dx=xys(1,no-1)+sp-xys_old(1,no);
    end
else
    if iscnt
        if (xys_old(1,no)+dx)<(xys(1,end)-dxl+sp)
            dx=xys(1,end)-dxl+sp-xys_old(1,no);
        end
    else
        dx=xl(1)-xys_old(1,no);
    end
end
    
xdt=xd+dx;
ydt=yd+dy;

xys(1,no)=xys_old(1,no)+dx;
xys(2,no)=xys_old(2,no)+dy;

set(hfl,'XData',xdt);
set(hfl,'YData',ydt);

% set(hfl,'Userdata',[x y r])
%xyr=get(hfl,'Userdata');
%set(hfl,'Userdata',[xyr(1)+(xpt-xp) xyr(2)+(ypt-yp) xyr(3)]);


update_curve;


drawnow;


