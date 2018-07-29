function distMap = MTM_PWC(img1, img2, foreground, L, alpha)
%MTM_PWC  COmputes the distance between two images using Matching by Tone Mapping (MTM).
%  distMap = MTM_PWC(img1, img2, fore, L, alpha) computes the distance
%  between two images using piecewise-constant (PWC) approximation of
%  Matching by Tone Mapping (MTM).
%
%    img1 & img2 - two grayscale images to be compared
%    foreground -  binary foreground mask (contains 1 for object and
%         shadowed pixels,  0 otherwise)
%    L - window size
%    alpha - vector of increasing values representing bin boundaries.
%          Boundaries should bound the im1 and im2 gray value range.

%  Written by: Elad Bullkich, Idan Ilan, Yair Moshe
%  Signal and Image Processing Laboratory (SIPL)
%  Department of Electrical Engineering
%  Technion - Israel Institute of Technology
%
%  $Revision 1.1        $Date: 6/17/2012

% Reference:
% E. Bullkich, I. Ilan, Y. Moshe, Y. Hel-Or, and H. Hel-Or, "Moving Shadow
% Detection by Nonlinear Tone-Mapping," Proc. of 19th Intl. Conf. on
% Systems, Signals and Image Processing (IWSSIP 2012), Vienna, April 2012.
% [Online]  http://sipl.technion.ac.il/~yair/

%% initializations
boxFiler = ones(L, L);                  % box filter
k = length(alpha) - 1;                    % number of bins

%% compute denominator
p = double(img1).*double(foreground);
W1 = conv2(p, boxFiler, 'same');
W2 = conv2(p.^2, boxFiler, 'same');
D2 = (W2 - W1.^2 ./ (L^2));

%% accumulate numerator
D1 = zeros(size(img1));
for j = 1:k
    % a slice contains all pixels in the foreground that are in the jth bin
    maskedSlice = ((img2 >= alpha(j)) & (img2 < alpha(j+1))).*foreground;
    pj = double(maskedSlice).*double(img1);
    
    % compute norm
    n = conv2(double(maskedSlice), boxFiler, 'same');
    n(n == 0) = 1; % avoid division by zero
    
    % compute normalized inner product
    T = conv2(pj, boxFiler, 'same');
    T = (T.*T)./n;
    
    % update accum
    D1 = D1 + T;
end;

%% compute distance
distMap = ((W2 - D1)+ 0.001)./(D2 + 0.001).*foreground;

end