function C = cartoon(A)

% CARTOON Image abstraction using bilateral filtering.
%    This function uses the bilateral filter to abstract
%    an image following the method outlined in:
%
%       Holger Winnemoller, Sven C. Olsen, and Bruce Gooch.
%       Real-Time Video Abstraction. In Proceedings of ACM
%       SIGGRAPH, 2006. 
%
%    C = cartoon(A) modifies the color image A to have a 
%    cartoon-like appearance. A must be a double precision
%    matrix of size NxMx3 with normalized values in the 
%    closed interval [0,1]. Default filtering parameters
%    are defined in CARTOON.M.
%
% Douglas R. Lanman, Brown University, September 2006.
% dlanman@brown.edu, http://mesh.brown.edu/dlanman


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set the image abstraction parameters.

% Set bilateral filter parameters.
w     = 5;         % bilateral filter half-width
sigma = [3 0.1];   % bilateral filter standard deviations

% Set image abstraction paramters.
max_gradient      = 0.2;    % maximum gradient (for edges)
sharpness_levels  = [3 14]; % soft quantization sharpness
quant_levels      = 8;      % number of quantization levels
min_edge_strength = 0.3;    % minimum gradient (for edges)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Verify that the input image exists and is valid.
if ~exist('A','var') || isempty(A)
   error('Input image A is undefined or invalid.');
end
if ~isfloat(A) || size(A,3) ~= 3 || ...
      min(A(:)) < 0 || max(A(:)) > 1
   error(['Input image A must be a double precision ',...
          'matrix of size NxMx3 on the closed ',...
          'interval [0,1].']);      
end

% Apply bilateral filter to input image.
B = bfilter2(A,w,sigma);

% Convert sRGB image to CIELab color space.
if exist('applycform','file')
   B = applycform(B,makecform('srgb2lab'));
else
   B = colorspace('Lab<-RGB',B);
end

% Determine gradient magnitude of luminance.
[GX,GY] = gradient(B(:,:,1)/100);
G = sqrt(GX.^2+GY.^2);
G(G>max_gradient) = max_gradient;
G = G/max_gradient;

% Create a simple edge map using the gradient magnitudes.
E = G; E(E<min_edge_strength) = 0;

% Determine per-pixel "sharpening" parameter.
S = diff(sharpness_levels)*G+sharpness_levels(1);

% Apply soft luminance quantization.
qB = B; dq = 100/(quant_levels-1);
qB(:,:,1) = (1/dq)*qB(:,:,1);
qB(:,:,1) = dq*round(qB(:,:,1));
qB(:,:,1) = qB(:,:,1)+(dq/2)*tanh(S.*(B(:,:,1)-qB(:,:,1)));

% Transform back to sRGB color space.
if exist('applycform','file')
   Q = applycform(qB,makecform('lab2srgb'));
else
   Q = colorspace('RGB<-Lab',qB);
end

% Add gradient edges to quantized bilaterally-filtered image.
C = repmat(1-E,[1 1 3]).*Q;