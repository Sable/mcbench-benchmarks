function [r,t,p,w]=spherequad(nr,nt,np,rad)

%SPHEREQUAD  Generate Gauss quadrature nodes and weights for numerically
% computing spherical volume integrals.
%
% [R,T,P,W]=SPHEREQUAD(NR,NT,NP,RAD) computes the product grid nodes in
% r, theta, and phi in spherical and the corresponding quadrature weights
% for a sphere of radius RAD>0. NR is the number of radial nodes, NT is
% the number of theta angle nodes in [0,pi], and NP is the number of phi 
% angle nodes in [0, 2*pi]. The sphere radius RAD can be set to infinity, 
% however, the functions to be integrated must decay exponentially with 
% radius to obtain a reasonable numerical approximation.
%
% Example 1: Infinite domain, theta independent
%
% f=@(R,T,P) exp(-R.^2.*(2+sin(P))); 
% [R,T,P,W]=spherequad(50,1,30,inf);
% Q=W'*f(R,T,P);
%
% Example 2: Sphere of radius 2, depends on all three
%
% f=@(R,T,P) sin(T.*R).*exp(-R.*sin(P));
% [R,T,P,W]=spherequad(24,24,24,2);
% Q=W'*f(R,T,P);
%
% Written by: Greg von Winckel - 04/13/2006
% Contact: gregvw(at)math(dot)unm(dot)edu 
% URL: http://www.math.unm.edu/~gregvw


[r,wr]=rquad(nr,2);         % radial weights and nodes (mapped Jacobi)

if rad==inf                 % infinite radius sphere
   
    wr=wr./(1-r).^4;        % singular map of sphere radius
    r=r./(1-r);
    
else                        % finite radius sphere
    
    wr=wr*rad^3;            % Scale sphere radius
    r=r*rad;
    
end

[x,wt]=rquad(nt,0); 
t=acos(2*x-1); wt=2*wt;     % theta weights and nodes (mapped Legendre)
p=2*pi*(0:np-1)'/np;        % phi nodes (Gauss-Fourier)
wp=2*pi*ones(np,1)/np;      % phi weights
[rr,tt,pp]=meshgrid(r,t,p); % Compute the product grid
r=rr(:); t=tt(:); p=pp(:);

w=reshape(reshape(wt*wr',nr*nt,1)*wp',nr*nt*np,1);


function [x,w]=rquad(N,k)

k1=k+1; k2=k+2; n=1:N;  nnk=2*n+k;
A=[k/k2 repmat(k^2,1,N)./(nnk.*(nnk+2))];
n=2:N; nnk=nnk(n);
B1=4*k1/(k2*k2*(k+3)); nk=n+k; nnk2=nnk.*nnk;
B=4*(n.*nk).^2./(nnk2.*nnk2-nnk2);
ab=[A' [(2^k1)/k1; B1; B']]; s=sqrt(ab(2:N,2));
[V,X]=eig(diag(ab(1:N,1),0)+diag(s,-1)+diag(s,1));
[X,I]=sort(diag(X));    
x=(X+1)/2; w=(1/2)^(k1)*ab(1,2)*V(1,I)'.^2;