function [Price YTM] = NSerror(Bonds, SR, Model, Params, IncludeSRinError, DispResults)
% =========================================================================
% NSERROR calculates errors of fit of the Nelson-Siegel and Svensson curves 
% 
% [Price YTM] = NSerror(Bonds, SR, Model, Params, IncludeSRinError, DispResults)
% 
% INPUT: Bonds, strucutre
%        Bonds.Prices - Clean Prices for 100 notional, i.e. without accrued
%                       interest
%        Bonds.Coupon - in decimal form   
%        Bonds.Issue
%        Bonds.Maturity 
%        Bonds.Settle  
%        Bonds.Basis  
% 
%        SR, structure with short rates continuously compounded   
%        If you do not want short rates error to be added, set SR = [];
% 
%        Model - 'NS'
%                'Svensson'
% 
% OPTIONAL INPUT: 
%                     IncludeSRinError - 'yes'/'no' (implicitly 'yes' ). Whether to include short rates into the RMSE, MAE, Max, SS, SR        
%                                                               
%                     DispResults - 'yes'/'no' (implicitly 'yes' )
%                               
%   
% OUTPUT: Price  -  structure, Price fit
%                     Price.Obs (Nbonds+Nshortrates X 1)
%                     Price.Fit (Nbonds+Nshortrates X 1)
%                     Price.Error (Nbonds+Nshortrates X 1) in haléøe
%                     Price.RMSE (Root Mean Square Error)
%                     Price.MAE (Mean Absolute Error) 
%                     Price.Max (Max Errror)
%           YTM  - structure, YTM fit
%                     YTM.Obs (Nbonds+Nshortrates X 1)
%                     YTM.Fit (Nbonds+Nshortrates X 1)
%                     YTM.Error (Nbonds+Nshortrates X 1), (Observed-Fit) in basis points
%                     YTM.TimeFraction (Nbonds+Nshortrates X 1)
%                     YTM.Emission {Nbonds+Nshortrates X 1}
%                     YTM.RMSE (Root Mean Square Error), scalar
%                     YTM.MAE (Mean Absolute Error) , scalar
%                     YTM.Max (Max Errror), scalar
%                     YTM.SS, Sum of Squares of observed YTM
%                     YTM.SR, Sum of Residuals (observed YTM - fitted YTM)
% 
% 
% USES: czbondfuturecf, czbondkeyfigures
% 
% Kamil Kladivko 
% email: kladivko@gmail.com
% December 2010 
% Cite as: 
% Kladivko Kamil (2010). The Czech Treasury Yield Curve from 1999 to the Present, 
% Czech Journal of Economics and Finance, 60(4): 307-335
% =========================================================================
if nargin == 4
    IncludeSRinError = 'yes';
    DispResults = 'yes';
end
if nargin == 5
    DispResults = 'yes';
end
Nbonds = length(Bonds.Prices); 
Bonds.Prices = Bonds.Prices./100.*Bonds.Notional;
ObsPrices = Bonds.Prices;
BondsCF = cell(Nbonds, 1);
AccruedInt = zeros(Nbonds,1);
FitPrices = zeros(Nbonds,1);

% === BONDS ==============================================================
% Calculate bonds fitted prices
for i = 1:Nbonds
    [BondsCF{i} AccruedInt(i)] = czbondfuturecf(Bonds.Coupon(i), Bonds.Issue(i), Bonds.Maturity(i), Bonds.Settle, Bonds.Basis, Bonds.Notional);      
end
for i=1:Nbonds
    CF = BondsCF{i};    
    TimeFactor = CF(3,:);
    [ZeroRates junk] = NScurve(Params, TimeFactor, Model);
    FitPrices(i) = sum(CF(1,:).*exp(-ZeroRates.*TimeFactor));
end
FitPrices = FitPrices - AccruedInt; %Clean fitted prices

% Calculate YTM for observed and fitted bond prices
ObsYTM = zeros(2, Nbonds); % Observed
for i = 1:Nbonds
    BondsFig = czbondkeyfigures(Bonds.Coupon(i), Bonds.Issue(i), Bonds.Maturity(i), Bonds.Settle, Bonds.Prices(i), Bonds.Basis, Bonds.Notional);  
    ObsYTM(1,i) = BondsFig.YTM;
    ObsYTM(2,i) = BondsFig.TimeToMaturity;
    Emission(i, 1) = Bonds.Emission(i);
end
FitYTM = zeros(2, Nbonds); % Fitted
for i = 1:Nbonds
    BondsFig = czbondkeyfigures(Bonds.Coupon(i), Bonds.Issue(i), Bonds.Maturity(i), Bonds.Settle, FitPrices(i), Bonds.Basis, Bonds.Notional);  
    FitYTM(1,i) = BondsFig.YTM;
    FitYTM(2,i) = BondsFig.TimeToMaturity;
end
% transpose to a row vector
ObsYTM = ObsYTM';
FitYTM = FitYTM';

% === SHORT RATES ==============================================================
% Calculate YTM for short rates
if ~isempty(SR)
    [FitSRcont junk] = NScurve(Params, SR.TimeFactor, Model); %Continuous compounding
    FitSR = exp(FitSRcont) - 1; % Transfor to annual compounding
    FitSR(2,:) = SR.TimeFactor;   
    ObsSR = exp(SR.IR)-1; % Transform observed short rates to annual compounding
    ObsSR(2,:) = SR.TimeFactor;
    ObsSR = ObsSR';
    FitSR = FitSR';
    AllObsYTM = [ObsSR; ObsYTM];
    AllFitYTM = [FitSR; FitYTM];
else
    AllObsYTM = ObsYTM;
    AllFitYTM = FitYTM;
end
% Calculate Price for short rates
if ~isempty(SR)
    ObsSRPrices = exp(-SR.IR.*SR.TimeFactor)*100;
    FitSRPrices = exp(-FitSRcont.*SR.TimeFactor)*100;    
    AllObsPrices = [ObsSRPrices'; ObsPrices];
    AllFitPrices = [FitSRPrices'; FitPrices];
else
    AllObsPrices = ObsPrices;
    AllFitPrices = FitPrices;    
end
% Yield and Price Errors for output
YTM.Obs = AllObsYTM(:,1);
YTM.Fit = AllFitYTM(:,1);
YTM.Error = (AllObsYTM(:,1) - AllFitYTM(:,1))*100*100; %Error in bp (residuals)
YTM.TimeFraction = AllFitYTM(:,2);
Price.Obs = AllObsPrices;
Price.Fit = AllFitPrices;
Price.Error = (AllObsPrices - AllFitPrices)*100; % Error in halere (residuals)
if ~isempty(SR) %Emise
    YTM.Emission = [SR.Emission'; Emission]; 
else
    YTM.Emission = Emission;
end

% === ERROR MEASURES =========================================================
if strcmp(IncludeSRinError, 'yes')
    % YTM Errors
    YTM.RMSE = sqrt(mean((AllFitYTM(:,1) - AllObsYTM(:,1)).^2))*100*100;
    YTM.Max = (max(abs(AllFitYTM(:,1) - AllObsYTM(:,1))))*100*100;
    YTM.MAE = (mean(abs(AllFitYTM(:,1) - AllObsYTM(:,1))))*100*100;
    YTM.SR = sum((AllFitYTM(:,1) - AllObsYTM(:,1)).^2); % Sum of Squared Residuals
    YTM.SS = sum((AllObsYTM(:,1)-mean(AllObsYTM(:,1))).^2); % Sum of Squares
    % Price errors 
    Price.RMSE = sqrt(mean((AllFitPrices - AllObsPrices).^2))*100;
    Price.Max = max(abs(AllFitPrices - AllObsPrices))*100; 
    Price.MAE = mean(abs((AllFitPrices - AllObsPrices)))*100;
else
    % YTM Errors
    YTM.RMSE = sqrt(mean((FitYTM(:,1) - ObsYTM(:,1)).^2))*100*100;
    YTM.Max = (max(abs(FitYTM(:,1) - ObsYTM(:,1))))*100*100;
    YTM.MAE = (mean(abs(FitYTM(:,1) -ObsYTM(:,1))))*100*100;
    YTM.SR = sum((ObsYTM(:,1)-FitYTM(:,1)).^2); % Sum of Squared Residuals
    YTM.SS = sum((ObsYTM(:,1)-mean(ObsYTM(:,1))).^2); % Sum of Squares
    % Price errors 
    Price.RMSE = sqrt(mean((FitPrices - ObsPrices).^2))*100;
    Price.Max = max(abs(FitPrices - ObsPrices))*100; 
    Price.MAE = mean(abs((FitPrices - ObsPrices)))*100;
end
    
% === PRINT RESULTS =======================================================
if strcmp(DispResults,'yes') 
    fprintf('======================= ERROR MEASURES ================================\n');
    Settle = datestr(Bonds.Settle, 'dd/mm/yyyy');        
    fprintf(['\nError Measures for: ' Settle '\n'])
    fprintf('Number of bonds for estimation = %d\n', Nbonds)
    if (strcmp(IncludeSRinError, 'yes')) && (~isempty(SR))
        fprintf('Short Rates included in error measures\n')
    end        
    if (~strcmp(IncludeSRinError, 'yes')) || (isempty(SR))
        fprintf('Short Rates NOT included in error measures\n')
    end   
    fprintf('\nRMSE for price in Halere = %2.0f\n', Price.RMSE)
    fprintf(' MAE for price in Halere = %2.0f\n', Price.MAE)
    fprintf('MaxAE for price in Halere = %2.0f\n', Price.Max)
    fprintf('\nRMSE for YTM in bp = %2.1f\n', YTM.RMSE)
    fprintf(' MAE for YTM in bp = %2.1f\n', YTM.MAE)   
    fprintf('MaxAE for YTM in bp = %2.1f\n', YTM.Max)
    %fprintf('-------------------------------------------------------------\n');
end

end