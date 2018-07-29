function [X,Y,Z,W]=tetraquad(N,vert)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% tetraquad.m - Gaussian Quadrature for a tetrahedron
%
% Construct Gauss points and weights for a tetrahedral domain with vertices
% specified by the 4x3 matrix vert. Where each row contains the (x,y,z) for 
% a vertex.
%
% Sample usage: 
%
% Suppose f(x,y,z)=x^2+y^2+z^2. Then let's integrate this over a regular
% tetrahedron.
%
% >>vert=[1/sqrt(3) 0 0; -sqrt(3)/6,1/2,0;-sqrt(3)/6,-1/2,0;0 0 sqrt(6)/3];
% >>[X,Y,Z,W]=tetraquad(4,vert);
% >>F=X.^2+Y.^2+Z.^2;
% >>Q=W'*F;
%
% Written by: Greg von Winckel  
% Contact: gregvw(at)math(dot)unm(dot)edu
% http://math.unm.edu/~gregvw
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[q1,w1]=rquad(N,2); [q2,w2]=rquad(N,1);  [q3,w3]=rquad(N,0);
[q1,q2,q3]=meshgrid(q1,q2,q3);
q1=q1(:);   q2=q2(:);       q3=q3(:);
x=1-q1;     y=(1-q2).*q1;   z=q1.*q2.*q3;
w=reshape(reshape(w2*w1',N^2,1)*w3',N^3,1);
c=[1 0 0 0;-1 1 0 0;-1 0 1 0;-1 0 0 1]*vert;
W=abs(det(c(2:4,:)))*w;

% Change of coordinates 
XYZ=[ones(N^3,1) x y z]*c; X=XYZ(:,1); Y=XYZ(:,2); Z=XYZ(:,3);
 
function [x,w]=rquad(N,k)

k1=k+1; k2=k+2; 
n=1:N;  nnk=2*n+k;
A=[k/k2 repmat(k^2,1,N)./(nnk.*(nnk+2))];
n=2:N; nnk=nnk(n);
B1=4*k1/(k2*k2*(k+3)); nk=n+k; nnk2=nnk.*nnk;
B=4*(n.*nk).^2./(nnk2.*nnk2-nnk2);
ab=[A' [(2^k1)/k1; B1; B']]; s=sqrt(ab(2:N,2));
[V,X]=eig(diag(ab(1:N,1),0)+diag(s,-1)+diag(s,1));
[X,I]=sort(diag(X));    

% Grid points
x=(X+1)/2; 

% Quadrature weights
w=(1/2)^(k1)*ab(1,2)*V(1,I)'.^2;