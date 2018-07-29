% RANDRAND - Reset both Random Number Generator Seeds to the clock
% Copyright (c) 1998, Harvard University. Full copyright in the file Copyright
% 
% Note: there are two random number generators in Matlab 
% one for normals and one for everything else.
% For reseting the normal random seed use  randn('state', ...)
% and for all others use rand('state, ...).
%
% This program initializes both off the system clock.
%
randn('state',sum(100*clock)) ;
rand('state',sum(100*clock)+10*normrnd(0,1,1,1)^2) ;
