function [mu, sigma, a, gf] = fit_norm(X, Y, varargin)
%fits normal distribution to histogram data
%FIT_NORM fits normal distribution to histogram data (value and count),
%initial guess for mean and standard deviation can be given as optional
%arguments. Return values are mean, standard deviation, scaling factor (for
%non-unit distributions) and goodness of fit (should be close to 1)
%
%Example:
%	[mu, sigma, a, gf] = fitnorm(xdata, ydata [, mean guess [, std guess]])
%
%Depends on: gof
%
%See also: normfit, fit_logn, normpdf

p = inputParser;
p.addRequired('X',      @(X) isnumeric(X) & length(X) > 2 );
p.addRequired('Y',      @(X) isnumeric(X) & length(X) > 2 );
p.addOptional('MU', [], @(X) isnumeric(X) & numel(X) == 1 );
p.addOptional('S',  [],	@(X) isnumeric(X) & numel(X) == 1 & X > 0);
p.parse(X, Y, varargin{:});

X  = X(:);
Y  = Y(:);
Xs = (X(1:end-1)+diff(X)/2);
Ys = Y(1:end-1);

if isempty(p.Results.MU)
	MU = sum( Ys.*Xs )/sum( Ys );
else
	MU = p.Results.MU;
end

if isempty(p.Results.S)
	S = sqrt(abs(sum( Ys.*(Xs-MU).^2 )/sum( Ys )));
else
	S = p.Results.S;
end

a     = sum(Ys.*diff(X));
scale = round(log10(abs(MU)));
ft    = fittype('gauss1');
opts  = fitoptions(ft);

opts.Lower = [0, -Inf, 0];
opts.Upper = [Inf, Inf, Inf];

% Try different orders of magnitude around 10
x_vec = logspace(-scale, -scale+2, 3);
% Set Starting Parameters
cf    = cell(size(x_vec));
gofs  = zeros(size(x_vec));
for j = 1:length(x_vec)
	opts.StartPoint = [a/(S*sqrt(2*pi)), MU*x_vec(j), sqrt(2)*S*x_vec(j)];
	fr              = fit(X*x_vec(j), Y, ft, opts);
	cf{j}           = coeffvalues(fr);
	gofs(j)         = gof( Y, normpdf(X, cf{j}(2)/x_vec(j), cf{j}(3)/sqrt(2)/x_vec(j)) ...
	                  *cf{j}(1)*cf{j}(3)*sqrt(pi)/x_vec(j) );
end
[~, i] = max(gofs);

% Final Fit
opts.StartPoint = [cf{i}(1), cf{i}(2)/x_vec(i), cf{i}(3)/x_vec(i)];
[fitresult]     = fit(X, Y, ft, opts);
cfs             = coeffvalues(fitresult);

a               = cfs(1)*cfs(3)*sqrt(pi);
mu              = cfs(2);
sigma           = cfs(3)/sqrt(2);
gf              = gof( Y, normpdf(X, mu, sigma)*a);

end

function G = gof(data, fitdata, varargin)
%calculates goodness-of-fit value R^2
%GOF calculates goodness-of-fit value R^2 from two data sets with an
%optional weight input
%
%Example:
%    gof(original values, fitted values [, weight])
%
% See also: fit
%

	idx		=	~isnan(data) & ~isnan(fitdata);
	data	=	data(idx);
	fitdata	=	fitdata(idx);
	if nargin > 2 && isnumeric(varargin{1})
		weights		=	varargin{1}(idx);
	else
		weights		=	ones(size(data));
	end

	G = 1 - sum(weights.*(data-fitdata).^2)/sum(weights.*(data - mean(data)).^2);

end

% Copyright 2009-2013 Alexandra Heidsieck <aheidsieck@tum.de>,
%                     IMETUM, Technische Universitaet Muenchen
