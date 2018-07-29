% ASTROTIK by Francesco Santilli
% R2BP (Restricted Two Bodies Problem)
% N2H inverts the keplerian equation for an hyperbolic orbit and finds
% hyperbolic anomaly with numeric iterative methods.
%
% Usage: H = N2H(N,e)
%
% where: N(k) = mean anomaly [rad]
%        e = eccentricity [-] (e>1)
%        H(k) = hyperbolic anomaly [rad]

function H = N2H(N,e)

    if ~(nargin == 2)
        error('Wrong number of input arguments.')
    end
    
    K = check(N,1);
    check(e,0)
    
    if e<=1
        error('e must be strictly major than 1.')
    end
    
    H = zeros(K,1);
    
    for k = 1:K
        F = @(H) e*sinh(H)-H-N(k);
        N0 = abs(N(k));
        H0 = min( N0/(e-1), (6*N0/e)^(1/3) );
        if N(k) >= 0
            H1 = -eps;
            H2 = H0+eps;
        else
            H1 = -H0-eps;
            H2 = eps;
        end
        H(k) = regulafalsi(F,H1,H2);
    end
    
end