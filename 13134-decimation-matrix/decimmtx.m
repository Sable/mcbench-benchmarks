function [D,y] = decimmtx(x,N)
% D = decimmtx(x,N)
% This function generates decimation matrix which post-multiplied by the
% signal x will procude a signal y which will be decimated version of x by
% a factor of N.
%
%
x = x(:);
nx = length(x);
nn = ceil(nx/N);
D1 = zeros(nn,nx);
D1(1,1) = 1;
for i = 2:nn
    D1(i,(i-1)*(N)+1) = 1;
end
D = D1;
y = D*x;
y = y';