%%Fitit
% Copyright (c) 2011, The MathWorks, Inc.

function [myfit,varargout] = fitit(X,Y,varargin)

% Input and Output checking
error(nargchk(1, 3, nargin))
error(nargchk(1, 3, nargout))

validateattributes(X, {'numeric'}, {'nonempty','vector'})
validateattributes(Y, {'numeric'}, {'nonempty','vector'})

% Finding optimal span for lowess
num = 99;
spans = linspace(.01,.99,num);
sse = zeros(size(spans));
cp = cvpartition(100,'k',10);

for j=1:length(spans),
    f = @(train,test) norm(test(:,2) - mylowess(train,test(:,1),spans(j)))^2;
    sse(j) = sum(crossval(f,[X,Y],'partition',cp));
end

[~,minj] = min(sse);
span = spans(minj);

if nargin-2 == 0
    yfit = mylowess([X,Y],X,span);
    
    figure;
    h1 = gca;
    scatter(h1,X,Y, 'k');
    hold on
    line(X,yfit,'color','b','linestyle','-', 'linewidth',2)
    hold off
    legend(h1,'Data','LOWESS',2)
    xlabel(h1,inputname(1));
    ylabel(h1,inputname(2));
    
else
    nboot = varargin{1};
    
    % Calculating confidence intervals
    
    f = @(xy) mylowess(xy,X,span);
    yboot2 = bootstrp(nboot,f,[X,Y])';
    yfit = mean(yboot2,2);
    stdloess = std(yboot2,0,2);
    
    figure;
    h1 = gca;
    scatter(h1,X, Y,'k')
    hold on
    line(X, yfit,'color','k','linestyle','-','linewidth',2);
    line(X, yfit+2*stdloess,'color','r','linestyle','--','linewidth',2);
    line(X, yfit-2*stdloess,'color','r','linestyle','--','linewidth',2);
    hold off
    legend(h1,'Data', 'Localized Regression','Confidence Intervals',2);
    xlabel(h1,inputname(1));
    ylabel(h1,inputname(2));
end

% Fit cubic spline to resulting data;
myfit = fit(X, yfit, 'cubicinterp');

if nargout == 3
    varargout{1} = fit(X, yfit+2*stdloess, 'pchipinterp');
    varargout{2} = fit(X, yfit-2*stdloess, 'pchipinterp');
end


function ys=mylowess(xy,xs,span)
%MYLOWESS Lowess smoothing, preserving x values
%   YS=MYLOWESS(XY,XS) returns the smoothed version of the x/y data in the
%   two-column matrix XY, but evaluates the smooth at XS and returns the
%   smoothed values in YS.  Any values outside the range of XY are taken to
%   be equal to the closest values.

if nargin<3 || isempty(span)
    span = .3;
end

% Sort and get smoothed version of xy data
xy = sortrows(xy);
x1 = xy(:,1);
y1 = xy(:,2);
ys1 = smooth(x1,y1,span,'loess');

% Remove repeats so we can interpolate
t = diff(x1)==0;
x1(t)=[]; ys1(t) = [];

% Interpolate to evaluate this at the xs values
ys = interp1(x1,ys1,xs,'linear',NaN);

% Some of the original points may have x values outside the range of the
% resampled data.  Those are now NaN because we could not interpolate them.
% Replace NaN by the closest smoothed value.  This amounts to extending the
% smooth curve using a horizontal line.
if any(isnan(ys))
    ys(xs<x1(1)) = ys1(1);
    ys(xs>x1(end)) = ys1(end);
end


