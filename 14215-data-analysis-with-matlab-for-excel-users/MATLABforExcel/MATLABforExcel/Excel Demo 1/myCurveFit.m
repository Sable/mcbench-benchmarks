function mycurvefit(averageDay, thehour)
%MYCURVEFIT    Create plot of datasets and fits
%   MYCURVEFIT(AVERAGEDAY)
%   Creates a plot, similar to the plot in the main curve fitting
%   window, using the data that you provide as input.  You can
%   apply this function to the same data you used with cftool
%   or with different data.  You may want to edit the function to
%   customize the code and this help message.
%
%   Number of datasets:  1
%   Number of fits:  1

 
% Data from dataset "averageDay":
%    Y = averageDay:
%    Unweighted
%
% This function was automatically generated on 13-Feb-2007 17:21:42
% Copyright 2006-2009 The MathWorks, Inc.

% Set up figure to receive datasets and fits
f_ = clf;
figure(f_);
set(f_,'Units','Pixels','Position',[318 118.5 680 477]);
xlim_ = [Inf -Inf];       % limits of x axis
ax_ = axes;
set(ax_,'Units','normalized','OuterPosition',[0 0 1 1]);
set(ax_,'Box','on');
axes(ax_); hold on;

 
% --- Plot data originally in dataset "averageDay"
x_1 = (1:numel(averageDay))';
averageDay = averageDay(:);
h_ = line(x_1,averageDay,'Parent',ax_,'Color',[0.333333 0 0.666667],...
     'LineStyle','none', 'LineWidth',1,...
     'Marker','.', 'MarkerSize',12);
xlim_(1) = min(xlim_(1),min(x_1));
xlim_(2) = max(xlim_(2),max(x_1));

% Nudge axis limits beyond data limits
if all(isfinite(xlim_))
   xlim_ = xlim_ + [-1 1] * 0.01 * diff(xlim_);
   set(ax_,'XLim',xlim_)
end


% --- Create fit "fit 1"
ok_ = isfinite(x_1) & isfinite(averageDay);
st_ = [0 0 0 0 0 0 0 0 0 0 0 0.2731819698774 ];
ft_ = fittype('fourier5');

% Fit this model using new data
cf_ = fit(x_1(ok_),averageDay(ok_),ft_,'Startpoint',st_);

% Or use coefficients from the original fit:
if 0
   cv_ = { 45.34421881175, -5.786363954186, -7.023252780652, -1.630929590598, -4.891585635542, -0.5298981900424, 1.512461132015, 0.2971460770778, 0.5534208653571, -0.6487411378073, -0.7572297602488, 0.2642948447239};
   cf_ = cfit(ft_,cv_{:});
end

% Plot this fit
h_ = plot(cf_,'fit',0.95);
legend off;  % turn off legend from plot method call
set(h_(1),'Color',[1 0 0],...
     'LineStyle','-', 'LineWidth',2,...
     'Marker','none', 'MarkerSize',6);

% Done plotting data and fits.  Now finish up loose ends.
hold off;

%% Evaluate

power = feval(cf_, thehour);
vline(thehour, 'r', sprintf('Est. Power at %.1f is %.1f MW\n', thehour, power));
