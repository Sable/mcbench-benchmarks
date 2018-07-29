%% Colour Segmentation - VIBGYOR Colour Segmentation
%% This function can be used for VIBGYOR Colour segmentation from the RGB
%% Color images.
%% Function C = VIBGYORsegmentation(img)
%% input    img = Color image (The input image should be a color image)    
%%  Example: C = VIBGYORsegmentation(img);
%%      Posted date : 14 - 07 - 2008
%%                  
%% Developed By : K.Kannan & Jeny Rajan
%%                  Medical Imaging Research Group (MIRG), NeST, Trivandrum.
%%
function C = VIBGYORsegmentation(img)
%% Electro-Magnetic wavelengths ranges in Nano Meter
% red 760-720
% orange 620-590
% yellow 590-545
% green 525-490
% blue 490-450
% indigo 450-420
% violet 420-380
%%
[row col plane] = size(img);
img = double(img);
C = zeros(row,col,plane);
if plane ~= 3
    disp('Input should be a color image');
    return;
end
GL = 255;
%% Color Choice
clc;
disp('   ');
disp('           r / R - for Red Color'); 
disp('           o / O - for Orange Color'); 
disp('           y / Y - for Yellow Color'); 
disp('           g / G - for Green Color'); 
disp('           b / B - for Blue Color'); 
disp('           i / I - for Indigo Color'); 
disp('           v / V - for Violet Color'); 
color = input('\nYour Color Choice = ','s');
%%
switch color
    case {'R','r'}
        f1 = (GL * 1);f2 = (GL * 0.4);f3 = (GL * 0.5);
        f4 = (GL * 0);f5 = (GL * 0.5);f6 = (GL * 0);
        C = cfilter(img,f1,f2,f3,f4,f5,f6,1,0);
    case {'O','o'}
        f1 = (GL * 1);f2 = (GL * 0.6);f3 = (GL * 0.68);        
        f4 = (GL * 0.3);f5 = (GL * 0.3);f6 = (GL * 0);
        C = cfilter(img,f1,f2,f3,f4,f5,f6,1,0);
    case {'Y','y'}
        f1 = (GL * 1);f2 = (GL * 0.78);f3 = (GL * 1);        
        f4 = (GL * 0.72);f5 = (GL * 0.52);f6 = (GL * 0);
        C = cfilter(img,f1,f2,f3,f4,f5,f6,1,1);
    case {'G','g'}
        f1 = (GL * 0.68);f2 = (GL * 0);f3 = (GL * 1);
        f4 = (GL * 0.4);f5 = (GL * 0.68);f6 = (GL * 0);
        C = cfilter(img,f1,f2,f3,f4,f5,f6,2,0);
    case {'B','b'}
        f1 = (GL * 0.5);f2 = (GL * 0);f3 = (GL * 0.68);
        f4 = (GL * 0);f5 = (GL * 1);f6 = (GL * 0.4);
        C = cfilter(img,f1,f2,f3,f4,f5,f6,3,0);
    case {'I','i'}
        f1 = (GL * 0.68);f2 = (GL * 0);f3 = (GL * 1);        
        f4 = (GL * 0.6);f5 = (GL * 1);f6 = (GL * 0.6);
        C = cfilter(img,f1,f2,f3,f4,f5,f6,1,1);
    case {'V','v'}
        f1 = (GL * 1);f2 = (GL * 0.6);f3 = (GL * 0.68);        
        f4 = (GL * 0);f5 = (GL * 1);f6 = (GL * 0.6);
        C = cfilter(img,f1,f2,f3,f4,f5,f6,3,1);
    otherwise
        disp('unknown method');
end
%% Display
C = uint8(C);
figure, subplot(1,2,1),imshow(uint8(img),[]);title('Original Image');
subplot(1,2,2),imshow(uint8(C),[]);title('Color Segmented Image');

%% Function for Color Filter
function C = cfilter(img,f1,f2,f3,f4,f5,f6,m,flg)
[row col plane] = size(img);
C = zeros(row,col,plane);
for i = 1:row
    for j = 1:col
        if flg == 0
            if (img(i,j,1) <= f1 && img(i,j,1) >= f2 && ...
                img(i,j,2) <= f3 && img(i,j,2) >= f4 && ...
                img(i,j,3) <= f5 && img(i,j,3) >= f6 ...
                && img(i,j,m) == max([img(i,j,1) img(i,j,2) img(i,j,3)]))
                C(i,j,1:3) = img(i,j,1:3);
            else
                C(i,j,1:3) = (img(i,j,1) * 0.3) + (img(i,j,2) * 0.59) + (img(i,j,3) * 0.11);
            end
        else
            if (img(i,j,1) <= f1 && img(i,j,1) >= f2 && ...
                img(i,j,2) <= f3 && img(i,j,2) >= f4 && ...
                img(i,j,3) <= f5 && img(i,j,3) >= f6)
                C(i,j,1:3) = img(i,j,1:3);
            else
                C(i,j,1:3) = (img(i,j,1) * 0.3) + (img(i,j,2) * 0.59) + (img(i,j,3) * 0.11);
            end
        end
    end
end
%%