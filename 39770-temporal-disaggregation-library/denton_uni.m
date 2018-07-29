function res = denton_uni(Y,x,ta,d,sc,op1,op2)
% PURPOSE: Temporal disaggregation using the Denton method.
% -----------------------------------------------------------------------
% SYNTAX: res = denton_uni(Y,x,ta,d,sc,op1,op2);
% -----------------------------------------------------------------------
% OUTPUT: res: a structure
%         res.meth  = 'Denton';
%         res.N     = Number of low frequency data
%         res.ta    = Type of disaggregation
%         res.sc    = Frequency conversion
%         res.d     = Degree of differencing
%         res.y     = High frequency estimate
%         res.x     = High frequency indicator
%         res.U     = Low frequency residuals
%         res.u     = High frequency residuals
%         res.et    = Elapsed time
% -----------------------------------------------------------------------
% INPUT: Y: Nx1 ---> vector of low frequency data
%        x: nx1 ---> vector of low frequency data
%        ta: type of disaggregation
%            ta=1 ---> sum (flow)
%            ta=2 ---> average (index)
%            ta=3 ---> last element (stock) ---> interpolation
%            ta=4 ---> first element (stock) ---> interpolation
%        d: objective function to be minimized: volatility of ...
%            d=1 ---> first differences
%            d=2 ---> second differences
%        sc: number of high frequency data points for each low frequency data point
%            sc= 4 ---> annual to quarterly
%            sc=12 ---> annual to monthly
%            sc= 3 ---> quarterly to monthly
%        op1: additive (1) or proportional (2) variant
%        op2: standard (1) or Cholette (2) solution [optional, default=1] 
% -----------------------------------------------------------------------
% LIBRARY: aggreg
% -----------------------------------------------------------------------
% SEE ALSO: tdprint, tdplot
% -----------------------------------------------------------------------
% REFERENCE: Denton, F.T. (1971) "Adjustment of monthly or quarterly
% series to annual totals: an approach based on quadratic minimization",
% Journal of the American Statistical Society, vol. 66, n. 333, p. 99-102.
% Cholette, P. (1984) "Adjusting sub-annual series to yearly benchmarks",
% Survey Methodology, vol. 10, p. 35-49.

% written by:
%  Enrique M. Quilis
%  Macroeconomic Research Department
%  Ministry of Economy and Competitiveness
%  <enrique.quilis@mineco.es>

% Version 1.0 [January 2013]

t0=clock;

% -----------------------------------------------------------------------
% Checking d (minimization of the volatility of first differences or second
% differences).
if ((d ~= 1) & (d ~= 2))
    error ('*** d must be 1 or 2 ***');
end

% -----------------------------------------------------------------------
% Computing input dimensions.
[N,M] = size(Y);
[n,m] = size(x);

% Ckecking consistency among dimensions.
if ((m > 1) | (M > 1))
    error ('*** INCORRECT DIMENSIONS ***');
else
    clear m M;
end

% -----------------------------------------------------------------------
% Setting defaults: approximate solution as default solution.
if (nargin == 6)
    op2 = 1;
end

% Defining combination of variant (additive or proportional) and degree of
% differencing (d=1 or d=2).
FLAX = [1 2; 3 4];
flax = FLAX(op1,d);

% -----------------------------------------------------------------------
% Generation of aggregation matrix C.
C = aggreg(ta,N,sc);

% -----------------------------------------------------------
% Expanding the aggregation matrix to perform
% extrapolation if needed.
if (n > sc * N)
    pred = n - sc*N;           % Number of required extrapolations
    C = [C zeros(N,pred)];
else
    pred = 0;
end

% -----------------------------------------------------------------------
% Temporal aggregation matrix of the indicator.
X = C*x;

% -----------------------------------------------------------------------
% Computing low frequency residuals.
U = Y - X;

% -----------------------------------------------------------------------
% Computing difference matrix.
D = dif(1,n);

switch op2
    case 1
        % -----------------------------------------------------------------------
        % STANDARD SOLUTION.
        switch flax
            case 1 %Additive first differences.
                Q = D'*D;
            case 2 %Additive second differences.
                D2 = dif(2,n);
                Q = D2'*D2;
            case 3 %Proportional first differences.
                p = diag(x);
                pi = inv(p);
                Q = pi*D'*D*pi;
            case 4 %Proportional second differences.
                p = diag(x);
                pi = inv(p);
                D2 = dif(2,n);
                Q = pi*D2'*D2*pi;
        end; %of switch flax.
        % Final computations.
        Qi = inv(Q);
        u = Qi*C'*inv(C*Qi*C')*U;
        y = x + u;
    case 2
        % -----------------------------------------------------------------------
        % CHOLETTE SOLUTION.
        % First iteration: defining Q matrix.
        switch flax
            case {1,3} %First differences.
                D_1 = D(2:end,:);
                Q = D_1'*D_1;
            case {2,4} %Second differences.
                D_1 = D(2:end,:);
                D_2 = D(3:end,2:end);
                Q = D_1'*D_2'*D_2*D_1;
        end; %of switch flax, first iteration.
        % Final computations.
        Ye = [Q*x ; Y];
        % Second iteration: defining M matrix.
        switch flax
            case {1,2}
                M = [Q C'; C zeros(N,N)];
                ye = M \ Ye;
            case {3,4}
                xs = x ./ repmat(mean(x),n,1);
                ps = diag(xs);
                pse = diag([xs ; ones(N,1)]);
                M = [Q ps*C'; C*ps zeros(N,N)];
                Mi = inv(M);
                ye = pse*Mi*pse*Ye;
        end
        y = ye(1:n);
        lambda = ye(n+1:end);
        u = y - x;
end; %of switch op2.

% -----------------------------------------------------------------------
% Loading the structure
% -----------------------------------------------------------------------

% Basic parameters
res.meth = 'Denton';

FLAX1 = [1 2 ; 3 4];
flax1 = FLAX1(op1,op2);
switch flax1
    case 1
        res.meth1 = 'Additive variant, standard solution';
    case 2
        res.meth1 = 'Additive variant, Cholette solution';
    case 3
        res.meth1 = 'Proportional variant, standard solution';
    case 4
        res.meth1 = 'Proportional variant, Cholette solution';
end

res.N 	= N;
res.ta	= ta;
res.sc 	= sc;
res.pred = pred;
res.d 	= d;

% -----------------------------------------------------------------------
% Series
res.y = y;
res.x = x;
res.U = U;
res.u = u;

% -----------------------------------------------------------------------
% Elapsed time
res.et  = etime(clock,t0);
