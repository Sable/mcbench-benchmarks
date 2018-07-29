function [parameters, stderrors, LLF, ht, kt, nu, resids, summary] = garchk(data, model, ar, ma, x, p, q, y, startingvalues, options)
%{
-----------------------------------------------------------------------
 PURPOSE:
 Brooks, C., Burke, S., P., and Persand, G., (2005), "Autoregressive 
 Conditional Kurtosis Model", Journal of Financial Econometrics, 3(3),
 339-421. 
-----------------------------------------------------------------------
 USAGE:
 [parameters, stderrors, LLF, ht, kt, resids, summary] = 
 garchfor(data, model, ar, ma, p, q, startingvalues, options)
 
 INPUTS:
 data:     (T x 1) vector of data
 model:    'GARCH', 'GJR', 'NARCH', 'AGARCH', 'NAGARCH'
 ar:        positive scalar integer representing the order of AR
 am:        positive scalar integer representing the order of MA
 x:         (T x N) vector of factors for the mean process
 p:         positive scalar integer representing the order of ARCH
 q:         positive scalar integer representing the order of GARCH
 y:         (T x N) vector of factors for the volatility process, must be positive!
 options:  a set of options used in fmincon
 
 OUTPUTS:
 parameters:   a vector of parameters a0, a1, b0, b1, b2, ...
 stderrors:    standard errors estimated by the inverse Hessian (fmincon)
 LFF:          the value of the Log-Likelihood Function
 ht:           vector of conditional variances
 kt:           vector of conditional kurtosis
 nu:           vector of conditional degress-of-freedom
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
 Date:     11/2011
-----------------------------------------------------------------------
 Notes:
 1. Supported Specifications:
    ARMAX Process:
    ARMAX(1,1,0):   m(t) = a0 + a1*ar(-1) + a2*ma(-1) + e(t)
    ARMAX(1,1,2):   m(t) = a0 + a1*ar(-1) + a2*ma(-1) + a3*factor1 + a4*factor2 + e(t)
    
    GARCH Process:
    GARCH(1,1):     h(t) = b0 + b1*e(t-1) + b2*h(t-1)
    NARCH(1,1):     h(t) = b0 + b1*abs(e(t-1))^delta + b2*h(t-1)
    AGARCH(1,1):    h(t) = b0 + b1(e(t-1) + asym(t-1)))^2 + b2*h(t-1)
    NAGARCH(1,1):   h(t) = b0 + b1(e(t-1)/sqrt(h(t-1)) + asym(t-1)))^2 + b2*h(t-1)

 2. Some combinations of specifications and distributions may not converge.
-----------------------------------------------------------------------
%}

if nargin == 0 
    error('Data, GARCH Model, AR, MA, X, ARCH, GARCH, Y, Initial Values and Options') 
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

% garchtype 1 = GARCH | 2 = GJR | 3 = GARCH | 4 = NAGARCH
if strcmp(model,'GARCH')
    garchtype = 1;
elseif strcmp(model,'GJR')
    garchtype = 2;
elseif strcmp(model,'AGARCH')
    garchtype = 3;
elseif strcmp(model,'NAGARCH')
    garchtype = 4;
else error('Invalid GARCH Model');
end

T=size(data,1);
m  =  max([ar,ma,p,q]);   
z=ar+ma+size(x,2)*(isscalar(x) < 1);            
v=size(y,2)*(isscalar(y) < 1);

% Specify Initial Values
if nargin < 9 | isempty(startingvalues)
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
    
    % Kurtosis Process Starting Values
    k0 = 0.05;
    k1 = 0.15*ones(p,1)/p;
    k2 = 0.75*ones(q,1)/q;
    
    % Starting Values
    switch garchtype
        case 1 % GARCH
            startingvalues = [a0; a1; a2; a3; b0; b1; b2; by; k0; k1; k2];
        case 2 % GJR
            startingvalues = [a0; a1; a2; a3; b0; b1; b2; by; 0.15*ones(p,1)/p; k0; k1; k2; ];
        case 3 % AGARCH
            startingvalues = [a0; a1; a2; a3; b0; b1; b2; by; 0.05*ones(p,1); k0; k1; k2]; 
        case 4 % NAGARCH
            startingvalues = [a0; a1; a2; a3; b0; b1; b2; by; 0.15*ones(p,1)/p; k0; k1; k2]; 
    end
end

% Specify constraints used by fmincon (A, b) and lower and upper bounds of parameters
switch garchtype
    case 1 % GARCH
        A =  [zeros(2+2*p+2*q,1+z) -eye(2+2*p+2*q) zeros(2+2*p+2*q,v); zeros(1,2+z) ones(1,p+q) zeros(1,v+2*p+2*q-max(p,q)); zeros(1,2+z+2*p+2*q-max(p,q)) ones(1,p+q) zeros(1,v)];
        b =  [zeros(1,2+2*p+2*q) [1 - 1e-6] [1 - 1e-6]];
        lowerbounds  = [-1; -ones(ar+ma,1); lx; 1e-8*ones(p+q+1,1); ly; 1e-8*ones(p+q+1,1)];
        upperbounds  = [ 1; ones(ar+ma,1); ux; ones(p+q+1,1); uy; ones(p+q+1,1)];
    case 2 % GJR
        A = [zeros(1+p+q,1+z) -eye(1+p+q) zeros(1+p+q,v+1+2*p+q); zeros(1,2+z) ones(1,p+q) 0.5*ones(1,p) zeros(1,v+p+q+1);zeros(1+p+q,1+z+2*p+2*q) -eye(1+p+q); zeros(1,2+z+2*p+2*q) ones(1,p+q)];        
        b = [zeros(1+p+q,1); [1 - 1e-6]; zeros(1+p+q,1);[1 - 1e-6]]; 
        lowerbounds  = [-1;  -ones(ar+ma,1); lx; 1e-8*ones(p+q+1,1); ly; -1*ones(p,1); 1e-8*ones(p+q+1,1)];
        upperbounds  = [ 1;  ones(ar+ma,1); ux; ones(p+q+1,1); uy; 1*ones(p,1); ones(p+q+1,1)];
      case 3 % AGARCH
        % -1 < asym < +1
        A = [zeros(1+p+q,1+z) -eye(1+p+q) zeros(1+p+q,v+1+2*p+q); zeros(1,2+z) ones(1,p+q) zeros(1,v+2*p+q+1); zeros(1+p+q,1+z+2*p+2*q) -eye(1+p+q); zeros(1,2+z+2*p+2*q) ones(1,p+q)];
        b = [zeros(1,1+p+q) [1 - 1e-6] zeros(1,1+p+q) [1 - 1e-6]];
        lowerbounds  = [-1;  -ones(ar+ma,1); lx; 1e-8*ones(p+q+1,1); ly; -1*ones(p,1); 1e-8*ones(p+q+1,1)];
        upperbounds  = [ 1;  ones(ar+ma,1); ux; ones(p+q+1,1); uy; 1*ones(p,1); ones(p+q+1,1)];
     case 4 % NAGARCH
        % -1 < asym < +1
        A = [zeros(1+p+q,1+z) -eye(1+p+q) zeros(1+p+q,v+1+2*p+q); zeros(1,2+z) ones(1,p+q) zeros(1,v+2*p+q+1); zeros(1+p+q,1+z+2*p+2*q) -eye(1+p+q); zeros(1,2+z+2*p+2*q) ones(1,p+q)];
        b = [zeros(1,1+p+q) [1 - 1e-6] zeros(1,1+p+q) [1 - 1e-6]];
        lowerbounds  = [-1;  -ones(ar+ma,1); lx; 1e-8*ones(p+q+1,1); ly; -1*ones(p,1); 1e-8*ones(p+q+1,1)];
        upperbounds  = [ 1;  ones(ar+ma,1); ux; ones(p+q+1,1); uy; 1*ones(p,1); ones(p+q+1,1)];
end


if nargin < 10 | isempty(options)
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


[parameters, LLF, EXITFLAG, OUTPUT, Lambda, GRAD, HESSIAN] =  fmincon('garchklik', startingvalues, A, b, [],[],lowerbounds, upperbounds, [], options, data, garchtype, ar, ma, x, p, q, y, m, z, v, T);

if EXITFLAG<=0
   EXITFLAG
   fprintf(1,'Convergence has been not successful!\n')
end

[LLF,likelihoods,ht,kt,nu,resids] = garchklik(parameters, data, garchtype, ar, ma, x, p, q, y, m, z, v, T);
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
    [holder1,indivlike] =  garchklik(parameters, data, garchtype, ar, ma, x, p, q, y, m, z, v, T);
    likelihoodsplus(:,i)=indivlike;
end
for i=1:length(parameters)
    hparameters=parameters;
    hparameters(i)=hminus(i);
     [holder1, indivlike] =  garchklik(parameters, data, garchtype, ar, ma, x, p, q, y, m, z, v, T);
    likelihoodsminus(:,i)=indivlike;
end
scores=(likelihoodsplus-likelihoodsminus)./(2*repmat(h',T-m,1));
scores=scores-repmat(mean(scores),T-m,1);
S=scores'*scores;
robustSE = diag((HESSIAN^(-1))*S*(HESSIAN^(-1)));
robusttstats = parameters./robustSE;


% Saving and Organizing Results
summary.Specification = sprintf('ARMAX(%1.0f,%1.0f,%1.0f)-%s(%1.0f,%1.0f,%1.0f)-K(%1.0f,%1.0f)', ar, ma, size(x,2)*(isscalar(x) < 1), model, p, q, size(y,2)*(isscalar(y) < 1), p,q);
summary.Iterations = OUTPUT.iterations;

% Statistics to be saved
A = char('Coeff', 'SErrors', 'Tstats', 'RobustSErrors', 'RobustTstats');

% Result vectors
C = char('parameters', 'stderrors', 'tstats', 'robustSE', 'robusttstats');

% Parameters to be saved for different models
if garchtype == 2 | garchtype == 3 | garchtype == 4
     t1= char(regexprep(regexp(sprintf('Leverage%1.0f/',0:p), '/', 'split'), '^.*0', ''));
else
    t1 = '';
end


% Parameters to be saved   
B = strcat(char('C',...
char(regexprep(regexp(sprintf('AR%1.0f/',0:ar), '/', 'split'), '^.*0', '')),...
char(regexprep(regexp(sprintf('MA%1.0f/',0:ma), '/', 'split'), '^.*0', '')),...
char(regexprep(regexp(sprintf('Factor%1.0f/',0:(size(x,2)-isscalar(x))), '/', 'split'), '^.*0', '')),...
'K',...
char(regexprep(regexp(sprintf('ARCH%1.0f/',0:p), '/', 'split'), '^.*0', '')),...
char(regexprep(regexp(sprintf('GARCH%1.0f/',0:q), '/', 'split'), '^.*0', '')),...
char(regexprep(regexp(sprintf('Factor%1.0f/',0:(size(y,2)-isscalar(y))), '/', 'split'), '^.*0', '')),...
t1, ...
'KK',...
char(regexprep(regexp(sprintf('ARCHK%1.0f/',0:p), '/', 'split'), '^.*0', '')),...
char(regexprep(regexp(sprintf('GARCHK%1.0f/',0:q), '/', 'split'), '^.*0', ''))));
   
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
fprintf('Specification: ARMAX(%1.0f,%1.0f,%1.0f) - %s(%1.0f,%1.0f,%1.0f) - K(%1.0f,%1.0f)\n', ar, ma, x, model, p, q,size(y,2)*(isscalar(y) < 1), p ,q)
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

