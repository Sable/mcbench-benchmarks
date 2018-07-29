function [x,w] = fnnls(XtX,Xty,tol)
%FNNLS	Non-negative least-squares.
%
% 	Adapted from NNLS of Mathworks, Inc.
%
%	x = fnnls(XtX,Xty) returns the vector X that solves x = pinv(XtX)*Xty
%	in a least squares sense, subject to x >= 0.
%	Differently stated it solves the problem min ||y - Xx|| if
%	XtX = X'*X and Xty = X'*y.
%
%	A default tolerance of TOL = MAX(SIZE(XtX)) * NORM(XtX,1) * EPS
%	is used for deciding when elements of x are less than zero.
%	This can be overridden with x = fnnls(XtX,Xty,TOL).
%
%	[x,w] = fnnls(XtX,Xty) also returns dual vector w where
%	w(i) < 0 where x(i) = 0 and w(i) = 0 where x(i) > 0.
%
%	See also NNLS and FNNLSb

%	L. Shure 5-8-87
%	Revised, 12-15-88,8-31-89 LS.
%	(Partly) Copyright (c) 1984-94 by The MathWorks, Inc.

%	Modified by R. Bro 5-7-96 according to
%       Bro R., de Jong S., Journal of Chemometrics, 1997, 11, 393-401
% 	Corresponds to the FNNLSa algorithm in the paper
%
%	
%	Rasmus bro
%	Chemometrics Group, Food Technology
%	Dept. Dairy and Food Science
%	Royal Vet. & Agricultural
%	DK-1958 Frederiksberg C
%	Denmark
%	rb@kvl.dk
%	http://newton.foodsci.kvl.dk/rasmus.html


%  Reference:
%  Lawson and Hanson, "Solving Least Squares Problems", Prentice-Hall, 1974.

% initialize variables
if nargin < 3
    tol = 10*eps*norm(XtX,1)*max(size(XtX));
end
[m,n] = size(XtX);
P = zeros(1,n);
Z = 1:n;
x = P';
ZZ=Z;
w = Xty-XtX*x;

% set up iteration criterion
iter = 0;
itmax = 30*n;

% outer loop to put variables into set to hold positive coefficients
while any(Z) & any(w(ZZ) > tol)
    [wt,t] = max(w(ZZ));
    t = ZZ(t);
    P(1,t) = t;
    Z(t) = 0;
    PP = find(P);
    ZZ = find(Z);
    nzz = size(ZZ);
    z(PP')=(Xty(PP)'/XtX(PP,PP)');
    z(ZZ) = zeros(nzz(2),nzz(1))';
    z=z(:);
% inner loop to remove elements from the positive set which no longer belong

    while any((z(PP) <= tol)) & iter < itmax

        iter = iter + 1;
        QQ = find((z <= tol) & P');
        alpha = min(x(QQ)./(x(QQ) - z(QQ)));
        x = x + alpha*(z - x);
        ij = find(abs(x) < tol & P' ~= 0);
        Z(ij)=ij';
        P(ij)=zeros(1,max(size(ij)));
        PP = find(P);
        ZZ = find(Z);
        nzz = size(ZZ);
        z(PP)=(Xty(PP)'/XtX(PP,PP)');
        z(ZZ) = zeros(nzz(2),nzz(1));
        z=z(:);
    end
    x = z;
    w = Xty-XtX*x;
end

