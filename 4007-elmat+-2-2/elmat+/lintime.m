function y=lintime(t0,dt,n)
%LINTIME Linearly spaced vector.
%   LINTIME(t0, dt) generates a row vector of 100 linearly
%   equally spaced points from t0 with elements spaced by dt.
%
%   LINTIME(t0, dt, N) generates N points from t0 spaced by dt.
%
%   See also LINSPACE, LOGSPACE, :.

% Copyright (c) 2003-12-11, B. Rasmus Anthin.

if nargin==2
   n=100;
end
t1=t0+(n-1)*dt;
y=t0:dt:t1;