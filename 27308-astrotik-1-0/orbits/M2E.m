% ASTROTIK by Francesco Santilli
% R2BP (Restricted Two Bodies Problem)
% M2E inverts the keplerian equation for an elliptical orbit and finds
% eccentric anomaly with a numeric iterative method.
%
% Usage: E = M2E(M,e)
%
% where: M(k) = mean anomaly [rad]
%        e = eccentricity [-] (0<e<1)
%        E(k) = eccentric anomaly [rad]

function E = M2E(M,e)

    if ~(nargin == 2)
        error('Wrong number of input arguments.')
    end
    
    K = check(M,1);
    check(e,0)
    
    if (e<=0 || e>=1)
        error('e must be in the range (0,1)')
    end
    
    E = zeros(K,1);
    for k = 1:K
        F = @(E) E-e*sin(E)-M(k);
        E1 = M(k)-e-eps;
        E2 = M(k)+e+eps;
        E(k) = regulafalsi(F,E1,E2);
    end

end