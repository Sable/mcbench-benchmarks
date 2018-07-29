function [TimeFraction DaysCount] = daybasis(Settle, Maturity, Standard)
% DAYBASIS
% 
% [TimeFraction DaysCount] = daybasisXLS(Settle, Maturity, Standard)
% 
% Settle and Maturity in 'dd.mm.yyyy' format
% Standard - '30E/360' or 'Act/360'
% 
% IMPORTANT: Set proper Date Format, e.g., for XLS: 'dd.mm.yyyy'
%
% Kamil Kladivko
% kladivko@gmail.com
% December 2010 
% Cite as: 
% Kladivko Kamil (2010). The Czech Treasury Yield Curve from 1999 to the Present, 
% Czech Journal of Economics and Finance, 60(4): 307-335
% ========================================================================================


DateFormat = 'dd/mm/yyyy';
if nargin ~= 3
    error('Three input variables needed.')
end

switch Standard
    case '30E/360'
        [SettleYr, SettleMo, SettleDay] = datevec(Settle, DateFormat);
        [MaturityYr, MaturityMo, MaturityDay] = datevec(Maturity, DateFormat);
        if SettleDay == 31, SettleDay = 30; end; if MaturityDay == 31, MaturityDay = 30; end
        DaysCount = 360*(MaturityYr-SettleYr) + 30*(MaturityMo-SettleMo) + (MaturityDay-SettleDay);
        TimeFraction = DaysCount/360;
    case {'Act/360', 'ACT/360'}
        DaysCount = datenum(Maturity, DateFormat) - datenum(Settle, DateFormat);         
        TimeFraction = DaysCount./360;  
    otherwise 
        error('Unknown day basis standard')
end