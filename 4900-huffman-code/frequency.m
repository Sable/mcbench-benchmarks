function f = frequency(vector)
%FREQUENCY   Simbols frequencies
%   For vectors, FREQUENCY(X) returns a [1x256] sized double array with frequencies
%   of simbols 0-255.
%
%   For matrices, X(:) is used as input.
%
%   Input must be of uint8 type, while the output is a double array.


%   $Author: Giuseppe Ridino' $
%   $Revision: 1.1 $  $Date: 02-Jul-2004 16:30:00 $


% ensure to handle uint8 input vector
if ~isa(vector,'uint8'),
	error('input argument must be a uint8 vector')
end

% create f
f = histc(vector(:), 0:255); f = f(:)'/sum(f); % always make a row of it
