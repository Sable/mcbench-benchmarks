function distance = NSobjY(Params, SR, BondsCF, ObsYTM, Model, OptAlgorithm, Bonds)
% =========================================================================
% Objective function of Nelson Siegel Model estimation routine
% This function is minimizing yield to maturity errors
% 
% INPUT: 
%         Params - Parameters to be estimated
%        BondsCF - Bonds future cashflows   
%         ObsYTM - Bonds observed yield to maturity
%          Model - 'NS' for Nelson-Siegel model
%                  'Svensson' for Svensson model
%   OptAlgotithm - 'lsqnonlin', 'fminsearch'
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
Nbonds = length(Bonds.Prices);
FitPrices = zeros(Nbonds,1);
FitYTM = zeros(Nbonds, 1);

if ~isempty(SR)
    ObsYTMSR = SR.IR;
    [FitYTMSR junk] = NScurve(Params, SR.TimeFactor, Model);
end

% Fitted prices and implied YTM
for i=1:Nbonds
    CF = BondsCF{i};    
    TimeFactor = CF(3,:);
    [ZeroRates FwdRates] = NScurve(Params, TimeFactor, Model);
    FitPrices(i) = sum(CF(1,:).*exp(-ZeroRates.*TimeFactor)); %Dirty price
    % Solve for the YTM
    InitialYield = Bonds.Coupon(i);
    [FitYTM(i), Fval, Exitflag] = fzero(@(Yield) YieldDirtyObj(Yield, FitPrices(i), CF), InitialYield);    
    if Exitflag < 0, warning('Could not solve for the yield.\n'); end        
end
WeightsLR = ones(Nbonds, 1);
% All Prices
if ~isempty(SR)
    AllFitYTM = [FitYTMSR'; FitYTM];
    AllObsYTM = [ObsYTMSR'; ObsYTM];
    WeightsSR = ones(length(SR.IR),1)./(length(SR.IR));  % short rates weights = 1/SRcount
    %WeightsSR = ones(length(SR.IR),1); % exactly fitting short rates
else
    AllFitYTM = FitYTM;
    AllObsYTM = ObsYTM;
    WeightsSR = [];
end
Weights = [WeightsSR; WeightsLR];
switch OptAlgorithm
    case 'lsqnonlin'
        distance = Weights.*(AllFitYTM - AllObsYTM);
    case 'fminsearch'
        distance = sum((AllFitYTM - AllObsYTM).^2);   
end

end

% -------------------------------------------------------------------------
% Objective function for Dirty Price
% -------------------------------------------------------------------------
function  f = YieldDirtyObj(Yield, Price, CF) 
    [junk CFcount] = size(CF);
    TimeFactor = CF(3,:);
    if CFcount > 1
        f = sum(CF(1,:)./((1+Yield).^TimeFactor)) - (Price);
    elseif CFcount == 1
        f = sum(CF(1,:)./(1+Yield.*TimeFactor)) - (Price);
    end
end