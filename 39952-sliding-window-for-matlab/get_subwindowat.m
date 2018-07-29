function [ result ] = get_subwindow( input_image, index, resx, resy, spacingx, spacingy )
% index is 0-N
%GET_SCRIPT Summary of this function goes here
%   Detailed explanation goes here

	maxPerRow = floor((size(input_image,2)-resx+spacingx) / spacingx);
    maxRows = floor((size(input_image,1) - resy+spacingy )/ spacingy);
    currentRow = floor(index / (maxPerRow));
    
    if (currentRow < maxRows)
        
        cutX = (mod(index,maxPerRow)*spacingx);
        cutY = (currentRow * spacingy);
        
        result = input_image(cutY+1:(cutY+resy),cutX+1:(cutX+resx),:);
        
    else
        result = 'error';
        %error('index too high, image overflow');        
    end
    
end

