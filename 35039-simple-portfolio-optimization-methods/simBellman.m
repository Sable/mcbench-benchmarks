function [Xr, Xreg] = simBellman(n,k,param)
%SIMBELLMAN: Simulate 'n' sample paths of 'k' periods of asset returns 
%and predictor variables based on a discrete time Bellman equation.
%
%   [Xr, Xreg] = SIMBELLMAN(n, k, param) returns the simulated paths of
%   both the regressor 'Xreg' as well as the asset returns 'Xr' based on
%   the input parameters structure 'param'. In this particular case we 
%   simulate the discrete Bellman equation.
%
%   The following input parameters are relevant:
%       'n'     :     constant, the number of sample paths
%       'k'     :     constant, the horizon length
%       'param' :     structure, consisting of the parameters in the
%                     discrete time Bellman equation.
%
%   We assume the following discrete time Bellman equations:
%   [1]     Return{t}    = b11 + b12*Predictor{t-1} + eps{t}
%   [2]     Predictor{t} = b21 + b22*Predictor{t-1} + eta{t},
%   where 't' is the index and eps and eta are the disturbance terms.
%
%   The structure 'param' consists of the following inputs:
%       'param.b11' :   b11, the constant in equation [1]
%       'param.b12' :   b12, the slope in equation [1]
%       'param.b21' :   b21, the constant in equation [2]
%       'param.b22' :   b22, the slope in equation [2]
%       'param.COV' :   the covariance of the disturbances COV(eps,eta)
%                     
%   [Xr, Xreg] = SIMBELLMAN(...) returns the following two matrices
%   'Xr'  :     is a path-by-horizon matrix representing the simulated
%               returns based on various paths and multiple investment 
%               horizons.
%   'Xdp' :     is a path-by-horizon matrix representing a regressor/
%               predictor variable, which is chosen such that it opts to 
%               predict the simulated returns. For example, if one attempts
%               to predict the equity premium, the DP ratio is usually 
%               chosen. See also Rapach et. al (2011).
%
%
%  Semin Ibisevic (2012)
%  $Date: 02/05/2012$
%
% -------------------------------------------------------------------------
% References
%
% B.F. Diris. Portfolio Management. Econometric Institute, 2012. Lecture
% FEM21010.
%
% D. Li and W-L. Ng, 2001, Optimal Dynamic Portfolio Selection:
% Multiperiod Mean-Variance Formulation, Mathematical Finance, Volume 10
% (issue 3).
%
% Brand and Van Binsbergen, 2007, Optimal Asset Allocation in Asset
% Liability Management, NBER Working Paper No. 12970.
%
% -------------------------------------------------------------------------

Xr      = zeros(n, k+1);
Xreg    = zeros(n, k+1);

% set some arbitraty start values
Xreg(:,1)       = repmat(-3.4596,   1,  n);
Xr(:,1)         = repmat(-3.4596,   1,  n);

for i = 1:n
    for j = 2:k+1
    eT = mvnrnd([0 0], param.COV );
    Xr(i,j)         = param.b11 + param.b12*Xreg(i,j-1) + eT(1);
    Xreg(i,j)       = param.b21 + param.b22*Xreg(i,j-1) + eT(2);
    end
end
Xr(:,1)=[];
Xreg(:,1) = [];