function I = make_odd_by_odd(I)
%MAKE_ODD_BY_ODD strips a row and or a column so that it will be 
%an odd number of pixels in each dimension.

if ~isodd(size(I,1))
    I = I(1:end -1,:,:);
end

if ~isodd(size(I,2))
    I = I(:, 1:end -1,:);
end
% Copyright 2002 - 2009 The MathWorks, Inc.