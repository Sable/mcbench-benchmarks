% Author: Harmon Amakobe
% Date: 3/8/2011
% Version : 1.1
% Newton's Method
% Input:
%   func -> function
%   gss -> initial guess
%   ite -> desired number of iterations
%   tol -> tolerance 
% NOTE: Number of iterations will be increased accordingly in order to meet
% the set tolerance value.
% Output:
%   This function will output the number of iterations it ran, and the
%   approximated value.
% Example:
%    >> newt( ' x^3 + x - 1 ', -.7 , 6 , 1e-6 )
%    >> 
%        6 
%
%    ans =
%
%        0.682327803844332

function apprx = newt(func,gss,ite,tol)
f = inline(func);
fp = inline(diff(sym(func)));
iter = ite;
for n=1:iter;
    oldgss = gss;
    newgss = gss - (f(gss)/fp(gss));
    gss = newgss;
end
if abs(newgss-oldgss) < tol
    apprx = gss;
    disp(iter);
else
    iter = ite+1;
    apprx = newt(func,gss,iter,tol);
end
end
