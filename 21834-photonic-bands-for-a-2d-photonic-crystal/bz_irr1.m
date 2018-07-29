%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% discretization of irreducible Brillouin zone boundary (perimeter); here, example
%%% for triangular lattice
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [BZx,BZy,kx,ky]=bz_irr1(Nr)
% Nr is an even number of discretization points
ky_GM=linspace(1e-4,1/2,Nr); kx_GM=-ky_GM/sqrt(3);
% less points along MK
ky_MK=linspace(1/2,2/3,0.5*Nr); kx_MK=sqrt(3)*(ky_MK-2/3);
ky_KG=linspace(2/3,1e-4,Nr); kx_KG=zeros(1,Nr);
ky = [ky_GM, ky_MK, ky_KG]; 
kx = [kx_GM, kx_MK, kx_KG];
% shift ky_KG for plotting
BZy = [ky_GM, ky_MK, (4/3)*ones(1,Nr)-ky_KG]; 
BZx = kx;