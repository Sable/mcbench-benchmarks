% MCMCGR - Gelman-Rubin R statistic for convergence
% Copyright (c) 1998, Harvard University. Full copyright in the file Copyright
%
% function [ R ] = mcmcgr(A,ng) ;
%
% calculates the Gelman-Rubin R statistic for each chain
%
% A = chain of values from an MCMC run
% ng = number of groups to use
% 
% See also: MCMCSUMM


function [ R ] = mcmcgr(A,ng) ;

[nr, nc, chainlen] = size(A) ;

gsize = chainlen/ng ;

X = NaN*zeros(nr,nc,ng,gsize);

gstart = 1 ;
for ig = 1:ng ;
  gend = gstart+gsize-1 ;
  X(:,:,ig,:) = A(:,:,gstart:gend) ;
  gstart = gend+1 ;
end

M = mean(X,4) ;

tB = std(M,0,3) ;

B = gsize * tB .* tB ;

S = std(X,0,4) ;

S2 = S .* S ;

W = sum(S2,3) / ng ;
vplus = (gsize-1)/gsize*W + B/gsize ;

R = vplus./W ;


