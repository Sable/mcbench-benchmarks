function DenoisedImg = FAST_NLM_II(NoisyImg,PatchSizeHalf,WindowSizeHalf,Sigma)
% -------------------------------------------------------------------------
% Function FAST_NLM_II (Fast Non-Local Mean Image Denoising using Integral Image)
% Implemented method from the paper 
% "FAST NONLOCAL FILTERING APPLIED TO ELECTRON CRYOMICROSCOPY" By Darbon et al.
% -------------------------------------------------------------------------
% Inputs: 
%       NoisyImg = a gray-scale image of an arbitrary size
%  PatchSizeHalf = an integer indicating the neighbourhood size for weight computation
% WindowSizeHalf = an integer indicating the size of searching region
%          Sigma = a decimal that can be interpreted as the noise level in the NoisyImg
%
% Outputs:
%    DenoisedImg = a denoised image of using the NLM method
% -------------------------------------------------------------------------
% Demo:
%       mse = @(a,b) (a(:)-b(:))'*(a(:)-b(:))/numel(a);
%       snr = @(clean,noisy) 20*log10(mean(noisy(:))/mean(abs(clean(:)-noisy(:))));
%       I = im2double(imread('cameraman.tif'));
%       N = imnoise(I,'gaussian',0,.001);
%       D = FAST_NLM_II(N,5,3,0.15);
%       subplot(1,3,1),imshow(I,[]),title('Clean Image')
%       subplot(1,3,2),imshow(N,[]),title(['Noisy Image, mse = ' num2str(mse(I,N)), ', snr = ', num2str(snr(I,N))])
%       subplot(1,3,3),imshow(D,[]),title(['Denoised Image, mse = ' num2str(mse(I,D)), ', snr = ', num2str(snr(I,D))])
% -------------------------------------------------------------------------
% NOTE:
% In Darbon's paper, these variables correspond to the following variables in paper equations:
% NoisyImg = v; PatchSizeHalf = P, WindowSizeHalf = K, Sigma = h, and DenoisedImg = u. 
% -------------------------------------------------------------------------
% By Yue (Rex) Wu
% ECE Dept. @ Tufts Univ.
% 09/16/2012
% -------------------------------------------------------------------------

%% NLM_II  
% Get Image Info
[Height,Width] = size(NoisyImg);
% Initialize the denoised image
u = zeros(Height,Width); 
% Initialize the weight max
M = u; 
% Initialize the accumlated weights
Z = M;
% Pad noisy image to avoid Borader Issues
PaddedImg = padarray(NoisyImg,[PatchSizeHalf,PatchSizeHalf],'symmetric','both');
PaddedV = padarray(NoisyImg,[WindowSizeHalf,WindowSizeHalf],'symmetric','both');
% Main loop
for dx = -WindowSizeHalf:WindowSizeHalf
    for dy = -WindowSizeHalf:WindowSizeHalf
        if dx ~= 0 || dy ~= 0
        % Compute the Integral Image 
        Sd = integralImgSqDiff(PaddedImg,dx,dy); 
        % Obtaine the Square difference for every pair of pixels
        SqDist = Sd(PatchSizeHalf+1:end-PatchSizeHalf,PatchSizeHalf+1:end-PatchSizeHalf)+Sd(1:end-2*PatchSizeHalf,1:end-2*PatchSizeHalf)-Sd(1:end-2*PatchSizeHalf,PatchSizeHalf+1:end-PatchSizeHalf)-Sd(PatchSizeHalf+1:end-PatchSizeHalf,1:end-2*PatchSizeHalf);       
        % Compute the weights for every pixels
        w = exp(-SqDist/(2*Sigma^2));
        % Obtaine the corresponding noisy pixels
        v = PaddedV((WindowSizeHalf+1+dx):(WindowSizeHalf+dx+Height),(WindowSizeHalf+1+dy):(WindowSizeHalf+dy+Width));
        % Compute and accumalate denoised pixels
        u = u+w.*v;
        % Update weight max
        M = max(M,w);
        % Update accumlated weighgs
        Z = Z+w;
        end
    end
end
% Speical controls to accumlate the contribution of the noisy pixels to be denoised        
f = 1;
u = u+f*M.*NoisyImg;
u = u./(Z+f*M);
% Output denoised image
DenoisedImg = u;

function Sd = integralImgSqDiff(v,dx,dy)
% FUNCTION intergralImgDiff: Compute Integral Image of Squared Difference
% Decide shift type, tx = vx+dx; ty = vy+dy
t = img2DShift(v,dx,dy);
% Create sqaured difference image
diff = (v-t).^2;
% Construct integral image along rows
Sd = cumsum(diff,1);
% Construct integral image along columns
Sd = cumsum(Sd,2);

function t = img2DShift(v,dx,dy)
% FUNCTION img2DShift: Shift Image with respect to x and y coordinates
t = zeros(size(v));
type = (dx>0)*2+(dy>0);
switch type
    case 0 % dx<0,dy<0: move lower-right 
        t(-dx+1:end,-dy+1:end) = v(1:end+dx,1:end+dy);
    case 1 % dx<0,dy>0: move lower-left
        t(-dx+1:end,1:end-dy) = v(1:end+dx,dy+1:end);
    case 2 % dx>0,dy<0: move upper-right
        t(1:end-dx,-dy+1:end) = v(dx+1:end,1:end+dy);
    case 3 % dx>0,dy>0: move upper-left
        t(1:end-dx,1:end-dy) = v(dx+1:end,dy+1:end);
end
% -------------------------------------------------------------------------
