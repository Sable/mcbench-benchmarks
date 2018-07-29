
function fig = imColorSep(A)

% IMCOLORSEP    Displays the RGB decomposition of a full-color image
%
% Syntax:       fig = imColorSep(A);
%
% Example:      A = imread('peppers.png');
%               fig = imColorSep(A);
%
%
% Written by:   Rick Rosson, 2007 December 26
%
% Revised:      Rick Rosson, 2008 January 2
%
% Copyright (c) 2007-08 Richard D. Rosson.  All rights reserved.
%
%

    % Number of gray scale values:
    N = 256;
    
    % Make sure data type of image array is 'uint8':
    A = im2uint8(A);

    % Create figure window:
    fig = figure;
    
    % Display full color image:
    subplot(2,2,1);
    imshow(A);
    title('Full Color');

    % Cell array of color names:
    ColorList = { 'Red' 'Green' 'Blue' };
    
    % Gray-scale column vector:         %   range [ 0 .. 1 ]
    gr = 0:1/(N-1):1;                   %   increment 1/(N-1)
    
        
    % Display each of the three color components:
    
    for k = 1:3
        
        % color map:
        cMap = zeros(N,3);
        cMap(:,k) = gr;   
        
        % Display monochromatic image:
        subplot(2,2,k+1);
        imshow(ind2rgb(A(:,:,k),cMap));
        title(ColorList{k});
        
    end

end

