function [output]=demosaicing(input)
% Bilinear Interpolation of the missing pixels
% Bayer CFA
%       R G R G
%       G B G B
%       R G R G
%       G B G B
%
% The input can be on one or three channels
%
% Output = a complete RGB image on 3 channels

im=double(input);
    
M = size(im, 1);
N = size(im, 2);
channel = size(size(im), 2);    % == 2 => one channel
                                % == 3 => three channel

red_mask = repmat([1 0; 0 0], M/2, N/2);
green_mask = repmat([0 1; 1 0], M/2, N/2);
blue_mask = repmat([0 0; 0 1], M/2, N/2);

if channel == 2
    R=im.*red_mask;
    G=im.*green_mask;
    B=im.*blue_mask;
elseif channel == 3
    R=im(:,:,1).*red_mask;
    G=im(:,:,2).*green_mask;
    B=im(:,:,3).*blue_mask;
end
    
% Interpolation for the green at the missing points
    G= G + imfilter(G, [0 1 0; 1 0 1; 0 1 0]/4);
    
% Interpolation for the blue at the missing points
% First, calculate the missing blue pixels at the red location
    B1 = imfilter(B,[1 0 1; 0 0 0; 1 0 1]/4);
% Second, calculate the missing blue pixels at the green locations
% by averaging the four neighouring blue pixels
    B2 = imfilter(B+B1,[0 1 0; 1 0 1; 0 1 0]/4);
    B = B + B1 + B2;
    
% Interpolation for the red at the missing points
% First, calculate the missing red pixels at the blue location
    R1 = imfilter(R,[1 0 1; 0 0 0; 1 0 1]/4);
% Second, calculate the missing red pixels at the green locations   
    R2 = imfilter(R+R1,[0 1 0; 1 0 1; 0 1 0]/4);
    R = R + R1 + R2
    

    output(:,:,1)=R; output(:,:,2)=G; output(:,:,3)=B;
