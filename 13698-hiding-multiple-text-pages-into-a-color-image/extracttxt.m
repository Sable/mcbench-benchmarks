function im_tx = extracttxt(im)
% This function extracts the text data from the LSB of encoded Color image
% im    - Color image coded with six Text images (2 per plane)
% im_tx - Output interleaved Text image extracted from Color image

% Get LSB bit of Color image
im_tx = bitand(im,1) * 255;
