function [specout,npix]=ComponentSpec(Sin,comp)

%% uses maps to isolate regions of interest to extract a spectrum.
%% Sin.DiffMaps have a m by n by j structure with m and n being the 
%% spatial dimensions and j being the compoenent maps
%%
%% j=1 -- COOH
%% j=2 -- inorganic
%% j=3 -- potassium
%% j=4 -- sp2
%% j=5 -- CO3
%%
%% specout is the output spectrum of the form [energies,OD]
%% RC Moffet, 2010

Energy=Sin.eVenergy;
Spectr=Sin.spectr;

%% setup flags for isolating ROIs. 

if strcmp('COOH',comp)==1
    cmp=1;                    %% sets the cmponent of interest
    exclude=[3,4,5];          %% sets the regions to exclude\
    %%exclude=[2,3,4,5];          %% sets the regions to exclude
elseif strcmp('Inorg',comp)==1
    cmp=2;
    exclude=[3,4,5];
elseif strcmp('K',comp)==1
    cmp=3;
    exclude=[];
elseif strcmp('sp2',comp)==1
    cmp=3;
    exclude=[];
     exclude=[2,4];
elseif strcmp('co3',comp)==1
    cmp=5;
    exclude=[];
end
cnt=1;


%% Intersect component maps and exclude overlapping pixels
for i = 1:length(Sin.BinCompMap)
    [j,k]=find(Sin.BinCompMap{i}>0);
    linidx{i}=sub2ind(size(Sin.BinCompMap{i}),j,k);
end


overlapidx=[];
cmpidx=[];
crap=zeros(size(Sin.BinCompMap{1}));

if isempty(exclude)
    if length(cmp)==1
    cmpidx=linidx{cmp};
    else
        for i=1:length(cmp)
            cmpidx=union(cmpidx,linidx{i});
        end
    end
else
    for i=exclude
        if i==cmp || isempty(linidx{i}) || i==6
            continue
        else
            tidx=intersect(linidx{cmp},linidx{i});
%             it=crap;
%             it(tidx)=1;
%             figure, imagesc(it);
            overlapidx=[overlapidx;tidx];
        end
        clear tidx
    end
    cmpidx=setdiff(linidx{cmp},overlapidx); %% exclude pixels overlapping with other components
%     i1=crap;
%     i2=crap;
%     i3=crap;
%     i1(linidx{cmp})=1;
%     i2(cmpidx)=1;
%     figure,imagesc(i1);
%     figure,imagesc(i2);
end
%% plot spectrum and binary map
for j=1:length(Energy)
    junkmat=Spectr(:,:,j);
    Partspec(j)=mean(mean(junkmat(cmpidx)));
end

map=zeros(size(Sin.BinCompMap{1}));
map(cmpidx)=1;

h=figure,
subplot(1,2,1)
plot(Energy,Partspec,'LineWidth',3);
title(gca,sprintf('%s Spectrum',comp),'FontSize',28);
xlabel('Energy (eV)','FontSize',24);
ylabel('OD','FontSize',24)
set(gca,'FontSize',18)
xlim([min(Energy),max(Energy)]);
if isempty(Partspec) | isnan(Partspec)
    ymax=1;
else
    ymax=abs(max(Partspec));
end
ylim([0,ymax])
subplot(1,2,2)
imagesc(map)
colormap('bone')
axis image
title(gca,sprintf('%s Regions',comp),'FontSize',28);
set(h,'Position',[1,1,1013,639]);
%% Return output
specout=[Energy,Partspec'];
npix=length(cmpidx);
