function [mu, s, a, gf] = fit_logn(X, Y, varargin)
%fits lognormal distribution to histogram data
%FIT_LOGN fits lognormal distribution to histogram data (value and count),
%initial guess for mean and standard deviation can be given as optional
%arguments. Return values are mean, standard deviation, scaling factor (for
%non-unit distributions) and goodness of fit (should be close to 1)
%
%Example:
%	[MU, sigma, a, gf] = fitlogn(xdata, ydata [, mean guess [, std guess]])
%
%See also: logn2mean, mean2logn, lognfit, fit_norm, lognpdf, lognstat

p = inputParser;
p.addRequired('X',       @(X) isnumeric(X) & length(X) > 2 );
p.addRequired('Y',       @(X) isnumeric(X) & length(X) > 2 );
p.addOptional('M',   [], @(X) isnumeric(X) & numel(X) == 1 );
p.addOptional('SIG', [], @(X) isnumeric(X) & numel(X) == 1 & X > 0);
p.parse(X, Y, varargin{:});

warning('off', 'curvefit:fit:complexXusingOnlyReal');
warning('off', 'MATLAB:singularMatrix');

X = X(:);
Y = Y(:);
if any(X <= 0)
	Y(X <= 0) = [];
	X(X <= 0) = [];
end

Xn = log(X);
Yn = Y.*X;
Xs = (Xn(1:end-1)+diff(Xn)/2);
Ys = Yn(1:end-1);

if ~isempty(p.Results.M) && ~isempty(p.Results.SIG)
	[MU, S] = mean2logn(p.Results.M, p.Results.SIG);
elseif ~isempty(p.Results.M) && isempty(p.Results.SIG)
	[MU, S] = mean2logn(p.Results.M, 0.1*p.Results.M^2);
else
	MU     = sum( Ys.*Xs )/sum( Ys );
	S      = sqrt(abs(sum( Ys.*(Xs-MU).^2 )/sum( Ys )));
end

% Initial Fit
[mu, s, a] = fit_norm(Xn, Yn, MU, S);
gf         = gof( Y, lognpdf(X, mu, s)*a );

% Reset Starting Parameters
if gf < 0.9999
	nsteps = min([50 max([3 ceil(10^(1-gf))])]);
	s_vec  = linspace(max([0 (2-nsteps)*S]), nsteps*S, nsteps);
	s_vec(s_vec == 0) = eps;
	cfs    = cell(size(s_vec));
	gofs   = zeros(size(s_vec));
	for j = 1:length(s_vec)
		[cfs{j}(2), cfs{j}(3), cfs{j}(1)] = fit_norm(Xn, Yn, MU, s_vec(j));
		gofs(j) = gof( Y, lognpdf(X,cfs{j}(2),cfs{j}(3))*cfs{j}(1) );
	end
	[~, i]         = max(gofs);
	[mu, s, a, gf] = fit_norm(Xn, Yn, cfs{i}(2), cfs{i}(3));
end

warning('on', 'curvefit:fit:complexXusingOnlyReal');
warning('on', 'MATLAB:singularMatrix');
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

