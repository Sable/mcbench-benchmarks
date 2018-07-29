function [H, pValue, Lambda, Orders, CI] = chaostest(X, ActiveFN, maxOrders, alpha, flag)
%CHAOSTEST performs the test for Chaos to test the positivity of the
%   dominant Lyapunov Exponent LAMBDA.
%
%   The test hypothesis are:
%   Null hypothesis: LAMBDA >= 0 which indicates the presence of chaos.
%   Alternative hypothesis: LAMBDA < 0 indicates no chaos.
%   This is a one tailed test.
%
%   [H, pValue, LAMBDA, Orders, CI] = ...
%           CHAOSTEST(Series, ActiveFN, maxOrders, ALPHA, FLAG)
%
% Inputs:
%   Series - a vector of observation to test.
%
% Optional inputs:
%   ActiveFN - String containing the activation function to use in the
%     neural net estimation. ActiveFN can be the 'LOGISTIC' function
%     f(u) = 1 / (1 + exp(- u)), domain = [0, 1], or 'TANH' function
%     f(u) = tanh(u), domain = [-1, 1], or 'FUNFIT' function
%     f(u) = u * (1 + |u/2|) / (2 + |u| + u^2 / 2), domain = [-1, 1].
%     Default = 'TANH'.
%
%   maxOrders - the maximum orders that the chaos function defined
%     in CHAOSFN can take. This must be a vector containing 3 elements.
%     maxOrders = [L, m, q].
%     Increasing the model's orders can slow down calculations.
%     Default = [5, 6, 5].
%
%   ALPHA - The significance level for the test (default = 0.05)
%
%   FLAG  - String specifying the method to carry out the test, by
%     varying the triplet (L, m, q) {'VARY' or anything else} or by
%     fixing them {'FIX'}. Default = {'VARY'}.
%
% Outputs:
%   H = 0 => Do not reject the null hypothesis of Chaos at significance
%            level ALPHA.
%   H = 1 => Reject the null hypothesis of Chaos at significance level
%            ALPHA.
%
%   pValue - is the p-value, or the probability of observing the given
%     result by chance given that the null hypothesis is true. Small
%     values of pValue cast doubt on the validity of the null hypothesis
%     of Chaos.
%
%  LAMBDA - The dominant Lyapunov Exponent.
%     If LAMBDA is positive, this indicates the presence of Chaos.
%     If LAMBDA is negative, this indicates the absence of Chaos.
%
%   Orders - gives the triplet (L, m, q) that minimizes the Schwartz
%     Information Criterion to obtain the best coefficients to compute
%     LAMBDA.
%
%   CI - Confidence interval for LAMBDA at level ALPHA.
%
%   The algorithm uses the Jacobian method in contrast to the direct
%   method, it needs the optimazition, the statistics, and the garch
%   toolboxes.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                Copyright (c) 17 March 2004 by Ahmed Ben Saïda          %
%                 Department of Finance, IHEC Sousse - Tunisia           %
%                       Email: ahmedbensaida@yahoo.com                   %
%                    $ Revision 4.0 $ Date: 17 Mars 2013 $               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
% References: 
%             Whang Y. and Linton O. (1999), "The asymptotic distribution
%               of nonparametric estimates of the Lyapunov exponent for
%               stochastic time series", Journal of Econometrics 91: 1-42.
%             Shintani M. and Linton O. (2004), "Nonparametric neural
%               network estimation of Lyapunov exponents and direct test
%               for chaos", Jounal of Econometrics 120: 1-33.
%             Andrews D. (1991), "Heteroskedasticity and autocorrelation
%               consistent covariance matrix estimation", Econometrica
%               59: 817-858.
%             Abarbanel H.D.I., Brown R. and Kennel M.B. (1991), "Lyapunov
%               exponents in chaotic systems: their importance and their
%               evaluation using observed data", International Journal of
%               Modern Physics B 5: 817-858.
%

% Set initial conditions.

if (nargin >= 1) && (~isempty(X))

   if numel(X) == length(X)   % Check for a vector.
      X  =  X(:);                  % Convert to a column vector.
   else
      error(' Observation ''Series'' must be a vector.');
   end

   % Remove any NaN (i.e. missing values) observation from 'Series'. 
   
    X(isnan(X)) =   [];
         
else
    error(' Must enter at least observation vector ''Series''.');
end

%
% Specify the activation function to use in CHAOSFN and ensure it to be a
% string. Set default if necessary.
%

if nargin >= 2 && ~isempty(ActiveFN)
    if ~ischar(ActiveFN)
        error(' Activation function ''ActiveFN'' must be a string.')
    end

    % Specify the activation function to use:
    % ActiveFN = {'logistic', 'tanh', 'funfit'}.
    
    if ~any(strcmpi(ActiveFN , {'tanh' , 'logistic' , 'funfit'}))
        error('Activaton function ''ActiveFN'' must be TANH, LOGISTIC, or FUNFIT');
    end
    
else
    ActiveFN    =   'tanh';
end

%
% Ensure the maximum orders maxL, maxM and maxQ are positive integers, and
% set default if necessary.
%

if (nargin >= 3) && ~isempty(maxOrders)
    if numel(maxOrders) ~= 3 || any((maxOrders - round(maxOrders) ~= 0)) || ...
            any((maxOrders <= 0))
      error(' Maximum orders ''maxOrders'' must a vector of 3 positive integers.');
    end
else
    maxOrders = [5, 6, 5];
end

maxL = maxOrders(1);
maxM = maxOrders(2);
maxQ = maxOrders(3);

% Check for a minimum size of vector X.
if length(X) <= maxL * maxM
    error(' Observation ''Series'' must have at least %d obeservations.',maxL*maxM+1)
end

%
% Ensure the significance level, ALPHA, is a 
% scalar, and set default if necessary.
%

if (nargin >= 4) && ~isempty(alpha)
   if numel(alpha) > 1
      error(' Significance level ''Alpha'' must be a scalar.');
   end
   if (alpha <= 0 || alpha >= 1)
      error(' Significance level ''Alpha'' must be between 0 and 1.'); 
   end
else
   alpha  =  0.05;
end

%
% Check the method to carry out the test, by varying (L, m, q) or by fixing
% them, and set default if necessary. The method must be a string.
%

if nargin >= 5 && ~isempty(flag)
    if ~ischar(flag)
        error(' Regressions type ''FLAG'' must be a string.')
    end    
else
    flag  =   'VARY';
end

if strcmpi(flag, 'FIX')
    StartL  =   maxL;
    StartM  =   maxM;
    StartQ  =   maxQ;
else
    StartL  =   1;
    StartM  =   1;
    StartQ  =   1;
end

% Initialize the Lyapunov Exponent to a small number.
Lambda =   - Inf;

%
% Create the structure OPTIONS to use for nonlinear least square function
% LSQNONLIN (included in the optimization toolbox).
%

Options =   optimset('lsqnonlin');
Options =   optimset(Options, 'Display', 'off');

% Use the user supplied analytical Jacobian in CHAOSFN.
Options =   optimset(Options, 'Jacobian', 'on');

% Initialize the starting value for the coefficient THETA.
StartValue  =   0.5;

for L = StartL:maxL
    for m = StartM:maxM
        for q = StartQ:maxQ
            
            A = StartValue * ones(q, m); % Contains the coefficients gamma(i,j).
            B = StartValue * ones(q, 1); % Contains the coefficients gamma(0,j).
            C = StartValue * ones(1, q); % Contains the coefficients beta(j).
            D = StartValue; % Constant.
            %E = StartValue * ones(1, m); % Linear coefficients for lagged X.
            
            Theta0 = [reshape(A', 1, q*m), B', C, D];
            %Theta0 = [reshape(A', 1, q*m), B', C, D, E];
            
            Theta = lsqnonlin('chaosfn', Theta0, [], [], Options, X, L, m, q, ActiveFN);
        
            T      =  length(X) - m*L; % New sample size.

%
% Use an inner function JACOBMATX to compute the Jacobian needed
% to compute the Lyapunov Exponent LAMBDA. This jacobian is relative
% to X and not to parameter THETA. N.B: the jacobian given by
% LSQNONLIN is relative to parameter THETA.
%

            JacobianMatrix   =   jacobmatx(Theta, X, L, m, q, ActiveFN);

%
% We distinguish between the "sample size" T used for estimating
% the Jacobian, and the "block length" M which is the number of
% evaluation points used for estimating LAMBDA (M <= T).
%

            n   =   3;
            h   =   round(T^(1/n)); % Number of blocks or step.

% We can choose the full sample by setting h = 1. When h > 1,
% the obtained exponent is the Local Lyapunov Exponent.

            newIndex    =   (h:h:T);

            M   =   length(newIndex); % Equally spaced subsample's size.

%
% Compute the dominant Lyapunov Exponent LAMBDA. The dominant exponent
% corresponds to the maximum eigenvalue of Tn(M)'*Tn(M). The following
% procedure uses a sample estimation of the Lyapunov exponent as
% described by Whang Y. and Linton O. (1999).
%

            Tn  =   JacobianMatrix(:, :, newIndex);
            for t = 2:M
                Tn(:, :, t)  =   Tn(:, :, t) * Tn(:,:,t-1);
            end

%
% Compute the "QR" estimate of LAMBDA as suggested by Abarbanel et al.
% (1991) by multiplying Tn by a unit vector U0 to reduce the systematic
% positive bias in the formal estimate of LAMBDA. U0 is chosen at random
% with respect to uniform measure on the unit sphere.
%

% In practice: U0 = [1; 0; 0; ...; 0].

            U0    =   [1; zeros(m-1, 1)];
            
% Or choose the U0 at random in the interval [0, 1] and ensure that the sum
% is unity.

            %U0 = rand(m,1);
            %U0 = U0 / sum(U0);
            
            v   =   eig((Tn(:, :, M) * U0)' * (Tn(:, :, M) * U0));
            
            % LAMBDA is the largest Lyapunov exponent for the specified
            % orders. To avoid Log of zero, when max(v) is zero replace
            % it with REALMIN.
            
            Lambda1  =  1/(2*M) * log(max([v ; realmin])); 

%
% Choose the largest Lyapunov exponent from all regressions carried by
% varying L, m, and q. So we have L*m*q regressions in total, the chosen
% LAMBDA is the largest of all. The triplet (L, m, q) can be seen as
% the degree of complexity of a chaotic map, if a process is not chaotic,
% it will reject the null hypothesis for all orders (L, m, q), else, it
% will accept the null for some orders where the chaotic map get more
% complex.
%

            if Lambda1 >= Lambda
                
                Lambda  = Lambda1;
                Orders  =   [L, m, q];
%
% Compute the asymptotic variance of the Lyapunov Exponent for noisy
% systems as computed by Shintani M. and Linton O. (2004).
%

                esp     =   realmin;
                Eta     =   zeros(M, 1);
                Eta(1)  =   0.5 * log(max(esp, max(eig(Tn(:, :, 1)' * ...
                    Tn(:, :, 1))))) - Lambda;

% Ensure that the obtained eigenvalue is not zero, if so, replace it with
% a positive small number REALMIN to avoid 'log of zero' and 'divide by zero'.

                for t = 2:M
                    Eta(t)  =   0.5 * log(max(esp, max(eig(Tn(:, :, t)' * ...
                        Tn(:, :, t))))./ max(esp, max(eig(Tn(:, :, t-1)' * ...
                        Tn(:, :, t-1))))) - Lambda;
                end

                gamm    =   zeros(M, 1);                
                for i = 1:M
                    gamm(i) =   1/M * Eta(M-i+1:M)' * Eta(1:i);
                end

                gamm   =   [gamm(1:end-1); flipud(gamm)];

%
% Compute the Lag truncation parameter. This is the optimal Lag as defined
% by Andrews (1991) p-830 for the Quadratic Spectral Kernel. The coefficient
% is for the QS kernel, Andrews (1991) p-830. The coefficient a(2) as defined
% by Andrews converges to 1: a(2) -> 1, its inverse too converges to 1:
% 1/a(2) -> 1, Andrews (1991) p-837. Because the calculation of a(2) is very
% difficult for neural network model, use the evident coeffiicent a(2) = 1.
% Limit(Sm, M, Inf) = Inf and Limit(Sm/M, M, Inf) = 0.
%

                Sm      =   1.3221 * (1 * M)^(1/5);
                
%
% Compute the kernel function needed to estimate the asymptotic variance of
% LAMBDA. The used kernel function is the Quadratic Spectral Kernel as
% defined by Andrews D. (1991) p-821.
%

                j           =   -M+1:M-1;
                KernelFN    =   ones(size(j));

                z           =   6 * pi * (j./Sm) / 5;

                % The limit(KernelFN(z), z, 0) = 1, so remove all z == 0.
                z(j==0)     =   [];

                KernelFN(j~=0)    =   (3 ./ z.^2) .* (sin(z) ./ z - cos(z));

%
% Compute the asymptotic variance of LAMBDA and prevent it from being
% negative or NaN. Next, compute the statistic of LAMBDA.
%

                varLambda       =   max(esp, KernelFN * gamm);
                LambdaStatistic =   Lambda / sqrt(varLambda / M);
                
            end

        end
    end
end

%
% The statistic just found is for the one-sided test where the null
% hypothesis: LAMBDA >= 0 (presence of chaos) against the alternative
% LAMBDA < 0 (no chaos). This statistic is asymptotically normal.
% This test is for TAIL = 1.
%

pValue   =   normcdf(LambdaStatistic, 0, 1);

%
% Compute the critical value and the confidence interval CI for the true
% LAMBDA only when asked because NORMINV is computationally intensive.
%

if nargout >=5
    crit     = norminv(1 - alpha, 0, 1) * sqrt(varLambda / M);
    CI       = [(Lambda - crit), Inf];
end

%
% To maintain consistency with existing Statistics Toolbox hypothesis
% tests, returning 'H = 0' implies that we 'Do not reject the null 
% hypothesis of chaotic dynamics at the significance level of alpha'
% and 'H = 1' implies that we 'Reject the null hypothesis of chaotic
% dynamics at significance level of alpha.'
%

H  = (alpha >= pValue);

%-------------------------------------------------------------------------%
%                       Helper function JACOBMATX                         %
%-------------------------------------------------------------------------%

function    J   =   jacobmatx(Theta, X, L, m, q, ActiveFN)
%JACOBMATX computes the Jacobian matrix needed to compute the Lyapunov
%   exponent LAMBDA. The jacobian matrix is relative to X: dF(X)/dX. Not
%   to confuse with the jacobian needed to determine the coefficient THETA.
%   The last Jacobian is relative to THETA and not X.

XLAG   =  lagmatrix(X, L:L:L*m); % size(XLAG) = [T, m].
XLAG   =  XLAG(m*L+1:end, :); % Remove all NaN observation.
T      =  length(X) - m*L; % New sample size.

A   =   reshape(Theta(1:q*m), m, q)'; % size(A) = [q, m].
B   =   Theta(q*m+1:q*m+q)'; % size(B) = [q, 1].
C   =   Theta(q*m+q+1:q*m+q+q); % size(C) = [1, q].

u   =   A * XLAG' + repmat(B,1,T); % size(u) = [q, T].

J   =   zeros(m, m, T);

J(2:end, 1:end-1, :)  =   repmat(eye(m-1), [1 1 T]);

switch upper(ActiveFN)
    case 'LOGISTIC'
        J(1, :, :)  =   A' * (repmat(C', 1, T) .* (exp(- u) ./ ...
            (1 + exp(- u)).^2));
        
    case 'TANH'
        J(1, :, :)  =   A' * (repmat(C', 1, T) .* (sech(u).^2));
        
    case 'FUNFIT'
        J(1, :, :)  =   A' * (8 * repmat(C', 1, T) .* ...
                (1 + abs(u)) ./ (3 + (1 + abs(u)).^2).^2);
            
    otherwise
        error(' Unrecognized activation function!')
end