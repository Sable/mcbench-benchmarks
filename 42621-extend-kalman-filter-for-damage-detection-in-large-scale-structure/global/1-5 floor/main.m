 clc
 clear
  run cal
 run unknown_input
load force.mat
load f_un.mat
load X.mat
load Y.mat
load u.mat
n=4

for ii=1:4;
      
    figure(ii)
    plot(detrend(X(ii,:)),'r')
    hold on
    plot(detrend(u(:,ii)))
end

for ii=1:4;
      
    figure(4+ii)
    plot(detrend(X(n+ii,:)),'r')
    hold on
    plot(detrend(Y(:,ii)))
end
 figure(9)
 plot(detrend(f_un));
 hold
 plot(detrend(force(:,2)),'r')
