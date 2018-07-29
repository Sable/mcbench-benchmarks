function [tau,ss] = myDCMotorFit(time,velocity,varargin)
%MYDCMOTORFIT    Create plot of datasets and fits
%   MYDCMOTORFIT(TIME,VELOCITY)
%   Creates a plot, similar to the plot in the main curve fitting
%   window, using the data that you provide as input.  You can
%   apply this function to the same data you used with cftool
%   or with different data.  You may want to edit the function to
%   customize the code and this help message.
%
%   Number of datasets:  1
%   Number of fits:  1
%
%-->Modified after generating code to output ss and Tr values as well as
%   change plotting to optional.
%
%   Example:
%   [tau,ss] = myDCMotorFit(time,velocity,'showplot')

% Data from dataset "Experimental Data":
%    X = time:
%    Y = velocity:
%    Unweighted
%
% This function was automatically generated on 08-Sep-2006 09:57:03

% ---- Added Code ---
showplot = 0;
if nargin >= 3
    if strcmpi(varargin{1},'showplot')
        showplot = 1;
    end
end

% Check for stepinfo --> computes rise time and steady state much faster
% than curve fits...
if exist('stepinfo','file') && ~showplot
    t = stepinfo(velocity,time);
    tau   = t.RiseTime/2.1927;
    ss = t.Peak;
    t0 = 0;
    return
end
% ---- Added Code ---

if showplot
    % Set up figure to receive datasets and fits
    f_ = clf;
    figure(f_);
    set(f_,'Units','Pixels','Position',[1124 368 680 477]);
    legh_ = []; legt_ = {};   % handles and text for legend
    xlim_ = [Inf -Inf];       % limits of x axis
    ax_ = axes;
    set(ax_,'Units','normalized','OuterPosition',[0 0 1 1]);
    set(ax_,'Box','on');
    axes(ax_); hold on;


    % --- Plot data originally in dataset "Experimental Data"
    time = time(:);
    velocity = velocity(:);
    h_ = line(time,velocity,'Parent',ax_,'Color',[0.333333 0.666667 0],...
        'LineStyle','none', 'LineWidth',1,...
        'Marker','.', 'MarkerSize',12);
    xlim_(1) = min(xlim_(1),min(time));
    xlim_(2) = max(xlim_(2),max(time));
    legh_(end+1) = h_;
    legt_{end+1} = 'Experimental Data';

    % Nudge axis limits beyond data limits
    if all(isfinite(xlim_))
        xlim_ = xlim_ + [-1 1] * 0.01 * diff(xlim_);
        set(ax_,'XLim',xlim_)
    end
end

% --- Create fit "Custom Exponential"
fo_ = fitoptions('method','NonlinearLeastSquares','Lower',[0 0 -Inf ]);
ok_ = isfinite(time) & isfinite(velocity);
st_ = [0.1883440486471 0.527089634853 0.8297401239903 ];
set(fo_,'Startpoint',st_);
ft_ = fittype('Vss*(1-exp(-(t-to)/tau))',...
    'dependent',{'y'},'independent',{'t'},...
    'coefficients',{'Vss', 'tau', 'to'});

% Fit this model using new data
cf_ = fit(time(ok_),velocity(ok_),ft_,fo_);

% Or use coefficients from the original fit:
if 0
    cv_ = { 2159.211873162, 2.617291584462, 0.1000705847091};
    cf_ = cfit(ft_,cv_{:});
end

% Plot this fit if desired
if showplot
    h_ = plot(cf_,'fit',0.95);
    legend off;  % turn off legend from plot method call
    set(h_(1),'Color',[1 0 0],...
        'LineStyle','-', 'LineWidth',2,...
        'Marker','none', 'MarkerSize',6);
    legh_(end+1) = h_(1);
    legt_{end+1} = 'Custom Exponential';

    % Done plotting data and fits.  Now finish up loose ends.
    hold off;
    leginfo_ = {'Orientation', 'vertical'};
    h_ = legend(ax_,legh_,legt_,leginfo_{:}); % create and reposition legend
    set(h_,'Units','normalized');
    t_ = get(h_,'Position');
    t_(1:2) = [0.626961,0.139064];
    set(h_,'Interpreter','none','Position',t_);
    xlabel(ax_,'Time (s)');
    ylabel(ax_,'Velocity (rpm)');
end

% ---- Added Code ---
% calculate the rise time and steady state velocity from fit
if nargout > 0
   coeff = coeffvalues(cf_);
   ss = coeff(1);
   tau = coeff(2);
   t0 = coeff(3);
end
% ---- Added Code ---