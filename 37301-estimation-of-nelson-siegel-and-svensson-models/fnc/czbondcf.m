function CF = czbondcf(CouponRate, Issue, Maturity, Basis, Notional)   
% =========================================================================
% CZBONDCF generates cash flows and cash flows dates for Czech Governemnt Bonds
% using 30E/360 or Actual/360 standard. Coupons are once a year. 
% First coupon can be irregular.  
%
% CF = czgbcf(CouponRate, Issue, Maturity, Notional)
% 
% INPUTS:  
%         CouponRate - Coupon rate in decimal form
%              Issue - Issue Date in serial date number
%                      (NOTE: convert date string using DATENUM) 
%           Maturity - Maturity Date in serial date number
% 
% OPTIONAL INPUT:
%           Notional - Notional of the bond (default is 100)
%              Basis - Day-count basis
%                      1 - 30E/360 (default)
%                      2 - Actual/360 
% 
% OUTPUT: 
%                 CF - Cash Flow matrix
%                       - 1st row, nominal cash flows
%                       - 2nd row, cash flow dates
% 
% NOTE:
%       Normally, Czech Government Bonds are traded according to 30E/360 convention!  
% 
% Kamil Kladivko 
% email: kladivko@gmail.com
% December 2010 
% Cite as: 
% Kladivko Kamil (2010). The Czech Treasury Yield Curve from 1999 to the Present, 
% Czech Journal of Economics and Finance, 60(4): 307-335
% =========================================================================
    if nargin < 3, error('Need at least 3 inputs'); end
    if nargin == 3, Basis = 1; Notional = 100; end
    if nargin == 4, Notional = 100; end    
    if all(Basis ~= [1, 2])
        warning('Unknown code for day count convention. Using 30E/360');
        Basis = 1;
    end
    [IssueYr, IssueMo, IssueDay] = datevec(Issue);
    [MatYr, MatMo, MatDay] = datevec(Maturity);
    Yrs2Mat = MatYr - IssueYr;
    
    CF = zeros(2, Yrs2Mat+1);
    CF(1,1) = -Notional;
    CF(2,1) = datenum(Issue);
    for i = 1:Yrs2Mat
        CF(2, i+1) = datenum(IssueYr+i, MatMo, MatDay);       
    end
    [ThisYr, ThisMo, ThisDay] = datevec(Issue);
    for i = 1:Yrs2Mat
        [NxtYr, NxtMo, NxtDay] = datevec(CF(2,i+1));
        switch Basis
            case 1
                if NxtDay == 31, NxtDay = 30; end; if ThisDay == 31, ThisDay = 30; end;
                DaysCount = 360*(NxtYr - ThisYr) + 30*(NxtMo - ThisMo) + (NxtDay - ThisDay);
                CF(1,i+1) = CouponRate*Notional*DaysCount/360;
                ThisYr = NxtYr; ThisMo = NxtMo; ThisDay = NxtDay;
            case 2
                DaysCount = datenum(NxtYr, NxtMo, NxtDay) - datenum(ThisYr, ThisMo, ThisDay);
                CF(1,i+1) = CouponRate*Notional*DaysCount/360;
                ThisYr = NxtYr; ThisMo = NxtMo; ThisDay = NxtDay;
        end
    end        
    CF(1,end) = CF(1,end) + Notional;
end
