function params = stblfit(X,varargin)
%PARAMS = STBLFIT(X) returns an estimate of the four parameters in a
% fit of the alpha-stable distribution to the data X.  The output 
% PARAMS is a 4 by 1 vector which contains the estimates of the 
% characteristic exponent ALPHA, the skewness BETA, the scale GAMMA and 
% location DELTA.  
%
%PARAMS = STBLFIT(X,METHOD) Specifies the algorithm used to
% estimate the parameters.  The choices for METHOD are
%        'ecf' - Fits the four parameters to the empirical characteristic
%               function estimated from the data.  This is the default. 
%               Based on Koutrouvelis (1980,1981), see [1],[2] below.
% 'percentile' - Fits the four parameters using various 
%                percentiles of the data X.  This is faster than 'ecf', 
%                however studies have shown it to be slightly less 
%                accurate in general.  
%                Based on McCulloch (1986), see [2] below.
%  
%PARAMS = STBLFIT(...,OPTIONS) specifies options used in STBLFIT.  OPTIONS
% must be an options stucture created with the STATSET function.  Possible
% options are
%       'Display' - When set to 'iter', will display the values of 
%                   alpha,beta,gamma and delta in each
%                   iteration.  Default is 'off'.
%       'MaxIter' - Specifies the maximum number of iterations allowed in
%                   estimation. Default is 5.
%       'TolX'    - Specifies threshold to stop iterations. Default is
%                   0.01.
%
%   See also: STBLRND, STBLPDF, STBLCDF, STBLINV
%
% References:
%   [1] I. A. Koutrouvelis (1980)
%       "Regression-Type Estimation of the Paramters of Stable Laws.
%       JASA, Vol 75, No. 372
%
%   [2] I. A. Koutrouvelis (1981)
%       "An Iterative Procedure for the estimation of the Parameters of
%       Stable Laws"
%       Commun. Stat. - Simul. Comput. 10(1), pages 17-28
%
%   [3] J. H. McCulloch (1986)
%       "Simple Consistent Estimators of Stable Distribution Parameters"
%       Cummun. Stat. Simul. Comput. 15(4)
%
%   [4] A. H. Welsh (1986)
%       "Implementing Empirical Characteristic Function Procedures"
%       Statistics & Probability Letters Vol 4, pages 65-67    


% ==== Gather additional options
dispit = false;
maxiter = 5;
tol = .01;
if ~isempty(varargin) 
    if isstruct(varargin{end})
        opt = varargin{end};
        try
            dispit = opt.Display;
        catch ME
            error('OPTIONS must be a structure created with STATSET');
        end
        if ~isempty(opt.MaxIter)
            maxiter = opt.MaxIter;
        end
        if ~isempty(opt.TolX)
            tol = opt.TolX;
        end
    end
end

if strcmp(dispit,'iter')
    dispit = true;
    fprintf('    iteration\t    alpha\t    beta\t  gamma\t\t  delta\n');
    dispfmt = '%8d\t%14g\t%8g\t%8g\t%8g\n';
end

% === Find which method.
if any(strcmp(varargin,'percentile'))    
    maxiter = 0; % This is McCulloch's percentile method
end


% ==== Begin estimation =====
N = numel(X); % data size

% function handle to compute empirical char. functions  
I = sqrt(-1);
phi = @(theta,data) 1/numel(data) * sum( exp( I * ...
    reshape(theta,numel(theta),1) *...
    reshape(data,1,numel(data)) ) , 2);

% Step 1 - Obtain initial estimates of parameters using McCulloch's method
%          then standardize data
[alpha beta] = intAlpBet(X);
[gam delta ] = intGamDel(X,alpha,beta);

if gam==0
    % Use standard deviation as initial guess
    gam = std(X);
end
    
s = (X - delta)/gam;


if dispit
    fprintf(dispfmt,0,alpha,beta,gam,delta);
end
  
% Step 2 - Iterate until convergence
alphaold = alpha; 
deltaold = delta;
diffbest = inf;
for iter = 1:maxiter
    
    % Step 2.1 - Regress against ecf to refine estimates of alpha & gam
    %            After iteration 1, use generalized least squares 
    if iter <= 2
        K = chooseK(alpha,N);
        t = (1:K)*pi/25;
        w = log(abs(t));
    end
    
    y = log( - log( abs(phi(t,s)).^2 ) );
    
    if iter == 1  % use ordinary least squares regression
        ell = regress(y,[w' ones(size(y))]);
        alpha = ell(1); 
        gamhat = (exp(ell(2))/2)^(1/alpha);
        gam = gam * gamhat;
    else          % use weighted least squares regression
        sig = charCov1(t ,N, alpha , beta, 1);
        try
            ell = lscov([w' ones(size(y))],y,sig);
        catch   % In case of badly conditioned covariance matrix, just use diagonal entries
            try
                ell = lscov([w' ones(size(y))],y,eye(K).*(sig+eps));
            catch
                break
            end
        end 
        alpha = ell(1); 
        gamhat = (exp(ell(2))/2)^(1/alpha);
        gam = gam * gamhat;
    end
     
    % Step 2.2 - Rescale data by estimated scale, truncate
    s = s/gamhat;
    alpha = max(alpha,0);
    alpha = min(alpha,2);
    beta = min(beta,1);
    beta = max(beta,-1);
    gam = max(gam,0);
    
    % Step 2.3 - Regress against ecf to refine estimates of beta, delta
    %            After iteration 1, use generalized least squares        
    if iter <=  2
        L = chooseL(alpha,N);
        % To ensure g is continuous, find first zero in real part of ecf
        A = efcRoot(s);
        u = (1:L)*min(pi/50,A/L);  
    end
    
    ecf = phi(u,s);
    U = real(ecf);
    V = imag(ecf);
    g = atan2(V,U);
    if iter == 1  % use ordinary least squares
        ell = regress(g, [u',  sign(u').*abs(u').^alpha]);
        beta =  ell(2)/tan(alpha*pi/2) ;
        delta = delta + gam* ell(1) ;
    else         % use weighted least squares regression
        sig = charCov2(u ,N, alpha , beta, 1);
        try
            ell = lscov([u',  sign(u').*abs(u').^alpha],g,sig);
        catch % In case of badly conditioned covariance matrix, use diagonal entries
            try
                ell = lscov([u',  sign(u').*abs(u').^alpha],g,eye(L).*(sig+eps));
            catch
                break
            end
        end
        beta =  ell(2)/tan(alpha*pi/2) ;
        delta = delta + gam* ell(1) ;   
    end
        
    % Step 2.4 Remove estimated shift
    s = s - ell(1);

    % display 
    if dispit
        fprintf(dispfmt,iter,alpha,beta,gam,delta);
    end
    
    % Check for blow-up
    if any(isnan([alpha, beta, gam, delta]) | isinf([alpha, beta, gam, delta]))
        break
    end
    
    
    % Step 2.5 Check for convergence, keep track of parameters with
    % smallest 'diff'
    diff = (alpha - alphaold)^2 + (delta - deltaold)^2;
    if abs(diff) < diffbest
        bestparams = [alpha; beta; gam; delta];
        diffbest = diff;
        if diff < tol
            break;
        end
    end
    
    
    
    
    alphaold = alpha;
    deltaold = delta;
    
end

% Pick best
if maxiter > 0 && iter >= 1 
    alpha = bestparams(1);
    beta = bestparams(2);
    gam = bestparams(3);
    delta = bestparams(4);
end

% Step 3 - Truncate if necessary
alpha = max(alpha,0);
alpha = min(alpha,2);
beta = min(beta,1);
beta = max(beta,-1);
gam = max(gam,0);

params = [alpha; beta; gam; delta];

end % End stblfit

%===============================================================
%===============================================================

function [alpha beta] = intAlpBet(X)
% Interpolates Tables found in MuCulloch (1986) to obtain a starting 
% estimate of alpha and beta based on percentiles of data X

% Input tables
nuA = [2.439 2.5 2.6 2.7 2.8 3.0 3.2 3.5 4.0 5.0 6.0 8.0 10 15 25];
nuB = [0 .1 .2 .3 .5 .7 1];
[a b] = meshgrid( nuA , nuB );
alphaTab=  [2.000 2.000 2.000 2.000 2.000 2.000 2.000;...
             1.916 1.924 1.924 1.924 1.924 1.924 1.924;...
             1.808 1.813 1.829 1.829 1.829 1.829 1.829;...
             1.729 1.730 1.737 1.745 1.745 1.745 1.745;...
             1.664 1.663 1.663 1.668 1.676 1.676 1.676;...
             1.563 1.560 1.553 1.548 1.547 1.547 1.547;...
             1.484 1.480 1.471 1.460 1.448 1.438 1.438;...
             1.391 1.386 1.378 1.364 1.337 1.318 1.318;...
             1.279 1.273 1.266 1.250 1.210 1.184 1.150;...
             1.128 1.121 1.114 1.101 1.067 1.027 0.973;...
             1.029 1.021 1.014 1.004 0.974 0.935 0.874;...
             0.896 0.892 0.887 0.883 0.855 0.823 0.769;...
             0.818 0.812 0.806 0.801 0.780 0.756 0.691;...
             0.698 0.695 0.692 0.689 0.676 0.656 0.595;...
             0.593 0.590 0.588 0.586 0.579 0.563 0.513]';
betaTab=  [ 0.000 2.160 1.000 1.000 1.000 1.000 1.000;...
            0.000 1.592 3.390 1.000 1.000 1.000 1.000;...
            0.000 0.759 1.800 1.000 1.000 1.000 1.000;...
            0.000 0.482 1.048 1.694 1.000 1.000 1.000;...
            0.000 0.360 0.760 1.232 2.229 1.000 1.000;...
            0.000 0.253 0.518 0.823 1.575 1.000 1.000;...
            0.000 0.203 0.410 0.632 1.244 1.906 1.000;...
            0.000 0.165 0.332 0.499 0.943 1.560 1.000;...
            0.000 0.136 0.271 0.404 0.689 1.230 2.195;...
            0.000 0.109 0.216 0.323 0.539 0.827 1.917;...
            0.000 0.096 0.190 0.284 0.472 0.693 1.759;...
            0.000 0.082 0.163 0.243 0.412 0.601 1.596;...
            0.000 0.074 0.147 0.220 0.377 0.546 1.482;...
            0.000 0.064 0.128 0.191 0.330 0.478 1.362;...
            0.000 0.056 0.112 0.167 0.285 0.428 1.274]';
   
% Calculate percentiles
Xpcts = prctile(X,[95 75 50 25 5]); 
nuAlpha = (Xpcts(1) - Xpcts(5))/(Xpcts(2) - Xpcts(4));
nuBeta = (Xpcts(1) + Xpcts(5) - 2*Xpcts(3))/(Xpcts(1) - Xpcts(5));
% Bring into range
if nuAlpha < 2.4390
    nuAlpha = 2.439 + 1e-12;
elseif nuAlpha > 25
    nuAlpha = 25 - 1e-12;
end

s = sign(nuBeta); 

% Get alpha
alpha = interp2(a,b,alphaTab,nuAlpha,abs(nuBeta));

% Get beta
beta = s * interp2(a,b,betaTab,nuAlpha,abs(nuBeta));

% Truncate beta if necessary
if beta>1
    beta = 1;
elseif beta < -1
    beta =-1;
end

    
end

function [gam delta] = intGamDel(X,alpha,beta)
% Uses McCulloch's Method to obtain scale and location of data X given
% estimates of alpha and beta.

% Get percentiles of data and true percentiles given alpha and beta;
Xpcts = prctile(X,[75 50 25]);

% If alpha is very close to 1, truncate to avoid numerical instability.
warning('off','stblcdf:ScaryAlpha');
warning('off','stblpdf:ScaryAlpha');
if abs(alpha - 1) < .02
    alpha = 1;
end

% With the 'quick' option, these are equivalent to McCulloch's tables 
Xquart = stblinv([.75 .25],alpha,beta,1,0,'quick');
Xmed = stblinv(.5,alpha,beta,1,-beta*tan(pi*alpha/2),'quick');

% Obtain gamma as ratio of interquartile ranges
gam = (Xpcts(1) - Xpcts(3))/(Xquart(1) - Xquart(2));

% Obtain delta using median of shifted data and estimate of gamma
zeta = Xpcts(2) - gam * Xmed;
delta = zeta - beta*gam*tan(alpha*pi/2);

end

function K = chooseK(alpha,N)
    % Interpolates Table 1 in [1] to calculate optimum K given alpha and N
    
    % begin parameters into correct ranges.
    alpha = max(alpha,.3);
    alpha = min(alpha,1.9);
    N = max(N,200);
    N = min(N,1600);
    a = [1.9, 1.5: -.2: .3];
    n = [200 800 1600]; 
    [X Y] = meshgrid(a,n);
    Kmat = [ 9   9   9 ; ...
            11  11  11 ; ...
            22  16  14 ; ...
            24  18  15 ; ...
            28  22  18 ; ...
            30  24  20 ; ...
            86  68  56 ; ...
            134 124 118  ];    
     K = round(interp2(X,Y,Kmat',alpha,N,'linear'));
    
                
end
               
function L = chooseL(alpha,N)
    % Interpolates Table 2 in [1] to calculate optimum L given alpha and N
    
    alpha = max(alpha,.3);
    alpha = min(alpha,1.9);
    N = max(N,200);
    N = min(N,1600);
    a = [1.9, 1.5, 1.1:-.2:.3];
    n = [200 800 1600]; 
    [X Y] = meshgrid(a,n);
    Lmat = [ 9  10  11 ; ...
            12  14  15 ; ...
            16  18  17 ; ...
            14  14  14 ; ...
            24  16  16 ; ...
            40  38  36 ; ...
            70  68  66 ]; 
    L = round(interp2(X,Y,Lmat',alpha,N,'linear'));
     
end
        
function A = efcRoot(X)
% An iterative procedure to find the first positive root of the real part
% of the empirical characteristic function of the data X. Based on [4].

N = numel(X);
U = @(theta) 1/N * sum( cos(   ...
    reshape(theta,numel(theta),1) *...
      reshape(X,1,N)       ) , 2 );  % Real part of ecf
m = mean(abs(X)); 
A = 0;
val = U(A);
iter1 = 0;
while abs(val) > 1e-3 && iter1 < 10^4
    A = A + val/m;
    val = U(A);
    iter1 = iter1 + 1;
end

end    

function sig = charCov1(t ,N, alpha , beta,gam)
% Compute covariance matrix of y = log (- log( phi(t) ) ), where phi(t) is 
% ecf of alpha-stable random variables. Based on Theorem in [2].

    K = length(t);
    w = tan(alpha*pi/2);
    calpha = gam^alpha;
    
    Tj = repmat( t(:) , 1 , K);
    Tk = repmat( t(:)'  , K , 1);
    Tjalpha = abs(Tj).^alpha;
    Tkalpha = abs(Tk).^alpha;
    TjxTk = abs(Tj .* Tk);
    TjpTk = Tj + Tk ;
    TjpTkalpha = abs(TjpTk).^alpha;
    TjmTk = Tj - Tk ;
    TjmTkalpha = abs(TjmTk).^alpha;
    
    A = calpha*( Tjalpha + Tkalpha - TjmTkalpha);
    B = calpha * beta *...
        (-Tjalpha .* sign(Tj) * w ...
        + Tkalpha .* sign(Tk) * w ...
        + TjmTkalpha .* sign(TjmTk) * w) ;
    D = calpha * (Tjalpha + Tkalpha - TjpTkalpha);
    E = calpha * beta *...
        ( Tjalpha .* sign(Tj) * w ...    
        + Tkalpha .* sign(Tk) * w ...
        - TjpTkalpha .* sign(TjpTk) * w);
    
    sig = (exp(A) .* cos(B) + exp(D).*cos(E) - 2)./...
          ( 2 * N * gam^(2*alpha) * TjxTk.^alpha);
    

end

function sig = charCov2(t ,N, alpha , beta, gam)
% Compute covariance matrix of z = Arctan(imag(phi(t))/real(phi(t)), 
% where phi(t) is ecf of alpha-stable random variables.
% Based on Theorem in [2].    
    K = length(t);
    w = tan(alpha*pi/2);
    calpha = gam^alpha;
    
    Tj = repmat( t(:) , 1 , K);
    Tk = repmat( t(:)'  , K , 1);
    Tjalpha = abs(Tj).^alpha;
    Tkalpha = abs(Tk).^alpha;
    TjpTk = Tj + Tk ;
    TjpTkalpha = abs(TjpTk).^alpha;
    TjmTk = Tj - Tk ;
    TjmTkalpha = abs(TjmTk).^alpha;
    
    B = calpha * beta *...
        (-Tjalpha .* sign(Tj) * w ...
        + Tkalpha .* sign(Tk) * w ...
        + TjmTkalpha .* sign(TjmTk) * w) ; 
    E = calpha * beta *...
        ( Tjalpha .* sign(Tj) * w ...    
        + Tkalpha .* sign(Tk) * w ...
        - TjpTkalpha .* sign(TjpTk) * w);
    F = calpha * (Tjalpha + Tkalpha);
    G = -calpha * TjmTkalpha;
    H = -calpha * TjpTkalpha;
    
    sig = exp(F) .*(exp(G) .* cos(B) - exp(H) .* cos(E))/(2*N);

    

end



