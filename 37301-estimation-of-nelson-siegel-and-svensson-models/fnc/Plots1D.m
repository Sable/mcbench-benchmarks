function Plots1D(Params, Model, YTM, ShortRates)
% =========================================================================
% Plots yield curve for estimated model. All rates are annualy compounded.
% 
% INPUT: 
%           
%         Params - Estimated parameters
%          Model - 'NS' for Nelson-Siegel model
%                  'Svensson' for Svensson model
%            YTM - 
%         Settle - 
% USES:
%        NScurve
% 
% Kamil Kladivko
% email: kladivko@gmail.com
% December 2010 
% Cite as: 
% Kladivko Kamil (2010). The Czech Treasury Yield Curve from 1999 to the Present, 
% Czech Journal of Economics and Finance, 60(4): 307-335
% =========================================================================

% Figure 1 (Spot, FWD and Par rates)
FontSize = 14;
Mat = 0:0.1:ceil(max(YTM.TimeFraction));
%Mat = 0:0.1:40; % 27.1.2010
[ZeroRates InstFwdRates] = NScurve(Params, Mat, Model);
ZeroRates = exp(ZeroRates) - 1; % Annual compounding
InstFwdRates = exp(InstFwdRates) - 1; % Annual compounding
% Par Rates 
MatForPar = 1:1:ceil(max(YTM.TimeFraction));
[ZeroForParRates junk] = NScurve(Params, MatForPar, Model);
ZeroForParRates = exp(ZeroForParRates) - 1;  % Annual compounding
ParRates = zero2par(ZeroForParRates); 
% Plot Zero, Observed YTM, Fit YTM, Par, Fwd
figure
plot(Mat, ZeroRates.*100, '-b', 'LineWidth', 2) % Zero
hold on
set(gca, 'FontSize', FontSize, 'FontName', 'Arial');
plot(MatForPar, ParRates.*100, '--b', 'MarkerSize', 8, 'LineWidth', 2) % Par rates
plot(Mat, InstFwdRates.*100, ':b', 'MarkerSize', 8, 'LineWidth', 2) % FWD rates
if ~isempty(ShortRates)
    SRcount = length(ShortRates.IR);
else
    SRcount = 0;
end
plot(YTM.TimeFraction(SRcount+1:end), YTM.Obs(SRcount+1:end).*100, 'ko', 'MarkerSize', 5, 'MarkerFaceColor','k') % YTM of observed bonds
plot(YTM.TimeFraction(SRcount+1:end), YTM.Fit(SRcount+1:end).*100, 'ks', 'MarkerSize', 7) % YTM of fitted bonds
plot(YTM.TimeFraction(1:SRcount), YTM.Obs(1:SRcount).*100, 'k^', 'MarkerSize', 6, 'MarkerFaceColor','k')
% Bonds ID (issue) number
BondsCount = length(YTM.TimeFraction);
minYTM = min(YTM.Obs, YTM.Fit);
j = 1;
for i=SRcount+1:BondsCount
    h(j) = text(YTM.TimeFraction(i), minYTM(i).*100 - 0.15, YTM.Emission{i});
    j = j + 1;
end
set(h, 'FontSize', FontSize, 'FontName', 'Arial');
xlim([0 max(Mat)]);
ymin = min([ZeroRates, ParRates, InstFwdRates]);
ymax = max([ZeroRates, ParRates, InstFwdRates]);
ylim([ymin*100-0.5 ymax*100+0.5]);
% ======================================================
xlabel('Maturity in years')
ylabel('Percents')
grid off
hold off
if SRcount ~= 0
    legend('Spot Rates', 'Par Rates', 'Instantaneous Forward Rates',...
           'Observed Yields to Maturity', 'Fitted Yields to Maturity', 'Short-Rates')
else
    legend('Spot Rates', 'Par Rates', 'Instantaneous Forward Rates',...
           'Observed Yields to Maturity', 'Fitted Yields to Maturity')
    
end
legend('Location', 'NorthWest')
legend('boxoff')

end