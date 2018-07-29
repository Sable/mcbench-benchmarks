function peaks = circle_houghpeaks(h, radii, varargin)
%CIRCLE_HOUGHPEAKS finds peaks in the output of CIRCLE_HOUGH
%   PEAKS = CIRCLE_HOUGHPEAKS(H, RADII, MARGIN, OPTIONS) locates the
%   positions of peaks in the output of CIRCLE_HOUGH. The result PEAKS is a
%   3 x N array, where each column gives the position and radius of a
%   possible circle in the original array. The first row of PEAKS has the
%   x-coordinates, the second row has the y-coordinates, and the third row
%   has the radii.
%
%   H is the 3D accumulator array returned by CIRCLE_HOUGH.
%
%   RADII is the array of radii which was passed as an argument to
%   CIRCLE_HOUGH.
%
%   MARGIN is optional, and may be omitted if the 'same' option was used
%   with CIRCLE_HOUGH. Otherwise, it should be the second result returned
%   by CIRCLE_HOUGH.
%
%   OPTIONS is a comma-separated list of parameter/value pairs, with the
%   following effects:
%
%   'Smoothxy' causes each x-y layer of H to be smoothed before peak
%   detection using a 2D Gaussian kernel whose "sigma" parameter is given
%   by the value of this argument.
%
%   'Smoothr' causes each radius column of H to be smoothed before peak
%   detection using a 1D Gaussian kernel whose "sigma" parameter is given
%   by the value of this argument.
%
%       Note: Smoothing may be useful to locate peaks in noisy accumulator
%       arrays. However, it may also cause the performance to deteriorate
%       if H contains sharp peaks. It is most likely to be useful if
%       neighbourhood suppression (see below) is not used.
%
%       Both smoothing operations use reflecting boundary conditions to
%       compute values close to the boundaries.
%
%   'Threshold' sets the minimum number of votes (after any smoothing)
%   needed for a peak to be counted. The default is 0.5 * the maximum value
%   in H.
%
%   'Npeaks' sets the maximum number of peaks to be found. The highest
%   NPEAKS peaks are returned, unless the threshold causes fewer than
%   NPEAKS peaks to be available.
%
%   'Nhoodxy' must be followed by an odd integer, which sets a minimum
%   spatial separation between peaks. See below for a more precise
%   statement. The default is 1.
%
%   'Nhoodr' must be followed by an odd integer, which sets a minimum
%   separation in radius between peaks. See below for a more precise
%   statement. The default is 1.
%
%       When a peak has been found, no other peak with a position within an
%       NHOODXY x NHOODXY x NHOODR box centred on the first peak will be
%       detected. Peaks are found sequentially; for example, after the
%       highest peak has been found, the second will be found at the
%       largest value in H excepting the exclusion box found the first
%       peak. This is similar to the mechanism provided by the Toolbox
%       function HOUGHPEAKS.
%
%       If both the 'Nhoodxy' and 'Nhoodr' options are omitted, the effect
%       is not quite the same as setting each of them to 1. Instead of a
%       sequential algorithm with repeated passes over H, the Toolbox
%       function IMREGIONALMAX is used. This may produce slightly different
%       results, since an above-threshold point adjacent to a peak will
%       appear as an independent peak using the sequential suppression
%       algorithm, but will not be a local maximum. 
%
%   See also CIRCLE_HOUGH, CIRCLE_HOUGHDEMO

% check arguments
params = checkargs(h, radii, varargin{:});

% smooth the accumulator - xy
if params.smoothxy > 0
    [m, hsize] = gaussmask1d(params.smoothxy);
    % smooth each dimension separately, with reflection
    h = cat(1, h(hsize:-1:1,:,:), h, h(end:-1:end-hsize+1,:,:));
    h = convn(h, reshape(m, length(m), 1, 1), 'valid');
    
    h = cat(2, h(:,hsize:-1:1,:), h, h(:,end:-1:end-hsize+1,:));
    h = convn(h, reshape(m, 1, length(m), 1), 'valid');
end

% smooth the accumulator - r
if params.smoothr > 0
    [m, hsize] = gaussmask1d(params.smoothr);
    h = cat(3, h(:,:,hsize:-1:1), h, h(:,:,end:-1:end-hsize+1));
    h = convn(h, reshape(m, 1, 1, length(m)), 'valid');
end

% set threshold
if isempty(params.threshold)
    params.threshold = 0.5 * max(h(:));
end

if isempty(params.nhoodxy) && isempty(params.nhoodxy)
    % First approach to peak finding: local maxima
    
    % find the maxima
    maxarr = imregionalmax(h);
    
    maxarr = maxarr & h >= params.threshold;
    
    % get array indices
    peakind = find(maxarr);
    [y, x, rind] = ind2sub(size(h), peakind);
    peaks = [x'; y'; radii(rind)];
    
    % get strongest peaks
    if ~isempty(params.npeaks) && params.npeaks < size(peaks,2)
        [~, ind] = sort(h(peakind), 'descend');
        ind = ind(1:params.npeaks);
        peaks = peaks(:, ind);
    end
    
else
    % Second approach: iterative global max with suppression
    if isempty(params.nhoodxy)
        params.nhoodxy = 1;
    elseif isempty(params.nhoodr)
        params.nhoodr = 1;
    end
    nhood2 = ([params.nhoodxy params.nhoodxy params.nhoodr]-1) / 2;
    
    if isempty(params.npeaks)
        maxpks = 0;
        peaks = zeros(3, round(numel(h)/100));  % preallocate
    else
        maxpks = params.npeaks;  
        peaks = zeros(3, maxpks);  % preallocate
    end
    
    np = 0;
    while true
        [r, c, k, v] = max3(h);
        % stop if peak height below threshold
        if v < params.threshold || v == 0
            break;
        end
        np = np + 1;
        peaks(:, np) = [c; r; radii(k)];
        % stop if done enough peaks
        if np == maxpks
            break;
        end
        % suppress this peak
        r0 = max([1 1 1], [r c k]-nhood2);
        r1 = min(size(h), [r c k]+nhood2);
        h(r0(1):r1(1), r0(2):r1(2), r0(3):r1(3)) = 0;
    end 
    peaks(:, np+1:end) = [];   % trim
end

% adjust for margin
if params.margin > 0
    peaks([1 2], :) = peaks([1 2], :) - params.margin;
end
end

function params = checkargs(h, radii, varargin)
% Argument checking
ip = inputParser;

% required
htest = @(h) validateattributes(h, {'double'}, {'real' 'nonnegative' 'nonsparse'});
ip.addRequired('h', htest);
rtest = @(radii) validateattributes(radii, {'double'}, {'real' 'positive' 'vector'});
ip.addRequired('radii', rtest);

% optional
mtest = @(n) validateattributes(n, {'double'}, {'real' 'nonnegative' 'integer' 'scalar'});
ip.addOptional('margin', 0, mtest); 

% parameter/value pairs
stest = @(s) validateattributes(s, {'double'}, {'real' 'nonnegative' 'scalar'});
ip.addParamValue('smoothxy', 0, stest);
ip.addParamValue('smoothr', 0, stest);
ip.addParamValue('threshold', [], stest);
nptest = @(n) validateattributes(n, {'double'}, {'real' 'positive' 'integer' 'scalar'});
ip.addParamValue('npeaks', [], nptest);
nhtest = @(n) validateattributes(n, {'double'}, {'odd' 'positive' 'scalar'});
ip.addParamValue('nhoodxy', [], nhtest);
ip.addParamValue('nhoodr', [], nhtest);
ip.parse(h, radii, varargin{:});
params = ip.Results;
end

function [m, hsize] = gaussmask1d(sigma)
% truncated 1D Gaussian mask
hsize = ceil(2.5*sigma);  % reasonable truncation
x = (-hsize:hsize) / (sqrt(2) * sigma);
m = exp(-x.^2);
m = m / sum(m);  % normalise
end

function [r, c, k, v] = max3(h)
% location and value of global maximum of a 3D array
[vr, r] = max(h);
[vc, c] = max(vr);
[v, k] = max(vc);
c = c(1, 1, k);
r = r(1, c, k);
end