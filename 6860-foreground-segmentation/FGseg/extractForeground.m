function foreground = extractForeground(video,frameSkip,dataRange,minSigmaLevel,shadowLevel,significanceThreshold,useGraph,graphAlpha,morphStructureElement,returnLargestComponent)

% extractForeground:  Extract the foreground from a video.
%
% This file shows sample usage for extracting the moving foreground
% from a static background.  It is intended as an example only;
% More sophisitcated background modeling techniques, particularly 
% adaptive ones, may be applied instead.  However, this should
% suffice for many simple videos.
%
% A number of parameters are available to control the behavior
% of the algorithm.  If these are unsupplied or empty, reasonable 
% default values will be chosen.
%
% video:  This is the only required parameter.  It may consist
%   of a string containing the name of an avi file to load.  
%   Alternately, it may contain the video frames as a cell
%   array of rgb images, stored as uint8 data.
%
% frameSkip:  Long videos may use enormous amounts of memory
%   during the intermediate processing stages.  If this becomes
%   a problem, frameSkip allows the background model to be 
%   computed using every nth frame.
%
% dataRange:  A cheap way of approximating robust statistics.
%   Mean/deviation are computed only for data falling within
%   the specified percentile ranges.  For example, with the
%   default value of [.25 .75], outlier pixels in up to 25% of 
%   the video frames will be ignored.
%
% minSigmaLevel:  Pixels with very low (or zero) deviation cause 
%   trouble.  This parameter specifies a percentile level,
%   which gives a floor deviation value for all pixels.
%
% shadowLevel:  Amount of shadowing to account for.  Positive
%   values allow some darkening of the pixel intensity without
%   treating it as evidence of a foreground object.
%
% significanceThreshold:  Number of standard deviations required
%   for a pixel to be considered foreground, in isolation.
%   This is perhaps the single most important parameter.  If pieces
%   of the foreground are being left out, try decreasing its value.
%   If too much background is included, try increasing its value.
%   (Lax dataRange bounds can also cause pieces of foreground to be
%   left out, if an object obscures the background for too long.
%   Increasing the shadowLevel can also help prevent background
%   inclusion, particularly around subjects' legs.)
%
% useGraph:  Boolean control parameter.  If true, use graph cut 
%   to find foreground.  If false, use morphology.
%
% graphAlpha:  Parameter controlling "clumpiness" of graph cut
%   operation.
%
% morphStructureElement:  Parameter controlling the morphological
%   operations if these are used.
%
% returnLargestComponent:  Boolean control parameter.  If true, 
%   then return single largest connected foreground component.
%   If false, return raw labels.
%
% Usage:
%   function foreground = extractForeground(video,frameSkip,dataRange,minSigmaLevel,shadowLevel,significanceThreshold,useGraph,graphAlpha,morphStructureElement,returnLargestComponent)

% Apply default values if required
if (nargin < 2)|isempty(frameSkip), frameSkip = 1; end;
if (nargin < 3)|isempty(dataRange), dataRange = [.25 .75]; end;
if (nargin < 4)|isempty(minSigmaLevel), minSigmaLevel = 0.1; end;
if (nargin < 5)|isempty(shadowLevel), shadowLevel = 0.05; end;
if (nargin < 6)|isempty(significanceThreshold), significanceThreshold = 6; end;
if (nargin < 7)|isempty(useGraph), useGraph = 1; end;
if (nargin < 8)|isempty(graphAlpha), graphAlpha = 1; end;
if (nargin < 9)|isempty(morphStructureElement), morphStructureElement = strel('disk',1); end;
if (nargin < 10)|isempty(returnLargestComponent), returnLargestComponent = 1; end;

if ischar(video)
    % Load the video from an avi file.
    avi = aviread(video);
    pixels = double(cat(4,avi(1:frameSkip:end).cdata))/255;
    clear avi
else
    % Compile the pixel data into a single array
    pixels = double(cat(4,video{1:frameSkip:end}))/255;
    clear video
end;
% NOTE:  The result of the cat operation above may be very large.
% If it will not fit into memory, try increasing frameSkip.
% Another alternative is to decrease the video resolution.

% Convert to HSV color space.
nFrames = size(pixels,4);
for f = 1:nFrames
    pixels(:,:,:,f) = rgb2hsv(pixels(:,:,:,f));
end;

% Generate Gaussian background model in hsv space for each pixel.
[backgroundMean, backgroundDeviation] = hsvGaussModel(pixels,dataRange);
backgroundDeviation(:,:,1) = max(backgroundDeviation(:,:,1),pctile(nonzeros(backgroundDeviation(:,:,1)),minSigmaLevel));
backgroundDeviation(:,:,2) = max(backgroundDeviation(:,:,2),pctile(nonzeros(backgroundDeviation(:,:,2)),minSigmaLevel));
backgroundDeviation(:,:,3) = max(backgroundDeviation(:,:,3),pctile(nonzeros(backgroundDeviation(:,:,3)),minSigmaLevel));

% Do frame-by-frame differencing
connections = pixCon(size(backgroundMean(:,:,1)));
foreground = cell(1,nFrames);
for f = 1:nFrames
    % Find scaled deviation of this frame from background
    deviation = sum(hsvCompare(pixels(:,:,:,f),backgroundMean,shadowLevel)./backgroundDeviation,3);

    % Compare with threshold to generate labeling
    if useGraph
        % Use graph cuts
        alpha = graphAlpha/significanceThreshold;
        label = reshape(graphLabel(alpha*[max(2*significanceThreshold-deviation(:)',0);deviation(:)'],connections),size(deviation));
    else
        % Use morphological operations
        label = double(imopen(imclose(deviation > significanceThreshold,morphStructureElement),morphStructureElement));
    end;

    % clean up:  find largest connected component, etc.
    if returnLargestComponent
        label = fgRanked(label,1);
    end;
    foreground{f} = uint8(label);  % Could use bwpack if desired
end;
% end of extractForeground

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Fits a gaussian to the specified distribution, in a robust manner.
%
% Returns the mean and standard deviation of the input arguments
% using the specified portion of the data.  Uses HSV color space
% for better shadow control.

function [mu,sigma] = hsvGaussModel(pixels,dataRange)

% statistics of s & v dimensions are simple.
[mu(:,:,2:3),sigma(:,:,2:3)] = fitGauss(pixels(:,:,2:3,:),dataRange,4);
hmu = polarMean(pixels(:,:,1,:)*2*pi,4);
h = zeros(size(pixels(:,:,1,:)));
nFrames = size(pixels,4);
for i = 1:nFrames
    h(:,:,1,i) = mod(pixels(:,:,1,i)*2*pi-hmu+pi,2*pi);
end;
[mu(:,:,1),sigma(:,:,1)] = fitGauss(h,dataRange,4);
mu(:,:,1) = mod(mu(:,:,1)-pi+hmu,2*pi)/(2*pi);
sigma(:,:,1) = sigma(:,:,1)/(2*pi);
% end of hsvGaussModel

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Fits a gaussian to the specified distribution, in a robust manner.
%
% Returns the mean and standard deviation of the input arguments
% using the specified portion of the data

function [mu,sigma] = fitGauss(m,dataRange,dim)

x = -3:0.01:3;
y = exp(-x.^2);
y = y./sum(y);
yy = cumsum(y);
fdev = sqrt(sum(y.*x.^2));
xbd = min(find(yy > dataRange(1))):min(find(yy > dataRange(2)));
pdev = sqrt(sum(y(xbd).*x(xbd).^2)/sum(y(xbd)));

dimlen = size(m,dim);
if all(dataRange == [0 1])|(dim > length(size(m)))
    % skip sorting step if we'll be using everything anyway
    ms = m;
else
    ms = sort(m,dim);
end;
dimind = round(dataRange*(dimlen-1)+1);
[refstr{1:length(size(m))}] = deal(':');
if (dim <= length(size(m)))
    refstr{dim} = dimind;
end;
sref = struct('type','()','subs',{refstr});
bds = subsref(ms,sref);
if (dim <= length(size(m)))
    sref.subs{dim} = dimind(1):dimind(2);
end;
data = subsref(ms,sref);
mu = mean(data,dim);
sigma = std(data,0,dim)*fdev/pdev;
% end of fitGauss

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% function d = hsvCompare(a,b,shadow)
%
% Returns the component differences between images in HSV color space.

function d = hsvCompare(a,b,shadow)

aclr = length(a(:))/3;
bclr = length(b(:))/3;
sa = a(aclr+1:2*aclr);
sb = b(bclr+1:2*bclr);
va = a(2*aclr+1:3*aclr);
vb = b(2*bclr+1:3*bclr);
d = zeros(size(a));
d(1:aclr) = (angdiff(2*pi*a(1:aclr),2*pi*b(1:bclr)).*min(sa,sb))';
d(aclr+1:2*aclr) = abs(sa-sb);
d(2*aclr+1:3*aclr) = va-vb;
neg = find(d(2*aclr+1:3*aclr)<0);
d(2*aclr+neg) = max(0,vb(neg)-va(neg)-shadow);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%function d = angdiff(th1, th2)
%
% Returns the difference between angles expressed in radians.
% This will always be <= pi.

function d = angdiff(th1, th2)

d = abs(mod(th1-th2+pi,2*pi)-pi);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Returns the "mean" of a set of angular variables

function pm = polarMean(th,dim)

th = mod(th,2*pi);
x = cos(th);
y = sin(th);
if (nargin < 2)
    pm = mod(atan2(mean(y),mean(x)),2*pi);
else
    pm = mod(atan2(mean(y,dim),mean(x,dim)),2*pi);
end;
% end of polarMean

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% PCTILE Percentile
%
% For vectors, PCTILE(X,Y) returns the element at the Yth percentile of X.
% For matrices, PCTILE(X,Y) returns a row vector containing the
% Yth percentile of each column.  Y must be between 0 and 1.
%
% PCTILE(X,Y,DIM) takes the percentile along dimension DIM of X.
%
% See also MIN, MAX, MEDIAN

function pct = pctile(x,pct,dim)

if (nargin < 3)
    [x,n] = shiftdim(x);
    dim = 1;
end;

sx = sort(x,dim);
subs = cell(1,length(size(x)));
[subs{:}] = deal(':');
subs{dim} = round(pct*(size(x,dim)-1))+1;
ref = struct('type','()','subs',{subs});
pct = subsref(sx,ref);

if (nargin < 3)
    pct = shiftdim(pct,-n);
end;
% end of pctile

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Returns the foreground connected component in the binary image
% supplied that have the specified ranked size(s).

function fgr = fgRanked(bin,rank)

fg = bwlabel(bin,4);
maxfg = max(fg(:));
h = hist(fg(find(bin)),[1:maxfg]);
[sh,sr] = sort(-h);
if (rank < 1)|(rank > max(find(sh > 0)))
    fgr = zeros(size(img))
else
    fgr = (fg==sr(rank));
end;
% end of fgRanked

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
