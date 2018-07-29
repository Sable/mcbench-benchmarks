% MCMCDEMO - small demonstration program for the use of MCMC library
% Copyright (c) 1998, Harvard University. Full copyright in the file Copyright
%
% There is no MCMC chain set up here, just a random sample
% of matricies from an inverse wishart distribution.
%
% The use of the summary and trace functions are demonstrated.
%
% The program is commented.
% 

echo 

% Creating an array to hold all the values so that things run a little
% faster.

% SIW = Sample of Inverse Wisharts

SIW = NaN* zeros(5,5,200) ;

% nu = degrees of freedom = precision parameter
nu = 50

% IWmode = mode of distribution of SIW
IWmode = 3*eye(5) + 2 * ones(5,5) 

% The inverse Wishart scale parameter = nu * the mode.
% (in our parameterization)
IWparm = nu * IWmode

% This is not really an MCMC run, simply a random sample.
echo off all

for ii = 1 : 200 ;
  IW = invwishrnd ( IWparm, nu ) ;
  SIW(:,:,ii) = IW ;
end ;

echo on 

% display the dimensions of SIW
size(SIW)

% create structure of summary statistics
SIWsumm = mcmcsumm(SIW) ;

SIWsumm.mean
SIWsumm.median
SIWsumm.std
SIWsumm.min
SIWsumm.max

% SIWsumm.sorted - not printed, but available for later use.
% SIWsumm.acf - autocorrelation, not printed but available.

% create lower triangular version, upper triangle is redundant
SIWlt = mcmclt(SIW) ;

% plot trace of upper triangular version
mcmctrace(SIWlt) ;

% for a plot of the autocorrelation, use mcmctrace(SIWsumm.acf) 
