function map=PeakDetect(S,IaRange,IbRange,IcRange,IdRange,noiseRange,sn)


%% This script was originally written to detect potassium peaks. Therefore
%% it is specialized to find both peaks. If you are only interested in
%% detecting one peak, simpy enter that peak in twice and adjust the signal
%% to noise threshold accordingly

%% S is the stxm data structure
%% IaRange and IbRange are the energy ranges ([energy1, energy2] for peaks a and b.
%% IcRange and Id Range are the energy ranges ([energy1, energy2] of the
%% baseline directly before and after the peaks a and b respectively
%% noiseRange is the energy range (typically pre edge) over which the noise
%% will be calculated.
%% sn is the signal to noise ratio below which values of "map" will be set
%% to zero.

%% RC Moffet, 2010



stack=S.spectr;energy=S.eVenergy;particle=S.particle;
IaIdx=find(energy > IaRange(1) & energy < IaRange(2));  %% define first baseline point
IbIdx=find(energy > IbRange(1) & energy < IbRange(2));  %% second baseline point
IcIdx=round(mean(find(energy>=IcRange(1) & energy<=IcRange(2)))); %locate 1st K peak at 297.3 eV   
IdIdx=round(mean(find(energy>=IdRange(1) & energy<=IdRange(2)))); %locate 2nd K peak at 299.8 eV
if isempty(IaIdx) || isempty(IbIdx) || isempty(IcIdx) || isempty(IdIdx)
    disp('couldnt find one of the peaks!')
    map=zeros(size(stack(:,:,1)));
    return
end
noiseidx=find(energy>=noiseRange(1) & energy<=noiseRange(2));
Ia=mean(stack(:,:,IaIdx),3); %% intensities of points a, b, c, and d
Ib=mean(stack(:,:,IbIdx),3);
Ic=stack(:,:,IcIdx);
Id=stack(:,:,IdIdx);
m=(Ib-Ia)./(mean(energy(IbIdx))-mean(energy(IaIdx)));  %% slope of baseline
Ea=mean(energy(IaIdx)); %% energies of points a, c and d
Ec=mean(energy(IcIdx));
Ed=mean(energy(IdIdx));
Ie=m.*(Ec-Ea)+Ia;  %% intensities of baseline at Ec and Ed calculated by linear extrapolation 
If=m.*(Ed-Ea)+Ia;
map=(Ic-Ie)+(Id-If);
map(map<0)=0;
% map=medfilt2(map);%% difference map calculated by sum of baseline subtracted intensities
map(isnan(map))=0;
stdev=std(stack(:,:,noiseidx),0,3);
noisemat=map./stdev;
map(noisemat<sn)=0;
% DiffMap(:,:,2)=map; 
