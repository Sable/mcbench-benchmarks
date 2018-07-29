function RMS= rms(varargin)
%
% Written by Phillip M. Feldman  March 31, 2006
%
% rms computes the root-mean-square (RMS) of values supplied as a
% vector, matrix, or list of discrete values (scalars).  If the input is
% a matrix, rms returns a row vector containing the RMS of each column.

% David Feldman proposed the following simpler function definition:
%
%    RMS = sqrt(mean([varargin{:}].^2))
%
% With this definition, the function accepts ([1,2],[3,4]) as input,
% producing 2.7386 (this is the same result that one would get with
% input of (1,2,3,4).  I'm not sure how the function should behave for
% input of ([1,2],[3,4]).  Probably it should produce the vector
% [rms(1,3) rms(2,4)].  For the moment, however, my code simply produces
% an error message when the input is a list that contains one or more
% non-scalars.

if (nargin == 0)
   error('Missing input.');
end


% Section 1: Restructure input to create x vector.

if (nargin == 1)
   x= varargin{1};

else

   for i= 1 : size(varargin,2)
      if (prod(size(varargin{i})) ~= 1)
         error(['When input is provided as a list, ' ...
                'list elements must be scalar.']);
      end

      x(i)= varargin{i};
   end
end


% Section 2: Compute RMS value of x.

RMS= sqrt (mean (x .^2) );
