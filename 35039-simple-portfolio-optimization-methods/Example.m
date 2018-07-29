% SIMPLE PORTFOLIO OPTIMIZATIONS - Semin Ibisevic (2012)
% http://www.mathworks.com/matlabcentral/fileexchange/authors/114076
%
%   TUTORIAL
%   To demonstrate how to use the simple portfolio optimization techniques,
%   multiple paths are simulated based on various horizons. This will give
%   the user the flexibility to adapt the code to its own preferences.
%   In this tutorial we replicate some of the features of the discrete time
%   Bellman equation. See Li and Ng (2001) and Van Binsbergen (2007).
%
%   The following assumptions are relevant:
%   -   A tradeoff is made between the returns and the risk free rate 'rf'
%   -   Weights are restricted between 0 and 1.
%
%   To calculate the optimal portfolio (myopic, buy-and-hold, constant 
%   proportion or dynamic) we use Monte Carlo simulation, consisting of the
%   following three steps:
%   1. simulate 'n' sample paths of 'k' periods of the asset returns and
%   predictor variables
%   2. set up a portfolio grid (done inside the functions)
%   3. calculate the optimal portfolio
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


% -------------------------------------------------------------------------
% SIMULATION OF THE PATHS
n       = 1000;         % path length (note, a small number is chosen due to computation time)
k       = 12;           % horizon length

% We use the estimates from Li and Ng (2001) and Van Binsbergen (2007) of 
% the coefficients and covariances of the disturbance terms
param.b11 = 0.2049;
param.b12 = 0.0568;
param.b21 = -0.1694;
param.b22 = 0.9514;
param.COV = [6.225, -6.044; -6.044, 6.316]*10^(-3);

[Xr, Xreg] = simBellman(n,k,param);


% -------------------------------------------------------------------------
% PREFERENCES (= OPTIONAL)

%   the portfolio optimization functions allows you to additionally input
%   your own preferences. The input of these parameters is optional. 

gamma      = 5.0;     % the amount of risk-aversion of the investor
rf         = 0.0;     % the risk free rate
accuracy   = 0.01;    % the single step length in the grid of numerical opt.


% -------------------------------------------------------------------------
% OPTIMAL MYOPIC PORTFOLIO WEIGHT

%   for the myopic portfolio we only use the simulated returns from the one
%   period horizon.

statsMy = optMyopic(Xr(:,1), gamma, rf, accuracy);


% -------------------------------------------------------------------------
% OPTIMAL BUY AND HOLD (CONSTANT PROPORTION) PORTFOLIO WEIGHT

%   The difference with the myopic strategy is that now we use the
%   cumulative returns instead of the single period returns. We calulate 
%   the optimal buy-and-hold portfolio for an investor with an investment
%   horizon of 'k' periods.

statsNH = optMyopic(sum(Xr,2), gamma, rf, accuracy);


% -------------------------------------------------------------------------
% OPTIMAL DYNAMIC PORTFOLIO WEIGHT

%   The dynamic portfolio uses both the (simulated) returns as well as the
%   (simulated) predictors.

statsDY = optDynamic(Xr, Xreg, gamma, rf, accuracy);

