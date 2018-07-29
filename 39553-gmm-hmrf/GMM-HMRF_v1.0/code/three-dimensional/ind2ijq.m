%%  index to i, j and q conversion
%   ind: index
%   m: height of each image slice
%   n: width of each image slice
%   i, j, q: 3D image coordinates

function [i j q]=ind2ijq(ind,m,n)
q=floor((ind-1)/(m*n))+1;
ind=ind-(q-1)*m*n;
i=mod(ind-1,m)+1;
j=floor((ind-1)/m)+1;