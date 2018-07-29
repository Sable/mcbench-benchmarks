function [fmin,fconstr]=fun(A,p,q)
% Example of target function to be used by SIMPS minimizer

% Handling of optional problem-dependent parameters
if nargin>1
%
 if nargin>2
%
 end
end

n=prod(size(A));
B=zeros(1,n); B(:)=A;
B=(sin((B.*(1:n)).^2)).^20;
fmin=abs(det(A))/500+sum(B)/1+norm(fix(n*A))/200;
% All three components are scaled to about the same order of
% magnitude. Observe that constants 500, 1 and 200
% - as well as 10 and 5 used for the constraints (see below) -
% are obtained statistically and they are hard-coded
% exclusively for the case of three-dimensional matrices A.

fconstr=[trace(abs(A))-10,5-min(abs(eig(A)))];

return

