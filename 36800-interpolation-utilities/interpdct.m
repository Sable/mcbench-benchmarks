function [y] = interpdct(x,ny,dim)

% INTERPDCT 1-D interpolation using DCT method
%    Y = INTERPDCT(X,N) returns a vector Y of length N obtained
%    by interpolation in the Discrete Cosine transform of X.
%
%    If X is a matrix, interpolation is done on each column.
%    If X is an array, interpolation is performed along the first
%    non-singleton dimension.
%
%    INTERPDCT(X,N,DIM) performs the interpolation along the
%    dimension DIM.
%
%    Example: 
%       % Set up a triangle-like signal signal to be interpolated 
%       y  = [0:.5:2 1.5:-.5:-2 -1.5:.5:0]; % equally spaced
%       factor = 5; % Interpolate by a factor of 5
%       m  = length(y)*factor;
%       x  = 1:factor:m;
%       xi = 1:m;
%       yi = interpdct(y,m);
%       plot(x,y,'o',xi,yi,'*')
%       legend('Original data','Interpolated data')
%
%    Class support for data input x:
%       float: double, single
%  
%    See also INTERPFT.

% Joe Henning - February 2012

error(nargchk(2,3,nargin));

if (nargin == 2)
   [x,nshifts] = shiftdim(x);
   if (isscalar(x))   % Return a row for a scalar
      nshifts = 1;
   end
elseif (nargin == 3)
   perm = [dim:max(length(size(x)),dim) 1:dim-1];
   x = permute(x,perm);
end

siz = size(x);
[m,n] = size(x);
if (~isscalar(ny))
   error('MATLAB:interpdct:NonScalarN', 'N must be a scalar.');
end

% If necessary, increase ny by an integer multiple to make ny > m.
if (ny >= m)
   incr = 1;
else
   if (ny == 0)
      y = [];
      return
   end
   incr = floor(m/ny) + 1;
   ny = incr*ny;
end
a = dct(x);
b = [a; zeros(ny-m,n)];
y = idct(b)*sqrt(ny/m);
y = y(1:incr:ny,:);  % Skip over extra points when oldny <= m.

% shift in time by (factor-1)/2
shift = -(ny/m-1)/2;
wshift = fix(shift);
y = circshift(y,wshift);
if (wshift ~= shift)
   fshift = shift - wshift;

   use_lagrange = 1;
   if (use_lagrange)
      f = 1:1:length(y);
      fi = f - fshift;
      yi = lagint(f,y,fi,13);
      y = yi(:);
   else
      f = -1:2/ny:1-2/ny;
      f = fftshift(f);
      y = ifft(fft(y).*exp(-j*pi*f(:)*fshift));
   end
end
%if isreal(x)
%   y = real(y);
%end

if (nargin == 2)
   y = reshape(y,[ones(1,nshifts) size(y,1) siz(2:end)]);
elseif (nargin == 3)
   y = ipermute(y,perm);
end
