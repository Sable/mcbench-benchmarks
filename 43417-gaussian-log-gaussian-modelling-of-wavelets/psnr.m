function p = psnr( I, J )

% Compute PSNR between images
% Peak signal-to-noise ratio; built-in function not used since it
% assumes pixel values in interval [0, 255].
%
% Syntax:
%	p = psnr( I, J )
%
%
% Input:
%	I : Original image.
%
%	J : Denoised image.
%
%
% Output:
%	p : PSNR between I and J.

if ~isequal( size(I), size(J) )
	error('Images must be of the same size');
end

pixel_range = max(I(:)) - min(I(:));
MSE = norm( I - J, 'fro' );

p = 20*log10( pixel_range * sqrt(numel(I)) / MSE );

end
