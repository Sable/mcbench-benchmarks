function [h,T,perm] = polardendrogram(Z,varargin)
%POLARDENDROGRAM plots a polar dendrogram plot, taking same options as
%dendrogram and giving same outputs.
% Example:
% X= rand(100,2);
% Y= pdist(X,'cityblock');
% Z= linkage(Y,'average');
% [H,T] = polardendrogram(Z,'colorthreshold','default');

%Plot a normal dendrogram
[h,T,perm] = dendrogram(Z,varargin{:});

%Get x and y ranges
xlim = get(gca,'XLim');
ylim = get(gca,'YLim');
minx = xlim(1);
maxx = xlim(2);
miny = ylim(1);
maxy = ylim(2);
xrange = maxx-minx;
yrange = maxy-miny;

%Reshape into a polar plot
for i=1:size(h)
    xdata = get(h(i),'XData');
    ydata = get(h(i),'YData');
    %Rescale xdata to go from pi/12 to 2pi - pi/12
    xdata = (((xdata-minx)/xrange)*(pi*11/6))+(pi/12);
    %Rescale ydata to go from 1 to 0, cutting off lines
    %which drop below the axis limit
    ydata = max(ydata,miny);
    ydata = 1-((ydata-miny)/yrange);
    %To make horizontal lines look more circular,
    %insert ten points into the middle of the line before
    %polar transform
    newxdata = [xdata(1), linspace(xdata(2),xdata(3),10), xdata(4)];
    newydata = [ydata(1), repmat(ydata(2),1,10), ydata(4)];
    %Transform to polar coordinates
    [xdata,ydata]=pol2cart(newxdata,newydata);
    %Reset line positions to new polar positions
    set(h(i),'XData',xdata);
    set(h(i),'YData',ydata);
end

%Relabel leaves
for i=minx+1:maxx-1
    [x,y]=pol2cart((((i-minx)/xrange)*(pi*11/6))+(pi*1/12),1.1);
    text(x,y,num2str(perm(i)));
end

%Add and label gridlines
hold on
lineh(1) = polar([0,0],[0,1],'-');
lineh(2) = polar(linspace(0,2*pi,50),ones(1,50),':');
lineh(3) = polar(linspace(0,2*pi,50),ones(1,50)*0.75,':');
lineh(4) = polar(linspace(0,2*pi,50),ones(1,50)*0.5,':');
lineh(5) = polar(linspace(0,2*pi,50),ones(1,50)*0.25,':');
set(lineh,'Color',[0.5,0.5,0.5]);
for i=1:4
    [x,y]=pol2cart(0,i/4);
    str = sprintf('%2.1f',((maxy-miny)*(4-i)/4)+miny);
    text(x,y,str,'VerticalAlignment','bottom');
end

%Prettier
set(gca,'XLim',[-1.5,1.5],'YLim',[-1.5,1.5],'Visible','off');
view(3)
axis fill
daspect([1,1,100]);
zoom(2.8);

