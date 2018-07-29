% edgeNL: Edge detection function based on nonlinear derivatives 
%   (elementary demo):
%   This function differientiates the image to estimate the gradient. 
%   The principle is based on polarized derivatives to automatically select
%   the best edge localization.
%   The main benefits are
%     - univocal edge localization for synthetic and real images
%     - noise reduction with no regularization: the noise level is weaker than
%       the noise level in the original image
%     - better direction estimation of the gradient
%     - can product a confident edge reference map for synthetic images
%     - extremely efficient on salt noise OR pepper noise (this last case needs 
%       a change in the nonlinear derivatives)
%     - still noise reduction with regularized schemes (Canny, Demigny, ..., 
%       can also be adapted to the asymetrical filters (Prewitt, Sobel, ...)
%   Drawback
%     - no detection of vertical and horizontal "white" thin (1 pixel) lines
%   Rk: this demo only performs edge detection and does not include edge 
%       extraction (local maxima) and other steps to obtain a binary
%       edge map.
%   Written by O. Laligant - 2009, University of Burgundy
%   Ref: A Nonlinear Derivative Scheme Applied to Edge Detection, 
%       Olivier Laligant, Frederic Truchetet, IEEE Transactions on Pattern 
%       Analysis and Machine Intelligence - PAMI , vol. 32, no. 2, 
%       pp. 242-257, 2010
function edgeNL()

%  ------------- Edge detection on a simple synthetic image  ------------- 
Im = example();
figure(1), imagesc(Im);
title ('Original image');


% edge detection (nonlinear gradient estimate)
% better localization and direction estimation than the linear scheme
gI = algoNL(Im);

% For a synthetic object, the edges are localized inside the object shape
figure(2), imagesc(gI);
title('Edge detection');


% ------------- Additive gaussian white noise ------------------------

Imn = imnoise(Im, 'gaussian', 0, 0.01);
figure(3), imagesc(Imn);
title ('Noisy image');

gIn = algoNL(Imn);

figure(4), imagesc(gIn);
title('Edge detection on the noisy image');

end
% ----------------------------------------------------------------------------




%
%  --------------------------- functions  -------------------------------------
%


% ------------- computation of the nonlinear derivatives  ------------- 
% polarized derivatives
% lead to an univocal localization of edges
function [gm, gh, gv] = algoNL(I);
% for classical regularization schemes, I can be replaced by a regularized
%   version
% for asymetrical schemes (Prewitt, Sobel, etc), I must be replaced by two
%   regularized versions (the regularization is different on columns and rows)
dph = thresh0(conv2(I, [0 1 -1], 'same'));
dnh = -thresh0(-conv2(I, [1 -1 0], 'same'));
gh = dph+dnh;
dpv = thresh0(conv2(I, [0; 1; -1], 'same'));
dnv = -thresh0(-conv2(I, [1;  -1; 0], 'same'));
gv = dpv + dnv;
gm = sqrt(gh.*gh + gv.*gv);

end

% ------------- threshold -------------
function st = thresh0(s)
	st = s.*(sign(s)+1)/2;
end%function

% ------------- test image -------------
% an example of image to illustrate the localization of the method
function Im = example()
Im =[
     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
     0     0   255   255   255     0     0     0     0     0     0     0   255     0     0
     0     0   255   255   255     0     0     0     0     0     0   255   255     0     0
     0     0   255   255   255     0     0     0     0     0   255   255   255     0     0
     0     0     0     0     0     0     0     0     0   255   255   255   255     0     0
     0     0     0     0     0     0     0     0   255   255   255   255   255     0     0
     0     0     0     0     0     0     0   255   255   255   255     0     0     0     0
     0     0     0     0     0     0   255   255   255   255     0     0     0     0     0
     0     0     0     0     0   255   255   255   255   255     0     0     0     0     0
     0     0     0     0   255   255   255     0   255   255     0     0     0     0     0
     0     0     0   255   255   255     0     0     0   255   255     0     0     0     0
     0     0   255   255   255   255   255     0   255   255   255   255   255     0     0
     0     0     0   255   255   255   255   255   255   255   255   255     0     0     0
     0     0     0     0   255   255   255   255   255   255   255   255   255     0     0
     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
];
end
