function status = burgersplot(t,y,flag,varargin,x,han)
% Plot

if isempty(flag)
xdata = num2cell([x x]',2);
ydata = num2cell([[0;y;0] -1*x.^0]',2);
set(han,{'xdata'},xdata,{'ydata'},ydata);
drawnow
end
status = false;
