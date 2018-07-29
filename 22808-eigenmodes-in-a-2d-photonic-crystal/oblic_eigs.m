%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% this function solves the eigenvalue problem beta=f(omega,epsi,kx,ky) for
%%% a 2D-PhC ; propagation is oblique, 'beta' is the vertical component of wavevector;
%%% the eigenvectors are column vectors of H-field Fourier coefficients P=(hx, hy)'
%%% the output is the sqrt of eigenvalues
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [P, beta]=oblic_eigs(omega,kGx,kGy,epsi,N)

eta=inv(epsi); 
E=[epsi zeros(N); zeros(N) epsi];
K=[kGx*kGx, kGx*kGy; kGy*kGx, kGy*kGy];
B=[kGy*eta*kGy, -kGy*eta*kGx;-kGx*eta*kGy, kGx*eta*kGx];
A=E*(omega^2*eye(2*N)-B)-K; 

[P,D]=eig(A); % eigenvalue problem A*Phi=D*Phi
beta=sqrt(diag(D));

