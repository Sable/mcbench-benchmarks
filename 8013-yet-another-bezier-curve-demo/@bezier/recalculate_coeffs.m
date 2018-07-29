function c=recalculate_coeffs(b)
% function c=recalculate_coeffs(b)

if ~strcmpi(class(b),'bezier')
  error('Expecting a bezier object');
end

c=b;

c.cx=3*(c.x1-c.x0);
c.bx=3*(c.x2-c.x1)-c.cx;
c.ax=c.x3-c.x0-c.cx-c.bx;

c.cy=3*(c.y1-c.y0);
c.by=3*(c.y2-c.y1)-c.cy;
c.ay=c.y3-c.y0-c.cy-c.by;
