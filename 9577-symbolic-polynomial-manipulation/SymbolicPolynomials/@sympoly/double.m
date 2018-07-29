function dbl=double(sp)
% sympoly/double: convert a constant polynom array (or scalar) to a double
% usage: dbl=double(sp);
% 
% arguments:
%  sp - sympoly object - scalar or a sympoly array - must all be constants
%
%  dbl - double array of the same size as sp

dbl=zeros(size(sp));
for i=1:numel(sp)
  spi = sp(i);
  
  E = spi.Exponent;
  if any(E(:)~=0)
    error 'This sympoly is not a constant'
  end
  
  dbl(i) = sum(spi.Coefficient);
end

