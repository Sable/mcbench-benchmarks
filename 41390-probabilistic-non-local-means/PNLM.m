function DenoisedImg = PNLM(ObsImg,PatchSizeHalf,WindowSizeHalf,EstSigma,RhoSq)
% FUNCTION: Probabilistic Non-Local Means (PNLM) for image denoising
% =========================================================================
% INPUT: 
%       ObsImg = 2D grayscale image
%       PatchSizeHalf = half of local square patch size (e.g. 3)
%       SearchSizeHalf = half of search window size (e.g. 15)
%       EstSigma = estimated image noise standard deviation
%       RhoSq = correction parameter (e.g. 1)
% OUTPUT:
%       DenoisedImg = denoised image using PNLM
% =========================================================================
% DEMO CODE: (Please copy and paste in a new file)
%       %% 1. Input and parameter settings
%       % Load a test image
%       CleanImg = im2double(imread('cameraman.tif'));
%       % Define a true sigma 
%       TrueSigma = 20/255;
%       % Define PNLM parameters
%       PatchSizeHalf = 1; 
%       WindowSizeHalf = 10;
%       RhoSq = 1;
% 
%       %% 2. Preparations
%       % Create a noise image
%       ObsImg = randn(size(CleanImg));
%       % Create an observed image
%       ObsImg = CleanImg + ObsImg./std2(ObsImg)*TrueSigma;
%       % Define PSNR measurement
%       PSNR = @(x) -10*log10(mean2((CleanImg-x).^2));
%       % Rough estimation of noise sigma
%       tmp = sort(ObsImg(1:2:end)-ObsImg(2:2:end));
%       n = floor(numel(CleanImg)*0.03);
%       EstSigma = std2(tmp(1:end-n))/sqrt(2);
% 
%       %% 3. PNLM denoising
%       % use the true noise deviation
%       DenoisedImg.TrueSigma = PNLM(ObsImg,PatchSizeHalf,WindowSizeHalf,TrueSigma,RhoSq);
%       % use an estimated deviation
%       DenoisedImg.EstSigma = PNLM(ObsImg,PatchSizeHalf,WindowSizeHalf,EstSigma,RhoSq);
% 
%       %% 4. Visualize results
%       figure('Position', [100,100,800,800]);
%       subplot(332),imshow(CleanImg,[0,1]),title('Clean Image')
%       subplot(334),imshow(ObsImg,[0,1]),title(['Observed Image (PSNR=' num2str(PSNR(ObsImg)) ')'])
%       subplot(335),imshow(DenoisedImg.TrueSigma,[0,1]),title(['PNLM Image with true \sigma (PSNR=' num2str(PSNR(DenoisedImg.TrueSigma)) ')'])
%       subplot(336),imshow(DenoisedImg.EstSigma,[0,1]),title(['PNLM Image with est. \sigma (PSNR=' num2str(PSNR(DenoisedImg.EstSigma)) ')'])
%       subplot(337),imshow(ObsImg-CleanImg,[-1,1]),title('Observed Image -Clean Image')
%       subplot(338),imshow(DenoisedImg.TrueSigma-CleanImg,[-1,1]),title('PNLM Image with true \sigma - Clean Image')
%       subplot(339),imshow(DenoisedImg.EstSigma-CleanImg,[-1,1]),title('PNLM Image with est. \sigma - Clean Image')
% 
% =========================================================================
% PAPER INFO:
%       Yue Wu, Brian Tracey, Premkumar Natarjan, and Joseph P. Noonan, 
%       "Probabilistic Non-Local Means", 
%       IEEE Signal Processing Letters, 2013.
% -------------------------------------------------------------------------
%       PLEASE CITE THIS PAPER, IF YOU USE THIS CODE FOR ACADEMIC PURPOSES
% -------------------------------------------------------------------------
%       This code is free of academic use. For all inquiries, please contact
%       author Yue Wu (rex.yue.wu[at]gmail.com)
%
%       Last Update 04/15/2013
% =========================================================================
%% 1. Initilizations
% 1.1 Extract size infor
[Height,Width] = size(ObsImg);
% 1.2 Create temporary weight/denoised pixel matrix
u = zeros(Height,Width); 
W = u;
% 1.3 Pad image with symmetric boaders 
PaddedComplete = padarray(ObsImg,[Height,Width],'symmetric','both');
% 1.4 Get the full size of patch
PatchSizeFull = PatchSizeHalf*2+1;  
%% 2. Compute Theoretical Patch Difference Distribution
% 2.1 Compute the number of overlapping pixels
col = @(x) x(:);
O = zeros((WindowSizeHalf*2+1));
O((end+1)/2-PatchSizeHalf:(end+1)/2+PatchSizeHalf,(end+1)/2-PatchSizeHalf:(end+1)/2+PatchSizeHalf) = 1;
O = conv2(O,ones(PatchSizeFull),'same');
tmp = col(O);
Oli = [tmp(1:(end-1)/2)',tmp((end+1)/2+1:end)']';
% 2.2 Compute var[D_{l,k}] (see Eq.(23) in paper)
varD = 2*PatchSizeFull^2+Oli;
% 2.3 Compute parameters gamma and eta in gamma*ChiSq_{eta} distribution (see Eqs.(11) and (12) in paper)
gamma = varD./PatchSizeFull^2./2;
eta = PatchSizeFull^2./gamma;
%% 3. PNLM
% 3.1 Initialization
count = 1;     
imgL = padarray(ObsImg,[PatchSizeHalf,PatchSizeHalf],'symmetric','both');
% 3.2 Main loop
for dx = -WindowSizeHalf:WindowSizeHalf
    for dy = -WindowSizeHalf:WindowSizeHalf
        if dx ~=0 || dy~=0
            % Compute the Integral Image            
            imgK = PaddedComplete((Height+1+dx-PatchSizeHalf):(Height+Height+dx+PatchSizeHalf),(Width+1+dy-PatchSizeHalf):(Width+dy+Width+PatchSizeHalf));
            diff = (imgL-imgK).^2;
            II = cumsum(cumsum(diff,1),2);
            SqDist = [0,zeros(1,Width-1);zeros(Height-1,1),II(1:end-PatchSizeFull,1:end-PatchSizeFull)]...
                +II(PatchSizeFull:end,PatchSizeFull:end)...
                -[zeros(1,Width);II(1:end-PatchSizeFull,PatchSizeFull:end)]...
                -[zeros(Height,1),II(PatchSizeFull:end,1:end-PatchSizeFull)];
            % Compute PNLM weights
            w = chi2pdf(SqDist./gamma(count)/(2*EstSigma^2*RhoSq),eta(count));
            v = imgK(PatchSizeHalf+1:end-PatchSizeHalf,PatchSizeHalf+1:end-PatchSizeHalf);
            % Compute and accumalate denoised pixels
            u = u+w.*v;
            W = W+w;
            count = count+1;
        end
    end
end
% 3.3 Initial denoised image (without center pixels)
xle = u./(W+eps);
% 3.4 Compute center pixel weights
cpw = chi2pdf(PatchSizeFull^2,PatchSizeFull^2);
% 3.5 Obtain the final estimation
DenoisedImg = W./(W+cpw).*xle+cpw./(cpw+W).*ObsImg;

