function range = imageshow(im, range)
% Show image with proper scalling

% First exclude the Inf value:
realim = im(find(isfinite(im)));

% By default range is within 2 standard deviation from the mean
if ~exist('range', 'var')
    range = mean(realim(:)) + std(realim(:)) * [-2, 2];
end

imagesc(im, range);
axis image;