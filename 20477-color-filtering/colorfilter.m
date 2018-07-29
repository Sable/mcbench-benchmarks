%% Colour Filter
%% This function can be used for separating or filter out Red components, 
%% Green components and Blue Components of colors from the color images.
%% Function C = colorfilter(img,color)
%% input    img = Color image (The input image should be a color image)
%%          color = which color want to be filtered out from the color image
%%                  it may be 'R' / 'r' / 'G' / 'g' / 'B' / 'b'                 
%%  Example: C = colorfilter(img,'r');
%%      Posted date   : 26 - 06 - 2008
%%      Modified date : 08 - 07 - 2008
%%                  
%% Developed By : K.Kannan & Jeny Rajan
%%                  Medical Imaging Research Group (MIRG), NeST, Trivandrum.
%%
function C = colorfilter(img,color)

[row col plane] = size(img);
img = double(img);
C = zeros(row,col,plane);
if plane ~= 3
    disp('Input should be a color image');
    return;
end
factor = max(img(:)) * 0.2;
switch color
    case {'R','r'}        
        for i = 1:row
            for j = 1:col
                if (img(i,j,1) > factor && img(i,j,1) == max([img(i,j,1) img(i,j,2) img(i,j,3)]))
                    C(i,j,1:3) = img(i,j,1:3);
                else
                    C(i,j,1:3) = (img(i,j,1) * 0.3) + (img(i,j,2) * 0.59) + (img(i,j,3) * 0.11);                    
                end
            end
        end
    case {'G','g'}
        for i = 1:row
            for j = 1:col
                if (img(i,j,2) > factor && img(i,j,2) == max([img(i,j,1) img(i,j,2) img(i,j,3)]))
                    C(i,j,1:3) = img(i,j,1:3);
                else
                    C(i,j,1:3) = (img(i,j,1) * 0.3) + (img(i,j,2) * 0.59) + (img(i,j,3) * 0.11);
                end
            end
        end
    case {'B','b'}
        for i = 1:row
            for j = 1:col
                if (img(i,j,3) > factor && img(i,j,3) == max([img(i,j,1) img(i,j,2) img(i,j,3)]))
                    C(i,j,1:3) = img(i,j,1:3);
                else
                    C(i,j,1:3) = (img(i,j,1) * 0.3) + (img(i,j,2) * 0.59) + (img(i,j,3) * 0.11);
                end
            end
        end
    otherwise
        disp('unknown method');
end
C = uint8(C);
figure,imshow(uint8(img),[]);
figure,imshow(uint8(C),[]);

