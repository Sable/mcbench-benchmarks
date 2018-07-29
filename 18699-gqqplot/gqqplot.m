function gqqplot (x,dist,varargin)
%GQQPLOT Display a generic Q-Q plot of sample vs. distribution
%	GQQPLOT(X,DIST) makes an plot of the quantiles of the data 
%	set X versus the inverse of the cdf of a distribution specified in 
%	DIST, evaluated at probabilities equal to the quantiles of X. The 
%	parameters of the distribution are calculated from X.
%
%	The purpose of the QQ plot is to determine whether the sample in X 
%	is drawn from a given distribution. If it is, the plot will be linear. 
%	In the case of the Binomial distribution, an additional parameter is 
%	needed: N, number of trials, e.g. GQQPLOT(X,'binom',N). 
%
%	The name of the distribution can be (case insensitive):
%
%	'norm'     or 'normal'
%	'gam'      or 'gamma'
%	'logn'     or 'Lognormal',
%	'exp'      or 'Exponential',
%	'wbl'      or 'Weibull'.
%	'beta'
%	'bin'      or 'Binomial'
%	'ev'       or 'Extreme Value',
%	'gev'      or 'Generalized Extreme Value',
%	'gp'       or 'Generalized Pareto',
%	'nbin'     or 'Negative Binomial',
%	'poiss'    or 'poisson'
%	'unif'     or 'uniform'
%	'rayl'     or 'rayleigh'
%
%	EXAMPLE:
%	x= gamrnd(2,0.5,1000,1);
%	gqqplot(x,'normal') %Bad fit
%	gqqplot(x,'gamma') %Good fit
%
%	Feb. 2008
%	Requires: Statistics Toolbox


%Check input parameters
error(nargchk(2,3,nargin))


x= sort(x);
np= 1000;
p= (0+1/(np-1):1/(np-1):1-1/(np-1))';
tit= 'QQ Plot of Sample Data versus ';


%-- Extra parameter for the Binomial
if ~isempty(varargin) N= varargin{1}; end


switch lower(dist)
	case {'norm','normal'}
		[mu,sigma]= normfit(x);
		y= icdf('normal',p,mu,sigma);
		tit= [tit,'Normal'];

	case {'gam','gamma'}
		pgam= gamfit(x);
		y= icdf('gamma',p,pgam(1),pgam(2));
		tit= [tit,'Gamma'];

	case {'logn','lognormal'}
		plogn= lognfit(x);
		y= icdf('logn',p,plogn(1),plogn(2));
		tit= [tit, 'Lognormal'];

	case {'exp','exponential'}
		mu= expfit(x);
		y= icdf('exp',p,mu);
		tit= [tit,'Exponential'];

	case {'wbl','weibull'}
		pwbl= wblfit(x);
		y= icdf('wbl',p,pwbl(1),pwbl(2));
		tit= [tit, 'Weibull'];

	case 'beta'
		betap= betafit(x);
		y= icdf('beta',p,betap(1),betap(2));
		tit= [tit, 'Beta'];

	case {'bino','binomial'}
		pbin= binofit(sum(x),N*length(x));
		y= binoinv(p,N,pbin)
		tit= [tit, 'Binomial'];

	case {'ev','extreme value'}
		pev= evfit(x);
		y= icdf('ev',p,pev(1),pev(2));
		tit= [tit, 'Extreme Value'];

	case {'gev','generalized extreme value'} 
		pgev= gevfit(x);
		y= icdf('gev',p,pgev(1),pgev(2),pgev(3));
		tit= [tit, 'Generalized Extreme Value'];

	case {'gp','generalized pareto'}
		warning ('Location parameter (p) must be 0')
		pgp= gpfit(x);
		y= icdf('gp',p,pgp(1),pgp(2));
		tit= [tit, 'Generalized Pareto'];

	case {'nbin','negative binomial'}
		pnbin= nbinfit(x);
		y= icdf('nbin',p,pnbin(1),pnbin(2));
		tit= [tit, 'Negative Binomial'];

	case {'poiss','poisson'}
		r= poissfit(x);
		y= icdf('poisson',p,r);
		tit= [tit, 'Poisson'];

	case {'unif','uniform'}
		y= unifinv(p,min(x),max(x));
		tit= [tit, 'Uniform'];

	case {'rayl','rayleigh'}
		mu= raylfit(x);
		y= icdf('rayleigh',p,mu);
		tit= [tit,'Rayleigh'];

	otherwise 
		error ('Unrecognized distribution name')
end

hold on
qd= quantile(x,p);
plot(y,qd,'+b');
plot([min(y) max(y)],[min(y) max(y)],'r-.');
xlabel('Theoretical Quantiles'); 
ylabel('Quantiles of Input Sample');
title(tit);
