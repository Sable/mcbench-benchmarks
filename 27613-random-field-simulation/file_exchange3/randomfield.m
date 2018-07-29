function [F,KL] = randomfield(corr,mesh,varargin)
%RANDOMFIELD Generates realizations of a Gaussian random field.
%
% F = randomfield(corr,mesh)
% F = randomfield(corr,mesh,...)
% [F,KL] = randomfield(corr,mesh,...)
%   
% Outputs:
%   F:      A matrix of random field realizations. Each column is a
%           realization of the random field with each element corresponding
%           to a point supplied in the required input 'mesh'.
%
%   KL:     A struct containing the components of a Karhunen-Loeve (KL)
%           expansion of the random field. See below for a more detailed
%           description.
%
% Required inputs:
%   corr:       A struct containing the correlation information. See below
%               for details of the corr struct.
%
%   mesh:       A matrix of size nx by d, where nx is the number of points 
%               in the mesh and d is the dimension.
%
% Optional inputs:
% To specify optional inputs, use the 'key/value' format. For example, to
% set the number of realizations to 7, include 'nsamples',7 in the argument
% list. See the examples below for more details.
%
%   nsamples:   Number of realizations of the random field. (Default 1)
%
%   data:       A struct with prespecified data values that yields a
%               conditional random field. See below for the details of the
%               data struct. (Default [])
%
%   filter:     Set filter to a number between 0 and 1 to capture a
%               percentage of the energy of the field as determined by the
%               square roots of the eigenvalues of the covariance matrix. 
%               (Default 1 means no filter.)
%
%   trunc:      Explicitly sets a truncation level for the KL expansion.
%               (Default 0 means no truncation.)
%
%   spthresh:   Threshold for setting an element of the covariance matrix
%               to zero in the sparse matrix. (Default 0 means include all
%               elements).
%
%   mean:       A user supplied mean of the random field. Must match the
%               values of the given mesh. (Default zeros)
%
%   snaps:      A data matrix of realizations (snapshots) from a random
%               field on the mesh, where each column is a realization.
%
%   lowmem:     An option to reduce the memory footprint when constructing
%               the covariance matrix. Useful for very large meshes, but
%               very very slow.
%
% The output struct 'KL' with components of the Karhunen-Loeve representation
% of the random field has the following fields.
%   KL.mean:    The mean of the random field. If mean was supplied by the
%               user, then this is the same vector. If the field was
%               conditioned on data, then this is equivalent to Kriging
%               interpolant.
%
%   KL.bases:   The eigenvectors covariance matrix.
%
%   KL.sv:      The square root of the eigenvalues of the covariance
%               matrix. Plot these on a semilog scale to examine their
%               decay.
%
% The input struct 'data' must contain the following fields.
%   data.x:     A matrix of size ndata by d, where ndata is the number of
%               data points and d is the dimension of the mesh, containing
%               the points in the mesh where the field is known.
%
%   data.fx:    A vector of length ndata containing the known values of 
%               the random field.
%
% The input struct 'corr' may contain the following fields.
%   corr.name:  Specifies the correlation type from 'gauss', 'exp', or
%               'turbulent'.
%
%   corr.c0:    The scaling parameters for the correlation function. c0 may
%               be a scalar for isotropic correlation or a vector for
%               anisotropic correlation. In the anisotropic case, the
%               vector must have d elements, where d is the dimesion of a
%               mesh point.
%
%   corr.c1:    The second scaling parameters for the 'turbulent' 
%               correlation function. Not used with 'gauss' or 'exp'.
%
%   corr.sigma: The variance scaling parameter. May be a scalar or a vector
%               the size of the mesh. 
%
%   corr.C:     The correlation matrix between the unknown elements of the 
%               field. If the precomputed correlation matrix fits into 
%               memory, this is the best option.
%
%   corr.A:     The correlation matrix between data points.
%
%   corr.B:     The correlation matrix between data points and unknowns. 
%               The code expects this to be structured so that rows 
%               correspond to mesh points and columns correspond to data 
%               points.
%
% Example 1:
%   % build the correlation struct
%   corr.name = 'gauss';
%   corr.c0 = 1;
%   corr.sigma = 1;
%
%   mesh = linspace(-1,1,101)';              % generate a mesh
%   data.x = [-1; 1]; data.fx = [0; -1];    % specify boundaries
%
%   [F,KL] = randomfield(corr, mesh, ...
%               'nsamples', 10, ...
%               'data', data, ...
%               'filter', 0.95);
%
%   % to generate 100 more samples using the KL
%   trunc = length(KL.sv);                  % get the truncation level
%   W = randn(trunc,100); 
%   F2 = repmat(KL.mean,1,100) + KL.bases*diag(KL.sv)*W;
%   
% Example 2 (2-D):
%   % build the correlation struct
%   corr.name = 'exp';
%   corr.c0 = [0.2 1]; % anisotropic correlation
%
%   x = linspace(-1,1,11);
%   [X,Y] = meshgrid(x,x); mesh = [X(:) Y(:)]; % 2-D mesh
%
%   % set a spatially varying variance (must be positive!)
%   corr.sigma = cos(pi*mesh(:,1)).*sin(2*pi*mesh(:,2))+1.5;
%
%   [F,KL] = randomfield(corr,mesh,...
%               'trunc', 10);
%
%   % plot the realization
%   surf(X,Y,reshape(F,11,11)); view(2); colorbar;
%
% References:
%   M. Davis, "Production of Conditional Simulations via the LU Triangular
%       Decomposition of the Covariance Matrix". Mathematical Geology,
%       1987.
%
% Copyright 2011 Qiqi Wang (qiqi@mit.edu) and Paul G. Constantine 
% (paul.constantine@stanford.edu).

if nargin<2, error('Not enough inputs.'); end

nx=size(mesh,1);

% set default values.
nsamples=1;
data=[];
filter=1;
trunc=0;
spthresh=0.01;
mu=zeros(nx,1);
X=[];
lowmem=0;

% error checking the correlation struct
if ~isfield(corr,'name'), error('corr.name must be gauss, exp, or turbulent'); end
if ~isfield(corr,'c0'), error('corr.c0 missing.'); end
if ~isfield(corr,'c1')
    if strcmp(corr.name,'turbulent') 
        error('corr.c1 missing for turbulent correlation.'); 
    else
        corr.c1=[];
    end
end
if ~isfield(corr,'sigma'), error('corr.sigma is missing.'); end

% set input values and some error checking
for i=1:2:(nargin-2)
    switch lower(varargin{i})
        case 'nsamples'
            nsamples=varargin{i+1};
            if nsamples<1, error('nsamples must be greater than 1.'); end
        case 'data'
            data=varargin{i+1};
            if ~isfield(data,'x'), error('data struct must have field x.'); end
            if ~isfield(data,'fx'), error('data struct must have field fx.'); end
            if size(mesh,2) ~= size(data.x,2)
                error('Data and mesh are different dimensions.');
            end
        case 'filter'
            filter=varargin{i+1};
            if filter<=0 || filter>1, error('filter must be strictly between 0 and 1.'); end
        case 'trunc'
            trunc=varargin{i+1};
            if trunc<0 || trunc>nx, error('trunc must be positive and smaller than mesh size.'); end
        case 'spthresh'
            spthresh=varargin{i+1};
            if spthresh<0, error('spthresh must be positive.'); end
        case 'mean'
            mu=varargin{i+1};
            if isscalar(mu), mu=mu*ones(nx,1); else mu=mu(:); end
            if size(mu,1)~=nx, error('mean must match mesh.'); end
        case 'snaps'
            X=varargin{i+1};
            if size(X,1)~=nx, error('snaps must match mesh.'); end
        case 'lowmem'
            lowmem=varargin{i+1};
        otherwise
            error('Unrecognized option: %s\n',varargin{i});
    end
end

if ~isempty(data) && norm(mu)>0
    warning('User-input mean will be ignored.');
end

% Form the KL expansion from the data.
if ~isempty(X)
    fprintf('Using data samples to approximate the KL terms.\n');
    if ~isempty(data)
        warning('Ignoring interpolation points. Not compatible with user input snapshots.'); 
    end
    
    m=size(X,2);
    mu=(1/m)*sum(X,2);
    X0=X-repmat(mu,1,m);
    [U,S,~]=svd(X0,0);
    
    ev=(1/sqrt(m-1))*diag(S); 
    
    % generate the samples
    W=randn(m,nsamples);
    F=(U*diag(ev))*W+repmat(mu,1,nsamples);

    % construct the KL representation
    KL.mean=mu;
    KL.bases=U; 
    KL.sv=ev;
    
    return
end

% If lowmem option is selected, we recompute the entries of the matrix for
% each matrix-vector multiply. This option is SLOW and should only be used
% if the matrix does not fit into memory. 
if lowmem
    fprintf('Using lowmem option. Go get a coffee.\n');
    if ~trunc, error('Please enter a truncation with the variable trunc.'); end
    if ~isempty(data) 
        warning('Ignoring interpolation data. Not compatible with lowmem option.'); 
    end
    
    opts.issym=1;
    opts.isreal=1;
    opts.maxit=max(5*trunc,300);
    opts.disp=0;
    opts.v0=ones(nx,1);
    cfun=@(x) correlation_fun(...
        corr,...
        mesh,...
        [],...
        spthresh,...
        1,...
        x);
    
    [U,S,eigflag]=eigs(cfun,nx,trunc,'lm',opts);
    if eigflag==0
        fprintf(' eigs converged!\n');
    else
        fprintf(' eigs convergence flag: %d\n',eigflag);
    end
    
    ev=abs(diag(S)); 
    [ev,indz]=sort(ev,'descend');
    U=U(:,indz);
    
    % generate the samples
    W=randn(trunc,nsamples);
    F=U*diag(sqrt(ev))*W+repmat(mu,1,nsamples);

    % construct the KL representation
    KL.mean=mu;
    KL.bases=U; 
    KL.sv=sqrt(ev);
    
    return
end

% Construct correlation matrix between unknowns
if isfield(corr,'C') && ~isempty(corr.C)
    C=corr.C;
else
    C=correlation_fun(...
        corr,...
        mesh,...
        [],...
        spthresh);
end
    
if ~isempty(data)
    
    % Construct the correlation matrix between the data points.
    if isfield(corr,'A') && ~isempty(corr.A)
        A=corr.A;
    else
        A=correlation_fun(...
            corr,...
            data.x,...
            [],...
            spthresh);
    end
    
    % Construct the correlation matrix between the data points and the
    % unknowns.
    if isfield(corr,'B') && ~isempty(corr.B)
        B=corr.B;
    else
        B=correlation_fun(...
            corr,...
            mesh,...
            data.x,...
            spthresh);
    end
    
    % build the tranformation
    e=ones(length(data.x),1);
    L=chol(A,'lower');
    f=data.fx(:); b=L'\(L\e);
    lambda=((b'*f)-1)/(b'*e);
    a=L'\(L\f)-lambda*b;
    
    % compute the mean
    mu=B*a+lambda;
    
    % update the covariance
    E=L\B';
    C=C-(E'*E);
    
end

% compute the transform
opts.issym=1;
opts.isreal=1;
opts.maxit=max(5*trunc,300);
opts.disp=0;
opts.v0=ones(nx,1);
if trunc
    [U,S,eigflag]=eigs(C,trunc,'lm',opts);
elseif filter<1
    fprintf(' Estimating the spectral decay to approximate the energy.\n');
    
    % Estimating the decay of the eigenvalues to estimate energy.
    neig=10;
    ev=eigs(C,neig); ev=sort(ev,'descend');
    
    % Use an exponential model.
    Y=[ones(neig,1) -(1:neig)'];
    a=Y\log(sqrt(ev));
    sv_est=exp(a(1)).*(exp(a(2)).^(-(1:nx)'));
    
    % Find a trunction based on estimated decay.
    trunc=sum(cumsum(sv_est)<filter*sum(sv_est))+1;
    fprintf(' Estimated %d terms comprise %2d percent of the total energy\n',trunc,round(filter*100));
    
    [U,S,eigflag]=eigs(C,trunc,'lm',opts);
else
    fprintf(' Computing the full spectral decomposition of the %d-by-%d covariance matrix.\n',nx,nx);
    [U,S]=eig(full(C));
    trunc=nx;
    eigflag=0;
end
if eigflag==0
    fprintf(' eigs converged!\n');
else
    fprintf(' eigs convergence flag: %d\n',eigflag);
end

ev=abs(diag(S)); 
[ev,indz]=sort(ev,'descend');
U=U(:,indz);

% generate the samples
W=randn(trunc,nsamples);
F=(U*diag(sqrt(ev)))*W+repmat(mu,1,nsamples);

% construct the KL representation
KL.mean=mu;
KL.bases=U; 
KL.sv=sqrt(ev);


end

