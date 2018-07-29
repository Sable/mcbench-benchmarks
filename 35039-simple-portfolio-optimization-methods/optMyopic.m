function stats = optMyopic(returns, gamma, rf, accuracy)
%OPTMYOPIC: Calculate the optimal portfolio weight through the Myopic
%strategy or alternatively the Buy-and-Hold strategy
%
%   STATS = OPTMYOPIC(returns, ...) retrieves the optimal portfolio weight
%   using the myopic strategy. A grid search is used, based on the input
%   variable 'returns'. At any grid point, the conditional expectation is
%   calculated. In the end, the portfolio weight with the highest
%   conditional expectation is selected.
%   Alternatively, one can use this function to calculate the optimal
%   portfolio with the buy-and-hold strategy. For an investor with
%   investment horizon of 'K' periods, define the cumulative returns over
%   the past 'K' periods and use K*rf instead of rf.
%
%   Note that it is optimal to invest myopically when there are not state
%   variables and when the future states and returns are independent
%   (conditional on the state variables), in continuous time. Moreover,
%   long-term investors should invest myopically when returns are identical
%   and independent distributed.
%
%   'returns'	:   is a 'n-by-1' vector. One could use realized returns or
%                   simulated path returns (see also example).
%
%   The following assumptions are relevant: 
%   -   A tradeoff is made between the input 'returns' and the risk free rate 'rf'
% 	-   The input consists only of the (simulated) returns.
%   -   Weights are restricted between 0 and 1.
%
%   STATS = OPTMYOPIC(returns, 'gamma', ...) allows you to specify an own
%   risk aversion parameter 'gamma'.
%       'gamma'   :     risk-aversion constant, initially set to 5.
%
%   STATS = OPTMYOPIC(returns, gamma, 'rf', ...) allows you to specify the
%   risk free rate, relevant for your optimization problem.
%       'rf'      :     the risk free rate constant, initial set to 0.
%
%   STATS = OPTMYOPIC(returns, gamma, rf, 'accuracy') allows you to extend
%   the accuracy of the grid, initially set to 0.01.
%       'accuracy':     the single step length in the grid
%
%   STATS = OPTMYOPIC(...) returns the structure 'stats' consisting of:
%       'stats.optWeight'   :  the optimal portfolio weight (in risky asset)
%       'stats.optCU'       :  optimal conditional expectation
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
% -------------------------------------------------------------------------

[n, m] = size(returns);
if m >= n,  error('optMyopic:InvalidInput','The number of rows should be sufficiently larger than the number of columns'); end
if m > 1,   error('optMyopic:InvalidInput','The input should consist only of one column. Note: to calculate the portfolio weights using the Buy-and-Hold strategy, use cumulative returns over the past k periods instead.'); end

if nargin < 1, error('optMyopic:InsufficientParameters','Input variable is necessary'); end
if nargin < 2, gamma = 5; end   % default risk aversion
if nargin < 3, rf = 0; end      % default risk free rate
if nargin < 4, accuracy = 0.01; end 

% One-dimensional grid
grid = 0.00:accuracy:1.00;

% init
U = zeros(n,size(grid,2));
CU = zeros(1,size(grid,2));
CUopt = -10^(9);
gridopt = 0;

% -------------------------------------------------------------------------

% pick portfolio weight from the grid
wIter = 1;
for w = grid
   
   % define the realized utility value for all i = 1,...,n
   U(:,wIter) = (1/(1-gamma)) * ( w*exp( returns ) + (1-w)*exp( rf ) ).^(1-gamma);
   
   % approximate the conditional expected utlity for grid point w
   CU(wIter) = (1/n)*sum( U(:,wIter) );
   
   % update
   if CU(wIter) > CUopt
       CUopt = CU(wIter);
       gridopt = w;
   end
   
   wIter = wIter + 1;
   
end

stats.optWeight = gridopt;
stats.optCU = CUopt;
