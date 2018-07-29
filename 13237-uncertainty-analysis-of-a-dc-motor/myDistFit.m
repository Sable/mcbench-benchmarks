function [k,sigma,mu] = myDistFit(Temperature)
%MYDISTFIT    Create plot of datasets and fits
%   MYDISTFIT(TEMPERATURE)
%   Creates a plot, similar to the plot in the main distribution fitting
%   window, using the data that you provide as input.  You can
%   apply this function to the same data you used with dfittool
%   or with different data.  You may want to edit the function to
%   customize the code and this help message.
%
%   Number of datasets:  1
%   Number of fits:  1

% This function was automatically generated on 04-Dec-2006 08:27:07
 
% Data from dataset "Temperature data":
%    Y = Temperature
 
% Force all inputs to be column vectors
Temperature = Temperature(:);

% Set up figure to receive datasets and fits
f_ = clf;
figure(f_);
set(f_,'Units','Pixels','Position',[654 334.5 680 468.45]);
legh_ = []; legt_ = {};   % handles and text for legend
ax_ = newplot;
set(ax_,'Box','on');
hold on;

% --- Plot data originally in dataset "Temperature data"
t_ = ~isnan(Temperature);
Data_ = Temperature(t_);
[F_,X_] = ecdf(Data_,'Function','cdf'...
              );  % compute empirical cdf
Bin_.rule = 1;
[C_,E_] = dfswitchyard('dfhistbins',Data_,[],[],Bin_,F_,X_);
[N_,C_] = ecdfhist(F_,X_,'edges',E_); % empirical pdf from cdf
h_ = bar(C_,N_,'hist');
set(h_,'FaceColor','none','EdgeColor',[0.333333 0 0.666667],...
       'LineStyle','-', 'LineWidth',1);
xlabel('Data');
ylabel('Density')
legh_(end+1) = h_;
legt_{end+1} = 'Temperature data';

% Nudge axis limits beyond data limits
xlim_ = get(ax_,'XLim');
if all(isfinite(xlim_))
   xlim_ = xlim_ + [-1 1] * 0.01 * diff(xlim_);
   set(ax_,'XLim',xlim_)
end

x_ = linspace(xlim_(1),xlim_(2),100);

% --- Create fit "Generalized Extreme Value Fit"

% Fit this distribution to get parameter values
t_ = ~isnan(Temperature);
Data_ = Temperature(t_);
% To use parameter estimates from the original fit:
%     p_ = [ -0.1140337456229, 30.99486601834, 23.95766494166];
p_ = gevfit(Data_, 0.05);
y_ = gevpdf(x_,p_(1), p_(2), p_(3));
h_ = plot(x_,y_,'Color',[1 0 0],...
          'LineStyle','-', 'LineWidth',2,...
          'Marker','none', 'MarkerSize',6);
legh_(end+1) = h_;
legt_{end+1} = 'Generalized Extreme Value Fit';

hold off;
leginfo_ = {'Orientation', 'vertical', 'Location', 'NorthEast'}; 
h_ = legend(ax_,legh_,legt_,leginfo_{:});  % create legend
set(h_,'Interpreter','none');

% ---- Added code after generation
k = p_(1);
sigma = p_(2);
mu = p_(3);
