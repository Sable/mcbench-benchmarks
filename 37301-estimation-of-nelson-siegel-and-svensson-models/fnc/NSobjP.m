function distance = NSobjP(Params, SR, BondsCF, ObsDirtyPrices, MD, Model, Optimization)
% =========================================================================
% distance = NSobjP(Params, SR, BondsCF, ObsDirtyPrices, MD, LongYTM, Model, Optimization)
% Objective function of Nelson Siegel Model estimation routine
% This function is minimizing price errors
% The parameters are estimated under continuous compounding
% 
% INPUT: 
%         Params - Parameters to be estimated
%        BondsCF - Bonds future cashflows  
%             SR - Short rates structure (see NSest for details)
% ObsDirtyPrices - Bonds observed dirty prices
%             MD - Modified Duration
%          Model - 'NS' for Nelson-Siegel model
%                  'Svensson' for Svensson model
%   Optimization - structure 
%    .Weights    - 'MD', 'LA', ''
%    .Algorithm  - 'lsqnonlin', 'fminsearch'
% 
% OUTPUT:
%       distance - Objective function value
% 
% Kamil Kladivko
% email: kladivko@gmail.com
% December 2010 
% Cite as: 
% Kladivko Kamil (2010). The Czech Treasury Yield Curve from 1999 to the Present, 
% Czech Journal of Economics and Finance, 60(4): 307-335
% =========================================================================
Nbonds = length(ObsDirtyPrices); 
FitPrices = zeros(Nbonds,1);
% Short Rates
if ~isempty(SR)
    ObsPricesSR = 100*exp(-SR.IR.*SR.TimeFactor);
    [ZeroRates FwdRates] = NScurve(Params, SR.TimeFactor, Model);
    FitPricesSR = 100*exp(-ZeroRates.*SR.TimeFactor);
    MDSR = SR.TimeFactor./(1+SR.IR);
    % Transpose short rates prices and duration 
    ObsPricesSR = ObsPricesSR';
    FitPricesSR = FitPricesSR';
    MDSR = MDSR';
end
% Bonds
for i=1:Nbonds
    CF = BondsCF{i};
    TimeFactor = CF(3,:);
    [ZeroRates junk] = NScurve(Params, TimeFactor, Model);
    FitPrices(i) = sum(CF(1,:).*exp(-ZeroRates.*TimeFactor)); %Dirty Price
end

% All Prices
if ~isempty(SR)
    AllFitPrices = [FitPricesSR; FitPrices];
    AllObsDirtyPrices = [ObsPricesSR; ObsDirtyPrices];
else
    AllFitPrices = FitPrices;
    AllObsDirtyPrices = ObsDirtyPrices;
end
% Set weights for objective function and run optimization
switch Optimization.Weights
        case 'MD' % Just modified duration approximation  
            if ~isempty(SR)               
                WeightsLR = 1./MD;
                % ==================================
                WeightsSR = ones(length(MDSR), 1)./min(MD); % short rates weights using min MD of bonds
                % WeightsSR = 1./MDSR;                      % short rates weights using their durations
                % ==================================
                Weights = [WeightsSR; WeightsLR];
            else 
                Weights = 1./MD; 
            end                        
        case 'LA' % YTM linear approximation    
            if ~isempty(SR)               
                WeightsLR = 1./(MD.*ObsDirtyPrices);
                % ==================================          
                WeightsSRadjusted = 1./(min(MD)*ObsPricesSR);      % short rates weights using min MD of bonds
                WeightsSRtrue = 1./(MDSR.*ObsPricesSR);            % short rates weights using their durations
                WeightsSR = min(WeightsSRadjusted, WeightsSRtrue); % This is to give proper weights to 6M and 9M PRIBOR
                % ==================================
                Weights = [WeightsSR; WeightsLR];
            else 
                Weights = 1./(MD.*AllObsDirtyPrices); 
            end                    
        otherwise % Equal weights
            Nsec = length(AllObsDirtyPrices);
            Weights = ones(Nsec, 1);
end
switch Optimization.Algorithm
    case 'lsqnonlin' % objective fnc as a vector of values (not sum of squares)               
        distance = Weights.*(AllFitPrices - AllObsDirtyPrices);           
    case {'fminsearch'} % objective fnc as a sum of squares        
        distance = sum((Weights.*(AllFitPrices - AllObsDirtyPrices)).^2);                      
end
end