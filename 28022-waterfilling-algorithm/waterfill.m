function [p, level] = waterfill (x,P)
% the water-filling process
% x: a vector with each component representing noise power
% P: total power
%
% The returned vector p maximizes the total sum rate given by
% sum(log(1 + p./x)), subject to the power constraint sum(p)== P, p>=0.
%
% The return a vector p also minimizes
%   norm(p+x) 
% subject to the constraints
%   sum(p)==P;  p>=0
%  
%
%  The second output "level" is the water level
%
%  Sample usage:
%  Three parallel Gaussian channels with noise powers 1, 2 and 3.
%  The total power is 2.
%
%  >> waterfill([1 2 3],2)
%  ans =
%  1.5000 0.5000 0
%
%
% Author: Kenneth Shum, 2010
%
% Reference:
%   T. M. Cover and J. A. Thomas, "Elements of Information Theory", John Wiley & Sons, 2003.

L=length(x);  % number of channels

y = sort(x);     % sort the interference power in increasing order
[a b]= size(y);
if (a>b)
    y = y' ;  % convert x and y to row vector if necessary
    x = x';
end

delta = [0 cumsum((y(2:L)-y(1:(L-1))).*(1:L-1))];
l = sum(P>=delta); % no. of channel with positive power

level = y(l)+(P- delta(l))/l;   % water level
p = (abs(level-x)+level-x)/2;   % the result of pouring water.
