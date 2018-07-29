
function A = DCC(I,k,T)
% This function implements the image interpolation algorithm
% based on the directional cubic convolution interpolation which
% has been described in the paper:
% D. Zhou, X. Shen, and W. Dong, 
% Image zooming using directional cubic convolution interpolation, 
% IET Image Processing, Vol. 6, No. 6, pp. 627-634, 2012.
%  
%       I(:,:)   inputted low resolution gray image, range 0~1
%       k        the weighted exponent
%       T        the threshold of the gradient ratio
%       A(:,:)   outputted high resolution image
%
% Copyright (c) May 28, 2009. Dengwen Zhou. All rights reserved.
% Department of Computer Science & Technology
% North China Electric Power University(NCEPU)
% Email: zdw@ncepu.edu.cn
%
% Last time modified: Oct. 11, 2012
%

% Read the image size
[m,n] = size(I);
nRow = 2*m;
nCol = 2*n;

% Initialize the output image
A = zeros(nRow,nCol);
A(1:2:end-1,1:2:end-1) = I;

% Do the cubic convolution interpolation
for i = 4:2:nRow-4
for j = 4:2:nCol-4
    
    % Compute the weights and interpolation direction
    [w,n] = DetectDirect(A(i-3:i+3,j-3:j+3),1,k,T);
    
    % Compute the pixel value
    A(i,j) = PixelValue(A(i-3:i+3,j-3:j+3),1,w,n);

end
end

for i = 5:2:nRow-5
for j = 4:2:nCol-4
    
    % Compute the weights and interpolation direction
    [w,n] = DetectDirect(A(i-2:i+2,j-2:j+2),2,k,T);
    
    % Compute the pixel value
    A(i,j) = PixelValue(A(i-3:i+3,j-3:j+3),2,w,n);
    
end
end

for i = 4:2:nRow-4
for j = 5:2:nCol-5
    
    % Compute the weights and interpolation direction
    [w,n] = DetectDirect(A(i-2:i+2,j-2:j+2),3,k,T);
    
    % Compute the pixel value
    A(i,j) = PixelValue(A(i-3:i+3,j-3:j+3),3,w,n);
    
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [w,n] = DetectDirect(A,type,k,T)
% Detect the interpolation directions
%  
%       A(:,:)    inputted 7x7 neighboring matrix. The center is
%                 the detected pixel.
%       type      inputted type of the position of the detected 
%                 pixel. type = 1, 2, or 3.
%       k         the weighted exponent
%       T         the threshold of the gradient ratio
%------------------------------------------------------------------------
%       w(;)      outputted directional weight vector. It has only
%                 2 elements.
%       n         outputted directional index. n = 1, 2, or 3.
%                 n = 1     the gradient is greater in 45 degree 
%                           diagnal or horizontal direction
%                 n = 2     the gradient is greater in 135 degree
%                           diagnal or vertical direction
%                 n = 3     the interpolated pixel is in the smooth area
%------------------------------------------------------------------------

% Compute the sum of the pixel differences
if type == 1
   % 45 degree diagonal direction
   t1 = abs(A(3,1)-A(1,3));   
   t2 = abs(A(5,1)-A(3,3))+abs(A(3,3)-A(1,5));     
   t3 = abs(A(7,1)-A(5,3))+abs(A(5,3)-A(3,5))+abs(A(3,5)-A(1,7)); 
   t4 = abs(A(7,3)-A(5,5))+abs(A(5,5)-A(3,7)); 
   t5 = abs(A(7,5)-A(5,7)); 
   d1 = t1+t2+t3+t4+t5;
   
   % 135 degree diagonal direction
   t1 = abs(A(1,5)-A(3,7));   
   t2 = abs(A(1,3)-A(3,5))+abs(A(3,5)-A(5,7));   
   t3 = abs(A(1,1)-A(3,3))+abs(A(3,3)-A(5,5))+abs(A(5,5)-A(7,7)); 
   t4 = abs(A(3,1)-A(5,3))+abs(A(5,3)-A(7,5));
   t5 = abs(A(5,1)-A(7,3));
   d2 = t1+t2+t3+t4+t5;
else
   % horizontal direction
   t1 = abs(A(1,2)-A(1,4))+abs(A(3,2)-A(3,4))+abs(A(5,2)-A(5,4));
   t2 = abs(A(2,1)-A(2,3))+abs(A(2,3)-A(2,5));
   t3 = abs(A(4,1)-A(4,3))+abs(A(4,3)-A(4,5));
   d1 = t1+t2+t3;   
   
   % vertical direction
   t1 = abs(A(2,1)-A(4,1))+abs(A(2,3)-A(4,3))+abs(A(2,5)-A(4,5));
   t2 = abs(A(1,2)-A(3,2))+abs(A(3,2)-A(5,2));
   t3 = abs(A(1,4)-A(3,4))+abs(A(3,4)-A(5,4));
   d2 = t1+t2+t3;
end

% Compute the weight vector
w1 = 1+d1^k; 
w2 = 1+d2^k;
w = [1/w1 1/w2];

% Compute the directional index
n = 3;
if (1+d1)/(1+d2) > T
   n = 1;
elseif (1+d2)/(1+d1) > T
   n = 2;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function p = PixelValue(A,type,w,n)
% Compute the pixel value.
%  
%       A(:,:)    inputted 7x7 neighboring matrix. The center is the
%                 interpolated pixel.
%       type      inputted type of the position of the interpolated 
%                 pixel. type = 1, 2, or 3.
%       w(:)      inputted directional weight vector. It has only 2
%                 elements.
%       n         inputted directional index. n = 1, 2, or 3.
%                 n = 1     the gradient is greater in 45 degree 
%                           diagnal or horizontal direction
%                 n = 2     the gradient is greater in 135 degree
%                           diagnal or vertical direction
%                 n = 3     the interpolated pixel is in the smooth area
%---------------------------------------
%       p         outputted pixel value
%---------------------------------------

f = [-1 9 9 -1]/16;
if type == 1
   v1 = [A(7,1) A(5,3) A(3,5) A(1,7)];
   v2 = [A(1,1) A(3,3) A(5,5) A(7,7)];
else
   v1 = [A(4,1) A(4,3) A(4,5) A(4,7)];
   v2 = [A(1,4) A(3,4) A(5,4) A(7,4)];
end
if n == 1
   p = sum(v2.*f);
elseif n == 2
   p = sum(v1.*f);
else
   p1 = sum(v1.*f);
   p2 = sum(v2.*f);
   p = (w(1)*p1+w(2)*p2)/(w(1)+w(2));
end
