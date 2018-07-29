function [t,x,y]=get_points(b,N)
% function [t,x,y]=get_points(b,N)
% return points


if ~strcmpi(class(b),'bezier')
  error('Expecting a bezier object');
end


t=linspace(0,1,N);
t2=t.^2;
t3=t2.*t;
x=b.ax*t3+b.bx*t2+b.cx*t+b.x0;
y=b.ay*t3+b.by*t2+b.cy*t+b.y0;

