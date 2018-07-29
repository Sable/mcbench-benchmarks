function out = immerge(bg, fg, coef)
% Creates an image 'out' of same type as bg.
% 'out' has 'bg' as background, and 'fg' (transparent, 
% weighted by 'coef') above 'bg'.
% Useful when one cannot use OpenGL as renderer, but still 
% wants to have transparency!
% 'out', 'bg', and 'fg' are RGB images.
%
% merged = immerged(bg, fg, coef)
%	- bg matrix of type double or uint8
%	- fg matrix of type double or uint8
%	- coef is a scalar between 0 and 1, or a matrix of 
%	  such scalars, same size as 'fg' and 'bg' (AlphaData).
%
% Suggestions for future development:
%	- allow to have 'coef' referring to the AlphaMap
%	- allow 'coef' to take values between 1 and 64.
%
% Gauthier Fleutot 28-07-2004
% fleutotg@esiee.fr

intOutput = 0;	% if we want the output to be of type integer

if ~isa(bg, 'double')
	bg = double(bg);	% because '-' isn't defined for uint8
	intOutput = 1;
end
if ~isa(fg, 'double')
	fg = double(fg);	% because '-' isn't defined for uint8
end

dif = fg-bg;

if size(coef) == [1 1]
	out = bg + coef.*dif;
else
	coef = cat(3,coef,coef,coef);	% extend the coef matric in the 3rd dim.
	out = bg + coef .* dif;
end

if intOutput == 1
	out = uint8(out);
end