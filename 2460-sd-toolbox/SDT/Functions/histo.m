function [bin,xx] = histo(y,N)
% bins the elements of Y into N equally spaced containers within
% the maximum dynamic of Y.
%
% bin: the number of occurrences for each bin
% xx:  is a vector returning the position of each bin

range=ceil(2*max(y)*10)/10;
dx = range/N;
for i=1:N
	x(i) = -range/2 + (i-1)*dx + dx/2;
end
[bin,xx]=hist(y,x);
