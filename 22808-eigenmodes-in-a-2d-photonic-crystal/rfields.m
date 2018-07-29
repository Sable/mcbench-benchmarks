%%%% calculation of field spatial distributions, starting from the eigenvectors (Fourier coefficients)
%%%% omega = normalized frequency
%%%% eta = inverse of matrix containing the Fourier coeff. of dielectric
%%%% function
%%%% Phi = matrix of column eigenvectors [hx,hy]'
%%%% kz = vector of real eigenvalues
%%%% u = index of selected eigenvalue/eigenvector
function [Ex,Ey,Ez,Hx,Hy,Hz] = rfields(omega,eta,kGx,kGy,kz,Phi,N1,N2,u)
N=N1*N2;
hx=Phi(1:N,u); hy=Phi((N+1):2*N,u); 
hz=-(1/kz(u))*(kGx*hx+kGy*hy);
ex=-(1/omega)*eta*(kGy*hz-kz(u)*hy); 
ey=-(1/omega)*eta*(kz(u)*hx-kGx*hz); 
ez=-(1/omega)*eta*(kGx*hy-kGy*hx); 

ex=reshape(ex,N1,N2); ey=reshape(ey,N1,N2); ez=reshape(ez,N1,N2); 
hx=reshape(hx,N1,N2); hy=reshape(hy,N1,N2); hz=reshape(hz,N1,N2);
Ex=(N1*N2)*ifft2(ifftshift(ex')); 
Ey=(N1*N2)*ifft2(ifftshift(ey'));
Ez=(N1*N2)*ifft2(ifftshift(ez')); 

Hx=(N1*N2)*ifft2(ifftshift(hx')); 
Hy=(N1*N2)*ifft2(ifftshift(hy')); 
Hz=(N1*N2)*ifft2(ifftshift(hz'));
