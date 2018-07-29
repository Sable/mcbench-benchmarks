function A = hmf(A,n)

%HMF Hybrid median filtering.
%   B = HMF(A,N) performs hybrid median filtering of the matrix A using a
%   NxN box. Hybrid median filtering preserves edges better than a NxN
%   square kernel-based median filter because data from different spatial
%   directions are ranked separately. Three median values are calculated in
%   the NxN box: MR is the median of horizontal and vertical R pixels, and
%   MD is the median of diagonal D pixels. The filtered value is the median
%   of the two median values and the central pixel C: median([MR,MD,C]).
%   For N = 5:
%        |D  *  R  *  D|
%        |*  D  R  D  *|
%        |R  R  C  R  R|
%        |*  D  R  D  *|
%        |D  *  R  *  D|
%
%   B = HMF(A) uses N = 5 (default value).
%
%   A can be a 2-D array or an RGB image. If A is an RGB image, hybrid
%   median filtering is performed in the HSV color space.
%
%   Notes
%   -----
%   1) N must be odd. If N is even then N is incremented by 1.
%   2) The Image Processing Toolbox is required.
%   3) If the function NANMEDIAN exists (Statistics Toolbox), NaN are
%      treated as missing values and are ignored.
%
%   Examples
%   --------
%     % -- original grayscale image --
%     I = imread('eight.tif');
%     % noisy image
%     J = imnoise(I,'salt & pepper',0.03);
%     % hybrid median filtering
%     K = hmf(J);
%     % figures
%     subplot(121),imshow(J),subplot(122),imshow(K)
%     
%     % -- original RGB image --
%     [I,map] = imread('trees.tif');
%     I = ind2rgb(I,map);
%     % noisy image
%     J = imnoise(I,'salt & pepper',0.02);
%     % hybrid median filtering (using a 9x9 box)
%     K = hmf(J,9);
%     % figures
%     subplot(121),imshow(J),subplot(122),imshow(K)
% 
%   See also MEDFILT2, MEDFILT2RGB, MEDFILT3, COLFILT
%
%   -- Damien Garcia -- 2007/08, revised 2010/02 

error(nargchk(1,2,nargin));
if nargin==1, n = 5; end

if ~isscalar(n) || n<0, n = 5; end

% --- n must be odd. If not then n = n+1
n = round(n);
if rem(n+1,2)~=0, n = n+1; end

% --- Do we have an RGB image?
% RGB images can be only be uint8, uint16, single, or double
isRGB = ndims(A)==3 && (isfloat(A) || isa(A,'uint8') || isa(A,'uint16'));
% ---- Adapted from the obsolete function ISRGB ----
if isRGB
   if isfloat(A)
      % At first just test a small chunk to get a possible quick negative  
      mm = size(A,1);
      nn = size(A,2);
      chunk = A(1:min(mm,10),1:min(nn,10),:);         
      isRGB = (min(chunk(:))>=0 && max(chunk(:))<=1);
      % If the chunk is an RGB image, test the whole image
      if isRGB
         isRGB = (min(A(:))>=0 && max(A(:))<=1);
      end
   end
end
% ---- end of isrgb ----

assert(isRGB | ndims(A)==2,...
    'The input must be a 2-D array or an RGB image.')

classA = class(A);

% --- If the input is an RGB image, HMF is used in the HSV color space
if isRGB
    A = rgb2hsv(A);
    for k = 1:3, A(:,:,k) = hmf(A(:,:,k),n); end
    A = hsv2rgb(A);
    % HSV2RGB returns a double: change the class if necessary
    switch classA
        case 'uint8'
            A = uint8(A*255);
        case 'uint16'
            A = uint16(A*65535);
        case 'single'
            A = single(A);
    end
    return
end

% --- Plus & Cross masks
Plus = false(n,n);
Plus((n+1)/2,:) = true;
Plus(:,(n+1)/2) = true;
Plus = Plus(:);
Cross = false(n,n);
Cross((1:n)+n*(0:n-1)) = true;
Cross((1:n)+n*((n-1):-1:0)) = true;
Cross = Cross(:);


%% --- Hybrid median filtering

% Note: NANMEDIAN is used if this function exists (Statistics Toolbox)
existNaNmedian = exist('nanmedian','file');

% --- the COLFILT function zero-pads! => replicate boundaries
A = padarray(A,[(n-1)/2 (n-1)/2],'replicate');

M1 = colfilt(A,[n n],'sliding',@CrossMedian);
M2 = colfilt(A,[n n],'sliding',@PlusMedian);
if existNaNmedian
    A = nanmedian(cat(3,A,M1,M2),3);
else
    A = median(cat(3,A,M1,M2),3);
end

% remove the borders that were added by PADARRAY
A = A((n+1)/2:end-(n-1)/2,(n+1)/2:end-(n-1)/2);

function CM = CrossMedian(X)
    ncol = size(X,2);
    I = repmat(Cross,[1 ncol]);
    X = reshape(X(I),[2*n-1 ncol]);
    if existNaNmedian
        CM = nanmedian(X);
    else
        CM = median(X);
    end
end

function PM = PlusMedian(X)
    ncol = size(X,2);
    I = repmat(Plus,[1 ncol]);
    X = reshape(X(I),[2*n-1 ncol]);
    if existNaNmedian
        PM = nanmedian(X);
    else
        PM = median(X);
    end
end

end
