function stats = nbreg( x, y, varargin )
% nbreg - Negative binomial regression 
% 
% Author: Surojit Biswas
% Email: sbiswas@live.unc.edu
% Institution: The University of North Carolina at Chapel Hill
%
% References: 
% [1] Hardin, J.W. and Hilbe, J.M. Generalized Linear Models and
% Extensions. 3rd Ed. p. 251-254. 
% 
% INPUT:
% x     =   [n x p] Design matrix. Rows are observations, Columns are
%           variables. (required)*
% y     =   [n x 1] Response matrix. Rows are observations. (required)
% 
% The following inputs are optional. For optional inputs the function call
% should include the input name as a string and then the input itself.
% For example, nbreg(x, y, 'b', myStartingRegCoeffs)
%
% alpha =   Scalar value. Starting estimate for dispersion parameter.
%           (optional, DEFAULT = 0.01)
% b     =   [p x 1] starting vector of regression coefficients. (optional,
%           DEFAULT = estimated with poisson regression)
% offset =  [n x 1] offset vector. (optional, default = 0)**
% trace =   logical value indicating if the algorithm's progress should be
%           printed to the screen. (optional, default = false)
% regularization = scalar specifying the amount of regularization (default
%                  = 1e-4). 
% distr     =   Distribution to fit ['poisson' | 'negbin' (defualt)];
% estAlpha  =   Estimate alpha or use the alpha provided? [true (default) |
%               false]
%
% OUTPUT:
% stats.b       =   [p x 1] vector of estimated regression coefficients.
% stats.alpha   =   Estimated dispersion parameter.
% stats.logL    =   Final model log-likelihood.
% stats.delta   =   Objective change at convergence. 
%
% NOTES:
% *  Supply your own column of ones for an intercept term.
% ** Make sure you have taken the log of the offset vector if necessary.
% If one wants to include an offset to control for exposure time/fit a rate
% model, then typically the offset vector should log-ed before it's
% supplied as an input. The regression routine assumes that E[y|x] ~ X*b +
% log(offset)


n = size(y,1);
p = size(x,2);
assert(n == size(x,1), 'Dimension mismatch between x and y');
df = n - p;
ALPHATHRESH = 1e-8;

%% Get variable arguments
% Offset.
offset = getVararg(varargin, 'offset');
if isempty(offset)
    offset = 0;
end

% Regression coefficients.
b = getVararg(varargin, 'b');
if isempty(b)
    mu = (y + mean(y))/2;
    eta = log(mu);
    b = Inf(size(x,2),1);
else
    eta = x*b + offset;
    mu = exp(eta);
end

% Alpha
alpha = getVararg(varargin, 'alpha');
if isempty(alpha)
    alpha = 0.01;
elseif alpha < ALPHATHRESH
    alpha = 0.01;
end

% Trace
trace = getVararg(varargin, 'trace');
if isempty(trace)
    trace = false;
end

% Regularization
reg = getVararg(varargin, 'regularization');
if isempty(reg)
    reg = 1e-4;
end

% Distribution
distr = getVararg(varargin, 'distr');
if isempty(distr)
    distr = 'negbin';
end

% Estimate alpha?
estAlpha = getVararg(varargin, 'estAlpha');
if isempty(estAlpha)
    estAlpha = true;
end




if trace
    fprintf('Delta\t');
    fprintf('alpha\t');
    for i = 1 : p
        fprintf('b_%0.0f\t', i)
    end
    fprintf('\n');
end



%% Optimize
MAXIT = 50;
eps = 1e-4;
REG = reg*eye(p);
LSOPTS.SYM = true;
LSOPTS.POSDEF = true;



del = Inf;
itr = 1;
logL = -Inf;
objChange = Inf;


while itr < MAXIT && objChange > eps
    innerItr = 0;
    while any(del > eps) && innerItr < 1000
        if strcmpi(distr, 'negbin')
            w =  repmat(mu./(1 + alpha*mu), 1, p)';     % Weight matrix
        elseif strcmpi(distr, 'poisson')
            w = repmat(mu, 1, p)';
        else
            error('Unknown distribution');
        end
        z = (eta + (y - mu)./mu) - offset;          % Working response
        xtw = x'.*w;                                % X'*W
        bold = b; 
        try
            b = linsolve(xtw*x + REG, xtw*z, LSOPTS);   % Update
        catch 
            b = linsolve(xtw*x + REG, xtw*z);
        end  
        eta = x*b + offset;                         % Linear predictor
        mu = exp(eta);                              % Mean

        del = abs(bold - b);
        innerItr = innerItr + 1;
    end
    
    if strcmpi(distr, 'poisson')
        alpha = 0;
        break
    end
    
    if ~estAlpha
        objChange = nan;
        amu = alpha*mu;
        amup1 = 1 + amu;
        logL = sum( y.*log( amu./amup1 ) - (1/alpha)*log(amup1) + gammaln(y + 1/alpha) - gammaln(y + 1) - gammaln(1/alpha));
        break
    end
    

    alpha = alphaLineSearch(y, mu, alpha);

    
    % Likelihood evaluation.
    amu = alpha*mu;
    amup1 = 1 + amu;
    plogL = logL;
    logL = sum( y.*log( amu./amup1 ) - (1/alpha)*log(amup1) + gammaln(y + 1/alpha) - gammaln(y + 1) - gammaln(1/alpha));
    objChange = (logL - plogL); if isnan(objChange); objChange = Inf; end
    
    
    % Display an update if trace switch is on.
    if trace
        fprintf('%0.6f\t', [objChange, alpha, b']);
        fprintf('\n');
    end
    if alpha < ALPHATHRESH
        break
    end    
    
    itr = itr + 1;
    del = Inf;
end

stats.alpha = alpha;
stats.b = b;
stats.logL = logL;
stats.delta = objChange;
    

    function [ alpha ] = alphaLineSearch( y, mu, alpha, varargin )
        
        gridSize = getVararg(varargin, 'gridSize');
        if isempty(gridSize)
            gridSize = 0.1;
        end


        border = 1e-10;



        interval = [Inf, -Inf];
        gflank = [Inf, -Inf];

        g = updateWindow(alpha);
        sg = g;
        % Crudely follow the gradient by stepping in that direction until you 
        % get to a point where it changes. At this point you know you have
        % bounded the domain value that maximizes the function. This is
        % assuming that the function being optimized is convex.
        while sign(sg) == sign(g)
            proposal = alpha + gridSize*sign(sg);

            % Ensure the proposal doesn't violate the constraint that alpha >
            % 0.
            if proposal <= 0
                % Check left border to see if we're looking at a corner
                % solution. If it's a corner solution (gradient at border is
                % negative) then return the border and exit. Otherwise set the
                % left edge of the interval to the border.
                [~, g] = alphaML(y,mu,border);
                if g < 0
                    alpha = border;
                    return;
                else
                    interval(1) = border;
                    gflank(1) = g;
                    break;
                end
            end

            alpha = proposal;
            sg = updateWindow(alpha);
        end

        % At this point the solution lies between interval(1) and interval(2).
        % note this means there is an interior point solution.
        while interval(2) - interval(1) > 1e-6
            %gt = sum(abs(gflank));
            %w = (gt - abs(gflank))/gt;
            alpha = mean(interval); 
            updateWindow(alpha);
        end

        alpha = mean(interval);
        
        function gr = updateWindow(a)
            [~, gr] = alphaML(y,mu,a);

            if sign(gr) > 0
                interval(1) = a;
                gflank(1) = gr;
            else
                interval(2) = a;
                gflank(2) = gr;
            end
        end

    end

    
    function [ f, g, H ] = alphaML( y, mu, a )
 
        ainv = 1/a;
        amuq = a*mu;
        amup1q = amuq + 1;
        lnamup1q = log(amup1q);
        lnamuq = log(amuq);

        % Function value:
        f = sum( y.*(lnamuq - lnamup1q) - ainv*lnamup1q + gammaln(y + ainv) - gammaln(ainv) );

        if nargout > 1
        % Gradient:
        g = (ainv^2)*sum( (lnamup1q - 1) + (a*y + 1)./(a*mu + 1) - psi(y + ainv) + psi(ainv));
        end

        if nargout > 2
        % Hessian:
        H = sum(  (ainv^3)*( (a*y + 1)./((amuq + 1).^2) - (2*a*y + 4)./(amuq + 1) - 2*lnamup1q - 3 ) ...
            + (ainv^2)*(psi(1, y + ainv) - psi(1, ainv))  );
        end

    end




    
    function a = getVararg(v, param)
        ind = find(strcmpi(v, param)) + 1;
        if isempty(ind)
            a = [];
        else
            a = v{ind};
        end
    end

        
end

