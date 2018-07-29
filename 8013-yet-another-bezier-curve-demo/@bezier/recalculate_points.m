function c=recalculate_points(b)
% function c=recalculate_points(b)

if ~strcmpi(class(b),'bezier')
  error('Expecting a bezier object');
end

c=b;

c.x1=c.x0+c.cx/3;
c.x2=c.x1+(c.cx+c.bx)/3;
c.x3=c.x0+c.cx+c.bx+c.ax;

c.y1=c.y0+c.cy/3;
c.y2=c.y1+(c.cy+c.by)/3;
c.y3=c.y0+c.cy+c.by+c.ay;
