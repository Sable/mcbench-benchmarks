%   xyerrorbar.m
%   (c) Nils Sjoberg 07-09-2004 Sweden
%   xyerrorbar(x,y,errx,erry,s) plots the data in y vs x with errorbars for
%   both y and x-data. Variables errx and erry are arrays of length=length(x and y) containing the
%   error in each and every datapoint.
%   s contains drawing-options for the plot and the options are the same as in
%   the ordinary plot-command, however the errorbar is plotted in a very
%   nice red hue!
%
%   Here is an example 
%   >figure
%   >xyerrorbar([1:0.5:5],[sin([1:0.5:5])],[ones(10,1).*0.1],[ones(10,1).*0.2],'g+')
%   the result shold be a plot of sin(x) vs x with errorbars for both x and
%   sin(x) -data.

function []=xyerrorbar(x,y,errx,erry,s)
if length(x)~=length(y)
    disp('x and y must have the same number of elements')
    return
end
if nargin<5
    s='';
end
hold on
for k=1:length(x)
    l1=line([x(k)-errx(k) x(k)+errx(k)],[y(k) y(k)]);
    set(l1,'color',[0.7 0.05 0.4])
    l2=line([x(k)-errx(k) x(k)-errx(k)],[y(k)-0.1*errx(k) y(k)+0.1*errx(k)]);
    l3=line([x(k)+errx(k) x(k)+errx(k)],[y(k)-0.1*errx(k) y(k)+0.1*errx(k)]);
    l4=line([x(k) x(k)],[y(k)-erry(k) y(k)+erry(k)]);
    set(l4,'color',[0.7 0.05 0.4])
    l5=line([x(k)-0.1*errx(k) x(k)+0.1*errx(k)],[y(k)-erry(k) y(k)-erry(k)]);
    l6=line([x(k)-0.1*errx(k) x(k)+0.1*errx(k)],[y(k)+erry(k) y(k)+erry(k)]);
end
plot(x,y,s)
hold off

