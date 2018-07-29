function handle = plot_bitmap(bitmap)
% handle = plot_bitmap(bitmap)
%
% Replacement for Matlab's image command that never attempts to use color maps.
% 
%                         PARAMETERS
%
% bitmap A matrix of N-by-M rgb triplets or a matrix of N-by-M grey-scale values.
%        This is never interpreted as a matrix of color indices.
%        For best results, use floating point values in the [0, 1] range or 
%        integer values in the [0, 255] range.
%
%                        RETURN VALUE
%
% handle The handle to an IMAGE object.
%
% Author: Luca Vezzaro (elvezzaro@gmail.com)

if size(bitmap, 1) <= 1 || size(bitmap, 2) <= 1
	error 'plot_bitmap: input bitmap is not a N-by-M matrix.'
end

if size(bitmap, 3) == 1
	result = repmat(bitmap, [1 1 3]);
else
	result = bitmap;
end

if isa(result, 'float') == 0
	warning 'plot_bitmap: input bitmap is not in floating point format, assuming 8-bit unsigned integer data.'
	result = double(result) / 255;
end

handle = image(result);
	