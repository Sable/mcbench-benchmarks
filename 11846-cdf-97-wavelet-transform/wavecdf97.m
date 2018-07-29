function c = wavecdf97(x, nlevel)
%WAVECDF97: Multi-level discrete 2-D wavelet transform 
%with the Cohen-Daubechies-Feauveau (CDF) 9/7 wavelet. 
%
% c = wavecdf97(x, nlevel) does the follows according to the value of 
%   nlevel:
%   nlevel > 0:   decomposes 2-dimension matrix x up to nlevel level;
%   nlevel < 0:   does the inverse transform to nlevel level;
%   nlevel = 0:   sets c equal to x;
%   omitted:      does the same as nlevel=5.  
%
% The boundary handling method is symmetric extension. 
%
% x may be of any size; it need not have size divisible by 2^L.
%   For example, if x has length 9, one stage of decomposition
%   produces a lowpass subband of length 5 and a highpass subband
%   of length 4.  Transforms of any length have perfect
%   reconstruction (exact inversion).
%   NOTE: the 5 lines above are quoted directly form [3].
%   
% If nlevel is so large that the approximation coefficients become 
%   a 1-D array, any further decomposition will be performed as for 1-D 
%   decomposition until the approximation coefficients be a scale number.  
%
% Lifting algorithm is not used here; we use subband filters directly.
%   Lifting algorithm and spline 5/3 wavelets and other jpeg2000 related 
%   codes will be available soon. 
%
% Example:
%   Y = wavecdf97(X, 5);    % Decompose image X up to 5 level
%   R = wavecdf97(Y, -5);   % Reconstruct from Y
%
% You can test wavecdf97.m with the following lines:     
%   % get a 2-D uint8 image 
%   x=imread('E:\study\jpeg2000\images\lena.tif');
%   % decompose
%   y=wavecdf97(x,2);
%   % show decomposed result 
%   figure;imshow(mat2gray(y));
%   % reconstruct without change of anything
%   ix=wavecdf97(y,-2);
%   % show and compare the original and reconstructed images
%   figure;subplot(1,2,1);imshow(x);subplot(1,2,2);imshow(uint8(ix));
%   % look at the MSE difference 
%   sum(sum((double(x)-ix).^2))/numel(x)
%
% Reference:
%   [1] D.S.Taubman et al., JPEC2000 Image Compression: F. S. & P.,
%       Chinese Edition, formula 10.6-10.9 in section 10.3.1 
%       and formula 10.13 in section 10.4.1.
%   [2] R.C.Gonzalez et al., Digital Image Processing Using MATLAB, 
%       Chinese Edition, function wavefast in section 7.2.2.
%   [3] Pascal Getreuer, waveletcdf97.m from Matlab file Exchange website
%   [4] Matlab files: biorwavf.m, wavdec2.m, wawrec2.m, etc.
%   
% Contact information: 
%   Email/MSN messenger:  wangthth@hotmail.com
%
% Tianhui Wang at Beijing, China,   July, 2006
%                  Last Revision:   Aug 5, 2006

%---------------------- input arguments checking  ----------------------%
error(nargchk(1,2,nargin));
if nargin == 1
    nlevel = 5; % default level
end
% check x
if ~isreal(x) || ~isnumeric(x) || (ndims(x) > 2)
    error('WAVELIFT:InArgErr', ['The first argument must' ...
        ' be a real, numeric 2-D or 1-D matrix.']);
end
if isinteger(x)
    x = double(x);
end
% check nlevel
if ~isreal(nlevel) || ~isnumeric(nlevel) || round(nlevel)~=nlevel
    error('WAVELIFT:InArgErr', ['The 2nd argument shall be ' ...
        'a real and numeric integer.']);
end
%---------------- forming low-pass and high-pass filters ---------------%
% CDF 9/7 filters: decomposition low-pass lp and high-pass hp
%                  reconstruction low-pass lpr and high-pass hpr
% The filter coefficients have several forms.
% What D.S.Taubman et al. suggest in [1] are used here:
lp = [.026748757411 -.016864118443 -.078223266529 .266864118443];
lp = [lp .602949018236 fliplr(lp)];
hp = [.045635881557 -.028771763114 -.295635881557];
hp = [hp .557543526229 fliplr(hp)];
lpr = hp .* [-1 1 -1 1 -1 1 -1] * 2;
hpr = lp .* [1 -1 1 -1 1 -1 1 -1 1] * 2;
% Matlab 'bior4.4' use the varied version (see Matlab's biorwavf.m):
%  lp=lp*sqrt(2);hp=hp*(-sqrt(2));lpr=lpr*(1/sqrt(2));hpr=hpr*(-1/sqrt(2));
% P.Getreuer's waveletcdf97.m [3] alters the Taubman's version as follows:
%  lp=lp*sqrt(2);hp=hp*sqrt(2);lpr=lpr*(1/sqrt(2));hpr=hpr*(1/sqrt(2));
% while R.C.Gonzalez et al in [2] alter the Taubman's version as follows:
%  lp=lp;hp=hp*(-2);lpr=lpr;hpr=hpr*(-1/2);
%----------------  remain unchanged when nlevel = 0  -------------------%
if nlevel == 0
    c = x;
%--------------------  decomposition,  if nlevel < 0  ------------------%
elseif nlevel > 0
    c = zeros(size(x));
    x = double(x);
    for i = 1:nlevel
        % [ll, hl; lh, hh]: 1-level FWT for x 
        temp = symconv2(x, hp, 'col');    % high filtering
        temp = temp(2:2:end, :);          % down sampling
        hh = symconv2(temp, hp, 'row');   % high filtering 
        hh = hh(:, 2:2:end);              % down sampling
        lh = symconv2(temp, lp, 'row');   % low filtering
        lh = lh(:, 1:2:end);              % down sampling
        
        temp = symconv2(x, lp, 'col');    % low filtering
        temp = temp(1:2:end, :);          % down sampling
        hl = symconv2(temp, hp, 'row');   % high filtering
        hl = hl(:, 2:2:end);              % down sampling
        ll = symconv2(temp, lp, 'row');   % low filtering
        ll = ll(:, 1:2:end);              % down sampling
        % update coefficient matrix
        c(1:size(x,1), 1:size(x,2)) = [ll, hl; lh, hh];
        % replace x with ll for next level FWT
        x = ll;
        % give a warning if nlevel is too large
        if size(x,1)<=1 && size(x,2)<=1 && i~=nlevel
            warning('WAVECDF97:DegradeInput', ['Only decompose to ' ...
                num2str(i) '-level instead of ' num2str(nlevel) ...
                ', \nas the approximation coefficients at ' num2str(i) ...
                '-level has row or/and column of length 1.']);
            break
        end
    end
%--------------------  reconstruction,  if nlevel < 0  -----------------%
else
    sx = size(x);
    % find reconstruction level
    nl = -nlevel;
    while sx(1)/2^nl<=1/2 && sx(2)/2^nl<=1/2,  nl = nl-1;  end
    if nl ~= -nlevel 
        warning('WAVECDF97:DegradeInput', ['Only reconstruct to ' ...
            num2str(nl) '-level instead of ' num2str(-nlevel) ...
            ', \nas the approximation coefficients at ' num2str(nl) ...
            '-level has row or/and column of length 1.']);
    end
    % nl-level reconstruction
    for i = 1:nl
        % find the target ll hl lh hh blocks
        sLL = ceil(sx/2^(nl-i+1));
        sConstructed = ceil(sx/2^(nl-i));
        sHH = sConstructed - sLL;
        lrow = sConstructed(1); lcol = sConstructed(2);

        ll = x(1:sLL(1), 1:sLL(2));
        hl = x(1:sLL(1), sLL(2)+1:sLL(2)+sHH(2));
        lh = x(sLL(1)+1:sLL(1)+sHH(1), 1:sLL(2));    
        hh = x(sLL(1)+1:sLL(1)+sHH(1), sLL(2)+1:sLL(2)+sHH(2));

        % upsample rows and low filter
        temp = zeros(sLL(1), lcol); temp(:, 1:2:end) = ll;
        ll = symconv2(temp, lpr, 'row'); 
        % upsample rows and high filter    
        temp = zeros(sLL(1), lcol); temp(:, 2:2:end) = hl;
        hl = symconv2(temp, hpr, 'row');
        % upsample columns and low filter      
        temp = zeros(lrow, lcol); temp(1:2:end, :) = ll + hl;
        l = symconv2(temp, lpr, 'col');  

        % upsample rows and high filter       
        temp = zeros(sHH(1), lcol); temp(:, 1:2:end) = lh;
        lh = symconv2(temp, lpr, 'row');
        % upsample rows and high filter       
        temp = zeros(sHH(1), lcol); temp(:, 2:2:end) = hh;
        hh = symconv2(temp, hpr, 'row');
        % upsample rows and high filter       
        temp = zeros(lrow, lcol); temp(2:2:end, :) = lh + hh;
        h = symconv2(temp, hpr, 'col');

        % update x with the new ll, ie. l+h
        x(1:lrow, 1:lcol) = l + h;
    end    
    % output
    c = x;
end
%------------------------- internal function  --------------------------%
%       2-dimension convolution with edges symmetrically extended       %
%-----------------------------------------------------------------------%
function y = symconv2(x, h, direction)
% symmetrically extended convolution(see section 6.5.2 in [1]):
%    x[n], E<=n<=F-1, is extended to x~[n] = x[n], 0<=n<=N-1;
%                                  x~[E-i] = x~[E+i], for all integer i
%                                x~[F-1-i] = x~[F-1+i], for all integer i
%    For odd-length h[n], to convolve x[n] and h[n], we just need extend x 
%    by (length(h)-1)/2  for both left and right edges. 
% The symmetric extension handled here is not the same as in Matlab 
%  wavelets toolbox nor in [2]. The last two use the following method:
%    x[n], E<=n<=F-1, is extended to x~[n] = x[n], 0<=n<=N-1;
%                                  x~[E-i] = x~[E+i-1], for all integer i
%                                x~[F-1-i] = x~[F+i], for all integer i 

l = length(h); s = size(x);
lext = (l-1)/2; % length of h is odd 
h = h(:)'; % make sure h is row vector 
y = x;
if strcmp(direction, 'row') % convolving along rows
    if ~isempty(x) && s(2) > 1 % unit length array skip convolution stage
        for i = 1: lext
            x = [x(:, 2*i), x, x(:, s(2)-1)]; % symmetric extension
        end
        x = conv2(x, h);
        y = x(:, l:s(2)+l-1); 
    end
elseif strcmp(direction, 'col') % convolving along columns
    if ~isempty(x) && s(1) > 1 % unit length array skip convolution stage
        for i = 1: lext 
            x = [x(2*i, :); x; x(s(1)-1, :)]; % symmetric extension
        end
        x = conv2(x, h');
        y = x(l:s(1)+l-1, :);
    end
end    
% EOF