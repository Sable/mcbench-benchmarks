function iplot(x,y,xr,yr,N,varargin)

% iplot %
% when we plot data, typically we use a fixed interval in the x-direction.  as a result, if you try
% to use markers, in regions of your function where y is changing rapidly, the markers will be very 
% spread out, and in regions where y barely changes, your markers will overlap.  the result is a 
% clumsy looking plot.  you can try to get around this by plotting a subset of your function (i.e., 
% plot(x(1:N:end),y(1:N:end)) but the result is also clumsy and you have to try and play around with 
% N. this function solves this problem by guarenteeing that the distance between neighboring markers 
% remains constant along the function you are plotting, regardless of its derivative direction.  the 
% user can specify the number of markers they want, N, spread evenly along the length of the plotted 
% line.  because the axis units does not always correspond to their displayed size in a plot, the 
% user must also specify the x and y axis ranges they ultimately wish to display the plot at in 
% xr=[xmin xmax] and yr=[ymin ymax].
%
% example
% 
% x=linspace(-pi,pi,361)
% y=sin(x);
% figure(1)
% iplot(x,y,[-pi pi],[-1 1],40,'k-s','LineWidth',0.75,'MarkerFaceColor','w','MarkerSize',5.0)

xres=100000;
xmin=min(x(:));
xmax=max(x(:));
ymin=min(y(:));
ymax=max(y(:));
ix=linspace(xmin,xmax,xres);
iy=interp1(x,y,ix);

xscale=abs(xr(2)-xr(1));
yscale=abs(yr(2)-yr(1));

d=sqrt(((ix(2:end)-ix(1:end-1))/xscale).^2+((iy(2:end)-iy(1:end-1))/yscale).^2);
dcdf=cumsum(d);
length=sum(d(:));
segment=length/N;

di=0;
xp=zeros(N,1);
yp=zeros(N,1);
for i=1:N+1
    dp=abs(dcdf-di);
    ind=find(dp==min(dp(:)));
    xp(i)=ix(ind);
    yp(i)=iy(ind);
    di=di+segment;
end

plot(xp,yp,varargin{:})
    
