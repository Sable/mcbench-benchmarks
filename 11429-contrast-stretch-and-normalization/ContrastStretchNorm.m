function [array_out] = ContrastStretchNorm(array_in, low_thr, high_thr)
%
% Stretches contrast on the image and normalize image from 0 to 1 
% The main difference of this function to the standard streching functions is that
% standard function finds global minimum and maximum on the image, then uses 
% some low and high threshold values to normalize image(values below LowTHR are
% equated to LowTHR and values above HighTHR are equated to HighTHR). This function
% uses threshold values that are NEXT to miminum and maximum. Thus, we can exclude
% image backgound (which is normally zero) and find minimum value on the image itself. 
% Same consideration goes to high thr. We exclude first global maximum because, if its 
% a spike, we have better chance with the next value, and if it is not a spike, normally,
%  next value is quite close to max (assuming smooth image), so our error is small
%
% If image is uniform, (all pixels have the same value), for instance zero, function
% returns the input array
% 
%INPUTS:
%   ARRAY_IN-   input image array
%   LOW_THR     -   Low  THR value. Default value => 1% (thr= 0.01)
%   HIGH_THR     -  High THR value. If ommited, default value => high_thr = low_thr;
%OUTPUT:
%   ARRAY_OUT- output image array

% 

%---------------------------------------------------|
% 	Sergei Koptenko, Resonant Medical, Montreal, Qc.|
% ph: 514.985.2442 ext265, www.resonantmedical.com  |
%      sergei.koptenko@resonantmedical.com          |
%---------------March/06/2006-----------------------|

if nargin ==1, low_thr = 0.01;  end
if nargin <3, high_thr = low_thr; end

abs_max = max(array_in(:));  %Get Global max
abs_min = min(array_in(:));  %Get Global min

if (abs_max == abs_min), array_out = array_in; return; end   % if image is uniform (all zeros, i.e.)

% Find next to MIN and next to MAX. Reason- zero is background, but we are interested 
% in MINIMUM in the IMAGE. Global MAX - can be a spike, so we take next value closest

array_in = array_in - abs_min; % remove possible min bias. Now ABS MIN==0
marr = abs_max*(array_in == 0)+ array_in; % Temporary Move ABS MIN to ABS MAX
next_min = min(marr(:));                    % This is NEXT MIN

marr = (array_in < abs_max).* array_in; % Temporary Move ABS MAX to ABS MIN
next_max = max(marr(:));                      % This is NEXT MAX

imrange = next_max - next_min;       % Range of contrast values
low_thr = low_thr * imrange;       % variation for contrast streching
high_thr = high_thr * imrange;       % variation for contrast streching

low_thr = next_min + low_thr;    %LOW  threshold for contrast streshing
high_thr = next_max - high_thr;   %HIGH threshold for contrast streshing
mask_lo = (array_in < low_thr);
array_in = mask_lo .*low_thr + (~mask_lo) .* array_in;

mask_hi = (array_in > high_thr);
array_in = mask_hi .*high_thr + (~mask_hi) .* array_in;

array_in = array_in - low_thr; % make 0- global min
array_out = array_in ./(high_thr - low_thr); % make 1- global max
