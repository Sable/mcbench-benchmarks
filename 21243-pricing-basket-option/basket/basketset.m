function basketstruct = basketset(SPrice, Sigma, Corr, Num)
%BASKETSET Create basket structure for pricing basket options
%
% SPrice - Stock price matrix
% Sigma - Volatility of each stock
% Corr - Correlation matrix
% Num - Number of each security 1 x number of securities
if (nargin<3)
     error('finderiv:basketset:InvalidInputs','function needs minimum 3 inputs')
end

basketstruct.SPrice = SPrice;
basketstruct.Sigma = Sigma;
basketstruct.Corr = Corr;
basketstruct.Num = Num;
