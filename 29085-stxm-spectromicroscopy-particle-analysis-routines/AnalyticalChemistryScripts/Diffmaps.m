function S = Diffmaps(S,varargin)

%% S = Diffmaps(S)
%% Returns component maps in S.DiffMap
%% S.DiffMap contains an m by n by j matrix with m and n being the x and
%% y pixel values, and j being the jth component map
%%
%% Stacks must be imported, aligned and converted to OD using ProcDir.m and
%% AlignOD.m 
%%
%% COMPONENTS: 
%% j=1 -- inorganic
%% j=2 -- potassium
%% j=3 -- sp2
%% j=4 -- CO3
%% j=5 -- carboxylic acid
%%
%% Example input
%% S = 
%% 
%%     eVenergy: [95x1 double]
%%       Xvalue: 4
%%       Yvalue: 4
%%       spectr: [67x67x95 double]  %% this is stack data!
%%     particle: '70202041'
%% 
if isempty(varargin)
    spThresh=0.35;
    figsav=0;
elseif length(varargin)==1
    spThresh=varargin{1};
    figsav=0;
elseif length(varargin)==3
    spThresh=varargin{1};
    figsav=1;
    rootdir=varargin{2};
    sample=varargin{3};
end

stack=S.spectr;energy=S.eVenergy;particle=S.particle;

DiffMap=zeros(size(stack,1),size(stack,2),5);

peakregion1=find(energy > min(energy) & energy < 283);  %% Pre edge
if isempty(peakregion1) 
    S.DiffMap=[];
    S.LabelMat=[];
    beep
    disp('This isnt the carbon edge');
    return
end

%% map inorganics
Preedge=mean(stack(:,:,peakregion1),3); %% compute average.
Preedge(Preedge==Inf)=0;
DetectThresh=3*mean(mean(std(stack(:,:,peakregion1),0,3)));
DiffMap(:,:,1)=ConstThresh(Preedge,DetectThresh);
DiffMap(:,:,1)=InorgMap1(S,DetectThresh,DiffMap(:,:,1));
Inorg=DiffMap(:,:,1);
DiffMap(DiffMap<.5 | DiffMap==NaN | DiffMap==Inf)=0;
DiffMap(:,:,1)=medfilt2(DiffMap(:,:,1));

postidx=find(energy > 315 & energy < 320);
postedge=mean(stack(:,:,postidx),3);


%% Potassium Map
% IaIdx=find(energy > 294 & energy < 295);  %% define first baseline point
IbIdx=find(energy > 302 & energy < 305);  %% second baseline point
DiffMap(:,:,2)=PeakDetect(S,[294,295],[302,305],[296.1,298.1],[298.6,301],[292,296],3);
DiffMap(:,:,2)=medfilt2(DiffMap(:,:,2));

%% 285 eV sp2 peak Minus post edge Map
ECpeakpos=find(energy > 284.75 & energy < 285.9);
Tmp=PeakDetect(S,[energy(1),energy(1)+1],[282,283],...
    [284.75,285.9],[284.75,285.9],[energy(1),283],6);
da=diff(stack(:,:,peakregion1),1,3);
de=diff(energy(peakregion1));
dade=zeros(size(stack(:,:,peakregion1)));
for i=1:length(de)
    dade(:,:,i)=da(:,:,i)./de(i);
end
avdade=mean(dade,3);
newstack=stack;
dep=diff(energy);
% calculate y intercept of preedge
for i=1:length(peakregion1)
    b(:,:,i)=stack(:,:,i)-avdade.*energy(i);
end
avb=mean(b,3);
% subtract linear preedge obtained above
for i=1:length(energy)
    newstack(:,:,i)=stack(:,:,i)-(avdade.*energy(i)+avb);
end

Tot = [280,310];
CCPeak = [284,287];
totidx=find(energy > Tot(1) & energy < Tot(2));
CCidx=find(energy > CCPeak(1) & energy < CCPeak(2));
Atot=trapz(energy(totidx),newstack(:,:,totidx),3);
ACC=trapz(energy(CCidx),newstack(:,:,CCidx),3);
sp2out=ACC./Atot.*8.6;
sp2out=medfilt2(sp2out.*Tmp);
sp2out(sp2out>1)=1;
sp2out(sp2out<0)=0;  %% sp2out is what is shown in the plot
Tmp=sp2out;



Tmp(Tmp<spThresh)=0; %% threshold map for output into partlabel.
DiffMap(:,:,3)=Tmp;
DiffMap(DiffMap(:,:,3)<0 | DiffMap(:,:,3)==NaN)=0;

% Post Edge Minus Pre Edge Map (total carbon)

% DiffMap(:,:,4)=medfilt2(negfilter(postedge(:,:)-Preedge));
% T.DiffMap=DiffMap;

%% CO3 Map

% DiffMap(:,:,4)=PeakDetect(S,[289.3,289.8],[291.1,292.5],...
%     [290.1,290.6],[290.1,290.6],[291.6,293.5]);
DiffMap(:,:,4)=PeakDetect(S,[289.3,289.8],[291.1,292.5],...
    [290.1,290.6],[290.1,290.6],[energy(1),283],6);
DiffMap(:,:,4)=medfilt2(DiffMap(:,:,4));
%% carboxylic map
CarbxIdx=find(energy > 288 & energy < 289);  %% define first baseline point
ICarbx=mean(stack(:,:,IbIdx),3);
ICarbx(ICarbx<DetectThresh)=0;
DiffMap(:,:,5)=ICarbx-Preedge;
tmp=DiffMap(:,:,5);
tmp(tmp<0 | isnan(tmp))=0;
tmp=medfilt2(tmp);
DiffMap(:,:,5)=tmp;

MatSiz=size(S.spectr);
XSiz=S.Xvalue/MatSiz(1);
YSiz=S.Yvalue/MatSiz(2);
xdat=[0:XSiz:S.Xvalue];
ydat=[0:YSiz:S.Yvalue];

%% Show DiffMaps
figure1=figure('Name',particle,'NumberTitle','off','Position',[1,1,715,869]);
title(sprintf(S.particle));
subplot(3,2,1)
plotIn=DiffMap(:,:,1);
plotIn(plotIn>3)=3;
imagesc(xdat,ydat,plotIn)
axis image
title('Inorganic')
colorbar
xlabel('X (\mum)');
ylabel('Y (\mum)'); 

subplot(3,2,2)
imagesc(xdat,ydat,DiffMap(:,:,2))
axis image
title('Potassium')
colorbar
xlabel('X (\mum)');
ylabel('Y (\mum)'); 


subplot(3,2,3)
% imagesc(xdat,ydat,DiffMap(:,:,3))
imagesc(xdat,ydat,sp2out)
axis image
title('Sp^{2}')
colorbar
xlabel('X (\mum)');
ylabel('Y (\mum)'); 


subplot(3,2,4)
imagesc(xdat,ydat,DiffMap(:,:,5))
axis image
% colormap('gray')
title('Carbox')
colorbar
xlabel('X (\mum)');
ylabel('Y (\mum)'); 


subplot(3,2,5)
imagesc(xdat,ydat,DiffMap(:,:,4))
axis image
title('CO_{3}')
colorbar
xlabel('X (\mum)');
ylabel('Y (\mum)'); 

subplot(3,2,6)

PartIm=DiffMap(:,:,5)+Preedge+DiffMap(:,:,3);
LabelMat=raw2mask(S);
title('Particle Map')
colorbar
axis image
xlabel('X (\mum)');
ylabel('Y (\mum)'); 

if figsav==1
filename=sprintf('%s%s%s%s',rootdir,sample,S.particle,'_f1_map');
saveas(gcf,filename,'tiff');
end


S=S;
S.DiffMap=DiffMap;
S.LabelMat=LabelMat;