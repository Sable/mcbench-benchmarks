function R = sep(varargin);
% SEP - An Algorithm for Converting Covariance to Spherical Error Probable
%
% Version 1.0
%
% Copyright 2004, Michael Kleder
%
% USAGE:
%
% R = sep(sx,sy,sz)
% R = sep(sx,sy,sz,prob)
%
% This function computes Spherical Error Probable radius from inputs consisting of the
% square roots of the eigenvalues of a covariance matrix (equivalently, from sigma-x,
% sigma-y, and sigma-z, of a trivariate normal distribution in a coordinate system
% where there is no cross-correlation between variables.) This means that if you have
% a covariance matrix and wish to compute the S.E.P., simply obtain the square roots
% of the eigenvalues and use these as inputs. For example, list them via "sqrt(eig(C))"
% where C is your covariance matrix.
%
% The S.E.P. is the radius of a sphere which contains a fraction of probability equal
% to the input "prob," which is asumed to be 0.5 if omitted.
%
% Note: if one of the input sigmas is significantly smaller than both others,
% calculation time may rise.
%
% By uncommenting a labeled line of code, the user can enter a diagnostic mode
% to verify the accuracy of this algorithm for whatever inputs are specified.
%
% The mathematical formulas contained herein were created by the author and
% are copyrighted. Feel free to use them provided you credit the author:
% Kleder, Michael. "An Algorithm for Converting Covariance to Spherical Error Probable"
% Mathworks Central File Exchange, 2004.


[sx,sy,sz]=deal(varargin{1:3});
target = .5;
if nargin>3
    target=varargin{4};
end
lowend=0;
highend=10*max([sx sy sz]);
R = fminbnd(@enclosederr,lowend,highend,[],sx,sy,sz,target);
% diagnostic(R,sx,sy,sz) % use this to verify results against RANDN
return
function enclerr = enclosederr(R,sx,sy,sz,target)
enclerr=dblquad(@dens,0,pi,0,2*pi,[],[],R,sx,sy,sz);
enclerr=(target-enclerr)^2;
return
function outp = dens(th,phi,R,sx,sy,sz)
sinth  = sin(th);
sinphi = sin(phi);
costh  = cos(th);
cosphi = cos(phi);
subexprA = sinth.^2.*cosphi.^2.*sy.^2.*sz.^2+sinth.^2.*...
    sinphi.^2.*sx.^2.*sz.^2+costh.^2.*sx.^2.*sy.^2;
subexprB = sx.*sy.*sz;
outp = -1./8.*sinth.*2.^(.5).*subexprB.*(2.*R.*exp(-.5.*subexprA.*...
    R.^2./subexprB.^2).*subexprA.^(.5)-pi.^(.5).*2.^(.5).*erf(.5.*...
    2.^(.5)./subexprB.*subexprA.^(.5).*R).*subexprB)./pi.^(1.5)./subexprA.^(1.5);
return
function diagnostic(R,sx,sy,sz)
disp('Running test of SEP.')
for i=10:-1:1
    fprintf('%g ',i);
    x=randn(1e6,1)*sx;;
    y=randn(1e6,1)*sy;
    z=randn(1e6,1)*sz;
    r=sqrt(sum([x y z].^2,2));
    m(i) = sum(r<R)/length(r);
end
disp(' ');
m=mean(m);
disp([num2str(m*100) ' percent of random points were located within the computed SEP.'])
return