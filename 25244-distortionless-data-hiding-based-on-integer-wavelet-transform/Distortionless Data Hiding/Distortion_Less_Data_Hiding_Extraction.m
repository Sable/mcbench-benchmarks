% Distortionless data hiding based on integer wavelet transform (Watermark Extraction)
% Guorong Xuan   Jiang Zhu   Jidong Chen   Shi, Y.Q.   Zhicheng Ni   Wei Su  
% Department of Computer Science, Tongji University, Shanghai
% 
% This paper appears in: Electronics Letters
% Publication Date: 5 Dec 2002
% Volume: 38,  Issue: 25
% On page(s): 1646- 1648
% ISSN: 0013-5194

% August 19, 2007, 3:38pm
% updated 13 December, 2008
% By: Asad (asad_82@yahoo.com)

clear all;
close all;

load WatermarkInfo.mat;
disp('------------------------ Extraction -------------------------------');

% read image and convert to gray scale if necessary
% a = imread('Watermarked Image.bmp');
% get the single channel
% a = a(:,:,1);
a = watermarkedImage;

% STEP 1: perfom integer wavelet decomposition
LS = liftwave('cdf2.2','Int2Int');
[CA,CH,CV,CD] = lwt2(double(a),LS);

% STEP 2: extract the embeded signal from 5th bit of CH, CV and CD
index = 1;
% preallocate memory to fasten things
embededSignal = zeros(size(CH,1)*size(CH,2)+size(CV,1)*size(CV,2)+size(CD,1)*size(CD,2),1);
for i=1:size(CH,1)
    for j=1:size(CH,2)
        % for constructing binary image using CH
        if CH(i,j) ~= -ERROR_NUM
            binSeq = dec2bin(abs(CH(i,j)),8);
            if binSeq(BITPLANE_NUMBER) == '1'
                embededSignal(index,1) = 1;
            else
                embededSignal(index,1) = 0;
            end
            index = index + 1;        
        end
    end
end

% extract the embeded signal from 5th bit of CV
for i=1:size(CV,1)
    for j=1:size(CV,2)
        % for constructing binary image using CV
        if CV(i,j) ~= -ERROR_NUM        
            binSeq = dec2bin(abs(CV(i,j)),8);
            if binSeq(BITPLANE_NUMBER) == '1'
                embededSignal(index,1) = 1;
            else
                embededSignal(index,1) = 0;
            end
            index = index + 1;        
        end
    end
end

% extract the embeded signal from 5th bit of CD
for i=1:size(CD,1)
    for j=1:size(CD,2)
        % for constructing binary image using CD
        if CD(i,j) ~= -ERROR_NUM        
            binSeq = dec2bin(abs(CD(i,j)),8);
            if binSeq(BITPLANE_NUMBER) == '1'
                embededSignal(index,1) = 1;
            else
                embededSignal(index,1) = 0;
            end
            index = index + 1;        
        end
    end
end

% STEP 3: extract header information
% obtain count1 of CH for use in aritmatic decoding
binNum = '';
for i=1:8
    if embededSignal(i,1) == 1
        binNum = strcat(binNum,'1');
    else
        binNum = strcat(binNum,'0');    
    end
end
num = bin2dec(binNum);
count1(1,1) = num;

binNum = '';
for i=9:16
    if embededSignal(i,1) == 1
        binNum = strcat(binNum,'1');
    else
        binNum = strcat(binNum,'0');    
    end
end
num = bin2dec(binNum);
count1(1,2) = num;

% obtain count2 of CV for use in aritmatic decoding
binNum = '';
for i=17:24
    if embededSignal(i,1) == 1
        binNum = strcat(binNum,'1');
    else
        binNum = strcat(binNum,'0');    
    end
end
num = bin2dec(binNum);
count2(1,1) = num;

binNum = '';
for i=25:32
    if embededSignal(i,1) == 1
        binNum = strcat(binNum,'1');
    else
        binNum = strcat(binNum,'0');    
    end
end
num = bin2dec(binNum);
count2(1,2) = num;

% obtain count3 of CD for use in aritmatic decoding
binNum = '';
for i=33:40
    if embededSignal(i,1) == 1
        binNum = strcat(binNum,'1');
    else
        binNum = strcat(binNum,'0');    
    end
end
num = bin2dec(binNum);
count3(1,1) = num;

binNum = '';
for i=41:48
    if embededSignal(i,1) == 1
        binNum = strcat(binNum,'1');
    else
        binNum = strcat(binNum,'0');    
    end
end
num = bin2dec(binNum);
count3(1,2) = num;

% obtain length of compressed CH
binNum = '';
for i=49:64
    if embededSignal(i,1) == 1
        binNum = strcat(binNum,'1');
    else
        binNum = strcat(binNum,'0');    
    end
end
num = bin2dec(binNum);
lenCH5 = num;

% obtain length of compressed CV
binNum = '';
for i=65:80
    if embededSignal(i,1) == 1
        binNum = strcat(binNum,'1');
    else
        binNum = strcat(binNum,'0');    
    end
end
num = bin2dec(binNum);
lenCV5 = num;

% obtain length of compressed CD
binNum = '';
for i=81:96
    if embededSignal(i,1) == 1
        binNum = strcat(binNum,'1');
    else
        binNum = strcat(binNum,'0');    
    end
end
num = bin2dec(binNum);
lenCD5 = num;

% obtain length of watermark
binNum = '';
for i=97:128
    if embededSignal(i,1) == 1
        binNum = strcat(binNum,'1');
    else
        binNum = strcat(binNum,'0');    
    end
end
num = bin2dec(binNum);
lenWatermark = num;

% STEP 4: Extract the respective signals CH, CV, CD and decode(uncompress) to get the original bit sequence  
HL = 128;
% construct sequence 1(CH) and decode
seq11 = embededSignal(HL+1:(HL+lenCH5));
CH5 = arithdeco(seq11,count1,size(CH,1)*size(CH,2)); 

% construct sequence 2(CV) and decode
seq22 = embededSignal((HL+lenCH5)+1:(HL+lenCH5+lenCV5));
CV5 = arithdeco(seq22,count2,size(CV,1)*size(CV,2)); 

% construct sequence 3(CD) and decode
seq33 = embededSignal((HL+lenCH5+lenCV5)+1:(HL+lenCH5+lenCV5+lenCD5));
CD5 = arithdeco(seq33,count3,size(CD,1)*size(CD,2)); 

% additional step is to verify the embeded watermark so extract it (not compared to the original but can be)
watermarkE = embededSignal((HL+lenCH5+lenCV5+lenCD5)+1:(HL+lenCH5+lenCV5+lenCD5+lenWatermark));
if isequal(watermark,watermarkE')
    disp('Watermark correct');
else
    disp('Watermark Error')    
end
watermarkE = reshape(watermarkE,WM_SIZE,WM_SIZE);
figure,imshow(watermarkE,[]),title('Retrieved Watermark')

% STEP 5: Restore the Image i.e. remove the watermark and insert the
% uncompressed 5th bit data back into the image
CH5 = reshape(CH5,size(CH,1),size(CH,1));
CV5 = reshape(CV5,size(CV,1),size(CV,1));
CD5 = reshape(CD5,size(CD,1),size(CD,1));

neg = 0;

for x=1:size(CH,1)
    for y=1:size(CH,2)
        if CH(x,y) ~= -ERROR_NUM
            % restore 5th bit of CH
            neg = 0;
            if CH(x,y) < 0
                neg = 1;
            end
            binSeq = dec2bin(abs(CH(x,y)),8);
            if CH5(x,y) == 2
                binSeq(BITPLANE_NUMBER) = '1';
            else
                binSeq(BITPLANE_NUMBER) = '0';
            end
            num = bin2dec(binSeq);
            if neg == 1
                CH(x,y) = num * -1;
            else
                CH(x,y) = num;
            end
        end        
        % restore 5th bit of CV
        if CV(x,y) ~= -ERROR_NUM        
            neg = 0;
            if CV(x,y) < 0
                neg = 1;
            end
            binSeq = dec2bin(abs(CV(x,y)),8);
            if CV5(x,y) == 2
                binSeq(BITPLANE_NUMBER) = '1';
            else
                binSeq(BITPLANE_NUMBER) = '0';
            end
            num = bin2dec(binSeq);
            if neg == 1
                CV(x,y) = num * -1;
            else
                CV(x,y) = num;
            end
        end
        
        % restore 5th bit of CD
        if CD(x,y) ~= -ERROR_NUM        
            neg = 0;
            if CD(x,y) < 0
                neg = 1;
            end
            binSeq = dec2bin(abs(CD(x,y)),8);
            if CD5(x,y) == 2
                binSeq(BITPLANE_NUMBER) = '1';
            else
                binSeq(BITPLANE_NUMBER) = '0';
            end
            num = bin2dec(binSeq);
            if neg == 1
                CD(x,y) = num * -1;
            else
                CD(x,y) = num;
            end
        end
    end
end

%STEP 6: Take inverse integer wavelet transform to get the original
%distortionless image back
restoredImage = ilwt2(CA,CH,CV,CD,LS);
figure,imshow(restoredImage,[]),title('Restored Image (Distortionless)');

difference = abs(double(originalImage) - double(restoredImage));
figure,imshow(difference,[]),title('Difference Image');