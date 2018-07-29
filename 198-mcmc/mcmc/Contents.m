% MCMC -- Markov Chain Monte Carlo Tools
% Copyright (c) 1998, Harvard University. Full copyright in the file Copyright
%
% There are three parts to this library of routines.
% 1. *[rnd,pdf,lpr].m - distribution function tools to complement Matlab's
% 2. mcmc*.m - routines to calculate and display summaries of MCMC output
% 3. other - other useful routines
%  
%   1. Distribution Function Tools
%
%   These function help in random number generation and
%   various calculations involving density functions.
%   The names attempt to match those that MatLab uses,
%   namely, *pdf, *cdf, and *rnd.   Those that end in
%   "lpr" are for "Log. Probability Ratio", which are
%   useful for a Metropolis-Hastings algorithm.
% 
%   Note: there are two random number generators in Matlab 
%   one for normals and the other for everything else.
%   For reseting the normal random seed use  randn('state', ...)
%   and for all others use rand('state', ...).
%
% randrand - randomize both random number chains off the clock
% 
% mvnormrnd - random multivariate normal - different from Matlab's mvnrnd
%
% wishrnd - random Wishart value
% wishirnd - random Wishart value - integer df only
% invwishrnd - random inverse Wishart value
% invwishirnd - random inverse Wishart value - integer df only
% invwishpdf - inverse Wishart density
%
% metrop - a general Metropolis-Hastings step
%
% betalpr - log probability ratio for beta distribution
% gamlpr  - log probability ratio for gamma distribution
% invwishlpr - log probability ratio for inverse wishart distribution
% mvnormlpr - log probability ratio for multivariate normal distribution
%   
%   2. MCMC Summaries
%     
% These routines use the last dimension of an array as the
% sample index.  So an array with dimension (nr,nc,ns) 
% will be a collection of ns samples of an nr by nc matrix of 
% parameters.  An array with dimension (nr,nc) will
% be nc samples of an nr-vector of parameters.
% When the summary statistics are calculated, the last dimension
% is dropped.  
%
% Note: Matlab routines tend to collapse over the first dimension
% instead of the last.  I chose to use the last dimension for
% an aesthetic reason, when simply displaying a 3+ dimensional
% array, Matlab displays the first two dimensions as a matrix
% and splits over the 3rd+ dimensions.  To see what I mean
% enter 'x = zeros(2,3,4)'.
% 
% mcmclt - lower triangle - for symmetric matricies - to use with mcmctrace
% mcmcsumm - calculate summary statistics
%   (includes autocorrelations and Gelman-Rubin statistics)
% mcmctrace - matrix of trace plots 
% mcmcacf - to plot autocorrelations
% mcmcgr - Gelman-Rubin R statistic for convergence
% 
% mcmcdemo - short demonstration program
% 
%   3. Other
%
% ltvec - convert a lower-triangular matrix into a vector
% veclt - convert a vector into a lower-triangular matrix
% ltindex - convert row and column index into lt-index
%
%
% Bug reports and suggestions are welcome, but quick
% response is not guaranteed.
%
%   David Shera - shera@hsph.harvard.edu
%   http://www.biostat.harvard.edu/~shera/mcmc


