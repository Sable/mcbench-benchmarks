function [parameters, stderrors, LLF, ht, resids, summary] = garch(data, model, distr, ar, ma, x, p, q, y, startingvalues, options)
%{
-----------------------------------------------------------------------
 PURPOSE:
 Estimation of different type ARMAX-GARCH models with different innovation
 distributions for any order of AR, MA, ARCH and GARCH effects, 
 as well as incorporating variables in the ARMA and GARCH processes.
-----------------------------------------------------------------------
 USAGE:
 [parameters, stderrors, LLF, ht, resids, summary] = 
 garchfor(data, model, distr, ar, ma, p, q, startingvalues, options)
 
 INPUTS:
 data:     (T x 1) vector of data
 model:    'GARCH', 'GJR', 'EGARCH', 'NARCH', 'NGARCH, 'AGARCH', 'APGARCH',
           'NAGARCH'
 distr:    'GAUSSIAN', 'T', 'GED', 'CAUCHY', 'HANSEN' and 'GC'  
 ar:        positive scalar integer representing the order of AR
 am:        positive scalar integer representing the order of MA
 x:         (T x N) vector of factors for the mean process
 p:         positive scalar integer representing the order of ARCH
 q:         positive scalar integer representing the order of GARCH
 y:         (T x N) vector of factors for the volatility process, must be positive!

 startingvalues: 
    -The first and ar+ma+x values are the parameter for the conditional
     mean, autoregressive and moving average terms
    -Following are the conditional variance, ARCH and GARCH effects
    -The leverage and distributional parameters are the last

 options:  a set of options used in fmincon
 
 OUTPUTS:
 parameters:   a vector of parameters a0, a1, b0, b1, b2, ...
 stderrors:    standard errors estimated by the inverse Hessian (fmincon)
 LFF:          the value of the Log-Likelihood Function
 ht:           vector of conditional variances
 resids:       vector of residuals
 summary:      summary of results including: 
                -model specification, distribution and statistics
                -optimization options
                -t-statistics
                -robust standard errors: (HESSIAN^-1)*cov(scores)*(HESSIAN^-1)
                -scores: numerical scores for M testing
                
-----------------------------------------------------------------------
 Author:
 Alexandros Gabrielsen, a.gabrielsen@city.ac.uk
 Date:     09/2008: Initial development
 Update 1: 06/2010: Added Student's t- and GED distributions
 Update 2: 10/2010: Added the following models and distributions:
                    NARCH, NGARCH, AGARCH, APGARCH, NAGARCH, 
                    Hansen Skew-t Distribution and Gram-Charlier Expansion
 Update 3: 08/2011: Added ARMA X family of models and output statistics
-----------------------------------------------------------------------
 Notes:
 1. Supported Specifications:
    ARMAX Process:
    ARMAX(1,1,0):   m(t) = a0 + a1*ar(-1) + a2*ma(-1) + e(t)
    ARMAX(1,1,2):   m(t) = a0 + a1*ar(-1) + a2*ma(-1) + a3*factor1 + a4*factor2 + e(t)
    
    GARCH Process:
    GARCH(1,1):     h(t) = b0 + b1*e(t-1) + b2*h(t-1)
    NARCH(1,1):     h(t) = b0 + b1*abs(e(t-1))^delta + b2*h(t-1)
    NGARCH(1,1):    h(t) = (b0 + b1*abs((e(t-1)))^delta + b2*h(t-1)^delta)^(1/delta)
    AGARCH(1,1):    h(t) = b0 + b1(e(t-1) + asym(t-1)))^2 + b2*h(t-1)
    APGARCH(1,1):   h(t) = (b0 + b1*abs((e(t-1)-asym(t-1)*e(t-1))^delta + b2*h(t-1)^delta)^(1/delta)
    NAGARCH(1,1):   h(t) = b0 + b1(e(t-1)/sqrt(h(t-1)) + asym(t-1)))^2 + b2*h(t-1)

2.  Supported Distributions:
    GAUSSIAN:   Normal Guassian Distribution
    T:          Student t-Distribution
    GED:        Generalized Error Distribution
    CAUCHY:     Cauchy-Lorentz Distribution
    HANSEN:     Hansen's Skew-t Distribution
    GC:         Gram-Charlier Expansion Series - constant higher moments
    Logistic:   Logistic Distribution
    Laplace:    Laplace Distribution
    Rayleigh:   Rayleigh Distribution
    CCAUCHY:    Centered Cauchy
    EVD:        Extreme Value Distribution Type 1
    EXP:        Generalized Exponential Distribution
 3. The estimation of the conditional variance with Cauchy-Lorentz 
    innovation terms is for educational purposes only.
 4. Some combinations of specifications and distributions may not converge.
-----------------------------------------------------------------------
%}

if nargin == 0 
    error('Data, GARCH Model, Distribution, AR, MA, X, ARCH, GARCH, Y, Initial Values and Options') 
end

if size(data,2) > 1
   error('Data vector should be a column vector')
end

if (length(ar) > 1) | (length(ma) > 1) | ar < 0 | ma < 0
    error('AR and MA should be positive scalars')
end

if (length(p) > 1) | (length(q) > 1) | p < 0 | q < 0
    error('P and Q should be positive scalars')
end

if (isscalar(x) == 0) & (size(data,1) ~=  size(x,1)) 
    error('Factor and data vectors have different dimmensions')
end

if (isscalar(y) == 0) & (size(data,1) ~=  size(y,1)) 
    error('Factor and data vectors have different dimmensions')
end

% garchtype 1 = GARCH | 2 = GJR | 3 = EGARCH | 4 = NARCH | 5 = NGARCH | 6 = AGARCH | 7 = APGARCH | 8 = NAGARCH
if strcmp(model,'GARCH')
    garchtype = 1;
elseif strcmp(model,'GJR')
    garchtype = 2;
elseif strcmp(model,'EGARCH')
    garchtype = 3;
elseif strcmp(model,'NARCH')
    garchtype = 4;
elseif strcmp(model,'NGARCH')
    garchtype = 5;
elseif strcmp(model,'AGARCH')
    garchtype = 6;
elseif strcmp(model,'APGARCH')
    garchtype = 7;
elseif strcmp(model,'NAGARCH')
    garchtype = 8;
else error('Invalid GARCH Model');
end

% errortype: 1 = Gaussian | 2 = Student'S t | 3 = GED | 4 = Cauchy-Lorentz
% | 5 = Hansen's Skew-t | 6 = Gram-Charlier | 7 = Logistic | 8 = Laplace |
% 9 = Rayleigh | 10 = Gumbel | 11 = Voigt | 12 = Centered-Cauchy | 13 =
% Extreme Value Distribution Type 1 | 14 = Generalized Exponential
% Distribution
if strcmp(distr,'GAUSSIAN') 
    errortype = 1;
    distr_name=char('Gaussian Normal');
elseif strcmp(distr,'T')
    errortype = 2;
    distr_name=char('Student-t');
elseif strcmp(distr,'GED') 
    errortype = 3;
    distr_name=char('Generalised Error');
elseif strcmp(distr,'CAUCHY') 
    errortype = 4;
    distr_name=char('Cauchy');
elseif strcmp(distr,'HANSEN') 
    errortype = 5;
    distr_name=char('Hansens Skew-t');
elseif strcmp(distr,'GC') 
    errortype = 6;
    distr_name=char('Gram-Charlier (Constant)');
elseif strcmp(distr,'Logistic') 
    errortype = 7;
    distr_name=char('Logistic');
elseif strcmp(distr,'Laplace') 
    errortype = 8;
    distr_name=char('Laplace');
elseif strcmp(distr,'Rayleigh') 
    errortype = 9;
    distr_name=char('Rayleigh');
elseif strcmp(distr,'Gumbel') 
    errortype = 10;
    distr_name=char('Gumbel');    
elseif strcmp(distr,'Voigt') 
    errortype = 11;
    distr_name=char('Voigt');  
elseif strcmp(distr,'CCAUCHY') 
    errortype = 12;
    distr_name=char('Centered-Cauchy');  
elseif strcmp(distr,'EVD') 
    errortype = 13;
    distr_name=char('Extreme Value Distribution'); 
elseif strcmp(distr,'GEXP') 
    errortype = 14;
    distr_name=char('Generalized Exponential Distribution'); 
else error('Invalid distribution type');
end

T=size(data,1);
m  =  max([ar,ma,p,q]);   
z=ar+ma+size(x,2)*(isscalar(x) < 1);            
v=size(y,2)*(isscalar(y) < 1);

% Specify Initial Values
if nargin < 10 | isempty(startingvalues)
    % Mean Process Starting Values
    a0 = mean(data);
    a1 = 0.5*ones(ar,1)/ar; 
    a2 = 0.5*ones(ma,1)/ma;
    if isscalar(x)
        a3=[];
        ux=[];
        lx=[];
    else
        a3 = 0.5*ones(size(x,2),1);
        ux = 100*ones(size(x,2),1);
        lx = -100*ones(size(x,2),1);
    end
    
    % Volatility Process Starting Values
    % b0 = 0.0000005; % another way is to set it to the unconditional
    b1 = 0.15*ones(p,1)/p;
    b2 = 0.75*ones(q,1)/q;
    b0 = (1-(sum(b1)+sum(b2)))*var(data);
    if isscalar(y)
       % fy = 0;
        by=[];
        uy=[];
        ly=[];
    else
       % fy = size(y,2);
        by = 0.15*ones(size(y,2),1);
        uy = 1*ones(size(y,2),1);
        ly = -1*ones(size(y,2),1);
    end
    % Starting Values
    switch garchtype
        case 1 % GARCH
            startingvalues = [a0; a1; a2; a3; b0; b1; b2; by];
        case 2 % GJR
            startingvalues = [a0; a1; a2; a3; b0; b1; b2; by; 0.15*ones(p,1)/p];
        case 3 % EGARCH
            startingvalues = [a0; a1; a2; a3; b0; b1; b2; by; 0.15*ones(p,1)/p];
        case 4 % NARCH
            % delta: 0.1, the parameter is found usually to be below 1 and
            % statistically insignificant
            startingvalues = [a0; a1; a2; a3; b0; b1; b2; by; 0.1];  
        case 5 % NGARCH
            % delta: 3.5
            startingvalues = [a0; a1; a2; a3; b0; b1; b2; by; 3.5];  
        case 6 % AGARCH
            startingvalues = [a0; a1; a2; a3; b0; b1; b2; by; 0.05*ones(p,1)]; 
        case 7 % APGARCH
            % delta: 3.5
            startingvalues = [a0; a1; a2; a3; b0; b1; b2; by; 3.5; 0.05*ones(p,1)]; 
         case 8 % NAGARCH
            startingvalues = [a0; a1; a2; a3; b0; b1; b2; by; 0.15*ones(p,1)/p]; 
    end
    switch errortype
        case 1 % GAUSSIAN
            k=0;
        case 2 % STUDENT'S t-Distribution, nu = 4
            startingvalues = [startingvalues; 4];
            k=1;
        case 3 % GED, nu = 4
            startingvalues = [startingvalues; 4];
            k=1;
        case 4 % Cauchy-Lorentz
            % the scale parameter m is not the mean of the distribution
            % rather than the median
            startingvalues(1) = median(data);
            k=0;
        case 5 % Hansen's, lambda = 0, and nu = 10
            startingvalues = [startingvalues; 0; 10];
            k=2;
        case 6 % Gram-Charlier sk = 0.1, and nu = 4
            startingvalues = [startingvalues; 0.1; 4];
            k=2;
        case 7 % Logistic
            k=0;
        case 8 % Laplace
            k=0;
        case 9 % Rayleigh
            k=0;
        case 10 % Gumbel
            k=0;
        case 11 % Voigt
            startingvalues = [startingvalues; 0.5];
            k=1;
        case 12 % Centered Cauchy
            startingvalues = [startingvalues; 0.5];
            k=1;
        case 13 % Extreme Value Distribution Type 1
            k=0;
        case 14 % Exponential Distribution
            k=0;
    end  
end 

% Specify constraints used by fmincon (A, b) and lower and upper bounds of parameters
% Example: GARCH(1,1): b0>0, b1>0, b2>0, and b1 + b2 <1
switch garchtype
    case 1 % GARCH
        A = [zeros(1+p+q,1+z) -eye(1+p+q) zeros(1+p+q,k+v); zeros(1,2+z) ones(1,p+q) zeros(1,k+v)];
        b = [zeros(1,1+p+q) [1 - 1e-6]];
        lowerbounds  = [-1; -ones(ar+ma,1); lx; 1e-8*ones(p+q+1,1); ly];
        upperbounds  = [ 1; ones(ar+ma,1); ux; ones(p+q+1,1); uy];
    case 2 % GJR
        A = [zeros(1+p+q,1+z) -eye(1+p+q) zeros(1+p+q,p+k+v); zeros(1,2+z) ones(1,p+q) 0.5*ones(1,p) zeros(1,k+v)];
        b = [zeros(1+p+q,1); [1 - 1e-6]]; 
        lowerbounds  = [-1;  -ones(ar+ma,1); lx; 1e-8*ones(p+q+1,1); ly; -1*ones(p,1)];
        upperbounds  = [ 1;  ones(ar+ma,1); ux; ones(p+q+1,1); uy; 1*ones(p,1)];
    case 3 % EGARCH
    case 4 % NARCH
        % delta > 0.1
        A = [zeros(1+p+q,1+z) -eye(1+p+q) zeros(1+p+q,1+k+v); zeros(1,2+z) ones(1,p+q) zeros(1,k+1+v)];
        b = [zeros(1,1+p+q) [1 - 1e-6]];
        lowerbounds  = [-1;  -ones(ar+ma,1); lx; 1e-8*ones(p+q+1,1); ly; 0];
        upperbounds  = [ 1;  ones(ar+ma,1); ux; ones(p+q+1,1); uy; 100];
     case 5 % NGARCH
        % delta > 1
        A = [zeros(1+p+q,1+z) -eye(1+p+q) zeros(1+p+q,1+k+v); zeros(1,2+z) ones(1,p+q) zeros(1,1+k+v)];
        b = [zeros(1,1+p+q) [1 - 1e-6]];
        lowerbounds  = [-1;  -ones(ar+ma,1); lx; 1e-8*ones(p+q+1,1); ly; 0];
        upperbounds  = [ 1;  ones(ar+ma,1); ux; ones(p+q+1,1); uy; 10];
    case 6 % AGARCH
        % -1 < asym < +1
        A = [zeros(1+p+q,1+z) -eye(1+p+q) zeros(1+p+q,p+k+v); zeros(1,2+z) ones(1,p+q) zeros(1,p+k+v)];
        b = [zeros(1,1+p+q) [1 - 1e-6]];
        lowerbounds  = [-1;  -ones(ar+ma,1); lx; 1e-8*ones(p+q+1,1); ly; -1*ones(p,1)];
        upperbounds  = [ 1;  ones(ar+ma,1); ux; ones(p+q+1,1); uy; 1*ones(p,1)];
     case 7 % APGARCH
        % delta > 0
        % -1 < asym < +1
        A = [zeros(1+p+q,1+z) -eye(1+p+q) zeros(1+p+q,1+p+k+v); zeros(1,2+z) ones(1,p+q) zeros(1,1+p+k+v)];
        b = [zeros(1,1+p+q) [1 - 1e-6]];
        lowerbounds  = [-1;  -ones(ar+ma,1); lx; 1e-8*ones(p+q+1,1); ly; 0; -1*ones(p,1)];
        upperbounds  = [ 1;  ones(ar+ma,1); ux; ones(p+q+1,1); uy; 5; 1*ones(p,1)];
     case 8 % NAGARCH
        % -1 < asym < +1
        A = [zeros(1+p+q,1+z) -eye(1+p+q) zeros(1+p+q,p+k+v); zeros(1,2+z) ones(1,p+q) zeros(1,p+k+v)];
        b = [zeros(1,1+p+q) [1 - 1e-6]];
        lowerbounds  = [-1;  -ones(ar+ma,1); lx; 1e-8*ones(p+q+1,1); ly; -1*ones(p,1)];
        upperbounds  = [ 1;  ones(ar+ma,1); ux; ones(p+q+1,1); uy; 1*ones(p,1)]; 
end
if garchtype ~= 3
switch errortype
    case 1 % GAUSSIAN Distribution
    case 2 % STUDENT'S t-Distribution
        % DoF must be larger than 2 in order for the Student's t-distribution 
        % to be well defined
        lowerbounds = [lowerbounds; 2+1e-6]; 
        upperbounds = [upperbounds; 100+1e-6];
    case 3 % GED Distribution
        % For consistency and asymptotic normality of maximum likelihood
        % estimates, the DoF much be larger than 2
        lowerbounds = [lowerbounds; 2+1e-6]; 
        upperbounds = [upperbounds; 100+1e-6];
    case 4 % Cauchy-Lorentz Distribution
    case 5 % Hansen's Skew-t Distribution
        % -1 < lamda < 1
        %  2 < nu < +oo
        lowerbounds = [lowerbounds; -1+1e-6; 2+1e-6];
        upperbounds = [upperbounds; 1-1e-6; inf];  
    case 6 % Gram-Charlier Expansion 
        % 3 < kurtosis < +oo
        lowerbounds = [lowerbounds; -10+1e-6; -inf];
        upperbounds = [upperbounds; 10+1e-6; inf];    
    case 11 % Voigt
        % g > 0
        lowerbounds = [lowerbounds; +0e-6];
        upperbounds = [upperbounds; inf];   
    case 12 % Centered Cauchy
        % g > 0
        lowerbounds = [lowerbounds; +0e-6];
        upperbounds = [upperbounds; inf];   
end
end

if nargin < 11 | isempty(options)
options  =  optimset('fmincon');
options  =  optimset(options , 'Algorithm ','interior-point');
options  =  optimset(options , 'TolFun'      , 1e-006);
options  =  optimset(options , 'TolX'        , 1e-006);
options  =  optimset(options , 'TolCon'      , 1e-006);
options  =  optimset(options , 'Display'     , 'iter');
options  =  optimset(options , 'Diagnostics' , 'on');
options  =  optimset(options , 'LargeScale'  , 'off');
options  =  optimset(options , 'MaxIter'     , 1500);
%options  =  optimset(options , 'HessUpdate'     ,'bfgs');
%options  =  optimset(options , 'LevenbergMarquardt'     ,'off');
options  =  optimset(options , 'LineSearchType'     ,'cubicpoly');
options  =  optimset(options , 'Jacobian'     ,'off');
options  =  optimset(options , 'MeritFunction'     ,'multiobj');
options  =  optimset(options , 'MaxFunEvals' , 3000);

options.OutputResults = char('on'); % This controls whether the output results are printed
end

if garchtype ~= 3
    [parameters, LLF, EXITFLAG, OUTPUT, Lambda, GRAD, HESSIAN] =  fmincon('garchlik', startingvalues ,A, b, [],[],lowerbounds, upperbounds, [], options, data, garchtype, errortype, ar, ma, x, p, q, y, m, z, v, T);
else
    [parameters, LLF, EXITFLAG, OUTPUT, GRAD, HESSIAN] =  fminunc('garchlik', startingvalues ,options, data, garchtype, errortype, ar, ma, x, p, q, y, m, z, v, T);
end

if EXITFLAG<=0
   EXITFLAG
   fprintf(1,'Convergence has been not successful!\n')
end

[LLF,likelihoods,ht,resids] = garchlik(parameters, data, garchtype, errortype, ar, ma, x, p, q, y, m, z, v, T);
LLF = -LLF;

% asymptotic standard errors
stderrors = sqrt(diag((HESSIAN)^(-1))); 

% t-statistics
tstats = parameters./stderrors;

% robust standard errors
h=parameters*eps;
hplus=parameters+h;
hminus=parameters-h;
likelihoodsplus=zeros(T-m,length(parameters));
likelihoodsminus=zeros(T-m,length(parameters));
for i=1:length(parameters)
    hparameters=parameters;
    hparameters(i)=hplus(i);
    [holder1,indivlike] =  garchlik(hparameters, data, garchtype, errortype, ar, ma, x, p, q, y, m, z, v, T);
    likelihoodsplus(:,i)=indivlike;
end
for i=1:length(parameters)
    hparameters=parameters;
    hparameters(i)=hminus(i);
     [holder1, indivlike] =  garchlik(hparameters, data, garchtype, errortype, ar, ma, x, p, q, y, m, z, v, T);
    likelihoodsminus(:,i)=indivlike;
end
scores=(likelihoodsplus-likelihoodsminus)./(2*repmat(h',T-m,1));
scores=scores-repmat(mean(scores),T-m,1);
S=scores'*scores;
robustSE = diag((HESSIAN^(-1))*S*(HESSIAN^(-1)));
robusttstats = parameters./robustSE;


% Saving and Organizing Results
summary.Specification = sprintf('ARMAX(%1.0f,%1.0f,%1.0f)-%s(%1.0f,%1.0f,%1.0f)', ar, ma, size(x,2)*(isscalar(x) < 1), model, p, q, size(y,2)*(isscalar(y) < 1));
summary.Distribution = strcat(distr_name);
summary.Iterations = OUTPUT.iterations;

% Statistics to be saved
A = char('Coeff', 'SErrors', 'Tstats', 'RobustSErrors', 'RobustTstats');

% Result vectors
C = char('parameters', 'stderrors', 'tstats', 'robustSE', 'robusttstats');

% Parameters to be saved for different models
if garchtype == 2 | garchtype == 3 | garchtype == 6 | garchtype == 8
     t1= char(regexprep(regexp(sprintf('Leverage%1.0f/',0:p), '/', 'split'), '^.*0', ''));
elseif garchtype == 4 | garchtype == 5
    t1 = 'Delta';
elseif garchtype == 7
    t1= strcat(char('Delta', char(regexprep(regexp(sprintf('Delta%1.0f/',0:p), '/', 'split'), '^.*0', ''))));
else
    t1 = '';
end

% Parameters to be saved for different distributions
if errortype == 2 | errortype == 3 | errortype == 11 | errortype == 12
    t2 = 'DoF';
elseif errortype == 5
    t2 = char('Lamda', 'Nu');
elseif errortype == 6
    t2 = char('Skewness', 'Kurtosis');
else
    t2 = '';
end

% Parameters to be saved   
B = strcat(char('C',...
char(regexprep(regexp(sprintf('AR%1.0f/',0:ar), '/', 'split'), '^.*0', '')),...
char(regexprep(regexp(sprintf('MA%1.0f/',0:ma), '/', 'split'), '^.*0', '')),...
char(regexprep(regexp(sprintf('Factor%1.0f/',0:(size(x,2)-isscalar(x))), '/', 'split'), '^.*0', '')),...
'K',...
char(regexprep(regexp(sprintf('ARCH%1.0f/',0:p), '/', 'split'), '^.*0', '')),...
char(regexprep(regexp(sprintf('GARCH%1.0f/',0:q), '/', 'split'), '^.*0', '')),...
char(regexprep(regexp(sprintf('Factor%1.0f/',0:(size(y,2)-isscalar(y))), '/', 'split'), '^.*0', '')),t1,t2));
   
for i = 1:size(A,1);
    for j = 1:size(B,1);
        eval(['summary.',strcat(A(i,:)),'.',strcat(B(j,:)),' =',strcat(C(i,:)),'(j);']);
    end
    clear j
end
clear i

summary.Scores=scores;
summary.Rsquared = (1-sum(resids.^2)/sum((data-mean(data)).^2));
summary.AdjRsquared = 1-((T-1)/(T-size(parameters,1))*(1-summary.Rsquared));
summary.LLF = LLF;
summary.AIC = -2*LLF+2*size(parameters,1);
summary.BIC = -2*LLF+size(parameters,1)*log(size(data,1));
%summary.HQIC = -2*LLF +2*size(parameters,1)*log(log(size(data,1)));

if nargin < 10 | isempty(options) | strcmp(options.OutputResults,'on')
% Print results
fprintf('-------------------------------------------------\n')
fprintf('Specification: ARMAX(%1.0f,%1.0f,%1.0f) - %s(%1.0f,%1.0f,%1.0f)\n', ar, ma, size(x,2)*(isscalar(x) < 1), model, p, q,size(y,2)*(isscalar(y) < 1))
fprintf('Distribution: %s\n', distr_name)
fprintf('Convergence achieved after %1.0f iterations\n', OUTPUT.iterations)
fprintf('-------------------------------------------------\n')
fprintf('Parameters  Coefficients  Std Errors    T-stats\n')
fprintf('-------------------------------------------------\n')
for i = 1:size(parameters,1)
    if parameters(i) < 0
        fprintf(strcat('  %s     %1.',num2str(round(5-length(sprintf('%1.0f', abs(parameters(i)))))),'f      %1.',num2str(round(5-length(sprintf('%1.0f', stderrors(i))))),'f       %1.',num2str(round(5-length(sprintf('%1.0f',abs(tstats(i)))))),'f\n'), B(i,:), parameters(i), stderrors(i), tstats(i))
    else    
        fprintf(strcat('  %s      %1.',num2str(round(5-length(sprintf('%1.0f', abs(parameters(i)))))),'f      %1.',num2str(round(5-length(sprintf('%1.0f', stderrors(i))))),'f        %1.',num2str(round(5-length(sprintf('%1.0f', abs(tstats(i)))))),'f\n') , B(i,:), parameters(i), stderrors(i), tstats(i))
    end
end
fprintf('-------------------------------------------------\n')
fprintf('R-Squared: %1.4f\n', summary.Rsquared)
fprintf('Adjusted R-Squared: %1.4f\n', summary.AdjRsquared)
fprintf('Log Likelihood: %1.0f\n', LLF)
fprintf('Akaike Information Criteron: %1.0f\n', summary.AIC)
fprintf('Bayesian Information Criteron: %1.0f\n', summary.BIC)
%fprintf('Hannan-Quinn Information Criteron: %1.0f\n', summary.HQIC)
fprintf('-------------------------------------------------\n')
end
end


