%% Simulate wavelet coefs

theta = homogeneus_to_full_GLG(8);

%% Write them to disk

tree = GLG_simulation( theta, 16 );

dwt2_to_graph( tree, 1, '~/Documents/articles/2013_GLG/R/wavelet.data' );
wavelet_graph( 3, '~/Documents/articles/2013_GLG/R/wavelet.graph' )

%% INLA

% INLA interfaces with R. Go to http://www.r-inla.org/ to see installation
% instructions.
%
% Once INLA is installed, run the following commands in R
% library("INLA")
% source("Rue.R")
%
% See results using e.g.
% summary(result)
% plot(result)
