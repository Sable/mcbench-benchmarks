function [x,y,z,Energy,TotalEnergy1MCS,ColorMatrix] = InitializeMatrices_3D_QPOTTS(NoLatticePoints,Q,MonteCarloSteps)

x=zeros(NoLatticePoints,NoLatticePoints,NoLatticePoints);y=x;z=x;
Energy=x;
TotalEnergy1MCS=zeros(1,MonteCarloSteps);
ColorMatrix=rand(Q,3);