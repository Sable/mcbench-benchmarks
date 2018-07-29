function B=autocorr2d(H)

% Compute the 2D  autocorrelation of matrix ( Image )
% Algorithm based on Wiener - Khintchine Theorem*.
%
% * :http://mathworld.wolfram.com/Wiener-KhinchinTheorem.html
%
% Special Case : 
% 2D zero mean Gaussian process with variance=1:
%           ==========================
%           | P=randn(400,600);      |
%           | CorrFunc=autocorr2d(H);|
%           ==========================
% CorrFunc is symmetric with Dirac impulsion in the center.
% with max(CorrFunc(:))=1
% July, 24, 2012
% KHMOU Youssef

[n m]=size(H);
% Divide by the size for normalization

B=abs(fftshift(ifft2(fft2(H).*conj(fft2(H)))))./(n*m);
figure, surf(B);
shading interp;