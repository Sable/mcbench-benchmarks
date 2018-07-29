function [h, margin] = circle_hough(b, rrange, varargin)
%CIRCLE_HOUGH Hough transform for circles
%   [H, MARGIN] = CIRCLE_HOUGH(B, RADII) takes a binary 2-D image B and a
%   vector RADII giving the radii of circles to detect. It returns the 3-D
%   accumulator array H, and an integer MARGIN such that H(I,J,K) contains
%   the number of votes for the circle centred at B(I-MARGIN, J-MARGIN),
%   with radius RADII(K). Circles which pass through B but whose centres
%   are outside B receive votes.
%
%   [H, MARGIN] = CIRCLE_HOUGH(B, RADII, opt1, ...) allows options to be
%   set. Each option is a string, which if included has the following
%   effect:
%
%   'same' returns only the part of H corresponding to centre positions
%   within the image. In this case H(:,:,k) has the same dimensions as B,
%   and MARGIN is 0. This option should not be used if circles whose
%   centres are outside the image are to be detected.
%
%   'normalise' multiplies each slice of H, H(:,:,K), by 1/RADII(K). This
%   may be useful because larger circles get more votes, roughly in
%   proportion to their radius.
%
%   The spatial resolution of the accumulator is the same as the spatial
%   resolution of the original image. Smoothing the accumulator array
%   allows the effective resolution to be controlled, and this is probably
%   essential for sensitivity to circles of arbitrary radius if the spacing
%   between radii is greater than 1. If time or memory requirements are a
%   problem, a generalisation of this function to allow larger bins to be
%   used from the start would be worthwhile.
%
%   Each feature in B is allowed 1 vote for each circle. This function
%   could easily be generalised to allow weighted features.
%
%   See also CIRCLEPOINTS, CIRCLE_HOUGHPEAKS, CIRCLE_HOUGHDEMO

% Copyright David Young 2008, 2010

% argument checking
opts = {'same' 'normalise'};
error(nargchk(2, 2+length(opts), nargin, 'struct'));
validateattributes(rrange, {'double'}, {'real' 'positive' 'vector'});
if ~all(ismember(varargin, opts))
    error('Unrecognised option');
end

% get indices of non-zero features of b
[featR, featC] = find(b);

% set up accumulator array - with a margin to avoid need for bounds checking
[nr, nc] = size(b);
nradii = length(rrange);
margin = ceil(max(rrange));
nrh = nr + 2*margin;        % increase size of accumulator
nch = nc + 2*margin;
h = zeros(nrh*nch*nradii, 1, 'uint32');  % 1-D for now, uint32 a touch faster

% get templates for circles at all radii - these specify accumulator
% elements to increment relative to a given feature
tempR = []; tempC = []; tempRad = [];
for i = 1:nradii
    [tR, tC] = circlepoints(rrange(i));
    tempR = [tempR tR]; %#ok<*AGROW>
    tempC = [tempC tC];
    tempRad = [tempRad repmat(i, 1, length(tR))];
end

% Convert offsets into linear indices into h - this is similar to sub2ind.
% Take care to avoid negative elements in either of these so can use
% uint32, which speeds up processing by a factor of more than 3 (in version
% 7.5.0.342)!
tempInd = uint32( tempR+margin + nrh*(tempC+margin) + nrh*nch*(tempRad-1) );
featInd = uint32( featR' + nrh*(featC-1)' );

% Loop over features
for f = featInd
    % shift template to be centred on this feature
    incI = tempInd + f;
    % and update the accumulator
    h(incI) = h(incI) + 1;
end

% Reshape h, convert to double, and apply options
h = reshape(double(h), nrh, nch, nradii);

if ismember('same', varargin)
    h = h(1+margin:end-margin, 1+margin:end-margin, :);
    margin = 0;
end

if ismember('normalise', varargin)
    h = bsxfun(@rdivide, h, reshape(rrange, 1, 1, length(rrange)));
end

end
