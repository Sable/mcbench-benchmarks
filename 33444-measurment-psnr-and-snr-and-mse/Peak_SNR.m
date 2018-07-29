function [MSE, SNR,P_SNR]=Peak_SNR(DI,OI)
%'This program is  Peak Signal-to-Noise-Ratio (PSNR)'
%'By Mohammed Mustafa Siddeq';
% Finished Work 5/2/2008......
% this fucntion is used to compare between two data, and output is :-
% Meas-Sequare-Error (MSE)
% Signal-to-Noise-Ratio (SNR)
% Peak-Signal-to-Noise-Ratio
% Input to the fuction :- 
% DI:- Original Data (i.e. 2D-Matrix or array or color image)
% OI:- Estimated Data, same size of "DI"

%DI=imread('D:\lectures\images\image14.bmp'); % specify image name..
%OI=double(imread('D:\Temp\X-ray\JPEG2000\3_49.bmp'));
%Color_Size=3; %% 
%%^^^^^^^^^^^^     this program compute color layers automatically 

 
 

'Input OI-> Original image...';
'Input DI-> Decoded Image....';
'Input High_P.....';
'Input Width_P....';
P_Size=size(OI); Test_Color=size(P_Size);
if (Test_Color(2)==3)
    Color_Size=3;
else
    Color_Size=1;
end;

% check image size row and column to select minimum of each
OI_Size=size(OI);
DI_Size=size(DI);
if (OI_Size(1) > DI_Size(1)) P_Size(1)=DI_Size(1); 
else
P_Size(1)=OI_Size(1);    
end;

if (OI_Size(2) > DI_Size(2)) P_Size(2)=DI_Size(2); 
else
P_Size(2)=OI_Size(2);    
end;

%P_Size=size(OI);
OI=double(OI); 
DI=double(DI);
MSE=0;
for hCC=1:Color_Size
 for i=1:P_Size(1)
    for j=1:P_Size(2)
        MSE=MSE+(OI(i,j,hCC)-DI(i,j,hCC))^2;
    end;
 end;
end;

Maxi=max(OI(:));
%MSE.....................
MSE=MSE/(Color_Size*P_Size(1)*P_Size(2));
%PSNR.....................
P_SNR=10*log10((Maxi^2)/MSE);

%'Also compute SNR ...'
DI=double(DI);
PP=0;
for hCC=1:Color_Size
 for i=1:P_Size(1)
    for j=1:P_Size(2)
        PP=PP+(DI(i,j,hCC))^2;
    end;
 end;
end;
PP=PP/(Color_Size*P_Size(1)*P_Size(2));
% SNR............
SNR=10*log10(sqrt(PP/MSE));

end
