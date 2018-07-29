function [coefs,x,y] = clickfit_OH(varargin)

% function [coefs,x,y] = clickfit_OH(varargin)
%
% clickfit_OH.m lets you "click" a series of datapoints on top of a (noisy)
% scatterplot and returns a spline or polynomial regression through the
% clicked dataseries. In addition the clicked series is returned.
%
% USES:
% * ginput_OH by Oscar Hartogensis
% * Uses (but will function without):
%   * splinefit.m by Jonas Lundgren 
%       (../fileexchange/13812-fit-a-spline-to-noisy-data) 
%   * binned_plot.m by Stefan Schroedl 
%       (../fileexchange/19506-binned-scatter-plot)
%       (needs the Statistics Toolbox!; if not available, this option will be disabled)
%
% INPUT:
% Varargin format: 
%    clickfit_OH('vararg1', value1, 'vararg2', value2)
% Varargin options:
%    --> 'method'     : 'spline' or 'polyfit' or 'none' (default='none')
%                       method='none' only returns x and y, no fit
%    --> 'M'          : only for method=spline - defines subset stepsize (1:M:end). 
%                       A large M means few breaks and a smooth spline.
%                       (default=1 - no smoothing) - see splinefit.m
%    --> 'order'      : only for method=polyfit -  (default=1)
%    --> 'intercept'  : only for method=polyfit & order=1 - [0 1] or 
%                       ['yes','no'] (default=1) 
%    --> 'binplot'    : [0 1] or ['on' 'off'] Make a binned (smoothed) plot
%                       of the data to guide the clicking 
%                       (default=0) - see binned_plot.m
%    --> 'pointertype': 'fullcrosshair','crosshair','arrow','circle'etc. 
%                       (default='arrow')
%    --> 'do_legend'  : [0 1] or ['on' 'off'] (default=0)
%
% OUTPUT:
% coefs : spline paramaters or polyfit coefficients:
%           usage: --> spline: yy = ppval(coefs,xx);
%                  --> polyfit: yy = polyval(coefs,xx);
% x     : x-coordinates of the clicked series
% y     : y-coordinates of the clicked series
%
% NOTE:
%    --> ENTER LAST DATA-POINT WITH RIGHT MOUSE BUTTON
%    --> clickfit_OH.m elaborates on a ginput.m-example in the Matlab help;
%        the name is inspired by click_fit.m by Nassim Khaled 
%        (../fileexchange/9311-clickfit)
%    --> The fixed colors used for binplot, clickplot and fitplot work best
%        with the datapoints in black or blue
%
% EXAMPLE:
%   Create noisy data:
%     a = 0:0.01:3;
%     noise = 0.07*randn(size(a));
%     b = 5*a.*exp(-3*a) + noise;
%     plot(a,b,'o');
%   Calls to clickfit_OH:
%     --> clickfit_OH;
%     --> clickfit_OH('method','spline', 'M', 3, 'binplot', 1);
%     --> [coefs] = clickfit_OH('method','spline', 'M', 3, 'binplot', 1,'do_legend', 1);
%     --> [coefs,x,y] = clickfit_OH('method','polyval', 'order', 1, 'intercept' 0, 'binplot', 1);
%
% Author:   Oscar Hartogensis (oscar.hartogensis at wur.nl)
% Date:     Januari 2010
% Rev:


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DISECT VARARGIN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load defaults
method = 'none';
M = 1;
order = 1;
intercept = 0;
binplot = 0;
pointertype = 'arrow';
do_legend = 0;
% disect varargin
vin=varargin;
if ~isempty(vin)
    for i=1:length(vin)
        if strcmpi(vin{i},'method')
            method=vin{i+1};
        elseif strcmpi(vin{i},'M')
            M=vin{i+1};
        elseif strcmpi(vin{i},'order')
            order=vin{i+1};
        elseif strcmpi(vin{i},'intercept')
            intercept=vin{i+1};
            if strcmpi(intercept,'yes') intercept=1; end
            if strcmpi(intercept,'no') intercept=0; end
        elseif strcmpi(vin{i},'binplot')
            binplot=vin{i+1};
            if strcmpi(binplot,'on') binplot=1; end
            if strcmpi(binplot,'off') binplot=0; end
			% disable binplot if binned_plot not available
            if ~exist('binned_plot','file')
                binplot=0; 
                disp('binplot option disabled; binned_plot.m not available')
            end
			% disable binplot if statistics toolbox not available
            if ~exist('quantile','file')
                binplot=0; 
                disp('binplot option disabled; statistics toolbox not available')
            end            
        elseif strcmpi(vin{i},'pointertype')
            pointertype=vin{i+1};
        elseif strcmpi(vin{i},'do_legend')
            do_legend=vin{i+1};
            if strcmpi(do_legend,'on') do_legend=1; end
            if strcmpi(do_legend,'off') do_legend=0; end            
        end
    end
end

hold on

if do_legend h_data=legend('data'); end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAKE BINPLOT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if binplot
    lines = findobj(gcf,'Type','line');
    if do_legend start=3; else start=1; end
    Xdata = []; Ydata=[];
    for i=start:length(lines)
        Xdata = [Xdata, get(lines(i),'XData')];
        Ydata = [Ydata, get(lines(i),'YData')];
    end
    [x_b,y_b] = binned_plot(Xdata,Ydata);
    h_binplot=plot(x_b,y_b,'mo-','linewidth',2);
    %
    if do_legend 
        [dum1,dum2,legend_handle,legend_plot]=legend;
        legend_plot(length(legend_plot)+1) = {'binned-data'};
        legend_handle = vertcat(legend_handle,h_binplot);
        legend(legend_handle,legend_plot);
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLICK DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Left mouse button picks points.')
disp('Right mouse button picks last point.')
but = 1;
% [x,y]=ginput(1);   
[x,y]=ginput_OH(1,pointertype);
h_click = plot(x,y,'ro-','linewidth',2);
X=[x,y];
while but == 1
    %  [x,y,but]=ginput(1);
    [x,y,but]=ginput_OH(1,pointertype,x,y);
    X=[X;[x,y]];
    delete(h_click);
    h_click=plot(X(:,1),X(:,2),'ro-','linewidth',2);
end
if do_legend 
    [dum1,dum2,legend_handle,legend_plot]=legend;
    legend_plot(length(legend_plot)+1) = {'click-series'};
    legend_handle = vertcat(legend_handle,h_click);
    legend(legend_handle,legend_plot);
end
x=X(:,1);
y=X(:,2);
     
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DO FIT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmpi(method,'spline')
    if ~exist('splinefit','file')
        coefs = spline(x,y);
    else
        coefs = splinefit(x,y,M);
    end
    y_fit = ppval(coefs,x);
    h_fit = plot(x,y_fit,'g--','linewidth',2);
elseif strcmpi(method,'polyfit')
    if order==1 && intercept==0
        coefs = [x\y 0];
    else
        coefs=polyfit(x,y,order);
    end
    y_fit = polyval(coefs,x);
    h_fit = plot(x,y_fit,'g--','linewidth',2);
else
    coefs = [];    
end    
if do_legend && ~isempty(coefs)
    [dum1,dum2,legend_handle,legend_plot]=legend;
    legend_plot(length(legend_plot)+1) = {'click-fit'};
    legend_handle = vertcat(legend_handle,h_fit);
    legend(legend_handle,legend_plot)
end
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargout == 0
    if ~strcmpi(method,'none')    
        coefs
    end
    [x,y]
end




