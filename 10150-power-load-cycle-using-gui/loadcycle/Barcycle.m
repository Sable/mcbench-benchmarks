% This function obtains a plot of the load cycle for a given interval.
% The demand interval and the load must be defined by the variable data
% in a three-column matrix.  The first two columns are the demand
% interval and the third column is the load value. The demand interval
% may be minutes, hours, or month in ascending order.  Hourly intervals
% must be expressed in military time.
%
% Copyright (C) 1998 by H. Saadat.

function barcycle(data)
L=length(data);
tt = [data(:,1) data(:,2)];
t = sort(reshape(tt, 1, 2*L));
PP=data(:,3);
for n = 1:L
P(2*n-1)=PP(n);
P(2*n)=PP(n);
end
plot(t,P)
