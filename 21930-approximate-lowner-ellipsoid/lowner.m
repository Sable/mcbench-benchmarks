function [E c]=lowner(a,tol)
% LOWNER Approximate Lowner ellipsoid.
%   [E C]=LOWNER(A,TOL) finds an approximation of the Lowner ellipsoid
%   of the points in the columns of A.  The resulting ellipsoid satisfies
%       x=A-repmat(C,size(A,2)); all(dot(x,E*x)<=1)
%   and has a volume of approximately (1+TOL) times the minimum volume
%   ellipsoid satisfying the above requirement.
%
%   A must be real and non-degenerate.  TOL must be positive.
%
%   Usually you can get faster results by using only the points on
%   the convex hull, e.g.:
%       [E c]=lowner(a(:,unique(convhulln(a'))),tol)
%
%   Example:
%       a=randn(2,100);
%       [E c]=lowner(a,0.001);
%       t=linspace(0,2*pi);
%       [V D]=eig(E);
%       e=repmat(c,size(t))+V*diag(1./sqrt(diag(D)))*[cos(t);sin(t)];
%       plot(a(1,:),a(2,:),'+',e(1,:),e(2,:),'-')
%
%   Reference:
%       Khachiyan, Leonid G.  Rounding of Polytopes in the Real Number
%           Model of Computation.  Mathematics of Operations Research,
%           Vol. 21, No. 2 (May, 1996) pp. 307--320.

%   See also: KHACHIYAN

%   Author: Anye Li (li.anye.0@gmail.com)
%   October 28, 2008

%   November 1, 2008:   Updated Khachiyan.
%                       Added an example.
[n m]=size(a);
if n<1, error('Input must be in one dimension or higher.'); end
%   Find the Lowner ellipsoid of the centrally symmetric set lifted
%   to a hyperplane in a higher dimension.
F=khachiyan([a;ones(1,m)],tol);
%   Intersect with the hyperplane where the input points lie.
A=F(1:n,1:n); b=F(1:n,end);
c=-A\b; E=A/(1-c'*b-F(end));

% Force all the points to really be covered.
ac=a-repmat(c,1,m);
E=E/max(dot(ac,E*ac,1));

function E=khachiyan(a,tol)
% KHACHIYAN Approximate Lowner ellipsoid of a centrally symmetric set.
%   E=KHACHIYAN(A,TOL) finds an approximation of the Lowner ellipsoid
%   of the points in the columns of [A -A].  The resulting ellipsoid
%   satisfies
%       all(dot(A,E*A)<=1)
%   and has a volume of approximately (1+TOL) times the minimum volume
%   ellipsoid satisfying the above requirement.
%
%   A must be real and non-degenerate.  TOL must be positive.
%
%   Reference:
%       Khachiyan, Leonid G.  Rounding of Polytopes in the Real Number
%           Model of Computation.  Mathematics of Operations Research,
%           Vol. 21, No. 2 (May, 1996) pp. 307--320.
%
%   See also: LOWNER

%   Author: Anye Li (li.anye.0@gmail.com)
%   October 28, 2008

%   November 1, 2008: Made the update equations more efficient.
%                     Fixed misleading comments.
%                     Made more sure that the ellipsoid really covers the
%                       points even after roundoff errors.
[n m]=size(a);
if n<2, error('Input must be in two dimensions or higher.'); end
if ~isreal(a), error('Inputs must be real.'); end
if ~(isreal(tol) && tol>0)
    error('Tolerance must be positive.');
end
%   Initialize the barycentric coordinate descent.
invA=m*inv(a*a');
w=dot(a,invA*a,1);
%   Khachiyan's BCD algorithm for finding the Lowner ellipsoid of a
%   centrally symmetric set.
%   Refer to (2.7),(2.10),(2.18),(BCD), and the end of Lemma 4 for
%   the iteration used here.  The variable names are basically the
%   same, except f, g, and h which are common factors.
%   Read the paper if you want to actually understand how it works.
while 1
    [w_r r]=max(w);
    f=w_r/n; epsilon=f-1;
    if epsilon<=tol, break; end
    g=epsilon/((n-1)*f); h=1+g; g=g/f;
    b=invA*a(:,r); invA=h*invA-g*b*b';
    bTa=b'*a; w=h*w-g*(bTa.*bTa);
end
E=invA/w_r;
% Accumulated roundoff errors may cause the ellipsoid 
% to not quite cover all the points.
% Use
%   E=invA/max(dot(a,invA*a,1));
% if you don't like that.
