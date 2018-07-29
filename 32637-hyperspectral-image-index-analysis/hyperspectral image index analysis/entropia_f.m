function [Epb Eav Etl hst] = entropia_f(I,Iclass)

% Entropy (E) of intensity image 

% 06/08/2011    - Version 4.0F

% Formula: E = -sum(p.*log2(p));

% Author:           Aristidis D. Vaiopoulos
% Acknowledgement:  Mathworks MATLAB entropy function



% If image class is not forced by user, detect and use native class
if nargin == 1;
    Iclass = class(I);
end
% Construct the bin values and convert image according to Iclass
switch Iclass
   case {'logical'}
%       cs = 1;
      cl = 2^1;
      I = logical(I);
      bv = [0 1];
   case {'uint8'}
%       cs = 2;
      cl = 2^8;
      I = im2uint8(I);
      bv = 0:(2^8)-1;
   case {'int16'}
%       cs = 3;
      cl = 2^16;
      I = im2int16(I);
      bv = -( (2^16)/2 ):( (2^16)/2-1 );
   case {'uint16'}
%       cs = 4;
      cl = 2^16;
      I = im2uint16(I);
      bv = 0:(2^16)-1;
   case {'single','double'}
%       cs = 5;
      cl = 2^16;
      I = im2uint16(I);
      bv = 0:(2^16)-1;  
    otherwise
%       cs = -1;
      disp('-Unsupported data class.')
    return;
      
end
% Transpose bin values
bv = bv';

% Find the number of bands
bands = size(I);
if length(bands) == 3
    bands = bands(1,3);
else
    bands = 1;
end
% Calculate histogram counts per band
p = zeros(cl,bands);
for b = 1:bands
    p(:,b) = imhist(I(:,:,b),cl);
end

% Give histogram
if nargout == 4
    hst = [bv p];
end
% normalize p so that sum(p) is one.
p = p ./ (numel(I)/bands);
% normalize p for whole image.
pt = sum(p,2)/bands;
% logarithmization
lp = log2(p);
lpt= log2(pt);
% nullify -Inf values due to logarithmization of zeros in p
lp(isinf(lp)) = 0;
lpt(isinf(lpt)) = 0;
% Entropy per band
Epb = -sum(p.*lp,1)';
% Average Entropy
Eav = mean(Epb);
% Total Entropy (whole image)
Etl = -sum(pt.*lpt);

end