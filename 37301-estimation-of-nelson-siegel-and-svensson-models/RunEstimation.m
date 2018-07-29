% ESTIMATION OF ZERO COUPON YIELDS FROM COUPON BOND PRICES USING THE
% NELSON-SIEGEL AND SVENSSON MODEL
% 
% Model = 'NS' (Nelson-Siegel) | 'Svensson'
%
% Optimization Structure
%
% .Method = 'price' | 'ytm' 
%  'price' fits (weighted)) cupon bond prices
%  'ytm' fits yields-to-maturity
%
% .Weights  = 'MD' | 'LA' | empty (Weights are irrelevant for the YTM method.)
%  'MD' weights use modified duration of bonds
%  'LA' weights work as the correct linear approaximation of ytm; 
%  LA weights equal MD weights divideded by observed cupon bond prices.
%  Note that weights are irrelevant for the YTM method.
%  Further note that short-rates (LIBOR rates) are underweighted, see the
%  NSobjP.m for details and "The Czech Treasury Yield Curve from 1999 to the
%  Present" for a discussion.
%
% .Algorithm = 'lsqnonlin' | 'fminsearch'
%  Supports two standard Matlab optimization routines. The nonlinear least
%  squares, lsqnonlin, which is tha part of Optimization Tbx is recommended.
%
% .Multistart = 'yes' | 'no'
%  The estimation algorothm creates a grid of starting values for optimization, which
%  gives better hope for finding global optima. Recommended.
%
% 
% Kamil Kladivko
% email: kladivko@gmail.com
%
% Cite as: 
% Kladivko Kamil (2010). The Czech Treasury Yield Curve from 1999 to the Present, 
% Czech Journal of Economics and Finance, 60(4): 307-335
% =========================================================================

clc
close all
clear variables

% 1) Set model
Model = 'NS';                       
Optimization.Method = 'price'; 
Optimization.Weights = 'LA';           
Optimization.Algorithm = 'lsqnonlin';   
Optimization.MultiStart = 'yes';       
                                                
% 2) Read data from EXCEL
% The EXCEL file contains Czech Governemnt bond prices and PRIBOR rates (short rates) from March 2, 2007
% There were 13 Czech Government bonds available on March 2, 2007. Furter, 4 PRIBOR rates are used
% to fix the short-end of the yield curve. See Section 5 of "The Czech Treasury Yield Curve from 1999 to the Present"

[B Btext] = xlsread('bonddata.xls', 'data', 'B6:F18');
[junk Settle] = xlsread('bonddata.xls', 'data', 'C2:C2');
[SR SRtext] = xlsread('bonddata.xls', 'data', 'J6:L9');

% The DATE format in EXCEL depends on the "national settings". Needs to be
% set accordingly!
Bonds.Issue = datenum(Btext(:,1), 'dd.mm.yyyy');
Bonds.Maturity = datenum(Btext(:,2), 'dd.mm.yyyy');
Bonds.Settle = datenum(Settle, 'dd.mm.yyyy');
Bonds.Prices = B(:,2);
% Make sure that bond ID (isseu number) was read as text! If not adjust
% either this code or EXCEL.
Bonds.Emission = Btext(:,5);
Bonds.Coupon = B(:,1)./100;
% Assumes that coupon is paid once a year. The first cupon can be payed
% later than after one year. See czbondcf.m and czbondfuturecf.m for
% details
Bonds.Notional = 100;
Bonds.Basis = 1; 
% Bonds.Basis = '1' | '2'
% Bond.Basis is Day-Count basis for calculation coupon cash flows
% 1: 30E/360 (default), 2: Actual/360 
% Go to czbondcf.m and czbondfuturecf.m to adjust for your basis

ShortRates.IR = SR(:,1)'./100; % This must be as row vector opposed to the bond data
if ~isempty(ShortRates), ShorRates.IR = log(1+ShortRates.IR); end % Transform SR to continuous compounding
ShortRates.TimeFactor = SR(:,2)';
ShortRates.Emission = SRtext';

% If Short Rates are not to be used then supply "ShotRates = []" into the
% estimation routine below.
%ShortRates = [];

% 3) Nelson-Siegel Parameters Estimation (calls the main estimation routine)
[Params Fval MaxTime2Mat ParamsMS FvalMS] = NSest(Bonds, ShortRates, Model, Optimization);

% 4) Estimation Error;
IncludeSRinError = 'no';
[PriceE YTME] = NSerror(Bonds, ShortRates, Model, Params, IncludeSRinError);

% 5) Plot
Plots1D(Params, Model, YTME, ShortRates);

