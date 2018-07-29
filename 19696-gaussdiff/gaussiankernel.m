function  [k t] = gaussiankernel(sigma, order, sigma2szeRatio)
% GAUSSIAN DERIVATIVE KERNEL - creates a gaussian derivative kernel.
%
% k = gaussiankernel(SIGMA,ORDER) creates a Gaussian derivative
% kernel with SIGMA the standard deviation and ORDER the order. 
%
% k = gaussiankernel(SIGMA) produces a zero order or "regular" Gaussian.
%
% The returned kernel k is a column vector, thus working in the first dimension (in
% images, this often is Y). 
%
% [k t] = gaussiankernel(...) also returns a vector t with the locations of
% the kernel elements.
%
% ----- Used Literature:
%
% Koenderink, J. J. 
%   The structure of images. 
%   Biological Cybernetics 50, 5 (1984), 363–370.
%
% Lindeberg, T. 
%   Scale-space for discrete signals. 
%   IEEE Transactions on Pattern Analysis and Machine Intelligence 12, 3 (1990), 234–254.
%
% Ter Haar Romeny, B. M., Florack, L. M. J., Salden, A. H., and Viergever, M. A. 
%   Higher order differential structure of images. 
%   Image and Vision Computing 12 (1994), 317–325.
%
% Ter Haar Romeny, B. M., Niessen, W. J., Wilting, J., and Florack, L. M. J. 
%   Differential structure of images: Accuracy of representation.
%   In First IEEE International Conference on Image Processing, (Austin, TX) (1994).
%
% See also gfilter, gaussiankernel2


%% Check input
if nargin<1; error([mfilename ': need at least one input arguments!']);  end;
if nargin>3; error([mfilename ': three input arguments is too much!']);  end;
if nargin<3 || isempty(sigma2szeRatio);  sigma2szeRatio=0;  end;
if nargin<2 || isempty(order);  order=0;  end;

if sigma<=0;  error([mfilename ': sigma should be larger than 0']);  end;
if order<0;  error([mfilename ': the order should be equal or larger than 0']);  end;
if round(order)~=order;  error([mfilename ': the order should be an integer number']);  end;


%% INIT

% if not given, calculate optimal sigma2szeratio
if sigma2szeRatio<=0
   sigma2szeRatio = 3 + 0.25 * order - 2.5/((order-6)^2+(order-9)^2); 
end

% check whether sigma is large enough
sigmaMin = 0.5 + order^(0.62) / 5;
if sigma < sigmaMin
   warning('The scale (sigma) is very small for the given order, better use a larger scale!'); 
end

% calculate kernel size
sze = ceil(sigma2szeRatio*sigma);

% create t vector which indicates the x-position
t = -sze:sze; % row vector
t = t(:); % column vector


%% CALCULATE GAUSSIAN

% precalculate some orders of sigma
sigma2 = sigma^2;
sqrt2  = sqrt(2);

% Calculate the gaussian, it is unnormalized. We'll normalize at the end.
basegauss = exp(- t.^2 / (2*sigma2) );

% Scale the t-vector, what we actually do is H( t/(sigma*sqrt2) ), where H() is the
% Hermite polynomial. 
x = t / (sigma*sqrt2);

% Depending on the order, calculate the Hermite polynomial (physicists notation).
% We let Mathematica calculate these, and put the first 20 orders in here.
% 20 orders should be sufficient for most tasks :)
switch order
    case 0,  part = 1;
    case 1,  part = 2*x;
    case 2,  part = -2 + 4*x.^2;
    case 3,  part = -12*x + 8*x.^3;
    case 4,  part = 12 - 48*x.^2 + 16*x.^4;
    case 5,  part = 120*x - 160*x.^3 + 32*x.^5;
    case 6,  part = -120 + 720*x.^2 - 480*x.^4 + 64*x.^6;
    case 7,  part = -1680*x + 3360*x.^3 - 1344*x.^5 + 128*x.^7;
    case 8,  part = 1680 - 13440*x.^2 + 13440*x.^4 - 3584*x.^6 + 256*x.^8;
    case 9,  part = 30240*x - 80640*x.^3 + 48384*x.^5 - 9216*x.^7 + 512*x.^9;
    case 10,  part = -30240 + 302400*x.^2 - 403200*x.^4 + 161280*x.^6 - 23040*x.^8 + 1024*x.^10;
    case 11,  part = -665280*x + 2217600*x.^3 - 1774080*x.^5 + 506880*x.^7 - 56320*x.^9 + 2048*x.^11;
    case 12,  part = 665280 - 7983360*x.^2 + 13305600*x.^4 - 7096320*x.^6 + 1520640*x.^8 - 135168*x.^10 + 4096*x.^12;
    case 13,  part = 17297280*x - 69189120*x.^3 + 69189120*x.^5 - 26357760*x.^7 + 4392960*x.^9 - 319488*x.^11 + 8192*x.^13;
    case 14,  part = -17297280 + 242161920*x.^2 - 484323840*x.^4 + 322882560*x.^6 - 92252160*x.^8 + 12300288*x.^10 - 745472*x.^12 + 16384*x.^14;
    case 15,  part = -518918400*x + 2421619200*x.^3 - 2905943040*x.^5 + 1383782400*x.^7 - 307507200*x.^9 + 33546240*x.^11 - 1720320*x.^13 + 32768*x.^15;
    case 16,  part = 518918400 - 8302694400*x.^2 + 19372953600*x.^4 - 15498362880*x.^6 + 5535129600*x.^8 - 984023040*x.^10 + 89456640*x.^12 - 3932160*x.^14 + 65536*x.^16;
    case 17,  part = 17643225600*x - 94097203200*x.^3 + 131736084480*x.^5 - 75277762560*x.^7 + 20910489600*x.^9 - 3041525760*x.^11 + 233963520*x.^13 - 8912896*x.^15 + 131072*x.^17;
    case 18,  part = -17643225600 + 317578060800*x.^2 - 846874828800*x.^4 + 790416506880*x.^6 - 338749931520*x.^8 + 75277762560*x.^10 - 9124577280*x.^12 + 601620480*x.^14 - 20054016*x.^16 + 262144*x.^18;
    case 19,  part = -670442572800*x + 4022655436800*x.^3 - 6436248698880*x.^5 + 4290832465920*x.^7 - 1430277488640*x.^9 + 260050452480*x.^11 - 26671841280*x.^13 + 1524105216*x.^15 - 44826624*x.^17 + 524288*x.^19;
    case 20,  part = 670442572800 - 13408851456000*x.^2 + 40226554368000*x.^4 - 42908324659200*x.^6 + 21454162329600*x.^8 - 5721109954560*x.^10 + 866834841600*x.^12 - 76205260800*x.^14 + 3810263040*x.^16 - 99614720*x.^18 + 1048576*x.^20;
    otherwise,
        error([mfilename ': derivative of that order not defined']);
end

% apply Hermite polynomial to gauss
k = (-1).^order .* part .* basegauss;


%% NORMALIZE

% By calculating the normalization factor by integrating the gauss, rather
% than using the expression 1/(sigma*sqrt(2pi)), we know that the KERNEL
% volume is 1 when the order is 0.
norm_default = 1 / sum(sum( basegauss ));
%           == 1 / ( sigma * sqrt(2*pi) )

% Here's another normalization term that we need because we use the Hermite
% polynomials.
norm_hermite = 1/(sigma*sqrt2)^order;

% Aditionally, we have a diffusion normalization term that prevents
% Gaussian derivatives to be low at high sigma. This one should only be
% applied when we are calculating Gaussian derivatives. Not when we are
% just smoothing!
% >>>> NO, THIS ONE IS BULLOCKS!

% So lets normalize...
k  = k .* ( norm_default * norm_hermite );
