function out = reconSpyrLevs(coeff,lofilt,bfilts)

% Recursive function for reconstructing levels of a steerable pyramid representation.  
% This is called by reconSpyr, and is not usually called directly.
%
% Input:
%     coeff:    the pyramid
%    lofilt:    lowpass filter
%    bfilts:    directional filter
%
% Output:
%       out:    original image

nbands = length(bfilts);

if  (length(coeff)==1) 
% Only Lowpass left
    out = coeff{1};
    
else
% Bandpass residue
    bands=coeff{1};
    bres=zeros(size(coeff{1}{1}));
    for b = 1:nbands
        bres = bres+upConv(bands{b},bfilts{b},[1 1]);
    end

% Lowpass component are upsampled and convoluted    
    temp = reconSpyrLevs(coeff(2:length(coeff)),lofilt, bfilts);
    temp=upConv(temp,lofilt,[2 2]);

% Add all residue together    
    out=temp+bres;
end

