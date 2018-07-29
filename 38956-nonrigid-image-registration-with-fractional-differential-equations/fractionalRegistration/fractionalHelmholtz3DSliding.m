function UNew = fractionalHelmholtz3DSliding(varargin)
% fractionalHelmholtz3DSliding: computes solution to the fractional
% Helmoltz equation in 3 dimensions with sliding boundary conditions.
%
% The continuous version of the fractional diffusion equation is:
%
%   d/dt U(x,y,z,t) - L^alpha/2 {U(x,y,z,t)} = f(x,y,z,t),
%
% where L^alpha/2 is the spatial fractional Laplacian operator.  A forward 
% discretization of this equation in time yields:
%
%   (U(x,y,z,t+tau) - U(x,y,z,t))/tau - L^alpha/2 {U(x,y,z,t+tau)} = f(x,y,z,t).
%
% Simplifying yields:
%   
%   (I - tau * L^alpha/2) {U(x,y,z,t+tau)} = U(x,y,z,t) + tau*f(x,y,z,t),
%
% which is what we call the "fractional Helmholtz equation".
%
% This function is called in the following manner:
%
% UNew = fractionalHelmholtz3DSliding(F,U,alpha,tau);
%
% arguments:
%   F (4-D array) - F(:,:,:,1), F(:,:,:,2), and F(:,:,:,3) are the
%       components of the force vector field F at time t
%   U (4-D array) - U(:,:,:,1), U(:,:,:,2), and U(:,:,:,3) are the
%       components of the estimate of the vector field U at time t.
%       If U is not supplied, it is assumed to be a zero vector field.
%   alpha (scalar) - order of the fractional Laplacian.  
%       The default (alpha = 2) generates the standard Laplacian.
%   tau (scalar) - time step.  Default tau = 1.
%

% author: Nathan D. Cahill
% email: nathan.cahill@rit.edu
% date: 28 October 2012

% Based on 1-D fractional Helmholtz solvers written by Clarissa Garvey

% parse input arguments
[F,U,alpha,tau,nR,nC,nS] = parseInputs(varargin{:});

% initialize UNew
UNew = zeros(nR,nC,nS,3);

% get transforms of kernels for each dimension with Dirichlet and Neumann 
% boundary conditions
[kTrans.row.Dirichlet,kTrans.row.Neumann] = getKernels(nR,alpha,tau,1);
[kTrans.col.Dirichlet,kTrans.col.Neumann] = getKernels(nC,alpha,tau,2);
[kTrans.slice.Dirichlet,kTrans.slice.Neumann] = getKernels(nS,alpha,tau,3);

%%%%%%%%%%%%%%%%%%%%%%%%%
% first component of vector field

% Dirichlet boundary conditions along y (first) dimension
A = imag(fft(U(:,:,:,1) + tau*F(:,:,:,1), 2*(nR-1), 1));
A = A(1:nR,:,:);

% Neumann boundary conditions along x (second) dimension
B = real(fft(A, 2*(nC-1), 2));

% Neumann boundary conditions along z (third) dimension
C = real(fft(B, 2*(nS-1), 3));

% divide by transformed filter coefficients - partially vectorized
H = kTrans.row.Dirichlet*kTrans.col.Neumann;
for k = 1:(2*(nS-1))
    C(:,:,k) = C(:,:,k)./(H.*kTrans.slice.Neumann(k));
end

% inverse sine transform along y (first) dimension
C = imag(fft(C, 2*(nR-1), 1));
C = C(1:nR,:,:);

% inverse cosine transform along x (second) dimension
B = real(fft(C, 2*(nC-1), 2));

% inverse cosine transform along z (third dimension)
A = real(fft(B, 2*(nS-1), 3));

% write first component into UNew
UNew(:,:,:,1) = A(1:nR,1:nC,1:nS);

%%%%%%%%%%%%%%%%%%%%%%%%%
% second component of vector field

% Dirichlet boundary conditions along x (second) dimension
A = imag(fft(U(:,:,:,2) + tau*F(:,:,:,2), 2*(nC-1), 2));
A = A(:,1:nC,:);

% Neumann boundary conditions along y (first) dimension
B = real(fft(A, 2*(nR-1), 1));

% Neumann boundary conditions along z (third) dimension
C = real(fft(B, 2*(nS-1), 3));

% divide by transformed filter coefficients - partially vectorized
H = kTrans.row.Neumann*kTrans.col.Dirichlet;
for k = 1:(2*(nS-1))
    C(:,:,k) = C(:,:,k)./(H.*kTrans.slice.Neumann(k));
end

% inverse sine transform along x (second) dimension
C = imag(fft(C, 2*(nC-1), 2));
C = C(:,1:nC,:);

% inverse cosine transform along y (first) dimension
B = real(fft(C, 2*(nR-1), 1));

% inverse cosine transform along z (third dimension)
A = real(fft(B, 2*(nS-1), 3));

% write second component into UNew
UNew(:,:,:,2) = A(1:nR,1:nC,1:nS);

%%%%%%%%%%%%%%%%%%%%%%%%%
% third component of vector field

% Dirichlet boundary conditions along z (third) dimension
A = imag(fft(U(:,:,:,3) + tau*F(:,:,:,3), 2*(nS-1), 3));
A = A(:,:,1:nS);

% Neumann boundary conditions along x (second) dimension
B = real(fft(A, 2*(nC-1), 2));

% Neumann boundary conditions along y (first) dimension
C = real(fft(B, 2*(nR-1), 1));

% divide by transformed filter coefficients - partially vectorized
H = kTrans.row.Neumann*kTrans.col.Neumann;
for k = 1:nS
    C(:,:,k) = C(:,:,k)./(H.*kTrans.slice.Dirichlet(k));
end

% inverse sine transform along z (third) dimension
C = imag(fft(C, 2*(nS-1), 3));
C = C(:,:,1:nS);

% inverse cosine transform along x (second) dimension
B = real(fft(C, 2*(nC-1), 2));

% inverse cosine transform along y (first dimension)
A = real(fft(B, 2*(nR-1), 1));

% write third component into UNew
UNew(:,:,:,3) = A(1:nR,1:nC,1:nS);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [F,U,alpha,tau,nR,nC,nS] = parseInputs(varargin)

% test number of inputs
narginchk(1,4);

% get / test first input
F = varargin{1};
[nR,nC,nS,nComp] = size(F);
if (numel(F)~=(nR*nC*nS*nComp)) || (nComp~=3)
    error([mfilename,':FWrongSize'],...
        'F must be a 4-D array with fourth dimension having three elements.');
end

% get / test second input
if nargin<2
    U = [];
else
    U = varargin{2};
end
if isempty(U)
    U = zeros(size(F)); % default
end
if ~isequal(size(U),size(F))
    error([mfilename,':UWrongSize'],...
        'U must be 4-D array having the same size as F.');
end

% get / test third input
if nargin<3
    alpha = [];
else
    alpha = varargin{3};
end
if isempty(alpha)
    alpha = 2; % default
end
if ~isscalar(alpha)
    error([mfilename,':alphaInvalid'],...
        'alpha must be a scalar.');
end

% get/test fourth input
if nargin<4
    tau = [];
else
    tau = varargin{4};
end
if isempty(tau)
    tau = 1; % default
end
if (~isscalar(tau)) || (tau<0)
    error([mfilename,':tauInvalid'],...
        'tau must be a positive scalar.');
end

end

function [D,N] = getKernels(numElements,alpha,tau,dim)

derivativeVector = helmholtzHelper(zeros(1,numElements),alpha/2,0);

% delete numElements+1 element
if numElements>1
    derivativeVector(numElements+1) = [];
end

% set up transform of vector for Neumann BC
N = fft(derivativeVector)/2 + tau;

% set up transform of vector for Dirichlet BC
D = N(1:numElements);

switch dim
    case 1
        D = D(:);
        N = N(:);
    case 2
        D = D(:).';
        N = N(:).';
    case 3
        D = reshape(D(:),[1 1 numel(D)]);
        N = reshape(N(:),[1 1 numel(N)]);
end

end