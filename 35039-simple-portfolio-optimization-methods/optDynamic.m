function stats = optDynamic(returns, predictors, gamma, rf, accuracy)
%OPTDYNAMIC: Calculate the optimal portfolio weight through the dynamic
%strategy
%
%   STATS = OPTDYNAMIC(returns, predictors, ...) uses both predictor
%   variables and returns to calculate the optimal portfolio. If possible,
%   the conditional expectation is approximated by accross-path sample
%   means which is done in the very last step of the algorithm. As this is
%   not always feasible, different paths have different (simulated)
%   predictor variables, the approximation of such conditional expectations
%   are done by accross-path OLS regressions.
%
%   For more information about the methodology, see Li and Ng (2001) and
%   Brandt and Van Binsbergen (2007).
%
%   'returns'       is a 'n-by-k' matrix where the rows correspond to the
%                   sampling paths and the columns to the investment
%                   horizons. See also Example.m for a demonstration of
%                   setting up a portfolio grid.
%   'predictors'    is a 'n-by-k' matrix where the rows correspond to the
%                   sampling paths and the columns to the investment
%                   horizons. See also Example.m for a demonstration of
%                   setting up a portfolio grid.
%
%   The following assumptions are relevant:
%   -   A tradeoff is made between the input 'returns' and the risk free rate 'rf'
% 	-   The input consists only of the (simulated) returns.
%   -   Weights are restricted between 0 and 1.
%
%   STATS = OPTDYNAMIC(returns, predictors, 'gamma', ...) allows you to
%   specify an own risk aversion parameter 'gamma'.
%       'gamma'   :     risk-aversion constant, initially set to 5.
%
%   STATS = OPTDYNAMIC(returns, predictors, gamma, 'rf', ...) allows you to
%   specify the risk free rate, relevant for your optimization problem.
%       'rf'      :     the risk free rate constant, initial set to 0.
%
%   STATS = OPTDYNAMIC(returns, predictors, gamma, rf, accuracy) allows you
%   to choose the accuracy of the grid, initially set to 0.01.
%       'accuracy':     the single step length in the grid
%
%   STATS = OPTDYNAMIC(...) returns the structure 'stats' consisting of:
%       'stats.optWeight'   :  the optimal portfolio weight (in risky asset)
%
%   NB:     -   For three assets we need a two dimensional grid, which
%               leads appearantly to the curse of dimensionality. There are
%               methods that solve this problem, however such solutions are
%               beyond the scope of this code.
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

[n1, K1] = size(returns);
[n2, K2] = size(predictors);
if n1 ~= n2 || K1 ~= K2, error('optMyopic:InvalidInput', 'The dimensions of the returns are not equal to the dimensions of the predictors'); end
if K1 >= n1,  error('optMyopic:InvalidInput','The number of rows should be sufficiently larger than the number of columns'); end
if nargin < 2, error('optMyopic:InsufficientParameters','Both predictors and returns are necessary in the dynamic portfolio selection.'); end
if nargin < 3, gamma = 5; end   % default risk aversion
if nargin < 4, rf = 0; end      % default risk free rate
if nargin < 5, accuracy = 0.01; end

% One-dimensional grid
grid = 0.00:accuracy:1.00;

% init
n = n1;
K = K1;
Ufut    = ones(n,1);                    % future utility
U       = zeros(n,size(grid,2));        % utility
CU      = zeros(n,size(grid,2));        % conditional expectation for particular weight

% -------------------------------------------------------------------------
% INITIALIZE Future utility
% start in period (T+) K-1
for tIter = 1:K
    
    t = K-tIter;
    
    % reset the values
    OptU    = ones(n,1)*(-10^9);        % optimal utility
    PortW   = zeros(n,1);               % optimal portfolio weight
    
    wIter = 1;
    for w = grid
        
        % define the realized utility value for all paths i = 1,...,n
        U(:,wIter) = (1/(1-gamma))*(    (   w*exp( returns(:,t+1) ) + (1-w)*exp( rf )   ).^(1-gamma)    ).*Ufut;
        
        % regress the utility values on a constant and the regressors and use
        % the fitted values of the regression as a proxy for the conditional
        % expectation for portfolio weight 'w', denoted by 'CU'
        
        if t == 0
            Xtemp = ones(n,1);
            Ytemp = U(:,wIter);
            beta = (Xtemp'*Xtemp)\(Xtemp'*Ytemp);
            CU(:,wIter) = ones(n,1)*beta;
        else
            Xtemp = [ones(n,1), predictors(:,t)];
            Ytemp = U(:,wIter);
            beta = (Xtemp'*Xtemp)\(Xtemp'*Ytemp);
            CU(:,wIter) = [ones(n,1), predictors(:,t)]*beta;
        end
        
        % update conditions
        bin = CU(:,wIter) > OptU;
        OptU(bin) = CU(bin,wIter);
        PortW(bin) = repmat(w,sum(bin),1);
        
        %--
        wIter = wIter+1;
    end
    
    % update the other vectors
    Ufut = Ufut.*( PortW.*exp( returns(:,t+1) ) + (1-PortW).*exp( rf ) ).^(1-gamma);
    
end
% end in period (T+)

% -------------------------------------------------------------------------
% OPTIMAL portfolio weight

stats.optWeight = PortW(1); %in the last step the optimal weights for all paths are the same

