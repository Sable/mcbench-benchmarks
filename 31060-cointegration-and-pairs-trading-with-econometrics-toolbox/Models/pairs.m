function varargout = pairs(series2, M, N, spread, scaling, cost)
% PAIRS returns a trading signal for a simple pairs trading strategy

%%
% Copyright 2010, The MathWorks, Inc.
% All rights reserved.

%% Process input args
if ~exist('scaling','var')
    scaling = 1;
end

if ~exist('cost','var')
    cost = 0;
end

if ~exist('spread', 'var')
    spread = 1;
end

if nargin == 1
    % default values
    M = 420;
    N = 60;
elseif nargin == 2
    error('PAIRS:NoRebalancePeriodDefined',...
        'When defining a lookback window, the rebalancing period must also be defined')
end

% Very often, the pairs will be convincingly cointegrated, or convincingly
% NOT cointegrated.  In these cases, a warning is issued not to read too
% much into the test statistic.  Since we don't use the test statistic, we
% can suppress these warnings.
warning('off', 'econ:egcitest:LeftTailStatTooSmall')
warning('off', 'econ:egcitest:LeftTailStatTooBig')

%% Sweep across the entire time series
% Every N periods, we use the previous M periods' worth of information to
% estimate the cointegrating relationship (if it exists).
%
% We then use this estimated relationship to identify trading opportunities
% until the next rebalancing date.

s = zeros(size(series2));
indicate = zeros(length(series2),1);

for i = max(M,N) : N : length(s)-N
    % Calibrate cointegration model by looking back.
    [h,~,~,~,reg1] = egcitest(series2(i-M+1:i, :));
    if h ~= 0
        % Only engage in trading if we reject the null hypothesis that no
        % cointegrating relationship exists.
        
        % The strategy:
        % 1. Compute residuals over next N days
        res = series2(i:i+N-1, 1) ...
            - (reg1.coeff(1) + reg1.coeff(2).*series2(i:i+N-1, 2));
        
        % 2. If the residuals are large and positive, then the first series
        % is likely to decline vs. the second series.  Short the first
        % series by a scaled number of shares and long the second series by
        % 1 share.  If the residuals are large and negative, do the
        % opposite.
        indicate(i:i+N-1) = res/reg1.RMSE;
        
        s(i:i+N-1, 2) = (res/reg1.RMSE > spread) ...
            - (res/reg1.RMSE < -spread);
        s(i:i+N-1, 1) = -reg1.coeff(2) .* s(i:i+N-1, 2);
    end
end

%% Calculate performance statistics

r  = sum([0 0; s(1:end-1, :) .* diff(series2) - abs(diff(s))*cost/2] ,2);
sh = scaling*sharpe(r,0); 

if nargout == 0
    %% Plot results
    ax(1) = subplot(3,1,1);
    plot(series2), grid on
    legend('LCO','WTI')
    title(['Pairs trading results, Sharpe Ratio = ',num2str(sh,3)])
    ylabel('Price (USD)')
    
    ax(2) = subplot(3,1,2);
    plot([indicate,spread*ones(size(indicate)),-spread*ones(size(indicate))])
    grid on
    legend(['Indicator'],'LCO: Over bought','LCO: Over sold',...
        'Location','NorthWest')
    title(['Pairs indicator: rebalance every ' num2str(N)...
        ' minutes with previous ' num2str(M) ' minutes'' prices.'])
    ylabel('Indicator')
    
    ax(3) = subplot(3,1,3);
    plot([s,cumsum(r)]), grid on
    legend('Position for LCO','Position for WTI','Cumulative Return',...
        'Location', 'NorthWest')
    title(['Final Return = ',num2str(sum(r),3),' (',num2str(sum(r)/mean(series2(1,:))*100,3),'%)'])
    ylabel('Return (USD)')
    xlabel('Serial time number')
    linkaxes(ax,'x')
else
    %% Return values
    for i = 1:nargout
        switch i
            case 1
                varargout{1} = s; % signal
            case 2
                varargout{2} = r; % return (pnl)
            case 3
                varargout{3} = sh; % sharpe ratio
            case 4
                varargout{4} = indicate; % indicator
            otherwise
                warning('PAIRS:OutputArg',...
                    'Too many output arguments requested, ignoring last ones');
        end 
    end
end