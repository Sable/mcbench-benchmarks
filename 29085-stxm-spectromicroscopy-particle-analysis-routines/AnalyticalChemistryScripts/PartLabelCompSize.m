function S=PartLabelCompSize(S,varargin)

%% PartLabel Assigns particle labels to particles 
%% based on features in the carbon edge spectrum. Note that DiffMaps.m must
%% be run on S prior to execution of this function.
%% OUTPUT NOTES:
%% S.CompSize is a matrix of areas for each component with particles in the
%% rows and components in the columns. the components are ordered as
%% follows: ['OCArea','InArea','Sp2Area','KArea','CO3Area','Total Area']

%% 081201 Ryan C. Moffet

if isempty(S.DiffMap)
    return
end
figsav=0;
particle=S.particle;
if ~isempty(varargin)
    rootdir=varargin{1};
    sample=varargin{2};
    figsav=1;
end
ColorVec=[0,170,0;0,255,255;255,0,0;255,170,0;255,255,255]; %% rgb colors of the different components

MatSiz=size(S.DiffMap(:,:,1));
RgbMat=zeros([MatSiz,3]);
RedMat=zeros(MatSiz);
GreMat=zeros(MatSiz);
BluMat=zeros(MatSiz);

cnt=1;

for i=[5,1,3,2,4]; %% cooh, In, sp2, K, co3 
        GrayImage=mat2gray(S.DiffMap(:,:,i)); %% Turn into a greyscale with vals [0 1]
        GrayImage=imadjust(GrayImage,[0 1],[0 1],0.1); %% increase contrast
%         GrayImage=medfilt2(GrayImage);  %% something weird was happening
                                          % %to the pixels on the corner
        Thresh=graythresh(GrayImage); %% Otsu thresholding
        Mask=im2bw(GrayImage,Thresh); %% Give binary image
        BinCompMap{cnt}=bwlabel(Mask,8);
        cnt=cnt+1;
end

% [j,k]=find(BinCompMap{3}>0); %% find index of >0 components
% [l,m]=find(S.LabelMat>0);
% S.BinCompMap=BinCompMap;
% if ~isempty(j) || ~isempty(k)
%     [orgspec]=ComponentSpec(S,'COOH');
%     [inorgspec]=ComponentSpec(S,'Inorg');
%     [ecspec]=ComponentSpec(S,'sp2');
%     ecspec(:,2)=ecspec(:,2)-mean(ecspec(1:8,2));
%     svdM = stackSVD(S,ecspec,orgspec,inorgspec);
%     svdM(svdM<0)=0;
%     figure,imagesc(svdM(:,:,1)),colormap gray, colorbar
%     BinCompMap{3}=threshimage(svdM(:,:,1));
% end
% 
%% This first loop creates masks for the individual components over the
%% entire field of view. Each component is then defined as a colored
%% component for visualization.
cnt=1;
for i=[5,1,3,2,4]%i=[5,1,2,3] %% loop over chemical components
%         GrayImage=mat2gray(S.DiffMap(:,:,i)); %% Turn into a greyscale with vals [0 1]
%         GrayImage=imadjust(GrayImage,[0 1],[0 1],0.1); %% increase contrast
% %         GrayImage=medfilt2(GrayImage);  %% something weird was happening
%                                           % %to the pixels on the corner
%         Thresh=graythresh(GrayImage); %% Otsu thresholding
%         Mask=im2bw(GrayImage,Thresh); %% Give binary image
%         BinCompMap{cnt}=bwlabel(Mask,8);
%     end
    [j,k]=find(BinCompMap{cnt}>0); %% find index of >0 components
    [l,m]=find(S.LabelMat>0);
    if ~isempty(j) || ~isempty(k)  %% this conditional defines a color for the component areas (if it exists)
        linidx=sub2ind(size(BinCompMap{cnt}),j,k); %% change to linear in dex
        labidx=sub2ind(size(BinCompMap{cnt}),l,m);
        rejidx=setdiff(linidx,labidx);
        BinCompMap{cnt}(rejidx)=0;
        linidx=sub2ind(size(BinCompMap{cnt}),find(BinCompMap{cnt}>0));
        RedMat(linidx)=ColorVec(cnt,1); %% define the color for the ith component
        GreMat(linidx)=ColorVec(cnt,2);
        BluMat(linidx)=ColorVec(cnt,3);
        trmat=zeros(size(RedMat));
        tgmat=zeros(size(RedMat));
        tbmat=zeros(size(RedMat));
        trmat(linidx)=ColorVec(cnt,1);
        tgmat(linidx)=ColorVec(cnt,2);
        tbmat(linidx)=ColorVec(cnt,3);
        ccmap{cnt}(:,:,1)=trmat;
        ccmap{cnt}(:,:,2)=tgmat;
        ccmap{cnt}(:,:,3)=tbmat;
        clear trmat tgmat tbmat
    else
        ccmap{cnt}=zeros(MatSiz(1),MatSiz(2),3);
    end
    cnt=cnt+1;  %% this counter keeps track of the indivdual components.
    clear j k l m linidx GrayImage Thresh Mask rejidx;
end

%% This second loop assigns labels over individual particles defined
%% previously in Diffmaps.m
NumPart=max(max(S.LabelMat));
% LabelStr={'OC','In','K','EC'};
LabelStr={'OC','In','EC','K','CO3'};

CompSize=zeros(NumPart,length(LabelStr)+1);
PartLabel={};
for i=1:NumPart  %% Loop over particles defined in Diffmaps.m
    PartLabel{i}='';
    for j=1:5  %% Loop over chemical components
        [a1,b1]=find(S.LabelMat==i);  %% get particle i
        [a2,b2]=find(BinCompMap{j}>0); %% get component j
        if ~isempty([a1,b1]) && ~isempty([a2,b2])
            linidx1=sub2ind(size(S.LabelMat),a1,b1); %% Linear index for particle
            linidx2=sub2ind(size(BinCompMap{j}),a2,b2); %% Linear index for component
            IdxCom=intersect(linidx1,linidx2); %% find common indices
            if length(IdxCom)>3%0.05*length(linidx1) %% if component makes up greater than 2% of the pixels of the particle...
                    PartLabel{i}=strcat(PartLabel{i},LabelStr{j}); %% give label of component.
                    CompSize(i,j)=length(IdxCom); %% number of pixels in the component.
            end
        end
    end
    if isempty(PartLabel{i})
        PartLabel{i}='NoID'; %% Particles identified by Otsu's mehod here but not in Particle map script
    end
    CompSize(i,j+1)=length(linidx1);  %% number of pixels in the particle
    clear linidx1 linidx2 IdxCom a1 b1 a2 b2;
end
if isempty(PartLabel)
    S.PartLabel='NoID';
else
    S.PartLabel=PartLabel;
end
S=ParticleSize(S);

MatSiz=size(S.LabelMat);
XSiz=S.Xvalue/MatSiz(1);
YSiz=S.Yvalue/MatSiz(2);
CompSize=CompSize.*(XSiz*YSiz); %% Area of components in um^2
S.CompSize=CompSize;
    
RgbMat(:,:,1)=RedMat;
RgbMat(:,:,2)=GreMat;
RgbMat(:,:,3)=BluMat;
S.RGBCompMap=RgbMat;
for i=1:length(BinCompMap)
    temp{i}=BinCompMap{i};
    temp{i}(temp{i}>1)=1;
end
xdat=[0:XSiz:S.Xvalue];
ydat=[0:YSiz:S.Yvalue];

% Show DiffMaps
figure('Name',particle,'NumberTitle','off','Position',[1,1,634,872])
subplot(3,2,1)
% imagesc(temp{1})
image(xdat,ydat,uint8(ccmap{1}))
title('Carbox')
axis image
xlabel('X (\mum)');
ylabel('Y (\mum)'); 

subplot(3,2,2)
% imagesc(temp{2})
image(xdat,ydat,uint8(ccmap{2}))
title('Inorg.')
axis image
xlabel('X (\mum)');
ylabel('Y (\mum)'); 

subplot(3,2,3)
% imagesc(temp{3})
image(xdat,ydat,uint8(ccmap{3}))
title('%sp2>35')
axis image
xlabel('X (\mum)');
ylabel('Y (\mum)'); 

subplot(3,2,4)
% imagesc(temp{4})
image(xdat,ydat,uint8(ccmap{4}))
title('Potassium')
axis image
xlabel('X (\mum)');
ylabel('Y (\mum)'); 

% LabelMat=raw2mask(S);
subplot(3,2,5)
image(xdat,ydat,uint8(ccmap{5}))
title('CO_{3}')
axis image
xlabel('X (\mum)');
ylabel('Y (\mum)'); 

% title('Particle Map')
% axis image

subplot(3,2,6)
image(xdat,ydat,uint8(RgbMat))
title('Mixed')
axis image
xlabel('X (\mum)');
ylabel('Y (\mum)'); 

if figsav==1
filename=sprintf('%s%s%s%s',rootdir,sample,particle,'_f2_thresh');
saveas(gcf,filename,'tiff');
end
S.BinCompMap=temp;
S=MultPartAvSpec(S);
if figsav==1
filename=sprintf('%s%s%s%s',rootdir,sample,particle,'_f3_spec');
saveas(gcf,filename,'tiff');
close all
end
