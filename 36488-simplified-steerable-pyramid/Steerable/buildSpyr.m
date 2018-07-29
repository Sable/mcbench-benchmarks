function coeff = buildSpyr(im, ht,filter)

% Build the steerable pyramid coefficients by convolution
% Input:
%           im:     input image
%           ht:     height of pyramid
%                   (including lowpass and highpass)
%       filter:     filter, typically sp3.mat, sp1.mat, sp5.mat
%
% Output:
%       coeff: a cell containing the pyramid
%       coeff{1}:   highpass residue
%       coeff{ht}:  lowpass residue
%       coeff{2}{1}: one orientation subband

load(filter,'lo0filt','hi0filt','lofilt','bfilts');

hi0 = corrDn(im, hi0filt,[1 1]);    
lo0 = corrDn(im, lo0filt,[1 1]);

temp = buildSpyrLevs(lo0, ht-1, lofilt, bfilts); 

coeff = [hi0  temp];

  
