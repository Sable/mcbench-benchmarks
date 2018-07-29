function [bias av_bias] = bias_f(x,y)

% Bias calculator

% Formula: 1 - mean(fused image)/mean(original image)
% (Ideal value = 0)

% 07/03/2010 Version 1.0
% 25/06/2010 Version 1.2    - Excel Output option
% 04/08/2011 Version 1.2F   - Function Version

% Author: Aristidis D. Vaiopoulos

% Find the number of bands
bands = size(x);
if length(bands) == 3
    bands = bands(1,3);
else
    bands = 1;
end
% Preallocation
mx = zeros(1,bands);
my = zeros(1,bands);
% Mean value calculation
for i = 1:bands
    xt = double(x(:,:,i));
    yt = double(y(:,:,i));
    mx(i) = mean(xt(:));
    my(i) = mean(yt(:));
end
% Bias calculation
bias = 1 - (my./mx);
bias = bias';

av_bias = mean(bias);

end

