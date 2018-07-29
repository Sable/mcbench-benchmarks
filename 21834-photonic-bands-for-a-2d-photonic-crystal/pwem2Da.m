%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% this program calculates and plots the photonic bands for a 2D photonic
%%% crystal consisting of cylinders with circular cross-section and
%%% infinite height, arranged in a triangular lattice; we consider in-plane propagation and 
%%% two independent polarization states: E-pol and H-pol (E-field and H-field are
%%% parallel to the cylinders, respectively); Fourier coefficients for the
%%% expansion of dielectric constant are calculated analytically; the
%%% materials considered here are dielectric and dispersionless;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% the package contains the following programs:
%%%     pwem2a.m - main program
%%%     epsgg.m - routine for calculating the matrix of Fourier coefficients
%%%                 of dielectric function
%%%     bz_irr1.m - routine for calculating the 'k-points' along the
%%%                 perimeter of irreducible Brillouin zone
%%%     kvect2.m - routine for calculating diagonal matrices with elements
%%%                 (kx+Gx) and (ky+Gy), where G=(Gx,Gy) is a reciprocal
%%%                 lattice vector
%%%     eigsEH.m - routine for solving the eigenvalue problems for E-pol
%%%                 and H-pol

%%% Author: Cazimir-Gabriel Bostan, 2008 (Bucharest, Romania)
%%%	http://cgbostan.evonet.ro
%%%	cgbostan@yahoo.com


clear all
tic

r=0.35; % radius of cylindrical holes (normalized w.r.t. lattice constant "a")
na=1; nb=3.45; % refractive indices ('na' for cylinders-atoms, 'nb' for background medium) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
No1=7; No2=No1; 
N1=2*No1+1; N2=2*No2+1;
N=N1*N2; % total number of plane waves used in Fourier expansions

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% primitive vectors of crystal lattice (normalized w.r.t. lattice constant "a")
% example considered here: triangular lattice
a1=[sqrt(3)/2, -1/2, 0]; a2=[sqrt(3)/2, 1/2, 0]; 
%%% area of primitive cell
ac=norm(cross(a1,a2)); 
%%% primitive vectors of reciprocal lattice (normalized w.r.t. lattice constant "2*pi/a"): b1=[1/sqrt(3),-1]; b2=[1/sqrt(3),1]; 
b1=(1/ac)*[a2(2),-a2(1)]; b2=(1/ac)*[-a1(2), a1(1)]; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% matrix of Fourier coefficients
eps1 = feval ('epsgg',r,na,nb,b1,b2,N1,N2); 

%%% discretization of Brillouin zone
Nr=10;
[BZx,BZy,kx,ky]=feval('bz_irr1',Nr);

%%% number of bands calculated
bands=10; 

%%% matrices to store the eigenvalues
omegaE=[]; omegaH=[];

for j=1:length(BZy)
    %%% diagonal matrices with elements (kx+Gx) si (ky+Gy)
    [kGx, kGy] = feval('kvect2',kx(j),ky(j),b1,b2,N1,N2);
    [omegaE(:,j), omegaH(:,j)]=feval('eigsEH',kGx,kGy,eps1,N,bands);
    display(sprintf('Calculation for k[%d] is finished',j));
end
for r=1:bands
    hold on;
    plot(BZy,omegaE(r,:),'r');
    plot(BZy,omegaH(r,:),'b:');
    title('Band diagram'); 
    xlabel('ky');
    ylabel('\omega');
end  

toc



