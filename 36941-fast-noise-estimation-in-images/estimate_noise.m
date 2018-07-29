
% by Tolga Birdal
% This is an extremely simple m-file which implements the method described
% in : J. Immerkær, “Fast Noise Variance Estimation”, Computer Vision and
% Image Understanding, Vol. 64, No. 2, pp. 300-302, Sep. 1996
% 
% The function inputs a grayscale image I and returns Sigma, the noise
% estimate. Here is a sample use: 
% 
% I = rgb2gray(imread('sample.jpg'));
% Sigma=estimate_noise(I);
%         
% The advantage of this method is that it includes a Laplacian operation 
% which is almost insensitive to image structure but only depends on the 
% noise in the image. 

function Sigma=estimate_noise(I)

[H W]=size(I);
I=double(I);

% compute sum of absolute values of Laplacian
M=[1 -2 1; -2 4 -2; 1 -2 1];
Sigma=sum(sum(abs(conv2(I, M))));

% scale sigma with proposed coefficients
Sigma=Sigma*sqrt(0.5*pi)./(6*(W-2)*(H-2));

end
