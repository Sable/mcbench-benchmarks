function [Header]=Walsh_DWT_Coding(I,Factors,wave_name,Para)
%Walsh-Harmard Transform with two level Discrete Wavelete Transform for image Compression  
% Designed by  Mohammed M. Siddeq
% Date 2012-2-22
% Email :- mamadmmx76@yahoo.com
% 
% this program is used for compress grayscale images by using some few parameters:
% INPUT :\ 
%   I        : grayscale image , two-dimensional matrix
%   
%   Factors  : this option is used at the quantization for Low and High
%              freqeuencies. This values means multiply maximum value in "LL2"
%              with these factors for division (i.e. for quantization).
%              Example Factors=[0.05,0.05]; first postion is for low
%              frequency and 2nd for all high-freqeuncies..........
%              the minimum value =0.01 or 0.02 (defaul=0.025)
%              the maximum value =0.3 or 0.4   (defual=0.2)
%              Note\ if used more than 0.4 , there will be an error , because the image is
%              compeletely degraded.. in this case use less values like:
%              0.025 or 0.05 or 0.1 or 0.2 or 0.3 or 0.4
%                     
%  wave_name : wavelet family name; for example : 'db3', 'db4'..etc  
%  Para      : this factor is used for reduce low-freqeuncy quality to
%               increase compression ratio. examples : 2 or 3 or 4,....etc
%
% OUTPUT\ Header : Compressed Record, contains all information about compressed data


% --- Very important for you ----------------------------------------------
%Befroe apply this function you need the following programs:
% 1- "Arith_code.m" and "Arith_Decode.m"
% 2- "Walsh2D_Transform.m"
%Note\ these programs free for download from the following website: 
%     www.MathWorks.com  -> Auther = Siddeq
%--------------------------------------------------------------------------
% Example (1) --- for compression grayscale images-------------------------
%    I = imread('D:\images\image1.bmp'); %%% read an image
%    [Header]=Walsh_DWT_Coding(I,[0.025, 0.025],'db3',2); %%% Apply function
%   save('D:\images\image1.WWT', 'Header'); %%% save compressed file....
%----------------------------------------------------------
% Example (2) -------------------------
%    I = imread('D:\images\image1.bmp'); %%% read an image
%    [Header]=Walsh_DWT_Coding(I,[0.05, 0.025],'db5',3); %%% Apply function
%   save('D:\images\image1.WWT', 'Header'); %%% save compressed file....
%----------------------------------- Good Luck -------------------------


%clc; % Clear Screen
%I = imread('D:\lectures\images\big4.bmp');
%Save_Path='C:\Temp\big4.WWT';
Im(:,:)=I(:,:,1); % Choose first layer from image matrix....
%wave_name='db3';


Im=double(Im);

[LL,LH,HL,HH]=dwt2(Im,wave_name);
LL=round(LL./2);
[LL2,LH2,HL2,HH2]=dwt2(LL,wave_name);
M=round(max(LL2(:))); % compute maximum value for "LL2"
%%%% Select ratio for each sub-band (LL2,LH2,HL2 and HH2) for the quantization process 


%---------------------- Parameters are used by the programmer
F1=Factors(1);
F2=Factors(2);
%F1=0.1; % for LL2
%F2=0.025;  %for HH2 and HL2 and LH2 


Arr_Size=8; %mask size 2x2 or 4x4 or 8x8 ....etc
%-------------------------------------------------------------


LH2=round(LH2./(M*F2)); HL2=round(HL2./(M.*F2)); HH2=round(HH2./(M.*F2));



%----------------- Apply Walsh 2D- Transform -------------------
S_=size(LL2);  




% generate quantization matrix..................  
L=M.*F1; 

for i=1:Arr_Size 
    for j=1:Arr_Size
        Q(i,j)=round((L)+(i+j).*Para); 
    end;
end;

%-----------------------------------------------




SAVE_(1,1:Arr_Size.*Arr_Size)=0; % locate "SAVE_" for save transformed matrix
LL2(1:S_(1),S_(2)+1:Arr_Size+S_(2))=0; % pad zeros for each row
LL2(S_(1)+1:Arr_Size+S_(1),1:S_(2))=0; % pad zeros for each column 
L=1;i=1;
while (i<=S_(1))
    j=1;
    while(j<=S_(2))
        X(1:Arr_Size,1:Arr_Size)=LL2(i:i+Arr_Size-1,j:j+Arr_Size-1);
        T=Walsh2D_Transform(X,Arr_Size,'T'); % apply 2D Walsh
        T=round(T./Q); % apply Quantization......
        
        %----------------------save each mask as one-dimensional array in "SAVE_" 
        Z=1;
        for k1=1:Arr_Size for k2=1:Arr_Size SAVE_(L,Z)=T(k1,k2); Z=Z+1; end; end;
        L=L+1;
        
        j=j+Arr_Size;
    end;
    i=i+Arr_Size;
end;

%------------Split DC values from AC coefficients-------------------------
S_2=size(SAVE_);
%L=L-1;
DC_Values(1:S_2(1))=SAVE_(1:S_2(1),1); % Store DC-Column in header file.........
SAVE_(1:L,1)=0;
%Save final matrix as one-dimensional array -> "Arr"  
Arr(1:S_2(1)*S_2(2))=SAVE_(1:S_2(1),1:S_2(2)); 
%-------------------------------------------------------------------------



%-------------Convert two dimensional high-freqeuncy domian to Array-------
Data1(1:S_(1)*S_(2))=LH2(1:S_(1),1:S_(2));

Data2(1:S_(1)*S_(2))=HL2(1:S_(1),1:S_(2));

Data3(1:S_(1)*S_(2))=HH2(1:S_(1),1:S_(2));


%---Compress all data by using Arithmetic Coding --------------------------

[Code_Arr,Arr_H1,Arr_H2]=Arith_code(Arr);

% Check the First array if all values are zero or not?
mi=min(Data1(:)); mx=max(Data1(:)); 
if (mi==mx) % if YES asign zero code
    Code_Data1=0; Data1_H1=0; Data1_H2=0;
else % if NO apply coding
    [Code_Data1,Data1_H1,Data1_H2]=Arith_code(Data1);
end;
%-----------------------------------------------------

% Check the Second array if all values are zero or not?
mi=min(Data2(:)); mx=max(Data2(:)); 
if (mi==mx) % if YES asign zero code
    Code_Data2=0; Data2_H1=0; Data2_H2=0;
else % if NO apply coding
    [Code_Data2,Data2_H1,Data2_H2]=Arith_code(Data2);
end;

% Check the Second array if all values are zero or not?
mi=min(Data3(:)); mx=max(Data3(:)); 
if (mi==mx) % if YES asign zero code
  Code_Data3=0; Data3_H1=0; Data3_H2=0;
else % if NO apply coding
   [Code_Data3,Data3_H1,Data3_H2]=Arith_code(Data3);
end;






%---------- Save information and compressed data in a Record..... "Header"
Header(1).S_2=uint16(S_2);
Header(2).S_=uint16(S_);
Header(3).Code_Arr=uint8(Code_Arr);
Header(4).Arr_H1=int16(Arr_H1);
Header(5).Arr_H2=int16(Arr_H2);
Header(6).Code_Data1=uint8(Code_Data1);
Header(7).Data1_H1=int32(Data1_H1);
Header(8).Data1_H2=int32(Data1_H2);
Header(9).Code_Data2=uint8(Code_Data2);
Header(10).Data2_H1=int32(Data2_H1);
Header(11).Data2_H2=int32(Data2_H2);
Header(12).Code_Data3=uint8(Code_Data3);
Header(13).Data3_H1=int32(Data3_H1);
Header(14).Data3_H2=int32(Data3_H2);
Header(15).DC_Values=uint16(DC_Values);
Header(16).M=uint16(M);
Header(17).Para=uint8(Para);
Header(18).F1=double(F1);
Header(19).F2=double(F2);
Header(20).wave_name=wave_name;
'Compression ..OK'
end