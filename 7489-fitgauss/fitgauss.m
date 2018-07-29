function [A, mu, sigma] = fitgauss(yk, xk, guess_A, guess_mu, guess_sigma)
% [A, MU, SIGMA] = FITGAUSS(Y, X, GUESS_A, GUESS_MU, GUESS_SIGMA)
%
% Fits a Normal Distribution, N(x), to the data in Y and X.
%
% Y           - Y-Data (1xM)
% X           - X-Data (1xM)
% GUESS_A     - (Optional) Initial guess for Area
% GUESS_MU    - (Optional) Initial guess for Mean
% GUESS_SIGMA - (Optional) Initial guess for Standard deviation
%
% A           - Fitted Area
% MU          - Fitted Mean
% SIGMA       - Fitted Standard Deviation
% 
% If an optional parameter is not specified or is [], an initial guess
% will automatically be calculated for that parameter.
%
% N(x) = A * exp(-0.5*((x-mu)/sigma)^2) / sqrt(2*pi*sigma^2);
%
% See also EXP, ERF, ERFC, RANDN.

% Mar 2005 James R. Blake
% Updated Apr 2005 JRB
% Updated Jul 2005 JRB, sigma could be equal to zero fix
%                       bug if no maxima found fixed
% Updated Sep 2005 MJK, code cleanup (no change to algorithm)

MAX_ITERATIONS = 100;
CHI2_REL_TOL   = 1e-3;

% Check input arguments
error(nargchk(2,5,nargin));
if ~isnumeric(yk), error('Y must be numeric.'); end
if ~isnumeric(xk), error('X must be numeric.'); end
if length(xk) ~= length(yk), error('X and Y must have same length.'); end

% === clear any warnings ===
swarn = warning;
warning off

% Initialise variables
if exist('guess_mu', 'var') && ~isempty(guess_mu)
	if ~isnumeric(guess_mu) || length(guess_mu) ~= 1
		error('GUESS_MU must be a numeric scalar.');
	end
	mu = guess_mu;
else
	% Guess mean (MU)
	idx = findmaxima(yk);
	if isempty(idx)
		% No peak (probably a peak off the edge). Poor chance of convergence. The
		% best we can do is to start MU at highest the location of the maximum.
		[dummy, idx2] = max(yk);
		mu = xk(idx2);
	else
		% We have peak(s). Set to highest peak.
		[dummy, idx2] = max(yk(idx));
		mu = xk(idx(idx2));
	end
end

if exist('guess_sigma', 'var') && ~isempty(guess_sigma)
	if ~isnumeric(guess_sigma) || length(guess_sigma) ~= 1
		error('GUESS_SIGMA must be a numeric scalar.');
	end
	sigma = guess_sigma;
else
	% Guess SIGMA to be about halfway down from peak.
	mk = yk > (max(yk)/2 + max(yk)/length(yk));
	tophalf = yk(mk);                   % top half values
	st = find(yk==tophalf(1));          % only use first value at top half
	sigma = abs(mu-xk(st(1)));          % now SD=mu-1st value over FWHM
	% Guess for sigma might be zero !!
	if abs(sigma) < 1e-8
		% Stab in the dark, could be improved
		sigma = xk(end)/2;
	end
end

if exist('guess_A', 'var') && ~isempty(guess_A)
	if ~isnumeric(guess_A) || length(guess_A) ~= 1
		error('GUESS_A must be a numeric scalar.');
	end
	A = guess_A;	
else
	A = traprule(yk,mean(diff(xk)));
end


% Form A or rather Ai
Ai = [A mu sigma];
Ai = Ai(:);

% Initialised, now solve ....
counter = 0;
loop    = 1;
lambda  = 1000;
Fold = [0.01 0.01 0.01];
Fold = Fold(:);

while loop==1
	counter = counter+1;
	Ah    = Ai;       % Store old values
	A     = Ai(1);    % Area factor
	mu    = Ai(2);    % Mean
	sigma = Ai(3);    % Standard deviation
	fx = fgauss(xk,A,mu,sigma); % abbreviation ... xk = independent variable
	rk = yk-fx;

	% Calculate the Jacobian
	% First derivatives
	dfdA     = fx ./ A;
	dfdmu    = fx .* (xk-mu) ./ sigma^2;
	dfdsigma = fx .* ((xk-mu).^2 / sigma^3 - 1/sigma);
	% Second derivatives
	%% d2fdA2 = 0;
	%% d2fdAdsigma  = dfdsigma ./ A;
	%% d2fdAdmu     = dfdmu ./ A;
	%% d2fdsigma2   = fx .* ((xk-mu).^4/sigma^6-5*(xk-mu).^2/sigma^4+2/sigma^2);
	%% d2fdsigmadmu = dfdmu .* ((xk-mu).^2/sigma^3-3/sigma);
	%% d2fdmu2      = dfdmu .* (xk-mu)/sigma^2-fx./sigma^2;

	% Form Jacobian
	Jacob(1,1) = sum((1+lambda)*dfdA.^2);
	Jacob(1,2) = sum(dfdA.*dfdmu);
	Jacob(1,3) = sum(dfdA.*dfdsigma);
	Jacob(2,1) = Jacob(1,2);
	Jacob(2,2) = sum((1+lambda)*dfdmu.^2);
	Jacob(2,3) = sum(dfdmu.*dfdsigma);
	Jacob(3,1) = Jacob(1,3);
	Jacob(3,2) = Jacob(2,3);
	Jacob(3,3) = sum((1+lambda)*dfdsigma.^2);
	% Form F
	F(1) = sum(rk .* dfdA);
	F(2) = sum(rk .* dfdmu);
	F(3) = sum(rk .* dfdsigma);
	F = F(:);
	Ai = Ah + inv(Jacob)*F;

	rkold   = yk-fgauss(xk,Ah(1),Ah(2),Ah(3));  % for testing the end of the loop
	chi2old = sumsq(rkold);
	rk      = yk-fgauss(xk,Ai(1),Ai(2),Ai(3));
	chi2    = sumsq(rk);

	% Calculate relative change in Chi^2 from previous iteration.
	pc_change = (sumsq(F)-sumsq(Fold)) / sumsq(Fold);
	Fold = F;
	
	if chi2 > chi2old
		% Residuals have INCREASED. Make refinements coarser.
		lambda = lambda*10;
	else
		if (chi2-chi2old < 1) && (abs(pc_change) < CHI2_REL_TOL), loop=0; end
		% Residuals have decreased, make finer refinements.
		lambda = lambda/10;
	end

	if counter > MAX_ITERATIONS, loop=0; end
	if isnan(chi2)
		A = NaN; mu = NaN; sigma = NaN; warning(swarn); return
	end

end

% Restore original warning settings
warning(swarn);


function output = fgauss(x,A,mu,sigma)

% Abbreviation to evaluate Gaussian functions.
output = A * exp(-0.5*((x-mu)./sigma).^2) / sqrt(2*pi*sigma^2);


function a = sumsq(b,dim)
% A = SUMSQ(B,DIM)
%
% Returns the sum of the square of each element in the matrix
% If two arguments are specified, then it sums the squares in
% a particular dimension.

if nargin==1, a = sum(b.*b); return; end
if ndims(b) < dim, error('DIM exceeds number of dimensions of B.'); end
a = sum(b.*b,dim);


function idx = findmaxima(y)
% Finds indices of Y where Y is locally maximum.

if length(y) < 3, idx = []; return; end
grad = diff(y);
idx = find(grad(2:end) < 0 & grad(1:end-1) > 0) + 1;


function output = traprule(y,sep)
% Approximate the area under a curve using the trapezium rule
% OUTPUT = TRAPRULE(Y, SEP)
%
% Y   - Y values at each x sample
% SEP - X separation between samples
%
% OUTPUT - Area

if nargin==2
	output = sep*(sum(y(:)) - 0.5*(y(1)+y(end)));
else
	output =      sum(y(:)) - 0.5*(y(1)+y(end));
end
