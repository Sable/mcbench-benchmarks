function out = pointOp(im,Y,X)
% Apply a 1D profile onto a 2d matrix
% Input:
%       im:     input matrix
%      Y,X:     two vectors define 1D profile
% Output:
%      out:     interpolated matrix

temp=interp1(X, Y, im(:), 'linear', 'extrap');
out = reshape(temp,size(im));

