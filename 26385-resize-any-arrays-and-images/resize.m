function x = resize(x,newsiz)

%RESIZE Resize any arrays and images.
%   Y = RESIZE(X,NEWSIZE) resizes input array X using a DCT (discrete
%   cosine transform) method. X can be any array of any size. Output Y is
%   of size NEWSIZE.
%   
%   Input and output formats: Y has the same class as X.
%
%   Note:
%   ----
%   If you want to multiply the size of an RGB image by a factor N, use the
%   following syntax: RESIZE(I,size(I).*[N N 1])
%
%   Examples:
%   --------
%     % Resize a signal
%     % original signal
%     x = linspace(0,10,300);
%     y = sin(x.^3/100).^2 + 0.05*randn(size(x));
%     % resized signal
%     yr = resize(y,[1 1000]);
%     plot(linspace(0,10,1000),yr)
%
%     % Upsample and downsample a B&W picture
%     % original image
%     I = imread('tire.tif');
%     % upsampled image
%     J = resize(I,size(I)*2);
%     % downsampled image
%     K = resize(I,size(I)/2);
%     % pictures
%     figure,imshow(I),figure,imshow(J),figure,imshow(K)
%
%     % Upsample and stretch a 3-D scalar array
%     load wind
%     spd = sqrt(u.^2 + v.^2 + w.^2); % wind speed
%     upsspd = resize(spd,[64 64 64]); % upsampled speed
%     slice(upsspd,32,32,32);
%     colormap(jet)
%     shading interp, daspect(size(upsspd)./size(spd))
%     view(30,40), axis(volumebounds(upsspd))
%
%     % Upsample and stretch an RGB image
%     I = imread('onion.png');
%     J = resize(I,size(I).*[2 2 1]);
%     K = resize(I,size(I).*[1/2 2 1]);
%     figure,imshow(I),figure,imshow(J),figure,imshow(K)
%
%   See also UPSAMPLE, RESAMPLE, IMRESIZE, DCTN, IDCTN
%
%   -- Damien Garcia -- 2009/11, revised 2010/01
%   website: <a
%   href="matlab:web('http://www.biomecardio.com')">www.BiomeCardio.com</a>

error(nargchk(2,2,nargin));

siz = size(x);
N = prod(siz);

% Do nothing if size is unchanged
if isequal(siz,newsiz), return, end

% Check size arguments
assert(isequal(length(siz),length(newsiz)),...
    'Number of dimensions must not change.')
newsiz = round(newsiz);
assert(all(newsiz>0),'Size arguments must be >0.')

class0 = class(x);
is01 = islogical(x);

% Check if DCTN & IDCTN exist
test4DCTNandIDCTN

% DCT transform
x = dctn(x);

% Crop the DCT coefficients
for k = 1:ndims(x)
    siz(k) = min(newsiz(k),siz(k));
    x(siz(k)+1:end,:) = [];
    x = reshape(x,circshift(siz,[0 1-k]));
    x = shiftdim(x,1);
end

% Pad the DCT coefficients with zeros
x = padarray(x,max(newsiz-siz,zeros(size(siz))),0,'post');

% inverse DCT transform
x = idctn(x)*sqrt(prod(newsiz)/N);

% Back to the previous class
if is01, x = round(x); end
x = cast(x,class0);

end

%% Test for DCTN and IDCTN
function test4DCTNandIDCTN
    if ~exist('dctn','file')
        error('MATLAB:smoothn:MissingFunction',...
            ['DCTN and IDCTN are required. Download DCTN <a href="matlab:web(''',...
            'http://www.biomecardio.com/matlab/dctn.html'')">here</a>.'])
    elseif ~exist('idctn','file')
        error('MATLAB:smoothn:MissingFunction',...
            ['DCTN and IDCTN are required. Download IDCTN <a href="matlab:web(''',...
            'http://www.biomecardio.com/matlab/idctn.html'')">here</a>.'])
    end
end