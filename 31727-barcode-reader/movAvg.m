function [gw,xw]=movAvg(g,wt)
% clear, load movAvgTest.mat, wt=3;
n=length(g);
x=ones(size(g)); x=cumsum(x);

for i=wt+1:n-wt
    gw(i-wt)=mean(g(i-wt:i+wt));
    xw(i-wt)=mean(x(i-wt:i+wt));
end

% figure(1), plot(x,g,xw,gw)