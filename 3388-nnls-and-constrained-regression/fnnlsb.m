function [x,w,P,Z] = fnnlsb(XtX,Xty,P_old,Z_old,tol)
%FNNLSb	Non-negative least-squares.
%
%     	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	%							 %
%	% Please note this version of NNLS is for advanced users %
%	% Please refer to the m-file FNNLS for a simpler fast    %
%	% version of NNLS				         %
%	%						         %
%     	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
% 	Adapted from NNLS of Mathworks, Inc.
%
%	x = fnnlsb(A,b) returns the vector X that solves x = pinv(A)*b
%	in a least squares sense, subject to x >= 0. 
%
%	A default tolerance of TOL = MAX(SIZE(A)) * NORM(A,1) * EPS
%	is used for deciding when elements of x are less than zero.
%	This can be overridden with x = fnnlsb(A,b,P_old,Z_old,TOL).
%
%	[x,w] = fnnlsb(A,b) also returns dual vector w where
%	w(i) < 0 where x(i) = 0 and w(i) = 0 where x(i) > 0.
%       [X,W,P,Z] = fnnlsb(A,b) also returns the index set P and Z
%	that explicitly tells which constraints (variables) are
% 	active, which are not. These can be used as subsequent 
%	input to fnnlsb if only minor changes are expected in a new 
%	problem. P designates the passive (unconstrained) set, while
%	designates the active constraints. For initialisation use
% 	P=zeros(size(Xty));
%	Z=[1:length(Xty)]';
%
%	See also FNNLS and NNLS

%	L. Shure 5-8-87
%	Revised, 12-15-88,8-31-89 LS.
%	(Partly) Copyright (c) 1984-94 by The MathWorks, Inc.

%	Modified by R. Bro 5-7-96 according to
%       Bro R., de Jong S., Journal of Chemometrics, 1997, 11, 393-401
% 	Corresponds to the FNNLSb algorithm in the paper
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
if nargin < 5
    tol = 10*eps*norm(XtX,1)*max(size(XtX));
end
[m,n] = size(XtX);
P = P_old(:)';
PP = find(P);
Z = Z_old(:)';
ZZ=find(Z);
iter = 0;
itmax = 30*n;
z=zeros(n,1);
x=z;
z(PP)=(Xty(PP)'/XtX(PP,PP)');

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

% set up iteration criterion
iter = 0;

% outer loop to put variables into set to hold positive coefficients
while any(Z) & any(w(ZZ) > tol)
    [wt,t] = max(w(ZZ));
    t = ZZ(t);
    P(1,t) = t;
    Z(t) = 0;
    PP = find(P);
    ZZ = find(Z);
    nzz = size(ZZ);
    z(PP)=(Xty(PP)'/XtX(PP,PP)');
    z(ZZ) = zeros(nzz(2),nzz(1))';
    z=z(:);
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

x=x(:);