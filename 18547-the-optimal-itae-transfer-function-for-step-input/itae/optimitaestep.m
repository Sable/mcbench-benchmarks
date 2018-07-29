function [p,f,p1,f1]=optimitaestep(n)
%OPTIMITAESTEP Calculate the optimal ITAE trasnfer function coefficient for a step input
%
% Usage:
% [p,itae,p0,itae0] = optimitaestep(n) returns the optimal coefficients of a 
% nth-order transfer function based on the ITAE criterion for a step input.
% Input:  n - the order of transfer function
% Output: p - the optimal coefficients of the nth-order transfer function
%         itae - the optimal ITAE criterion.
%         p0 - original coefficients derivided by Graham and Lathrop.
%         itae0 - the ITAE citerion correcponding to p0.
%
% Background:
% The original ITAE (stands for Integral of Time multiplied by Absolute
% Error) coefficient table was drived by D. Graham and R.C. Lathrop through 
% an analog computer. The table has been widely adopted as a standard in 
% most undergraduate level control engineering text books. However, the 
% optimality of these coefficients has been questioned by several researchers.
% This code provides a means to re-calculate these coefficient using more
% advanced numerical optimization techniques in digital computers.
%
% References:
% 1. D. Graham and R.C. Lathrop, "The Synthesis of Optimum Response: Criteria
%    ans Standard Forms, Part 2", Transactions of the AIEE 72, Nov. 1953, pp. 273-288
% 2. Y. Cao, "Correcting the minimum ITAE standard forms of 
%    zero-displaceemnt-error systems", Journal of Zhejiang University 
%    (Natural Science) Vol. 23, N0o.4, pp. 550-559, 1989.
%
% Example, the 7th-order optimal and original ITAE coefficients 
%{
format compact
format short g
[p,f,p1,f1] = optimitaestep(7)
%}
% p =
%    1  2.2172  6.7447  9.3493  11.58   8.6799  4.3233  1
% f =
%    10.585
% p1 =
%    1  4.475   10.42   15.08   15.54   10.64   4.58    1
% f1 =
%    14.953
%

%Input check
error(nargchk(1,2,nargin));
if n<2 || n>8
    error('n must be within range of [2 8].')
end
itaeOrg={ 1.4, [1.75 2.15], [2.1 3.4 2.7],...
       [2.8 5.0 5.5 3.4], [3.25 6.60 8.60 7.45 3.95],...
       [4.475 10.42 15.08 15.54 10.64 4.58],...
       [5.2 12.8 21.6 25.75 22.2 13.3 5.15]};
p1=itaeOrg{n-1};
p0=fliplr(p1);
opt=optimset('display','off','TolX',1e-9,'TolFun',1e-9,'LargeScale','off');
dt=0.01;
tf=50;
flag=0;
while ~flag
    cost=@(x)itaecost(x,dt,tf);
    [p0,f,flag]=fminunc(cost,p0,opt);
    p=[1 fliplr(p0) 1];
    if any(real(roots(p))>0)
        tf=tf*2;
        flag=0;
        p0=fliplr(itaeOrg{n-1});
    end
end
if nargout>2
    f1=cost(fliplr(p1));
    p1=[1 p1 1];
end
    
function E=itaecost(p,dt,tf)
n=numel(p);
A=[zeros(n,1) eye(n);-1 -p];
B=[zeros(n,1);1];
A=expm([A B;zeros(1,n+2)]*dt);
x=[zeros(n+1,1);1];
E=0;
for t=0:dt:tf
    tdt=t*dt;
    x=A*x;
    e=1-x(1);
    E=E+abs(e)*tdt;
end
