%*******************************************************************
% Region Based Stereo Matching Algorithm by Region Growing
% method explanied in the "Obtaining Depth Maps From Color Images 
% By Region Based Stereo Matching Algorithms". It simplified to line
% growing at row directions
% 
% It uses stereo color image pairs. Right camera image is loaded into XR array
% and left camera image is loaded into XL array. You can set Disparity search 
% range by DisparityRange.
% 
%
% Programmer: B. Baykant ALAGÖZ
% Ver.1.0 date: 09.2008
%******************************************************************
clear all
tic
% User can set DisparityRange and matching variable.

%You can set upper bound of disparity search range by dmax
dmax=40;

%Threshold for line growing
LineGrowingTreshold=10;

% Alfa tolerance coefficient for eliminating unreliable estimation
Alfa=1;

% Stereo Camera System Parameter for dept map calcualtion
% foc: focal length of cameras in unit of cm
foc=30;
% T: distance between stereo camera pair in unit of cm
T=20;

%Loading Right image to XR and Left image to XL
[XR,MAP] = IMREAD('view5m.png');
[XL,MAP] = IMREAD('view1m.png');

%------------------ END of USER SETTINGS----------------------

% auto-presettings for the program
XR=double(XR);
XL=double(XL);
[m n p]=size(XR);
disparity=zeros(m,n);
regMap=zeros(m,n);% Show status of point. 0: not tested, 1:Belong to a region
                  % 2:A root point 3: Useless(Idle) point
IndexI=1;
IndexJ=1;
State=0;
Edis=100000*ones(m,n);
% Red,Green,Blue deðerleri birleþtirip ortalamasý alýnarak gri resim elde
% edilir.


for i=2:m
    fprintf ('Scanned row for line growing: %d\n',i);
for j=2:n-1-dmax
      % Root point selection process
      % State=0 indicates finding a root
      if State==0
       if regMap(i,j)==0
        for d=0:dmax
          % Error energy calculated along line lenght of 3.(o-*-o)
          ErrorEnergy=(1/9)*[(XR(i,j,1)-XL(i,j+d,1))^2+(XR(i,j,2)-XL(i,j+d,2))^2+(XR(i,j,3)-XL(i,j+d,3))^2+(XR(i,j-1,1)-XL(i,j-1+d,1))^2+(XR(i,j-1,2)-XL(i,j-1+d,2))^2+(XR(i,j-1,3)-XL(i,j-1+d,3))^2+(XR(i,j+1,1)-XL(i,j+1+d,1))^2+(XR(i,j+1,2)-XL(i,j+1+d,2))^2+(XR(i,j+1,3)-XL(i,j+1+d,3))^2];
          if ErrorEnergy < Edis(i,j)
             disparity(i,j)=d;
             Edis(i,j)=ErrorEnergy;
             State=1;
             IndexI=i;
             IndexJ=j;
             if LineGrowingTreshold<ErrorEnergy
               regMap(i,j)=3; % Mark as idle point
               disparity(i,j)=0;
            else
               regMap(i,j)=2;% Mark as root points 
            end   
          end
        end%For d
       end 
      end% if
      
       % Region growing process
       % State=1 indicates growing the line
        while (State==1)
            State=0;
            k=IndexI;
                for w=IndexJ+1:(n-1-dmax)
                    if k>1 && w>1 && k<(m-1) && w<(n-1-dmax) && regMap(k,w)==0
                       % Error energy calculated along line lenght of 3.(o-*-o)
                       ErrorEnergy=(1/9)*[(XR(k,w,1)-XL(k,w+disparity(IndexI,IndexJ),1))^2+(XR(k,w,2)-XL(k,w+disparity(IndexI,IndexJ),2))^2+(XR(k,w,3)-XL(k,w+disparity(IndexI,IndexJ),3))^2+(XR(k,w-1,1)-XL(k,w-1+disparity(IndexI,IndexJ),1))^2+(XR(k,w-1,2)-XL(k,w-1+disparity(IndexI,IndexJ),2))^2+(XR(k,w-1,3)-XL(k,w-1+disparity(IndexI,IndexJ),3))^2+(XR(k,w+1,1)-XL(k,w+1+disparity(IndexI,IndexJ),1))^2+(XR(k,w+1,2)-XL(k,w+1+disparity(IndexI,IndexJ),2))^2+(XR(k,w+1,3)-XL(k,w+1+disparity(IndexI,IndexJ),3))^2];
                                 if ErrorEnergy < LineGrowingTreshold
                                    disparity(k,w)=disparity(IndexI,IndexJ);
                                    Edis(k,w)=ErrorEnergy;
                                    State=1;
                                    IndexIa=k;
                                    IndexJb=w;
                                    regMap(k,w)=1;% Mark as associated region point
                                 end
                    end
                end %For w
            
            if State==1
               IndexI=IndexIa;
               IndexJ=IndexJb;
            end 
            %figure(1)
            %imagesc(regMap);
            %pause(1);
        end %While
       
    end %For i
end  %For j

% clear 1000000 pre-setting in Edis
for k=1:m
    for l=1:n
       if Edis(k,l)==100000
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
        regMapx(k,l)=regMap(k,l);
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


figure(2)
colormap('gray')
imagesc(disparityReliable);colorbar;
title('Disparity Map with Reliable Disparities')


figure(3)
colormap('gray')
imagesc(disparityF);colorbar;
title('Median Filtered Disparity Map with Reliable Disparities')


figure(4)
colormap('gray')
imagesc(DepthMap);colorbar;
title('Depth Map from Disparity Map with Reliable Disparities [cm]')


figure(5)
colormap('gray')
imagesc(log10(Ed));colorbar;
title('Dispatiy Map Error Energy')


figure(6)
imagesc(XR./255)
title('Right Camera Color Image')


figure(7)
imagesc(XL./255)
title('Left Camera Color Image')


figure(8)
colormap('default')
imagesc(regMapx);colorbar;
title('Point Status Map (0: not procesed, 1:region point, 2:rootpoint, 3:idle')
