function DispCoord1(Mode)

%--------------------------------------------------------------------------------------------
%DispCoord1(MODE) show the coordinate of the point on the 2D or 3D in 2 mode:
%   Mode=1, show in format (x,y) or (x,y)=z whenever you click a mouse button at one point;
%   Mode=2, show in format (x,y) or (x,y)=z in the mouse pointer trace when you move it.
%   Values are shown with 3 decimals.
%
%   Usage Examples,
%   x = -pi:.1:pi;
%   y = sin(x);
%   plot(x,y)
%   DispCoord1(2);   
%
%   [X,Y] = meshgrid(-3:.125:3);
%   Z = peaks(X,Y);
%   meshc(X,Y,Z);
%   DispCoord1(1);
%
%   Zhenhai Wang <zhenhai@ieee.org>
%   Version 1.00
%   April, 2002
%--------------------------------------------------------------------------------------------

if Mode==1
    set(gcf,'Pointer','crosshair','WindowButtonDownFcn','DispCoord2');
elseif Mode==2
    set(gcf,'Pointer','crosshair','WindowButtonMotionFcn','DispCoord2');
end