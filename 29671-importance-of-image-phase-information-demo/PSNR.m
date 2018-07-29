function psnr_Value = PSNR(A,B)
% PSNR (Peak Signal to noise ratio)

if (size(A) ~= size(B))
   error('The size of the 2 matrix are unequal')

   psnr_Value = NaN;
   return; 
elseif (A == B)
   disp('Images are identical: PSNR has infinite value')

   psnr_Value = Inf;
   return;   
else

    maxValue = double(max(A(:)));

    % Calculate MSE, mean square error.
    mseImage = (double(A) - double(B)) .^ 2;
    [rows columns] = size(A);
    
    mse = sum(mseImage(:)) / (rows * columns);

    % Calculate PSNR (Peak Signal to noise ratio)
    psnr_Value = 10 * log10( 255^2 / mse);
end


end % function END

%{
function [SNR,MSE]=PSNR(u0,u)

[ny,nx]=size(u0);
A=max(max(u0(:)),max(u(:)));
dif=u0(:)-u(:);

MSE=mean(dif.^2);

SNR=10*log(A*A/MSE)/log(10);
%}

% PURPOSE: To find the PSNR (peak signal-to-noise ratio) between two
%          intensity images A and B, each having values in the interval
%          [0,1]. The answer is in decibels (dB).
%
%          There is also a provision, in EXAMPLE 3 below, for images 
%          stored in the interval [0,255], i.e. 256 gray levels. 
%
% SYNOPSIS: PSNR(A,B)
%
% DESCRIPTION: The following is quoted from "Fractal Image Compression",
%              by Yuval Fisher et al.,(Springer Verlag, 1995),
%              section 2.4, "Pixelized Data".
%
%              "...PSNR is used to measure the difference between two
%              images. It is defined as
%
%                           PSNR = 20 * log10(b/rms)
%
%              where b is the largest possible value of the signal
%              (typically 255 or 1), and rms is the root mean square
%              difference between two images. The PSNR is given in
%              decibel units (dB), which measure the ratio of the peak 
%              signal and the difference between two images. An increase
%              of 20 dB corresponds to a ten-fold decrease in the rms
%              difference between two images.
%              
%              There are many versions of signal-to-noise ratios, but
%              the PSNR is very common in image processing, probably
%              because it gives better-sounding numbers than other
%              measures."
%
% EXAMPLE 1: load clown
%            A = ind2gray(X,map); % Convert to an intensity image in [0,1].
%            B = 0.95 * A;        % Make B close to, but different from, A.
%            PSNR(A,B)            % ---> "PSNR = +33.49 dB"
%
% EXAMPLE 2: A = rand(256); % A is a random 256 X 256 matrix in [0,1].
%            B = 0.9 * A;   % Make B close to, but different from, A.
%            PSNR(A,B)      % ---> "PSNR = +24.76 dB (approx)"
%
% EXAMPLE 3: For images with 256 gray levels: this function PSNR was 
%            originally written for matrix-values between 0 and 1,
%            because of MATLAB's preference for that interval.
%
%            However, suppose the matrix has values in [0,255]. Taking
%            Example 1 above, we could change the image to 256 gray levels.
%         
%            load clown
%            A = ind2gray(X,map); % Convert to intensity image in [0,1]
%            AA = uint8(255*A);   % Change to integers in [0,255]
%            BB = 0.95*AA;        % Make BB close to AA.
%
%            Now we must alter the code for this new case. Comment out the
%            existing program (using %) and uncomment the alternative 
%            underneath it.
%
%            PSNR(AA,BB)          % ---> "PSNR = +33.56 dB"
%
%            Note the slightly different result from Example 1, because
%            decimal values were rounded into integers.