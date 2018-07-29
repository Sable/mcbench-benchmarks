function dg=diffScheme(g)
% clear, load movAvgTest.mat
dg=zeros(size(g));
dg(2:end-1) = g(3:end) - g(1:end-2);
dg(1)=g(2)-g(1);
dg(end)=g(end)-g(end-1);
% x=1:length(g); figure(1), plot(x,g,x,dg)