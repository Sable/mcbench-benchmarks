function [saliencyFeatures,saliencyMask,saliencyMap] = PQFT_2(img,img_3,varargin)
%%PQFT is written to demonstrate the ability of generating PQFT saliency
%%map
% Article: A Novel Multiresoulution Spatiotemporal Saliency Detection Model
% and Its Applications in Image and Video Compression
% input:
% img: current image
% img_3: frame at t = -3
% Copyright LE NGO ANH CAT, The University of Nottingham, Malaysia Campus 2012

%% Read info of img 

% Tune the application for lane mark detection.
% Default value is 'general'
% Lanemark application has 'lanemark' tag
tmp_img = img;
inImg = im2double(img);
img_3 = im2double(img_3);
[row col] = size(rgb2gray(img));
visualScale = varargin{2};
inImg = imresize(inImg, [visualScale, visualScale], 'bilinear');
img_3 = imresize(img_3, [visualScale, visualScale], 'bilinear');
%% Create a quaternion image

r = inImg(:,:,1);
g = inImg(:,:,2);
b = inImg(:,:,3);

R = r - (b + g) /2;
G = g - (r + b) /2;
B = b - (r + g) /2;
Y = (r + g)/2 - abs(r - g)/2 - b;

% 2 Color channels
RG = R - G;
BY = B - Y;

% 1 Intensity channel
I = ( r + g + b ) / 3;
I_3 = sum(img_3,3) / 3;

% 1 Motion channel
M = abs(I - I_3);

% tst = zeros(varargin{2},varargin{2});
% q = quaternion(M,tst,tst,tst);
% q = quaternion(tst,RG,tst,tst);
% q = quaternion(tst,tst,BY,tst);
% q = quaternion(tst,tst,tst,I);
q = quaternion(M,RG,BY,I);

%% Test for edge features
% gray_img = rgb2gray(inImg);
% HE = double(edge(gray_img,'sobel','horizontal'));
% VE = double(edge(gray_img,'sobel','vertical'));
% q = quaternion(M,HE,VE,I);

%% Create Spatio-temporal Saliency Map by using QFT (Quaternion Fourier
%% Transform

myFFT = fft2(q);
a = ones(visualScale,visualScale)*q1 + ones(visualScale,visualScale)*q2 + ones(visualScale,visualScale)*q3;
myPhase = angle(myFFT,unit(a));

%% Display the spectrum of images with Gaussian Smoother
% tmp_myPhase = reshape(myPhase,[1 4096]);
% [n,xout] = hist(tmp_myPhase,100);
% figure;
% plot(xout,n);
% % % Gaussian Filter begin
% % gf=gausswin(8,3);
% % gf=gf/sum(gf);
% % n_smoothed=conv(gf,n);
% % figure;
% % plot(n_smoothed);
% ylabel('No of pixels');
% xlabel('Phase');
% % % Datacursors format
% % alldatacursors = findall(gcf,'type','hggroup');
% % set(alldatacursors,'FontSize',12);
saliencyMap = abs(ifft2(exp(1i*myPhase))).^2;
saliencyMap(1,1) = (saliencyMap(1,2) + saliencyMap(2,2) + saliencyMap(2,1))/3;
%% After Effect
if (isequal(varargin{1},'disk'))
    saliencyMap = imfilter(saliencyMap, fspecial('disk', 3));
elseif (isequal(varargin{1},'gaussian'))
    saliencyMap = imfilter(saliencyMap, fspecial('gaussian', 8, 3));
end
saliencyMap = mat2gray(saliencyMap);
% imshow(saliencyMap);
saliencyMask = im2bw(saliencyMap,graythresh(saliencyMap));

saliencyMap = imresize(saliencyMap, [row,col], 'bilinear');
saliencyMask = imresize(saliencyMask, [row,col], 'bilinear');

% %% LME as post-processing step
% if isequal(varargin{3},'lanemark_pospro')    
%     img = LME(img);    
%     saliencyMask = saliencyMask | (rgb2gray(img) > 0);
% end
% 
% %% Result Presentation
% img = tmp_img;
% grayImg = double(rgb2gray(img));
% 
% % % The below code line is for drawing around the lanemark
% % saliencyMask = 1 - edge(double(saliencyMask),'canny');
% saliencyFeatures = grayImg .* saliencyMask;

%% Filter the unnecessary road parts 
tmp(:,:,1) = tmp_img(:,:,1) .* uint8(saliencyMask);
tmp(:,:,2) = tmp_img(:,:,2) .* uint8(saliencyMask);
tmp(:,:,3) = tmp_img(:,:,3) .* uint8(saliencyMask);
tmp = []; % Delete temporary variable

%% Result Presentation in Grayscale or Color
img = tmp_img;

if (nargin - 2 < 3) || isequal(varargin{3},'grayscale')
    grayImg = double(rgb2gray(img));
    % saliencyMask = 1 - edge(double(saliencyMask),'canny');
    saliencyFeatures = grayImg .* saliencyMask;
elseif isequal(varargin{3},'color')
    saliencyFeatures(:,:,1) = img(:,:,1) .* uint8(saliencyMask);
    saliencyFeatures(:,:,2) = img(:,:,2) .* uint8(saliencyMask);
    saliencyFeatures(:,:,3) = img(:,:,3) .* uint8(saliencyMask);
end
end