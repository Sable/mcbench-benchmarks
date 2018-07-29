% Dual tree complex wavelet transform (DT-CWT) based image fusion demo
% By VPS Naidu, MSDF Lab, June 2011
% DT-CWT software used in this fusion algorithm is from 
clear all; close all; home;

% User selection (1,2,3,...)
J = 6; % number of decomposition levels used in the fusion 


[Faf,Fsf] = FSfarras; % first stage filters
[af,sf] = dualfilt1;  % second stage filters


% images to be fused
im1 = double(imread('saras91.jpg'));
im2 = double(imread('saras92.jpg'));
figure; subplot(121);imshow(im1,[]); subplot(122); imshow(im2,[]);

% image decomposition
w1 = cplxdual2D(im1,J,Faf,af);
w2 = cplxdual2D(im2,J,Faf,af);

% Image fusion process start here
for j=1:J % number of stages
    for p=1:2 %1:real part & 2: imaginary part
        for d1=1:2 % orientations
            for d2=1:3
                x = w1{j}{p}{d1}{d2};
                y = w2{j}{p}{d1}{d2};
                D  = (abs(x)-abs(y)) >= 0; 
                wf{j}{p}{d1}{d2} = D.*x + (~D).*y; % image fusion
            end
        end
    end
end
for m=1:2 % lowpass subbands
    for n=1:2
        wf{J+1}{m}{n} = 0.5*(w1{J+1}{m}{n}+w2{J+1}{m}{n}); % fusion of lopass subbands
    end
end

% fused image
imf = icplxdual2D(wf,J,Fsf,sf);
figure; imshow(imf,[]); 