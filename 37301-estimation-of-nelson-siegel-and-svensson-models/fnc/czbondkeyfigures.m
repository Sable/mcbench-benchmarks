function BondFig = czbondkeyfigures(CouponRate, Issue, Maturity, Settle, Price, Basis, Notional, PrintResults)
% =========================================================================
% CZBONDKEYFIGURES calculates Yield to Maturity, Accrued Interest, Modified Duration and Time to Maturity
% for Czech Government Bonds according to 30E/360 or Actual/360 day count basis.
%
% [BondFig] = czbondkeyfigures(CouponRate, Issue, Maturity,...
%       Settle, Price, Basis, Notional, PrintResults)
% 
% INPUTS:  
%         CouponRate - Coupon rate in decimal form
%              Issue - Issue Date in serial date number
%                      (NOTE: convert date string using DATENUM) 
%           Maturity - Maturity Date in serial date number
%             Settle - Settlment Date in serial date number
%              Price - Clean price for 100 notional, i.e price without
%                      accrued interest
% 
% OPTIONAL INPUTS: 
%             Basis - Day-count basis
%                      1 - 30E/360 (default)
%                      2 - Actual/360 (This is currently not used for Czech
%                      Government bonds)
%           Notional - Notional of the bond (default 100)
%       PrintResults - Print results in Matlab command window
%                    - 'yes' 
%                    - 'no' (default)         
% 
% OUTPUTS: 
%             BondFig - Bonnd's key figures, structure
%                                    BondFig.YTM - yiled to maturity in decimal form
%                             BondFig.AccruedInt - accrued interest 
%                                     BondFig.MD - modified duration
%                        BonndFig.TimeToMaturity - time to maturity
%                        BonndFig.Convex - convexity
% 
% USES: czbondfuturecf
% 
% Kamil Kladivko 
% email: kladivko@gmail.com
% December 2010 
% Cite as: 
% Kladivko Kamil (2010). The Czech Treasury Yield Curve from 1999 to the Present, 
% Czech Journal of Economics and Finance, 60(4): 307-335
% =========================================================================
    if nargin < 5, error('Need at least 5 inputs'); end
    if nargin == 5, Basis = 0; Notional = 100; PrintResults = 'no'; end
    if nargin == 6, Notional = 100; PrintResults = 'no'; end
    if nargin == 7, PrintResults = 'no'; end
    if all(Basis ~= [1, 2])
        warning('Unknown code for day count convention. Using 30E/360.\n');
        Basis = 1;
    end
    if Maturity <= Settle
        %dbstop in czbondkeyfigures at 50
        error('Maturity date before or at Settlment date! Terminating...')
    end
    if Issue > Settle 
        error('Issue date after Settlment date! Terminating...')
    end
        
    Price = Price/100*Notional;        
    % Generate CZGB future cash flows and calculate accrued interest
    [FutureCF AccruedInt] = czbondfuturecf(CouponRate, Issue, Maturity, Settle, Basis, Notional);  
    TimeToMaturity = FutureCF(3, end);
    % Solve for yield to maturity   
    InitialYield = CouponRate;
    [Yield, Fval, Exitflag] = fzero(@(Yield) YieldObj(Yield, Price, AccruedInt, FutureCF), InitialYield);    
    if Exitflag < 0, warning('Could not solve for the yield.\n'); end
    % Duration and Modified Duration
    TimeFactor = FutureCF(3,:);
    Dnominator = sum(FutureCF(1,:).*TimeFactor./((1+Yield).^TimeFactor));
    Ddenominator = sum(FutureCF(1,:)./((1+Yield).^FutureCF(3,:)));
    D = Dnominator/Ddenominator;
    MD = D/(1+Yield);
    % Convexity
    Cnominator = sum(FutureCF(1,:).*TimeFactor.*(TimeFactor+1)./((1+Yield).^TimeFactor));
    C = Cnominator/Ddenominator;
    Convex = C/(1+Yield)^2;            
    % Print Results 
    if strcmp(PrintResults, 'yes')
        fprintf('\nYield to Maturity (%%) = %1.3f\n', Yield*100);
        fprintf('Accrued Interest = %1.3f\n', AccruedInt);
        fprintf('Duration = %1.3f\n', D);
        fprintf('Modified Duration = %1.3f\n', MD);
    end
    BondFig.YTM = Yield;
    BondFig.AccruedInt = AccruedInt;
    BondFig.MD = MD;
    BondFig.Convex = Convex;
    BondFig.TimeToMaturity = TimeToMaturity;    
end
% -------------------------------------------------------------------------
% Objective function for clean price
% -------------------------------------------------------------------------
function  f = YieldObj(Yield, Price, AccruedInt, CF)
    [junk CFcount] = size(CF);
    TimeFactor = CF(3,:);
    if CFcount > 1
        f = sum(CF(1,:)./((1+Yield).^TimeFactor)) - (Price + AccruedInt);
    elseif CFcount == 1
        f = sum(CF(1,:)./(1+Yield.*TimeFactor)) - (Price + AccruedInt);
    end
end

