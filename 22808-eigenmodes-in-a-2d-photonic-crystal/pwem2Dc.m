%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% consider a 2D photonic crystal consisting of cylinders with circular cross-section and
%%% infinite height, arranged in a triangular lattice; 
%%% this program calculates and plots the spatial distributions in the unit cell (E&H) of
%%% eigenmodes allowed at a given frequency ; 'omega'is taken as input; 
%%% oblique propagation is implicit, so the polarization states cannot be
%%% separated in E-pol and H-pol;
%%% Fourier coefficients for the expansion of dielectric constant are calculated analytically; 
%%% the materials considered here are dielectric and dispersionless;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% the package contains the following programs:
%%%     pwem2Dc.m - main program
%%%     epsgg.m - routine for calculating the matrix of Fourier coefficients
%%%                 of dielectric function
%%%     prcellgrid.m - routine for discretization of direct space, to be used for plotting the field
%%%                  distribution
%%%     kvect2.m - routine for calculating diagonal matrices with elements
%%%                 (kx+Gx) and (ky+Gy), where G=(Gx,Gy) is a reciprocal
%%%                 lattice vector
%%%     oblic_eigs.m - routine for solving the eigenvalue problem for
%%%                     H-field
%%%     rfields.m - routine for calculation of field spatial distributions

%%% Author: Cazimir-Gabriel Bostan, 2008 (Bucharest, Romania)
%%%	http://cgbostan.evonet.ro
%%%	cgbostan@yahoo.com

clear all
tic

omega=0.45; % normalized frequency "a/lambda"

r=0.43; % radius of cylindrical holes (normalized w.r.t. lattice constant "a")
na=1; nb=3.45; % refractive indices (cylinders-atoms, background) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
No1=7; No2=No1; 
N1=2*No1+1; N2=2*No2+1;
N=N1*N2; % total number of plane waves used in Fourier expansions

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% primitive vectors of direct lattice (normalized w.r.t. lattice constant "a")
a1=[sqrt(3)/2, -1/2, 0]; a2=[sqrt(3)/2, 1/2, 0]; 
%%% area of primitive cell
ac=norm(cross(a1,a2)); 
%%% primitive vectors of direct lattice (normalized w.r.t. lattice constant "2*pi/a"): b1=[1/sqrt(3),-1]; b2=[1/sqrt(3),1]; 
b1=(1/ac)*[a2(2),-a2(1)]; b2=(1/ac)*[-a1(2), a1(1)]; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% matrix of Fourier coefficients
eps1 = feval ('epsgg',r,na,nb,b1,b2,N1,N2); 
eta=inv(eps1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Brillouin zone edges
% kx=1e-4; ky=1e-4; % Gamma
% kx=1e-4; ky=2/3; % M
kx=-.5/sqrt(3); ky=.5; % K
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[X,Y,Xi,Yi]=feval('prcellgrid',a1,a2,N1,N2);

%%% diagonal matrices with elements (kx+Gx) si (ky+Gy)
[kGx, kGy] = feval('kvect2',kx,ky,b1,b2,N1,N2);

[P, beta]=feval('oblic_eigs',omega,kGx,kGy,eps1,N);
L=imag(beta)==0;
P=P(:,L);
[kz,I]=sort(beta(L)); %%% keep only the propagative modes (real eigenvalues) and sort them in ascending order
Phi=[]; % this will contain the eigenvectors corresponding to eigenvalues sorted in ascending order 

for j=1:length(kz)
    Phi(:,j)=P(:,I(j));
end

for u=1:length(kz)
    [Ex,Ey,Ez,Hx,Hy,Hz] = feval('rfields', omega,eta,kGx,kGy,kz,Phi,N1,N2,u);
    E=(Ex+Ey+Ez).*exp(i*2*pi*(kx*X+ky*Y));
    Ei=griddata(X,Y,E,Xi,Yi);
    modEi=abs(Ei); 
    figure
    subplot(2,1,1)
    mesh (Xi, Yi, modEi); view(2); title(sprintf('E-field for omega=%0.5g, kz=%0.5g',omega, kz(u)))
    H=(Hx+Hy+Hz).*exp(i*2*pi*(kx*X+ky*Y));
    Hi=griddata(X,Y,H,Xi,Yi);
    modHi=abs(Hi);
    subplot(2,1,2)
    mesh (Xi, Yi, modHi); view(2); title(sprintf('H-field for omega=%0.5g, kz=%0.5g',omega, kz(u)))
end




toc



