function [X,P]=subPx(g,x,gMax,N)
% clear, load subPxData.mat, N=100;
xi=linspace(x(1),x(end),N*length(x));
gi = interp1(x,g,xi,'spline');
[pk,loc]=peakDetect(gi,0,0);
% in case multiple peaks are detected, the one closest to gMax is chosen
if length(loc)>1
    disp('WARNING: multiple peaks detected')
    [val,id]=min(abs(xi(loc)-x(find(g==gMax))));
else
    id=1;
end
X=xi(loc(id)); P=pk(id);
% figure(1), plot(x,g,'o',xi,gi,'.',xi(L),gi(L),'o')