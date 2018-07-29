function [nps, f] = calc_digital_nps(I, n, px, use_window, average_stack)

% [nps, f] = calc_digital_nps(I, n, px, use_window, average_stack)
%
% Calculates the digital noise-power spectrum (NPS) noise-only
% realizations. The following rference provides a good overview of NPS
% calculations:
% I. A. Cunningham, in Handbook of Medical Imaging (SPIE Press,
% Bellingham, USA, 2000), vol. 1.
%
% I is a stack of symmetric n-dimensional noise realizations. The
% realizations are stacked along the last array dimension of I. If
% average_stack is set, the calculated NPS is averaged over the stack to
% reduce uncertainty. px is the pixel size of the image.
%
% If use_window is set, the data is multiplied with a Hann tapering window
% prior to NPS calculation. Windowing is useful for avoiding spectral
% leakage in case the NPS increases rapidly towards lower spatial
% frequencies (e.g. power-law behaviour).
%
% nps is the noise-power spectrum of I in units of px^n, and f is the
% corresponding frequency vector.
%
% Erik Fredenberg, Royal Institute of Technology (KTH) (2010).
% Please reference this package if you find it useful.
% Feedback is welcome: fberg@kth.se.

if nargin<3 || isempty(px), px=1; end
if nargin<4 || isempty(use_window), use_window=0; end
if nargin<5 || isempty(average_stack), average_stack=0; end

stack_size=size(I,n+1);

size_I=size(I);
if any(diff(size_I(1:n)))
    error('ROI must be symmetric.');
end
roi_size=size_I(1);

% Cartesian coordinates
x=linspace(-roi_size/2,roi_size/2,roi_size);
x=repmat(x',[1 ones(1,n-1)*roi_size]);

% frequency vector
f=linspace(-0.5,0.5,roi_size)/px;

% radial coordinates
r2=0; for p=1:n, r2=r2+shiftdim(x.^2,p-1); end, r=sqrt(r2);

% Hann window to avoid spectral leakage
if use_window
    h=0.5*(1+cos(pi*r/(roi_size/2)));
    h(r>roi_size/2)=0;
    h=repmat(h,[ones(1,n) stack_size]);
else h=1;
end

% detrending by subtracting the mean of each ROI
% more advanced schemes include subtracting a surface, but that is
% currently not included
S=I; for p=1:n, S=repmat(mean(S,p), ((1:n+1)==p)*(roi_size - 1) + 1); end
%S=repmat(S,ones(1,n)*roi_size);
F=(I-S).*h;

% equivalent to fftn
for p = 1:n, F = fftshift(fft(F,[],p),p); end

% cartesian NPS
nps=abs(F).^2/...
    roi_size^n*px^n./... NPS in units of px^n
    (sum(h(:).^2)/length(h(:))); % the normalization with h is according to Gang 2010

% averaging the NPS over the ROIs assuming ergodicity
if average_stack, nps=mean(nps,n+1); end