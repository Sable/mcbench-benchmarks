function InToCarbRatio=InorgMap1(S,Thresh,Mask)
%% Calculates the % sp2 of a stack (S.spectr) region specified by linidxin
%% S.spectr is the stack data aligned and converted to OD
%% linidxin is the linear index defining the region over which to determine
%% the % sp2
%% 081201 Ryan C. Moffet 

Spectr=S.spectr;
energy=S.eVenergy;
[prei]=find(energy > min(energy) & energy < 284);  %% Pre edge
[posi]=find(energy > 316);
if isempty(posi)
    disp('warning: scan does not go out to 320 eV \n will use max energy');
    posi=find(energy == max(energy));
end

preim=nanmean(Spectr(:,:,prei),3);
% preim(preim<Thresh)=0;
posim=nanmean(Spectr(:,:,posi),3);


InToCarbRatio=preim./posim;
InToCarbRatio=InToCarbRatio.*Mask;

