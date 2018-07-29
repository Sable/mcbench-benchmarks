function [x,y,r]=MagnetGInput(h,N,TEST)
% MAGNETGINPUT(h,N,test)
% Given the handle of the plot, h, MAGNETGINPUT will either
% return the position clicked (upon right button press) or
% the location of the datapoint closest to the position
% clicked (upon left button press)
%
% If N is provided, MagnetGInput will allow N button clicks
%
% The closest datapoint is determined by minimizing the
% distance which is weighted by the scale of the figure,
% such that if your figure is [0:1:0:1000], the distance
% is
%
%    sqrt(((X-x)./1).^2+((Y-y)./1000).^2);
%
% It returns the abscissa and ordinate of the point clicked
% or datapoint closest to that point as well as the distance
% from the returned position to the click.
%
% If TEST is set true, MAGENETGINPUT will draw a red line
% from the click to the closest datapoint and a red circle
% using the click as the origin and the distance to the
% closest datapoint as a radius
%
% USAGE:
%
%   y=sin([.1:.1:10])+rand(1,100).*0.1;
%   h=plot([1:100],y,'-');
%   [xin,yin,rin]=MagnetGInput(h);
%   % click on your plot with the LEFT mouse button
%   line(xin+[0 10],yin+[0 .5],'color','r');
%   text(xin+10,yin+.5,{'This datapoint','was the closest to','your mouse click'},'color','r');
%   hold on;plot(xin,yin,'ro');
%   
% IT'S NOT FANCY BUT IT WORKS.

% Michael Robbins
% robbins@bloomberg.net
% michael.robbins@us.cibc.com

if nargin<2 N=1; end;
if nargin<3 TEST=0; end;

X=get(h,'XData');
Y=get(h,'YData');
XScale=diff(get(gca,'XLim'));
YScale=diff(get(gca,'YLim'));

for j=1:N
    [x(j),y(j),button]=ginput(1);
    if button==1
        r=sqrt(((X-x(j))./XScale).^2+((Y-y(j))./YScale).^2);
        [temp,i]=min(r);
        xclick=x(j);
        yclick=y(j);
        x(j)=X(i);
        y(j)=Y(i);
        if TEST
            k=0:.1:3.*pi;
            hold on;
            plot(XScale.*r(i).*sin(k)+xclick,YScale.*r(i).*cos(k)+yclick,'r');
            line([xclick x(j)],[yclick y(j)],'color','r');
        end;
    end;
end;