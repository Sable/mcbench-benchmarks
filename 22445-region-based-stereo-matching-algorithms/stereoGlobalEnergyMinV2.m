%*******************************************************************
% Region Based Stereo Matching Algorithm by Global Error Energy
% Minimization by Smoothing Functions method explanied in  the 
% "Obtaining Depth Maps From Color Images By Region Based Stereo
% Matching Algorithms"
% 
% It uses stereo color image pairs. Right camera image is loaded into XR array
% and left camera image is loaded into XL array. You can set Disparity search 
% range by dmax.
% 
%
% Programmer: B. Baykant ALAGÖZ
% Ver.2.0 date: 04.2011
%******************************************************************

clear all
tic
%User can set DisparityRange and matching variable.
%You can set upper bound of disparity search range by dmax
dmax=40;
%Set window size in error energy calculation.
%windowSize: [sizeRow sizeCol]
% Note: set odd numbers for sizeRow and sizeCol such as 1 3 5 ...
%For point by point enegy, set windowSize=[1 1]
%For line window with the length of 3, set windowSize=[1 3]
%For square window with the size of 3x3, set windowSize=[3 3]

windowSize=[3 3]; % give odd number for window size such as 3 5 7

% Parameter setting for iterative averaging filtering
averagWindowSize=[5 5];%give odd number for window size such as 3 5 7
numberOfIteration=5;

% Alfa tolerance coefficient for eliminating unreliable estimation
Alfa=2;

% Stereo Camera System Parameter for dept map calcualtion
% foc: focal length of cameras in unit of cm
foc=30;
% T: distance between stereo camera pair in unit of cm
T=10;
%Loading Right image to XR and Left iamage to XL
[XRs,MAP] = imread('view5m.png');
[XLs,MAP] = imread('view1m.png');
XR = imresize(XRs,1);
XL = imresize(XLs,1);

%------------------ END of USER SETTINGS----------------------

% auto-presettings for the program
[m n p]=size(XR);
Edis=(1e+6)*ones(m,n);
disparity=zeros(m,n);
XR=double(XR);
XL=double(XL);

% process by increasing disparity
for d=0:dmax
    fprintf ('Computing for disparity: %d\n',d);
% composing error energy matrix for every disparity.(Algorithm step:1)

if p==3
    [ErrorEnergy]=windowSSE(XR,XL,windowSize,d);
else
    Disp('ERROR WARNING: Use RGB color image for stereo pair');
end

% applying smooting on error energy surfaces by iterative averaging
% filtering. (Algorithm step:2)
ErrorEnergyFilt=IterativeAveragingFilter(ErrorEnergy,numberOfIteration,averagWindowSize);

% selecting disparity which has minimum error energy.(Algorithm step:3)
[m1 n1]=size(ErrorEnergyFilt);
for k=1:m1
    for l=1:n1
       if Edis(k,l)>ErrorEnergyFilt(k,l)
            disparity(k,l)=d;
            Edis(k,l)=ErrorEnergyFilt(k,l);
        end        
    end
end
end
% clear 1000000 pre-setting in Edis
for k=1:m
    for l=1:n
       if Edis(k,l)==1e+6
            Edis(k,l)=0;
        end        
    end
end

% extracting calculated zone
nx=n-dmax;
for k=2:m-1
    for l=2:nx-1
        disparityx(k,l)=disparity(k,l);
        %Edisx(k,l)=Edis(k,l);
        %regMapx(k,l)=regMap(k,l);
        XLx(k,l)=XL(k,l);
        XRx(k,l)=XR(k,l);
        top=0;
        for x=k-1:k+1
            for y=l-1:l+1
                top=top+(XL(x,y+disparity(k,l),1)-XR(x,y,1))^2+(XL(x,y+disparity(k,l),2)-XR(x,y,2))^2+(XL(x,y+disparity(k,l),3)-XR(x,y,3))^2;  
            end
        end
        Ed(k,l)=(1/27)*top;
    end
end

%calculates error energy treshold for reliablity of disparity
Toplam=0;
for k=1:m-1
    for l=1:nx-1
      Toplam=Toplam+Ed(k,l);       
    end
end
% Error threshold Ve
Ve=Alfa*(Toplam/((m-1)*(nx-1)));

EdReliable=Ed;
disparityReliable=disparityx;
Ne=zeros(m,nx);
for k=1:m-1
    for l=1:nx-1
       if Ed(k,l)>Ve
          % sets unreliable disparity to zero
          disparityReliable(k,l)=0;
          EdReliable(k,l)=0;
          Ne(k,l)=1; % indicates no-estimated state
        end        
    end
end

% calculating reliablities both raw disparity and filtered disparity
TopE=0;
TopER=0;
Sd=0;
for k=1:m-1
    for l=1:nx-1
          TopE=TopE+Ed(k,l);
          if Ne(k,l)==0          
             TopER=TopER+EdReliable(k,l);
             Sd=Sd+1;
          end          
    end
end
ReliablityE=((nx-1)*(m-1))/(TopE);
ReliablityER=(Sd)/(TopER);

% median filtering for repairment of occulations
%disparityF=IterativeAveragingFilter(disparity,5,[4 4]);
disparityF=medfilt2(disparityReliable,[5 5]);

for k=1:m-1
    for l=1:nx-1
          % Zero disparity produce zero dept
          if disparityF(k,l)<5;
              DepthMap(k,l)=0;
          else
              DepthMap(k,l)=foc*(T/disparityF(k,l));
        end        
    end
end

fprintf ('******** Reliablity Report  ********** \n')
fprintf ('Reliablity of the disparity map: %f \n',ReliablityE)
fprintf ('Reliablity of the disparity map filtered: %f \n',ReliablityER)
fprintf ('******** Algoritm Speed Report  ********** \n')
fprintf ('Time Spend for calculation: %f \n',toc)

figure(1)
imagesc(disparityx);colorbar;
colormap('gray')
title('Disparity Map')
pixval on

figure(2)
colormap('gray')
imagesc(disparityReliable);colorbar;
title('Disparity Map with Reliable Disparities')
pixval on

figure(3)
colormap('gray')
imagesc(disparityF);colorbar;
title('Median Filtered Disparity Map with Reliable Disparities')
pixval on

figure(4)
colormap('gray')
imagesc(DepthMap);colorbar;
title('Depth Map from Disparity Map with Reliable Disparities [cm]')
pixval on

figure(5)
colormap('gray')
imagesc(log10(Ed));colorbar;
title('Dispatiy Map Error Energy')
pixval on

figure(6)
imagesc(XR./255)
title('Right Camera Color Image')
pixval on

figure(7)
imagesc(XL./255)
title('Left Camera Color Image')
pixval on

figure(8)
colormap('bone')
mesh(disparityF)
title('3D View')

figure(9)
subplot(2,1,1); imagesc(disparityx);colorbar;
colormap('gray')
title('Disparity Map')
subplot(2,1,2);imagesc(XR(:,1:n-dmax)./255);colorbar;
title('Image Zone for Disparity Calculated')
