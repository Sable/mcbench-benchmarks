% guided_filter - two dimensional edge-preserving filtering
%    This function implements 2-D guided filtering using
%    the method outlined in:
%      'Guided Image Filtering' by He, K; Sun, J and Tang, X; ECCV 2010
% 
% filtered = guided_filter(input, guide, epsilon, win_size)
% input - the input image to be filtered, assumed to be single channel
%         intensity image, with values in [0 1].
% guide - the guide image, same dimension and same range as 'input'.
% epsilon - the regularization parameter to provide the balance between
%           data matching and smoothing, note epsilon ~= 0, otherwise 
%           division by zero error occurs when calculating average a in 
%           flat image region. 
% win_size - size of the windows, odd numbers only, eg., 3, 5, 7.
%
% Ruimin Pan, Canon Information System Research Australia, September 2011.
% ruimin.pan AT cisra.canon.com.au


function filtered = guided_filter(input, guide, epsilon, win_size)
% calculate a few useful parameters
num_pixels = win_size * win_size;
half = floor(win_size / 2);
% average value in every win_size-by-win_size window of the input image
paddedp = padarray(input, [half, half], 'both');
mup = zeros(size(paddedp));
% average value in every win_size-by-win_size window of the guide image
paddedi = padarray(guide, [half, half], 'both');
mui = zeros(size(paddedi));
% variance in every window of the guide image
sigmai = zeros(size(paddedi));
% cross term of the guide and input image in every window
cross = zeros(size(paddedi));

%constructing denominator image;
initial_denom = padarray(ones(size(input)), [half, half], 'both');
denom = zeros(size(paddedi));


% calculating sum over each window by shifting and adding
for i = -half : half
    for j = -half : half
        mup = mup + circshift(paddedp, [i, j]);
        mui = mui + circshift(paddedi, [i, j]);
        sigmai = sigmai + circshift(paddedi, [i, j]).^2;
        cross = cross + circshift(paddedi, [i, j]).*circshift(paddedp, [i, j]);
        denom = denom + circshift(initial_denom, [i, j]);
    end
end

% remove the padding
mup = mup(half+1:end-half, half+1:end-half);
mui = mui(half+1:end-half, half+1:end-half);
sigmai = sigmai(half+1:end-half, half+1:end-half);
cross = cross(half+1:end-half, half+1:end-half);
denom = denom(half+1:end-half, half+1:end-half);

% calculate average, variance and cross terms in equation (5) and (6) in
% the paper
mup = mup ./ denom;
mui = mui ./ denom;
sigmai = sigmai ./ denom - mui.^2;
cross = cross ./ denom;

% calculating the linear coefficients a and b
a = (cross - mui .* mup) ./ (sigmai + epsilon);
b = mup - a .* mui;

apad = padarray(a, [half, half], 'both');
bpad = padarray(b, [half, half], 'both');

mua = zeros(size(apad));
mub = zeros(size(bpad));

% calculating sum over each window by shifting and adding
for i = -half : half
    for j = -half : half
        mua = mua + circshift(apad, [i, j]);
        mub = mub + circshift(bpad, [i, j]);
    end
end

% remove the padding
mua = mua(half+1:end-half, half+1:end-half);
mub = mub(half+1:end-half, half+1:end-half);

% calculate average a and b
mua = mua ./ denom;
mub = mub ./ denom;

% the filtered image
filtered = mua .* input + mub;
  
    
    











