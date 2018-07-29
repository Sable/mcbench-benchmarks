function X = MvnRndMatchCrossCov(S, varargin)
% X = MvnRndMatchCrossCov(S, J) simulates a panel of J scenarios of a
% multivariate normal random vector with zero sample mean and sample
% covariance exactly equal to S. Each row of X is a scenario and each
% column is a variable. 
%
% X = MvnRndMatchCrossCov(S, P, F, CovF) generates a multivariate normal
% panel X with zero sample mean, sample covariance S and sample cross
% covariance P with another zero-mean panel F. CovF, the sample covariance
% of F, is computed if not provided as input.

% IMPORTANT: The order of computations in the following expressions is
% important for efficiency. Please use the same order, or have a good reason
% to change it! 

% Code by S. Gollamudi. This version December 2009. 



% check input 
N = size(S,1);
if nargin==2,
    J = varargin{1};
    K = 0;
else
    P = varargin{1};
    F = varargin{2};
    [J,K] = size(F);
    assert(all(size(P)==[K,N]), 'Incorrect dimensions of cross-covariance P.');
    if length(varargin)<=2,
        CovF = cov(F,1);
    else
        CovF = varargin{3};
    end
    sqrtJ = sqrt(J);
end

% tolerance level
eps = 1e-9;

% Algorithm: X = F*B + V*R
% where F'*V=0, V'V=J*I and R is upper triangular

if K>0,
    
    % Compute B
    B = CovF \ P;

    % Compute R
    Sigma_orth = S - P'*B;
    var_orth = diag(Sigma_orth);
    var_x = diag(S);
    if any(var_orth < -eps*var_x),
        error('MvnRndMatchCrossCov: S and P are incompatible.')
    end
    i_positive = (var_orth > eps*var_x);
    num_positive = sum(i_positive);
    R = zeros(num_positive,N);
    R(:,i_positive) = chol(S(i_positive,i_positive) - P(:,i_positive)'*B(:,i_positive));

    % Generate V 
    Z = randn(J/2,N);
    Z=[Z
        -Z];
    
    % using QR decomposition
    %[V,dummy] = qr([F Z],0);
    %V = V(:,K+1:K+num_positive)*sqrtJ;
    
    % using modified Gram-Schmidt
    Z = Z - (F/CovF)*((F'*Z)/J);
    V = zeros(J,0);
    for n = 1:num_positive,
        u = Z(:,n) - V*((V'*Z(:,n))/J);
        V = [V u*(sqrtJ/norm(u))];
    end

    % generate panel X
    X = F*B + V*R;

else

    % generate X to have zero sample mean and sample covariance S
    Z = randn(J/2,N);
    Z = [Z
        -Z];
    X = Z * (chol(cov(Z,1)) \ chol(S));

end
