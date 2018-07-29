function y=ramp(p,x,a)
% ramp delayed until x > a; p = slope
y=p*(x-a)*step(x,a,1);
function y=step(x,a,E)
% step delayed to x = a, Vpeak = E
if x<a
   y=0;
else
   y=E;
end
