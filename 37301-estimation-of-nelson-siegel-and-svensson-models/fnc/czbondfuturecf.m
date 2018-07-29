function [FutureCF AccruedInt] = czbondfuturecf(CouponRate, Issue, Maturity, Settle, Basis, Notional)
% =========================================================================
% CZBONDFUTURECF generates future (and current - settlement date) cash flows,
% cash flow dates and cash flow time fraction according to day count basis (30E/360, Actual/360)
% for Czech Government Bonds. Further, it calculates accrued interest.
%
% [Yield AccruedInt] = czgbfuturecf(CouponRate, Issue, Maturity,...
%       Settle, Basis, Notional)
% 
% INPUTS:  
%         CouponRate - Coupon rate in decimal form
%              Issue - Issue Date in serial date number
%                      (NOTE: convert date string using DATENUM)
%           Maturity - Maturity Date in serial date number
%             Settle - Settlment Date in serial date number
% 
% OPTIONAL INPUT:
%           Notional - Notional of the bond (default is 100)
%              Basis - Day-count basis
%                      1 - 30E/360 (default)
%                      2 - Actual/360 
% 
% OUTPUT: 
%            FutureCF - Future cash flow matrix 
%                       - 1st row, nominal cash flows
%                       - 2nd row, cash flow dates
%                       - 3rd row, cash flow time fraction measured in years
%                            
%         AccruedInt - Accrued interest since last coupon
% 
% NOTE: 
%         It doesn't work take ex-coupon date into account
%         Normally, Czech Government Bonds are traded according to 30E/360 convention!  
% 
% USES: czbondcf
% 
% Kamil Kladivko 
% email: kladivko@gmail.com
% December 2010 
% Cite as: 
% Kladivko Kamil (2010). The Czech Treasury Yield Curve from 1999 to the Present, 
% Czech Journal of Economics and Finance, 60(4): 307-335
% =========================================================================

    if nargin < 4, error('Need at least 4 inputs'); end
    if nargin == 4, Basis = 0; Notional = 100; end  
    if nargin == 5, Notional = 100; end 
    if all(Basis ~= [1, 2])
        warning('Unknown code for day count convention. Using 30E/360');
        Basis = 1;
    end
    % Generates CZGB cash flows
    CF = czbondcf(CouponRate, Issue, Maturity, Basis, Notional);  
    TempCF = CF(:, 2:end); % Don't want first negative CF (notional of the bond)
    % Pick only furture and current (Settlment date) cash flows
    [SettYr, SettMo, SettDay] = datevec(Settle);       
    FutureCF = TempCF(:, TempCF(2, :) >= datenum(Settle));
    % Find last cash flow date before settlment
    [junk FutureCFcount] = size(FutureCF);
    AccrualDate = CF(2, end-FutureCFcount);        
    % Acrrued Interest
    switch Basis
        case 1 % 30E/360
            [AccrualYr, AccrualMo, AccrualDay] = datevec(AccrualDate);
            if SettDay == 31, SettDay = 30; end; if AccrualDay == 31, AccrualDay = 30; end
            DaysCount = 360*(SettYr - AccrualYr) + 30*(SettMo - AccrualMo) + (SettDay - AccrualDay);
            AccruedInt = CouponRate*Notional*DaysCount/360;
        case 2 % Actual/360; 
            DaysCount = datenum(Settle) - AccrualDate;
            AccruedInt = CouponRate*Notional*DaysCount/360;
    end
    % Time Factor
    switch Basis
        case 1 % 30E/360
            DaysCount = zeros(1, FutureCFcount);
            for i = 1:FutureCFcount
                [NxtYr, NxtMo, NxtDay] = datevec(FutureCF(2,i));
                if NxtDay == 31, NxtDay = 30; end
                DaysCount(i) = 360*(NxtYr - SettYr) + 30*(NxtMo - SettMo) + (NxtDay - SettDay);                  
            end
            TimeFactor = DaysCount./360;
        case 2 % Actual/360;      
              DaysCount =  FutureCF(2,:) - datenum(Settle);         
              TimeFactor = DaysCount./360;       
    end                         
    FutureCF = [FutureCF; TimeFactor];                        
end