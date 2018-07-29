function F = stblcdf(x,alpha,beta,gam,delta,varargin)
%F = STBLCDF(X,ALPHA,BETA,GAM,DELTA) returns the cdf of the stable 
% distribtuion with characteristic exponent ALPHA, skewness BETA, scale
% parameter GAM, and location parameter DELTA, at the values in X.  We use 
% the parameterization of stable distribtuions used in [2] - The 
% characteristic function phi(t) of a S(ALPHA,BETA,GAM,DELTA)
% random variable has the form
%
% phi(t) = exp(-GAM^ALPHA |t|^ALPHA [1 - i BETA (tan(pi ALPHA/2) sign(t)]
%                  + i DELTA t )  if alpha ~= 1
%
% phi(t) = exp(-GAM |t| [ 1 + i BETA (2/pi) (sign(t)) log|t| ] + i DELTA t
%                                 if alpha = 1
%
% The size of P is the size of X.  ALPHA,BETA,GAM and DELTA must be scalars
% 
%P = STBLCDF(X,ALPHA,BETA,GAM,DELTA,TOL) computes the cdf to within an
% absolute error of TOL.  Default for TOL is 1e-8.
%
% The algorithm works by computing the numerical integrals in Theorem
% 1 in [1] using MATLAB's QUADV function.    
%
% If abs(ALPHA - 1) < 1e-5,  ALPHA is rounded to 1.
%
% See also: STBLRND, STBLPDF, STBLINV
%  
% References:
%
% [1] J. P. Nolan (1997)
%     "Numerical Calculation of Stable Densities and Distribution
%     Functions"  Commun. Statist. - Stochastic Modles, 13(4), 759-774
%
% [2] G Samorodnitsky, MS Taqqu (1994)
%     "Stable non-Gaussian random processes: stochastic models with 
%      infinite variance"  CRC Press
%  
%
%

if nargin < 5
    error('stblcdf:TooFewInputs','Requires at least five input arguments.'); 
end

% Check parameters
if alpha <= 0 || alpha > 2 || ~isscalar(alpha)
    error('stblcdf:BadInputs',' "alpha" must be a scalar which lies in the interval (0,2]');
end
if abs(beta) > 1 || ~isscalar(beta)
    error('stblcdf:BadInputs',' "beta" must be a scalar which lies in the interval [-1,1]');
end
if gam < 0 || ~isscalar(gam)
    error('stblcdf:BadInputs',' "gam" must be a non-negative scalar');
end
if ~isscalar(delta)
    error('stblcdf:BadInputs',' "delta" must be a scalar');
end

if nargin > 6
    error('stblcdf:TooManyInputs','Accepts at most six input arguments.');
elseif isempty(varargin)
    tol = 1e-8;
elseif isscalar(varargin{1})
    tol = varargin{1};
else
    error('stblcdf:BadInput','"TOL" must be a scalar.')
end

% Warn if alpha is very close to 1 or 0
if (1e-5 < abs(1 - alpha) && abs(1 - alpha) < .02) || alpha < .02
    warning('stblcdf:ScaryAlpha',...
        'Difficult to approximate cdf for alpha close to 0 or 1')
end

%========= Compute CDF =============%

% Check to see if you are in a simple case, if so be quick, if not do
% general algorithm
if alpha == 2                  % Gaussian distribution 
    x = (x - delta)/gam;       % Standardize
    F = .5*(1 + erf(x/2));     % ~ N(0,2)

elseif alpha==1 && beta == 0   % Cauchy distribution
    x = (x - delta)/gam;       % Standardize
    F = 1/pi * atan(x) + .5; 

elseif alpha == .5 && abs(beta) == 1 % Levy distribution 
    x = (x - delta)/gam;  % Standardize 
    F = zeros(size(x));
    if beta > 0
        F(x > 0) = erfc(sqrt(1./(2*x(x>0))));
        F(x <= 0) = 0;
    else % beta < 0
        F(x < 0) = 1 - erfc(sqrt(-1./(2*x(x<0))));
        F(x >= 0) = 1;
    end

elseif abs(alpha - 1) > 1e-5         % Gen. Case, alpha ~= 1
    
    xold = x;  % Save for possible later use
    % Standardize in (M) parameterization ( See equation (2) in [1] )
    x = (x - delta)/gam - beta * tan(alpha*pi/2); 
    F = zeros(size(x));
    % Compute CDF
    zeta = -beta * tan(pi*alpha/2);
    theta0 = (1/alpha) * atan( beta * tan(pi*alpha/2) );
    A1 = alpha*theta0;
    c1 = (alpha > 1) + (alpha < 1)*(1/pi)*(pi/2 - theta0);
    A2 = cos(A1)^(1/(alpha-1));
    exp1 = alpha/(alpha-1);
    alpham1 = alpha - 1;
    V = @(theta) A2 * ( cos(theta) ./ sin( alpha*(theta + theta0) ) ).^exp1.*...
        cos( A1 + alpham1*theta ) ./ cos(theta);
    
    
    if any(x > zeta)
        xshift = (x(x>zeta) - zeta).^(alpha/(alpha - 1));
        % shave off end points of integral to avoid numerical instability
        % when calculating V
        F( x > zeta ) = c1 + sign(1-alpha)/pi * ...
           quadv(@(theta) exp(-xshift * V(theta)),-theta0+1e-10,pi/2-1e-10,tol);
    end
    
    if any(abs(x - zeta) < 1e-8)
        F(abs(x - zeta) < 1e-8) = (1/pi) * (pi/2 - theta0);
    end
    
    if any( x < zeta)
        % Recall with -xold, -beta, -delta
        F(x < zeta) =...
            1 - stblcdf(-xold(x < zeta),alpha,-beta,gam,-delta);
    end
elseif beta > 0                     % Gen. Case, alpha = 1, beta >0
    x = (x - (2/pi) * beta * gam * log(gam) - delta)/gam; % Standardize
    piover2 = pi/2;
    twooverpi = 2/pi;
    oneoverb = 1/beta;
    % Use logs to avoid overflow/underflow
    logV = @(theta) log(twooverpi * ((piover2 + beta *theta)./cos(theta))) + ...
                 ( oneoverb * (piover2 + beta *theta) .* tan(theta) );
    
    xterm = (-pi*x/(2*beta));
    F = (1/pi)*quadv(@(theta) exp(-exp(xterm + logV(theta))),...
                                            -pi/2+1e-12,pi/2-1e-12,tol);
                                       

else                           % alpha = 1, beta < 0 
    F = 1 - stblcdf(-x,1,-beta,gam,-delta,tol);              
end

F = max(real(F),0); % in case of small imaginary or negative resutls from QUADV



             
             
             
end





