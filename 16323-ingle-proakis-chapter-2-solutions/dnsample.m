function [y,m] = dnsample(x,n,M)
% Implements downsampling on x by a factor of M
% with careful attention to the origin of the time axis at n = 0
% For Example
% [y,m] = dnsample(x,n,M);
index = find (n==0);
x1 = x(1:index);
x1 = fliplr(x1);
y1 = downsample(x1,M);
y1 = fliplr(y1);
temp = size(y1);
m1 = 1:temp(1,2)-1;
m1 = -fliplr(m1);
x2 = x(index:end);
y2 = downsample(x2,M);
y = [y1(1:end-1),y2];
temp = size(y2);
m2 = 0:temp(1,2)-1;
m = [m1,m2];