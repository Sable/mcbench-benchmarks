
function S=OdStack(structin,method)
%function S=OdStack(structin,method)
%
%Automated STXM raw data to optical density (OD) conversion. 
%Particle regions are detected by a constant threshold condition or by using Otsu's thresholding algorithm. 
%Particle-free image zones are used to calculate the normalization intensity Izero
%by averaging the intensity data over the particle-free zones.
%R.C. Moffet, T.R. Henn February 2009
%
%Inputs
%------
%structin       aligned raw data stack structure array (typically the output of the 
%               FTAlignStack.m script).
%method         string defining the thresholding method:    -'O' thresholding using Otsu's method
%                                                           -'C' thresholding using a constant value 
%                                                                (98.5% of maximal intensity)
%
%Outputs
%-------
%S              structure array containing the OD converted STXM data


% create temporary variables
stack=structin.spectr;
eVlength=length(structin.eVenergy);

% construct the output struct
S=structin;
clear S.spectr;
S.spectr=zeros(size(structin.spectr,1),size(structin.spectr,2),size(structin.spectr,3));

% calculate imagesc limits
xAxislabel=[0,S.Xvalue];
yAxislabel=[0,S.Yvalue];

% particle masking & thresholding with constant threshold condition
if strcmp(method,'C')==1
    
    imagebuffer=mean(stack,3);
    imagebuffer=medfilt2(imagebuffer); % median filtering of the stack mean
    GrayImage=mat2gray(imagebuffer); % Turn into a greyscale with vals [0 1]
    Mask=zeros(size(GrayImage));
    Mask(GrayImage>=0.985)=1; % Detect particle free image regions
    
% particle masking & thresholding using Otsu's method
elseif strcmp(method,'O')==1
    
    imagebuffer=mean(stack,3);  %% Use average of all images in stack
    GrayImage=mat2gray(imagebuffer); %% Turn into a greyscale with vals [0 1]
    GrayImage=imadjust(GrayImage,[0 1],[0 1],15); %% increase contrast
    Thresh=graythresh(GrayImage); %% Otsu thresholding
    Mask=im2bw(GrayImage,Thresh); %% Give binary image
    
% Thresholding method not defined
else
    
    display('Error! No thresholding method defined! Input structure not converted!')
    return
    
end

% Izero extraction
Izero=zeros(eVlength,2);
Izero(:,1)=S.eVenergy;

% loop over energy range of stack, calculate average vor each energy -> return_spec
for cnt=1:eVlength
    
    buffer=stack(:,:,cnt);
    Izero(cnt,2)=mean(mean(buffer(Mask==1)));
    clear buffer
   
end

S.Izero=Izero;

% stack conversion Intensity --> Optical Density

for k=1:eVlength
        
        S.spectr(:,:,k)=-log(stack(:,:,k)/Izero(k,2));
        
end

%Plot results
figure
subplot(2,2,1)
imagesc(xAxislabel,yAxislabel,imagebuffer)
axis image
colorbar
title('Raw Intensity Stack Mean')
colormap gray
xlabel('X-Position (µm)','FontSize',11,'FontWeight','normal')
ylabel('Y-Position (µm)','FontSize',11,'FontWeight','normal')

subplot(2,2,2)
imagesc(xAxislabel,yAxislabel,mean(S.spectr,3));
axis image
colorbar
colormap gray
title('Optical Density Stack Mean')
xlabel('X-Position (µm)','FontSize',11,'FontWeight','normal')
ylabel('Y-Position (µm)','FontSize',11,'FontWeight','normal')


subplot(2,2,3)
imagesc(xAxislabel,yAxislabel,Mask)
colorbar
axis image
title('Izero Region Mask')
xlabel('X-Position (µm)','FontSize',11,'FontWeight','normal')
ylabel('Y-Position (µm)','FontSize',11,'FontWeight','normal')

subplot(2,2,4)
plot(Izero(:,1),Izero(:,2))
title('Izero')
xlabel('Photon energy (eV)','FontSize',11,'FontWeight','normal')
ylabel('Raw Counts','FontSize',11,'FontWeight','normal')

if length(S.eVenergy)>1
    xlim([min(S.eVenergy),max(S.eVenergy)])
    ylim([0.9*min(S.Izero(:,2)),(max(S.Izero(:,2))+0.1*min(Izero(:,2)))])
end

return