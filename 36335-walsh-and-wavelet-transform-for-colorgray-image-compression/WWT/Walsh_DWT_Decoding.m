function [Im]=Walsh_DWT_Decoding(Header)
%Walsh-Harmard Transform with Tow level Discrete Wavelete Transform for image Decompression  
% Designed by  Mohammed M. Siddeq
% Date 2012-2-22
% Email :- mamadmmx76@yahoo.com
% 
% this program is used for Decompress grayscale images by using : 
% INPUT\  Header : this parameter contains all infmration about compressed file
% 
%OUTPUT\  Im : Decoded image from "Header" 


% --- Very important for you ----------------------------------------------
%Befroe apply this function you need the following programs:
% 1- "Arith_code.m" and "Arith_Decode.m"
% 2- "Walsh2D_Transform.m"
%Note\ these programs free for download from the following website: 
%     www.MathWorks.com  -> Auther = Siddeq

%--------------------------------------------------------------------------
% Example (1) --- for compression grayscale images-------------------------
%    I = imread('D:\images\image1.bmp'); % read an image
%    [Header]=Walsh_DWT_Coding(I,[0.025, 0.025],'db3',2); % Apply function
%    
%     
%    [Im]=Walsh_DWT_Decoding(Header); % for decoding;
%    imshow(uint8(Im)); % show final decoded image 


% Example (2) -------------------------------------------------------------
%    I = imread('D:\images\imageG.bmp'); %-> read an image
%    [Header]=Walsh_DWT_Coding(I,[0.025, 0.025],'db5',3); %-> Apply function
%    save('C:\imageG.WWT', 'Header'); -> save compressed file....
%   
%   X=load('C:\imageG.WWT', '-mat'); %-> load compressed file....
%   H=X.Header;
%   Im=Walsh_DWT_Decoding(H); %-> for decoding;
%   imshow(Im); %-> show final decoded image 
%
%----------------------------------- Good Luck -------------------------


%--Read Header file for Decoding.....
S_2=double(Header(1).S_2);
S_=double(Header(2).S_);
Code_Arr=double(Header(3).Code_Arr);
Arr_H1=double(Header(4).Arr_H1);
Arr_H2=double(Header(5).Arr_H2);
Code_Data1=double(Header(6).Code_Data1);
Data1_H1=double(Header(7).Data1_H1);
Data1_H2=double(Header(8).Data1_H2);
Code_Data2=double(Header(9).Code_Data2);
Data2_H1=double(Header(10).Data2_H1);
Data2_H2=double(Header(11).Data2_H2);
Code_Data3=double(Header(12).Code_Data3);
Data3_H1=double(Header(13).Data3_H1);
Data3_H2=double(Header(14).Data3_H2);
DC_Values=double(Header(15).DC_Values);
M=double(Header(16).M);
Para=double(Header(17).Para);
F1=double(Header(18).F1);
F2=double(Header(19).F2);
wave_name=Header(20).wave_name;
%---------------------------------------------------------------




Arr_Size=8; %window size 2x2 or 4x4 or 8x8 used by Walsh-Transformed ................ 


%--------Compute the Quantization Matrix
Q(1:Arr_Size,1:Arr_Size)=1; % initilize quantization matrix........
L=M.*F1;
for i=1:Arr_Size 
    for j=1:Arr_Size
        Q(i,j)=round((L)+(i+j).*Para); 
    end;
end;



%----------Using Arihtmetic Decoding for extract original data.....
[Arr]=Arith_Decode(Code_Arr,Arr_H1,Arr_H2); % Low-Freqeuncy Decoding...


% High-Frequency Decoding......................................
if (Code_Data1==0)
  Data1(1:S_(1)*S_(2))=0;
else
  [Data1]=Arith_Decode(Code_Data1,Data1_H1,Data1_H2); 
end;

if (Code_Data2==0)
 Data2(1:S_(1)*S_(2))=0;
else
 [Data2]=Arith_Decode(Code_Data2,Data2_H1,Data2_H2);
end;

if (Code_Data3==0)
  Data3(1:S_(1)*S_(2))=0;
else
  [Data3]=Arith_Decode(Code_Data3,Data3_H1,Data3_H2);
end;
%-------------------------------------------------------------------------


%Retrun "SAVE_" matrix from one-dimensional array "Arr"
POS=1;
SAVE_(1:S_2(1),1:S_2(2))=0;
sizeofArr=size(Arr);
for j=1:S_2(2)
  if (POS<=sizeofArr(2)) % to be ensure the postions is not exceeding 
    for i=1:S_2(1) 
      if (POS<=sizeofArr(2)) % to be ensure again not exceeding
        SAVE_(i,j)=Arr(POS);
      end;
      POS=POS+1;
    end;
  end;
end;


% Return "DC_Values" to matrix "SAVE_"..... 
SAVE_(1:S_2(1),1)=DC_Values(1:S_2(1));


% Deocde - HH2
% Return all original data from array 
k=1;

for j=1:S_(2)
    for i=1:S_(1)
        HH2(i,j)=Data3(k);
        k=k+1;
    end;
end;
%-----------------------------------------------------------------------
% Decode HL2
% Return all original data from array 
k=1;
for j=1:S_(2)
    for i=1:S_(1)
        HL2(i,j)=Data2(k);
        k=k+1;
    end;
end;
%-----------------------------------------------------------------------
% Decode LH2
% Return all original data from array 
k=1;
for j=1:S_(2)
    for i=1:S_(1)
        LH2(i,j)=Data1(k);
        k=k+1;
    end;
end;




%------------------- Reconstruct "LL2" from matrix "SAVE_"
L=1;i=1;
while (i<=S_(1))
    j=1;
    while(j<=S_(2))
        Z=1;
        for k1=1:Arr_Size 
            for k2=1:Arr_Size 
                T(k1,k2)=SAVE_(L,Z); 
                Z=Z+1; 
            end; 
        end;
        L=L+1;
        %------Apply inverse Quantization and inverse Walsh Transform------
        T=T.*Q;
        X=Walsh2D_Transform(T,Arr_Size,'i');
        D(i:i+Arr_Size-1,j:j+Arr_Size-1)=X(1:Arr_Size,1:Arr_Size);
        j=j+Arr_Size;
    end;
    i=i+Arr_Size;
end;
%-------------------------------------------------------------------------



%Adjustment for D matrix to be same size alike "LH2" or others
RELL(1:S_(1),1:S_(2))=D(1:S_(1),1:S_(2));
%RELL=RELL.*1
% Apply inverse Quantization for each sub-band (just high-Freqeuncy)
LH2=round(LH2.*(M*F2)); HL2=round(HL2.*(M.*F2)); HH2=round(HH2.*(M.*F2));

% Inverse -Wavelet Transform Stage-1
S_=size(LH2); LL2=0;
LL2(1:S_(1),1:S_(2))=RELL(1:S_(1),1:S_(2));
L1=idwt2(LL2,LH2,HL2,HH2,wave_name);
L1=L1*Para;
% Inverse -Wavelet Transform Stage-2
S_=size(L1);
HL(1:S_(1),1:S_(2))=0; % all main sub-bands are zeros

%L=0;
%L(1:S_(1),1:S_(2))=L1(1:S_(1),1:S_(2));

Im=idwt2(L1,HL,HL,HL,wave_name);% Decoded image 
Im=uint8(Im);
'Decompression ..OK'
end