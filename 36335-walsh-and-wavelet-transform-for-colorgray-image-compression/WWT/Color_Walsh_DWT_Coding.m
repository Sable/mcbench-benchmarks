%Walsh-Harmard Transform with two level Discrete Wavelete Transform for 
% Color image Compression  
% Designed by  Mohammed M. Siddeq
% Data 2012-2-22
% Email :- mamadmmx76@yahoo.com
% 

% this program is used for compress Color images by using some few parameters:
% INPUT :\ 
%   Im        : grayscale image , two-dimensional matrix
%   
%   F1,F2  : this option is used at the quantization for Low and High
%              freqeuencies. This values means multiply maximum value in "LL2"
%              with these factors for division (i.e. for quantization).
%              Example F1=0.05;F2=0.05; first value is for low
%              frequency and 2nd value for all high-freqeuncies..........
%              the minimum value =0.01 / 0.02 (defaul=0.025)
%              the maximum value =0.3 / 0.4   (defual=0.2)
%              Note\ if used more than 0.4 , there will be an error , because the image is
%              compeletely degraded.. in this case use less values: 0.025
%              or 0.05 or 0.1 or 0.2
%                     
%  wave_name : wavelet family name; for example : 'db3', 'db4'..etc  
%  Para      : this factor is used for reduce low-freqeuncy quality to
%               increase compression ratio. examples : 2 or 3 or 4,....etc
%
% OUTPUT\ Header : Compressed Record, contains all information about compressed data

clear;

Path_Name='C:\WWT\Images\2.bmp';
Im = imread(Path_Name); % Read color image

F1=0.05; % range values {0.02 - 0.5}
F2=0.025; % range values {0.02 - 0.5}
wave_name='db3'; % Wavelete name
Para=2; % range values {1 - 10}

% ---- Convert Color image RGB to Ycbcr format
ycbcr = rgb2ycbcr(Im);
y=ycbcr(:,:,1);
cb=ycbcr(:,:,2);
cr=ycbcr(:,:,3);

% Apply function for compression for each layer independantly
H1=Walsh_DWT_Coding(y,[F1,F2],wave_name,Para);
H2=Walsh_DWT_Coding(cb,[F1,F2],wave_name,Para);
H3=Walsh_DWT_Coding(cr,[F1,F2],wave_name,Para);

Header(1).H1=H1;
Header(2).H2=H2;
Header(3).H3=H3;

% assign location for the compressed data as "*.wwt"######################
S_=size(Path_Name); % using same file path name
Path_Name(S_(2))='t'; Path_Name(S_(2)-1)='w'; Path_Name(S_(2)-2)='w';  
%#########################################################################

save(Path_Name,'Header'); % Save Compress data "Header" 



