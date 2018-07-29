function [Params Fval MaxTime2Mat MinTime2Mat LongYTM ShortYTM OptMinLambda ParamsMS FvalMS] = NSest(Bonds, ShortRates, Model, Optimization)
% =========================================================================
% NSESTP estimates Nelson-Siegel or Svensson model parameters
% 
% [Params Fval MaxTime2Mat MinTime2Mat LongYTM ShortYTM OptMinLambda ParamsMS FvalMS] = NSest(Bonds, ShortRates, Model, Optimization)
% 
% Parameters are estimated for the 30E/360 convention
% 
% INPUT: 
%        Bonds - strucutre with bonds properties
%        Bonds.Prices    - price for 100 notional
%        Bonds.Coupon    - coupon in decimal form   
%        Bonds.Issue     - issue date in serial date number
%                          (NOTE: convert date string using DATENUM)
%        Bonds.Maturity  - maturity date in serial date number
%        Bonds.Settle    - settlment (value) date in serial date number
%        Bond.Basis      - Day-count basis
%                          1 - 30E/360 (default)
%                          2 - Actual/360 
% 
%        ShortRates - Zero coupon rates of short maturities, such as LIBOR rates
%                     to fit the very short end of the yield curve. Short rates are consider
%                     to be continuously compounded. If no short rates are used, supply
%                     empty matrix - [].
%                       
%        Model - Yield curve model 
%                 'NS' for Nelson-Siegel curve
%                 'Svensson' for Svensson curve
% 
%        Optimization - stucture with optimization method and weights in
%                       objective function
%        Optimization.Method        - Price or YTM fitting
%                                       'price' for fitting the prices                
%                                       'ytm' for fitting yields to maturity
%        Optimization.Weights       - weights in objective function
%                                       'MD' for modified duration 
%                                       'No' no weights (default)
%        Optmization.Algotithm     - 'lsqnonlin' (default)
%                                  - 'fminsearch'
%        Optimization.DispResults  - 'yes' (default) Display optimization results
%                                  - 'no'          
% 
%        Optimization.MultiStart   - 'yes' Runs optimization from a grid of initial parameters
%                                  - 'no' (default) 
%                                      
% OUTPUT: Params
%         Fval
%         MaxTime2Mat
%         MinTime2Mat
%         LongYTM
%         ShortYTM
%         ParamsMS 
%         FvalMS           
% 
% USES: czbondfuturecf, czbondkeyfigures, NSobjP, NSobjY
% 
% Kamil Kladivko 
% email: kladivko@gmail.com
% December 2010 
% Cite as: 
% Kladivko Kamil (2010). The Czech Treasury Yield Curve from 1999 to the Present, 
% Czech Journal of Economics and Finance, 60(4): 307-335
% =========================================================================
Nbonds = length(Bonds.Prices); 
if ~isempty(ShortRates)    
    Nsr = length(ShortRates.IR);
else
    Nsr = 0;
end
Bonds.Prices = Bonds.Prices./100.*Bonds.Notional;
BondsCF = cell(Nbonds, 1);
MD = zeros(Nbonds, 1);
Convex = zeros(Nbonds, 1);
ObsYTM = zeros(Nbonds, 1);
Time2Mat = zeros(Nbonds, 1);
for i = 1:Nbonds
    % Bonds future cashflows and accrued interest
    [BondsCF{i} AccruedInt] = czbondfuturecf(Bonds.Coupon(i), Bonds.Issue(i), Bonds.Maturity(i), Bonds.Settle, Bonds.Basis, Bonds.Notional);   
    % Calculate modified duration for weights and YTM
    BondsFig = czbondkeyfigures(Bonds.Coupon(i), Bonds.Issue(i), Bonds.Maturity(i), Bonds.Settle,  Bonds.Prices(i), Bonds.Basis, Bonds.Notional);
    MD(i) = BondsFig.MD;
    Convex(i) = BondsFig.Convex;
    ObsYTM(i) = BondsFig.YTM;
    Time2Mat(i) = BondsFig.TimeToMaturity;
    % Add accrued interest to price
    Bonds.DirtyPrices(i, 1) = Bonds.Prices(i) + AccruedInt;  
end
MaxTime2Mat = max(Time2Mat);
MinTime2Mat = min(Time2Mat);

% Set initial parameters
LongYTM = ObsYTM(Time2Mat == max(Time2Mat)); % YTM for the longest maturity
ShortYTM = ObsYTM(Time2Mat == min(Time2Mat)); % YTM for the shortest maturity
LongYTM =  log(1+LongYTM); % Convert the LongYTM to the continuous compounding
beta0 = LongYTM; % beta0 = YTM with the maximal time to maturity
if ~isempty(ShortRates)    
    tmp = min(ShortRates.IR(1), ShortYTM);
    tmp = log(1+tmp);  %Convert the Short Rate to the continuous compounding
    beta1 = tmp - beta0; % beta1 = SR - beta0 (slope of the curve) 
else
    beta1 = ShortYTM - beta0; %YTM with the minimal time 2 maturity - beta0
end
% some bounds for lambda and gamma
% To get the bounds, let's try to play with min lambda
% Maturity of the maximum value of the hump component corresponding to lamda values
% lambda: 0.01  0.10  0.2  0.8  1.0  2.0  3.0  4.0  5.0 10.0   
% tau   : 179   17.9  8.9  2.2  1.8  0.9  0.6  0.4  0.4 0.18

MaxMat4lambda = 0.5*MaxTime2Mat; 
MaxMat4lambda = min(MaxMat4lambda, 10);
options = optimset('LargeScale', 'off', 'MaxIter', 3e5, 'MaxFunEvals', 3e5, 'TolFun', 1e-5, 'TolX', 1e-5, 'Display', 'off');   
lambda0 = 0.6;
OptMinLambda = fminsearch(@(lambda) LambdaLoading(lambda, MaxMat4lambda), lambda0, options);
OptMinGamma = fminsearch(@(lambda) LambdaLoading(lambda, MaxMat4lambda), lambda0, options);

% ==============================================
tol = 1e-6;
lambdaMin = OptMinLambda;
lambdaMax = 30;

gammaMin = OptMinGamma;
gammaMax = 30;

switch Model
    case 'NS'
        lb = [-inf, -inf, -inf, lambdaMin];
        ub = [ inf,  inf,  inf, lambdaMax];   
    case 'Svensson'
        lb = [tol, -inf, -inf, -inf, lambdaMin, gammaMin];
        ub = [inf,  inf,  inf,  inf, lambdaMax, gammaMax];  
    otherwise
        error('Unknown Model')
end    
  fprintf('\n\n======================== RUNNING ESTIMATION ============================\n');
 % No-Multistart initial values
if ~strcmp(Optimization.MultiStart, 'yes')
    switch Model
        case 'NS'
           beta2 = 0;
           lambda = 0.62; 
           if lambda < lambdaMin
               lambda = lambdaMin+0.05;
           end
           Params0 = [beta0 beta1 beta2 lambda];           
         case 'Svensson'
           beta2 = 0;
           beta3 = 0;
           lambda = 0.62; 
            if lambda < lambdaMin
               lambda = lambdaMin+0.1;
            end
           gamma = 7*lambda;  
           Params0 = [beta0 beta1 beta2 beta3 lambda gamma];     
        otherwise
            error('Unknown Model')
    end
    RunsCount = 1;
end
% Multistart initial values
if strcmp(Optimization.MultiStart, 'yes') 
    fprintf('Running Multistart Optimization.\n')
    switch Model
        case 'NS'
             lambda = [0.1 0.5 1.2 6 15];
             if any(lambda < lambdaMin)
                lambda = lambda(lambda>lambdaMin);
                lambda = [lambdaMin+0.05 lambda];
             end
             beta2 = 0;
             %beta2 = [-0.03 0 0.03];
        case 'Svensson'
             lambda = [0.1 0.5 1.5 6];
             lambda = lambda(lambda>lambdaMin);    
             gamma =  [0.1 0.5 1.5 6];              
             gamma = gamma(gamma>gammaMin);    
             beta2 = 0;
             beta3 = 0;
            %beta2 = [-0.2 0 0.2];
            %beta3 = [-0.2 0 0.2];
    end
    switch Model
        case 'NS'
            RunsCount = length(beta0)*length(beta1)*length(beta2)*length(lambda);
            Params0 = zeros(RunsCount, 4);
            i = 1;
            for l1 = 1:length(lambda)
                for b0 = 1:length(beta0)
                    for b1 = 1:length(beta1)
                        for b2 = 1:length(beta2)                                
                           Params0(i, :) = [beta0(b0) beta1(b1) beta2(b2) lambda(l1)];
                           i = i +1;                        
                        end
                    end
                end            
            end    
            ParamsMS = zeros(RunsCount, 4);
        case 'Svensson'
            RunsCount = length(beta0)*length(beta1)*length(beta2)*length(beta3)*length(lambda)*length(gamma);
            Params0 = zeros(RunsCount, 6);
            i = 1;
            for l2 = 1:length(gamma)
                for l1 = 1:length(lambda)
                    for b0 = 1:length(beta0)
                        for b1 = 1:length(beta1)
                            for b2 = 1:length(beta2)
                                for b3 = 1:length(beta3)           
                                            Params0(i, :) = [beta0(b0) beta1(b1) beta2(b2) beta3(b3) lambda(l1) gamma(l2)];
                                    i = i +1;
                                end
                            end
                        end
                    end
                end    
            end
            ParamsMS = zeros(RunsCount, 6);
        otherwise
            error('Unknown Model')
    end
    FvalMS = zeros(RunsCount, 1);
    ExitflagMS = zeros(RunsCount, 1);
end

for i = 1:RunsCount
    if strcmp(Optimization.MultiStart, 'yes'), fprintf('MultiStart Run = %d out of %d\n',i, RunsCount); end
    if strcmp(Optimization.Method, 'price') || strcmp(Optimization.Method, 'ytm')
    else
        warning('Unknown optimization method. Using "price" instread');
        Optimization.Method = 'price';
    end
   if strcmp(Optimization.Method, 'ytm')
       Optimization.Weights = 'MD';
   end
    switch Optimization.Algorithm
        case 'lsqnonlin'         
            switch Optimization.Weights
                case 'MD'
                     options = optimset('MaxIter', 3e5, 'MaxFunEvals', 3e5, 'TolFun', 1e-8, 'TolX', 1e-8, 'Display', 'off');   
                case 'LA'
                     options = optimset('MaxIter', 3e5, 'MaxFunEvals', 3e5, 'TolFun', 1e-12, 'TolX', 1e-12, 'Display', 'off',...
                                        'Algorithm', 'trust-region-reflective');   
            end
        case 'fminsearch'
             options = optimset('MaxIter', 3e5, 'MaxFunEvals', 3e5, 'TolFun', 1e-12, 'TolX', 1e-12, 'Display', 'off');
       
    end
    switch Optimization.Method
        case 'price' % Fitting Price
            switch Optimization.Algorithm
                case 'lsqnonlin'              
                    [ParamsMS(i,:), FvalMS(i), Residuals, ExitflagMS(i)] = lsqnonlin(@(Params) NSobjP(Params, ShortRates, BondsCF, Bonds.DirtyPrices, MD, Model, Optimization), Params0(i,:), lb, ub, options);                                    
                case 'fminsearch'
                     [ParamsMS(i,:), FvalMS(i), ExitflagMS(i)] = fminsearch(@(Params)NSobjP(Params, ShortRates, BondsCF, Bonds.DirtyPrices, MD, Model, Optimization), Params0(i,:), options);                                                
            end                
        case 'ytm' % Fitting YTM
           switch Optimization.Algorithm
               case 'lsqnonlin'               
                    [ParamsMS(i,:), FvalMS(i), Residuals, ExitflagMS(i)] = lsqnonlin(@(Params) NSobjY(Params, ShortRates, BondsCF, ObsYTM, Model, Optimization.Algorithm, Bonds), Params0(i,:), lb, ub, options);
               case 'fminsearch'                
                    [ParamsMS(i,:), FvalMS(i), ExitflagMS(i)] = fminsearch(@(Params) NSobjY(Params, ShortRates, BondsCF, ObsYTM, Model, Optimization.Algorithm, Bonds), Params0(i,:), options);
           end
    end
end

% Fidn minimum function value in MultiStart Results
MinIndex = find(FvalMS == min(FvalMS));
Params = ParamsMS(MinIndex(1), :);
Fval = FvalMS(MinIndex(1));
Exitflag = ExitflagMS(MinIndex(1));

% Print results
if ~isfield(Optimization, 'DispResults')
    Optimization.DispResults = 'yes';
end
if strcmp(Optimization.DispResults, 'yes')
    switch Model
        case 'NS'
            fprintf('======================= ESTIMATION RESULTS ============================\n');
            fprintf(['Nelson-Siegel, Fitting: ' Optimization.Method ', Algorithm: ' Optimization.Algorithm ', Weights: ' Optimization.Weights '\n\n']);
            fprintf(['Estimation for: ' datestr(Bonds.Settle, 'dd/mm/yyyy') '\n'])      
            fprintf('Number of bonds for estimation = %d\n', Nbonds)     
            fprintf('Number of short rates for estimation = %d\n', Nsr)  
            fprintf('The longest YTM = %3.4f\n', LongYTM);
            fprintf('The shortest YTM = %3.4f\n', ShortYTM);
            fprintf('The minimal value of lambda = %3.4f\n\n', lambdaMin);
            if length(MinIndex) > 1
                fprintf('Objective function value is the same for %d multistart initial parameter vectors!\n\n', length(MinIndex));    
            end
            fprintf('Beta0 = %+3.4f\n', Params(1));
            fprintf('Beta1 = %+3.4f\n', Params(2));
            fprintf('Beta2 = %+3.4f\n', Params(3));
            fprintf('lambda = %+3.4f\n', Params(4));
            fprintf('\nExitflag = %d\n', Exitflag);          
            fprintf('Objective function value = %3.2e\n\n', Fval);
        case 'Svensson'
            fprintf('======================= ESTIMATION RESULTS ============================\n');
            fprintf(['SVENSSON, Fitting: ' Optimization.Method ', Algorithm: ' Optimization.Algorithm ', Weights: ' Optimization.Weights '\n\n']);    
            fprintf(['Estimation for: ' datestr(Bonds.Settle, 'dd/mm/yyyy') '\n'])      
            fprintf('Number of bonds for estimation = %d\n', Nbonds)     
            fprintf('Number of short rates for estimation = %d\n', Nsr)  
            fprintf('The longest YTM = %3.4f\n', LongYTM);
            fprintf('The shortest YTM = %3.4f\n', ShortYTM);
            fprintf('The minimal value of lambda = %3.4f\n\n', lambdaMin);
            if length(MinIndex) > 1
                fprintf('Objective function value is the same for %d multistart initial parameter vectors!\n\n', length(MinIndex));    
            end
            fprintf('\nBeta0 = %+3.4f\n', Params(1));
            fprintf('Beta1 = %+3.4f\n', Params(2));
            fprintf('Beta2 = %+3.4f\n', Params(3));
            fprintf('Beta3 = %+3.4f\n', Params(4));
            fprintf('lambda = %+3.4f\n', Params(5));
            fprintf('gamma = %+3.4f\n', Params(6));     
            fprintf('Exitflag = %d\n',Exitflag);
            fprintf('Objective function value = %3.2e\n\n', Fval);
    end
end

end

