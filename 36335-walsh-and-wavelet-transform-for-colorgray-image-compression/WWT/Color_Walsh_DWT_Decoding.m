%Walsh-Harmard Transform with Tow level Discrete Wavelete Transform for 
% Color image Decompression  
% Designed by  Mohammed M. Siddeq
% Data 2012-2-22
% Email :- mamadmmx76@yahoo.com
% 
% this program is used for Decompress grayscale images by using : 
% INPUT\  Header : this parameter contains all infmration about Color Compressed file
% 
%OUTPUT\  Im : Decoded Color image from "Header" 


clear;
Path_Name='C:\WWT\images\2.wwt';
X=load(Path_Name, '-mat'); % Read compress data from the file
Header=X.Header;
H1=Header(1).H1; 
H2=Header(2).H2;
H3=Header(3).H3;
Y=Walsh_DWT_Decoding(H1);% Apply Decompression on each layer
Cb=Walsh_DWT_Decoding(H2);
Cr=Walsh_DWT_Decoding(H3);

%% Collect all layers in one matrix Ycbcr
ycbcr(:,:,1)=Y(:,:);
ycbcr(:,:,2)=Cb(:,:);
ycbcr(:,:,3)=Cr(:,:); 

Im= ycbcr2rgb(ycbcr); % Convert YCbCr format to RGB

imshow(uint8(Im));
