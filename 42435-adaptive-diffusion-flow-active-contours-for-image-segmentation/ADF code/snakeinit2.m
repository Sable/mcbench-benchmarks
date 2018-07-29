function [x,y] = snakeinit2(delta)

hold on
x = [];
y = [];
disp('Left mouse button picks points.')
disp('Right mouse button picks last point.')
but = 1;x=[];y=[];
while but == 1
    [xi,yi,but] = ginput(1);
    plot(xi,yi,'b.');
    x=[x xi];y=[y yi];
    plot(x,y,'r-');
end

xr=[x x(1)];
yr=[y y(1)];
n=length(xr);
xy=[xr;yr];

% spline curve interpolation
t = 1:n;
ts = 1: delta: n;
xys = spline(t,xy,ts);

plot(xys(1,:),xys(2,:),'r-');
x=xys(1,1:length(xys)-1)';
y=xys(2,1:length(xys)-1)';
