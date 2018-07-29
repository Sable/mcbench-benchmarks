function y = meanShiftPixCluster(x,hs,hr,th,plotOn)
% FUNCTION: meanShiftPixCluster implements the classic mean shift pixel
% clustering algorithm introduced in Cmaniciu etal.'s PAMI paper 
% "Mean shift: a robust apporach toward feature space analysis", 2002.
% -------------------------------------------------------------------------
% Input: 
%       x = an input image (either gray or rgb, please expect long time processing if image size is large)
%      hs = the bandwidth of spatial kernel (see Eq.(35) in the cited paper)
%      hr = the bandwidth of feature kernel (see Eq.(35) in the cited paper)
%      th = the threshod of the convergence criterion (default = .25)
%  plotOn = switch on/off the image display of intermediate results (default = 1)
%
% Output:
%       y = the output clustered image
% -------------------------------------------------------------------------
% Demo (please cut and paste):
%
%      clear all 
%      close all
%      clc
% 
%      x = imread('cameraman.tif');
%      x = imnoise(x,'Gaussian',.001);
%      y = meanShiftPixCluster(x,8,10);
%      figure
%      subplot(231), imshow(x), title('Input Image')
%      subplot(232), contour(flipud(x)),colormap(jet),axis on, title('Initial Image Contours'),axis square
%      subplot(233), imhist(x), title('Input Histogram'),axis square
%      subplot(234), imshow(y,[0,255]), title('Clusterd Image')
%      subplot(235), contour(flipud(y)),title('Output Image Contours'),axis square
%      subplot(236), imhist(uint8(y)), title('Output Image Histogram'),axis square
% -------------------------------------------------------------------------
% Additional Info:
% This is a toy code of mean shift pixel clustering, but it did cover the
% core idea od mean shift. One may extend the current code for
% multiresolution analysis, or replace new kernel functions instead of
% gaussian kernels used in this implementations. Details of parameters and
% their influence on clustering results and the convergence proof of the
% mean shift algorithm please refer the cited paper. 
%
% Please play with this code with other images and parameters. Contact me
% if you find any bugs.
%
% by Yue Wu
% rex.yue.wu@gmail.com
% 03/27/2013
% 
% ------------------------------------------------------------------------- 

%% Argument Check
if nargin<3
    error('please type help for function syntax')
elseif nargin == 3
    th = .25; plotOn = 1;
elseif nargin == 4
    if th<0 || th >255
        error('threshold should be in [0,255]')
    else
        plotOn = 1;
    end
elseif nargin == 5
    if sum(ismember(plotOn,[0,1])) == 0
        error('plotOn option has to be 0 or 1')
    end
elseif nargin>5
    error('too many input arguments')
end
%% initialization
x = double(x);
[height,width,depth] = size(x);
y = x;
done = 0;
iter = 0;
if plotOn 
    figure(randi(1000)+1000); 
end
% padding image to deal with pixels on borders
xPad = padarray(x,[height,width,0],'symmetric');
%% main loop
while ~done
    weightAccum = 0;
    yAccum = 0;
    % only 99.75% area (3sigma) of the entire non-zero Gaussian kernel is considered
    for i = -3*hs:3*hs
        for j = -3*hs:3*hs
            % spatial kernel weight 
            spatialKernel = exp(-(i^2+j^2)/hs^2/2);
            xThis =  xPad(height+i:2*height+i-1, width+j:2*width+j-1, 1:depth);
            xDiff = abs(y-xThis);
            xDiffSq = xDiff.^2./hr^2;
            % deal with multi-channle image
            if depth > 1
                xDiffSq = repmat(sum(xDiffSq,3),[1,1,depth]);
            end
            % feature kernel weight
            intensityKernel = exp(-xDiffSq./2);
            % mixed kernel weight
            weightThis = spatialKernel.*intensityKernel.*xDiff;
            % update accumulated weights
            weightAccum = weightAccum+ weightThis;
            % update accumulated estimated ys from xs 
            yAccum = yAccum+xThis.*weightThis;
        end
    end
    % normalized y (see Eq.(20) in the cited paper)
    yThis = yAccum./(weightAccum+eps);
    % convergence criterion
    yMSE = mean((yThis(:)-y(:)).^2);
    if yMSE <= th % exit if converge
        done = 1;
    else % otherwise update estimated y and repeat mean shift
        y = yThis;
        iter = iter+1;
        if plotOn
            drawnow, imshow(uint8(y)),axis image, title(['iteration times = ' num2str(iter) '; mse = ' num2str(yMSE)]);
        end
    end
end

