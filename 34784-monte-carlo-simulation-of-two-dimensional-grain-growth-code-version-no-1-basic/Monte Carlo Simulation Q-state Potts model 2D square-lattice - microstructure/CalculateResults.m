function [TotalEnergy1MCS,AGS]=CalculateResults(mcs,x,y,state,Energy)

TotalEnergy1MCS(1,mcs)=sum(sum(Energy(:,:,mcs)));
AGS(mcs) = AverageGrainSize(state,x,y);