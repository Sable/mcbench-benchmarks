function myProbFit(riseTime)
%MYPROBFIT    Create plot of datasets and fits
%   MYPROBFIT(RISETIME)
%   Creates a plot, similar to the plot in the main distribution fitting
%   window, using the data that you provide as input.  You can
%   apply this function to the same data you used with dfittool
%   or with different data.  You may want to edit the function to
%   customize the code and this help message.
%
%   Number of datasets:  1
%   Number of fits:  1

% This function was automatically generated on 04-Dec-2006 08:39:59
 
% Data from dataset "riseTime data":
%    Y = riseTime
 
% Force all inputs to be column vectors
riseTime = riseTime(:);

% Set up figure to receive datasets and fits
f_ = clf;
figure(f_);
set(f_,'Units','Pixels','Position',[1044 414 680 468.45]);
legh_ = []; legt_ = {};   % handles and text for legend
ax_ = newplot;
set(ax_,'Box','on');
hold on;

% --- Plot data originally in dataset "riseTime data"
t_ = ~isnan(riseTime);
Data_ = riseTime(t_);
[Y_,X_] = ecdf(Data_,'Function','cdf'...
              );  % compute empirical function
h_ = stairs(X_,Y_);
set(h_,'Color',[0.333333 0 0.666667],'LineStyle','-', 'LineWidth',1);
xlabel('Data');
ylabel('Cumulative probability')
legh_(end+1) = h_;
legt_{end+1} = 'riseTime data';

% Nudge axis limits beyond data limits
xlim_ = get(ax_,'XLim');
if all(isfinite(xlim_))
   xlim_ = xlim_ + [-1 1] * 0.01 * diff(xlim_);
   set(ax_,'XLim',xlim_)
end

x_ = linspace(xlim_(1),xlim_(2),100);

% --- Create fit "Generalized Extreme Value Fit"

% Fit this distribution to get parameter values
t_ = ~isnan(riseTime);
Data_ = riseTime(t_);
% To use parameter estimates from the original fit:
%     p_ = [ 0.1736524861501, 0.6950669599504, 5.471795648656];
p_ = gevfit(Data_, 0.05);
y_ = gevcdf(x_,p_(1), p_(2), p_(3)); % compute cdf
h_ = plot(x_,y_,'Color',[1 0 0],...
          'LineStyle','-', 'LineWidth',2,...
          'Marker','none', 'MarkerSize',6);
legh_(end+1) = h_;
legt_{end+1} = 'Generalized Extreme Value Fit';

hold off;
leginfo_ = {'Orientation', 'vertical'}; 
h_ = legend(ax_,legh_,legt_,leginfo_{:}); % create and reposition legend
set(h_,'Units','normalized');
t_ = get(h_,'Position');
t_(1:2) = [0.546814,0.700251];
set(h_,'Interpreter','none','Position',t_);
