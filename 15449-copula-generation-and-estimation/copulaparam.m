function param = copulaparam(type,tau)
%COPULAPARAM Copula parameter, given Kendall's rank correlation.
%   RHO = COPULAPARAM('Gaussian',TAU) returns the linear correlation
%   parameter RHO corresponding to a Gaussian copula having Kendall's rank
%   correlation TAU.  If TAU is a scalar correlation coefficient, RHO is a
%   scalar correlation coefficient corresponding to a bivariate copula.  If
%   TAU is a P-by-P correlation matrix, RHO is a P-by-P correlation matrix
%   corresponding to a P-variate copula.
%
%   RHO = COPULAPARAM('t',TAU) returns the linear correlation parameter RHO
%   corresponding to a t copula having Kendall's rank correlation TAU.  If
%   TAU is a scalar correlation coefficient, RHO is a scalar correlation
%   coefficient corresponding to a bivariate copula.  If TAU is a P-by-P
%   correlation matrix, RHO is a P-by-P correlation matrix corresponding to
%   a P-variate copula.
%   
%   ALPHA = COPULAPARAM(TYPE,TAU) returns the copula parameter ALPHA
%   corresponding to a bivariate Archimedean copula having Kendall's rank
%   correlation TAU.  TYPE is one of 'Clayton', 'Frank', or 'Gumbel'.
%
%   Example:
%      % Determine the linear correlation coefficient corresponding to a
%      % bivariate Gaussian copula having a rank correlation of -0.5
%      tau = -0.5
%      rho = copulaparam('gaussian',tau)
%
%      % Generate dependent beta random values using that copula
%      u = copularnd('gaussian',rho,100)
%      b = betainv(u,2,2)
%
%      % Verify that those pairs have a sample rank correlation approximately
%      % equal to tau
%      tau_sample = kendall(b)

%   Written by Peter Perkins, The MathWorks, Inc.
%   Revision: 1.0  Date: 2003/09/05
%   This function is not supported by The MathWorks, Inc.
%
%   Requires MATLAB R13.

if nargin < 2
    error('Requires two input arguments.');
end

switch lower(type)
case {'gaussian' 't'}
    if ((numel(tau) == 1) && (tau < -1 | 1 < tau)) || ((numel(tau) ~= 1) && ~iscor(tau))
        error('TAU must be a correlation coefficient between -1 and 1, or a positive semidefinite correlation matrix.');
    end
    param = sin(tau.*pi./2);
    
case {'clayton' 'frank' 'gumbel'}
    if (numel(tau) ~= 1) || (tau < -1 | 1 < tau)
        error('TAU must be a correlation coefficient between -1 and 1.');
    end
    switch lower(type)
    case 'clayton'
        if tau < 0
            error('TAU must be nonnegative for the Clayton copula.');
        end
        param = 2*tau ./ (1-tau);
    case 'frank'
        if tau == 0
            param = 0;
        elseif abs(tau) < 1
            % There's no closed form for alpha in terms of tau, so alpha has to be
            % determined numerically.
            warn = warning('off','MATLAB:fzero:UndeterminedSyntax');
            param = fzero(@frankRootFun,sign(tau),[],tau);
            warning(warn);
        else
            param = sign(tau).*Inf;
        end
    case 'gumbel'
        if tau < 0
            error('TAU must be nonnegative for the Gumbel copula.');
        end
        param = 1 ./ (1-tau);
    end
    
otherwise
    error('Unrecognized copula type: ''%s''',type);
end


function err = frankRootFun(alpha,targetTau)
if abs(alpha) < realmin
    tau = 0;
else
    tau = 1 + 4 .* (debye1(alpha)-1) ./ alpha;
end
err = tau - targetTau;
