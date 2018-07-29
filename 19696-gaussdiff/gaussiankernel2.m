function k = gaussiankernel2(sigma, ox, oy, sigma2szeRatio)
% GAUSSIAN KERNEL 2D - creates a gaussian derivative kernel in two
% dimensions. Note that the Gaussian function has the property of
% seperability, so convolving with two 1D kernels will have the same
% effect, but is much faster. Therefore only use this function for
% illustration purposes. 
% 
% gaussiankernel2(sigma, order_x, order_y)
%
% See also gfilter, gaussiankernel

if nargin==1;  ox = [];  oy = [];  end;
if nargin==2;  error([mfilename ': when supplying the order of x, also supply that of y!']);  end;
if nargin<4;   sigma2szeRatio = 0;  end;
if nargin>4;   error([mfilename ': too many input arguments!']);  end;
    
if isempty(ox);  ox=0;  end;
if isempty(oy);  oy=0;  end;

% get the largest of the two minimal kernel cut-offs
if sigma2szeRatio <= 0
    sigma2szeRatioX = 3 + 0.25 * ox - 2.5/((ox-6)^2+(ox-9)^2); 
    sigma2szeRatioY = 3 + 0.25 * oy - 2.5/((oy-6)^2+(oy-9)^2); 
    sigma2szeRatio = max([sigma2szeRatioX, sigma2szeRatioY]);
end

% span the kernel from the two 1D kernels
kx = gaussiankernel(sigma, ox, sigma2szeRatio);
ky = gaussiankernel(sigma, oy, sigma2szeRatio);

% span by multiplying two orthogonal vectors
k = kx * ky';
