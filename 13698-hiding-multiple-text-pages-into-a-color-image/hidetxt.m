function im_wm = hidetxt(im_in,im_tx)
% This function sets the LSB bit of Color image as '1' or '0' based on the 
% information available in the Text image. The final output Color image has
% the watermark of Text as a LSB information.
% im_in - Input Color image which used to hide the Text data
% im_tx - Input interleaved Text image
% im_wm - Output watermarked Color image coded with interleaved Text image in it's LSB 

% Set the LSB bit of each Color plane based on the Text image
%   0 <= im_tx(x,y) <  128 = Set LSB as '0'
% 128 <= im_tx(x,y) <  256 = Set LSB as '1'
im_wm = bitset(im_in,1,bitshift(im_tx,-7));

