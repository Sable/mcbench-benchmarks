%% load some data
load leq
%% plot it
plot(yy);, grid on
title('1-D signal')
%% embed it into a 3-D space with a delay of 10
N=10;
A=[yy(1:end-(N-1)),yy(N/2:end-N/2),yy(N:end)];
%% plot it again
figure
plot3(A(:,1),A(:,2),A(:,3))
grid on, axis tight
title('3-D signal')