function filtered = Kuwahara(original,winsize)
%Kuwahara   filters an image using the Kuwahara filter
%   filtered = Kuwahara(original,windowSize) filters the original image with a
%                                            given windowSize and yields the result in filtered
% 
% This function is optimised using vectorialisation, convolution and
% the fact that, for every subregion
%     variance = (mean of squares) - (square of mean).
% A nested-for loop approach is still used in the final part as it is more
% readable, a commented-out, fully vectorialised version is provided as
% well.
% 
% This function is about 2.3 times faster than KuwaharaFast at
% http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=13474&objectType=file
% with a 5x5 window, and even faster at higher window sizes (about 4 times on a 13x13 window)
% 
% Inputs:
% original      -->    image to be filtered
% windowSize    -->    size of the Kuwahara filter window: legal values are
%                      5, 9, 13, ... = (4*k+1)
% 
% Example
% filtered = Kuwahara(original,5);
%  
% Filter description:
% The Kuwahara filter works on a window divided into 4 overlapping
% subwindows (for a 5x5 pixels example, see below). In each subwindow, the mean and
% variance are computed. The output value (located at the center of the
% window) is set to the mean of the subwindow with the smallest variance.
%
%    ( a  a  ab   b  b)
%    ( a  a  ab   b  b)
%    (ac ac abcd bd bd)
%    ( c  c  cd   d  d)
%    ( c  c  cd   d  d)
% 
% References:
% http://www.ph.tn.tudelft.nl/DIPlib/docs/FIP.pdf 
% % http://www.incx.nec.co.jp/imap-vision/library/wouter/kuwahara.html
%
% Copyright Luca Balbi, 2007

%% Incorrect input handling
error(nargchk(2, 2, nargin, 'struct'));

% non-double data will be cast
if ~isa(original, 'double')
    original = double(original);
end % if

% wrong-sized kernel is an error
if mod(winsize,4)~=1
    error([mfilename ':IncorrectWindowSize'],'Incorrect window size: %d',winsize)
end % if
    
%% Build the subwindows
tmpAvgKerRow = [ones(1,(winsize-1)/2+1) zeros(1,(winsize-1)/2)];
tmpPadder = zeros(1,winsize);
tmpavgker = repmat(tmpAvgKerRow,(winsize-1)/2+1,1);
tmpavgker = [tmpavgker; repmat(tmpPadder,(winsize-1)/2,1)];
tmpavgker = tmpavgker/sum(sum(tmpavgker));

% tmpavgker is a 'north-west' subwindow (marked as 'a' above)
% we build a vector of convolution kernels for computing average and
% variance
avgker(:,:,1) = tmpavgker;                  % North-west (a)
avgker(:,:,2) = fliplr(tmpavgker);      % North-east (b)
avgker(:,:,4) = flipud(tmpavgker);      % South-east (c)
avgker(:,:,3) = fliplr(avgker(:,:,4));      % South-west (d)

% this is the (pixel-by-pixel) square of the original image
squaredImg = original.^2;

% preallocationg these arrays makes it about 15% faster
avgs = zeros([size(original) 4]);
stddevs = zeros([size(original) 4]);

%% Calculation of averages and variances on subwindows
for k=1:4
    avgs(:,:,k) = conv2(original,avgker(:,:,k),'same');      % mean on subwindow
    stddevs(:,:,k) = conv2(squaredImg,avgker(:,:,k),'same'); % mean of squares on subwindow
    stddevs(:,:,k) = stddevs(:,:,k)-(avgs(:,:,k)).^2;        % variance on subwindow
end % for

%% Choice of the index with minimum variance
[minima,indices] = min(stddevs,[],3); %#ok<ASGLU>

%% Building of the filtered image (with nested for loops)
filtered = zeros(size(original));
for k=1:size(original,1)
    for n=1:size(original,2)
        filtered(k,n) = avgs(k,n,indices(k,n));
    end % for
end % for

%% Commented out, completely vectorialised alternative
% [y,x] = meshgrid(1:size(original,2),1:size(original,1));
% lookupIndices = x+size(original,1)*(y-1)+numel(original)*(indices-1);
% filtered = avgs(lookupIndices);

end % function
