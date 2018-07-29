function [ A ] = solve_lsq( h,hn,x0 )
% The problem (sum_{k=1}^{N} (H(y_k) - h(y_k))^2 == min) has to be solved,
% where y_k are the N measured points, h is the measured data and
% H = 2*sum_n (A_n*hn(y)) is the sum over the number of expansion elements
% of the expression A*hn with the already computed integrals hn and the
% corresponding amplitudes A. [1]
%
%   [1] G. Pretzler, Z. Naturforsch. 46a, 639 (1991)
%
%                                         written by C. Killer, Sept. 2013


% function to be optimized
myfun=@(x,hn) 2*hn*x;          

% let MATLAB do the least-square-calculation, resulting in the amplitudes A
A=lsqcurvefit(myfun,x0,hn,h);   

