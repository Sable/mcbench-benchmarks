%Normaldistribution
%
% calculating the area under a normal distribution curve
% from -ve infinity upto point x.   
%
% Input:
%    x       : point on the normal distribution curve
%    mean    : mean of the normal distribution curve
%    sigma   : standard deviation of the normal distribution curve 
%              (hint: normal dist mean=0, sigma=1)
%    plotting: Plot the calculated area if plotting = 1
% Output: area under the curve.
%
% Author:
%  Sherif Omran
%  University and university hospital of Zurich
%  Date: May 2009
%-------------------------------------------------------------------------%



function prob=normaldistribution(x, mean, sigma,plotting)
resolution=0.01;
u=[mean-3.5*sigma:resolution:mean+3.5*sigma]; %array of points from -inf to x
e=exp(1);
p=(1/(sqrt(2*pi)*sigma))*e.^(-((u-mean).^2)./(2*sigma^2));
mx=max(p);
p=p/mx; %normalize into 1
k=find(u<x);
prob=sum(p(k))*resolution*mx;

if nargin<4,
    plotting=0;
end
if plotting==1,  % plot the probability distribution function and the area
    figure;
    basey = min(0,min(p)); 
    h = fill([u(1) u(k)], [p(k) basey], 'r');     % fill with red
    hold on
    plot(u,p);
    v=gcf; h=get(v,'currentaxes');
    set(h,'Xlim',[u(1) u(end)]);
    set(h,'Ylim',[basey max(p)]);
    title('normal distribution curve')
    xlabel(['mean=' num2str(mean) '  standard deviation=' num2str(sigma)]);
    ylabel('probability distribution function (x)')
    grid on
end
return