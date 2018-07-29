function plotMVAR(VaR, mVaR, time, names)
% PLOTMVAR: A helper function to display the estimate VaR and mVaR for a
% portfolio of stocks.
%
% Inputs:
% VaR: An nTimes-by-1 vector listing the portfolio VaRs at each of the
%   requested times
% mVaR: An nTimes-by-nAssets matrics listing the marginal VaRs of each
%  asset at each of the requested time
% time: An nTimes-by-1 vector labelling each of the requested times
% names: A 1-by-nAssets cell array containing identifying strings for each
%   of the assets

figure

% Plot the mVaR of the individual stocks.
plot(time, mVaR, '.-', 'DisplayName', names)

hold all

% Plot the VaR of the portfolio.
plot(time, VaR, '.-', 'DisplayName', 'Portfolio', 'LineWidth', 2)

hold off

xlabel('Trading day');
ylabel('Relative mVaR and VaR');

grid on
legend('show', 'Location', 'Best')
