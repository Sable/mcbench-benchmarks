function [i,j,k] = PickRandomLatticeSite_3D_QPOTTS(x,y,z)
Sx = size(x,1);
i=floor(1+rand*Sx);
j=floor(1+rand*Sx);
k=floor(1+rand*Sx);