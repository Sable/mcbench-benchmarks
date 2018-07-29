function S=MultPartAvSpec(S,varargin)

%% This script loops over each particle and calculates an aveage spectrum.
%% The output goes in the stxm data structure, S.
%% RC Moffet, 2010

if length(varargin)==1
    nofig=1;
else
    nofig=0;
end

BinaryMap=S.LabelMat;
Spectr=S.spectr;Energy=S.eVenergy;

numofps=max(max(BinaryMap'));

%% Average Particle Spectra
junkmat=zeros(size(S.spectr(:,:,1)));
for i=1:numofps
    [k,l]=find(BinaryMap==i);
    loc=sub2ind(size(junkmat),k,l);
    for j=1:length(Energy)
        junkmat=Spectr(:,:,j);
        Partspec(j,i)=mean(mean(junkmat(loc)));
    end
    clear k,l;
end

% function [particle_spectra,locationMap,numofps,particleComposition,particleSVD,particleArea,label_Mat,particleComposition2] = particle_average(energy,matstruct,Xvalues,Yvalues)
if nofig==0
    figure('Name',S.particle,'NumberTitle','off')
    subnum=ceil(sqrt(numofps));
    
    for c=1:numofps
        subplot(subnum,subnum,c)
        plot(S.eVenergy,Partspec(:,c))
        plottitle=strcat(num2str(c),S.PartLabel{c});
        title(plottitle);
        ylim([min(Partspec(:,c)),max(Partspec(:,c))])
        xlim([min(Energy),max(Energy)])
        xpos=(max(Energy)-min(Energy))/10;
        ypos=0.9*max(Partspec(:,c));
        xlabel('Energy (eV)');
        ylabel('Optical Density');
    end
end
S.PartSpec=Partspec;

return
