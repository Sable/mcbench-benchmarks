function L = gfilter( L, sigma, orders )
% GFILTER - Gaussian filterering and Gaussian derivative filters
%
% Lg = gfilter( L, sigma ) performes Gaussian smoothing with on the data L.
% L can be of any dimension.
%
% Lg = gfilter( L, sigma, orders ) calculates Gaussian derivatives with
% the specified orders. "orders" should be an array with as many elements
% as the number of dimensions of L.
%
% - Makes use of the seperability property of the Gaussian by convolving 1D
%   kernels in each dimension. 
% - When the maximum order is >0, kernels are used that are normalized with
%   sigma^2/2, so the derivatives do not deminish for high sigma.
% - When the first element in "orders" corresponds to the first dimension,
% which does not have to be X, as images are often stored with Y the first
% dimension.
%
% Example:
% % Calculate the second order derivative with respect to x (Lx) (if the
% first dimension of the image is Y).
% gfilter( im, 2, [0,2] ) 
% % Calculate the first order derivative with respect to y and z (Lyz).
% gfilter( volume, 3, [0,1,1] ) 
%
% See also gaussiankernel

% we may want to change this, or make it a parameter.
BOUNDARY_OPTION = 'symmetric';


%% CHECK INPUT

% check amount of arguments
if nargin>3;  error([mfilename ': need two or three parameters!']);  end;
if nargin<2;  error([mfilename ': need two or three parameters!']);  end;
if nargin==2;  orders=[];  end;

% check image
if ~isnumeric(L);  error([mfilename ': the image must be a numeric matrix!']);  end;
dims    = ndims(L);  % number of dimensions

% check sigma
if ~isnumeric(sigma) || numel(sigma)~=1
    error([mfilename ': sigma should be a numeric scalar!']);
end
if sigma<=0;  error([mfilename ': sigma should be larger than zero!']);  end;

% check orders
if isempty(orders);  orders = zeros([dims,1]);  end;
if numel(orders)~=dims
    error([mfilename ': the amount of order-params should be equal to the amount of dimensions of the data!']);
end

    

%% CONCOLVE IN EACH DIMENSION
for d = 1 : dims
    
    % create kernel in appropriate direction
    k = gaussiankernel(sigma, orders(d));
    
    % shift the dimension of the kernel
    k = shiftdim(k, -(d-1) );
    
    % convolve
    L = imfilter( L, k, BOUNDARY_OPTION, 'same' );
    
end
