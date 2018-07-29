function h = g2h(g, epsilon)

% G = h2g(H,EPSILON)
%
% Hybrid-G to Hybrid-H transformation
% G and H are matrices of size [2,2,F]
% where F is the number of frequencies
% (the number of ports is always 2)
% 
% EPSILON is a limit used in finding correspondent Hybrid-H matrices 
% in the vicinity of singularities; 
% by default set to 1e-12, should provide accurate results
% realistic problems; could be increased for a gain in speed
%
% written by tudor dima, tudima@zahoo.com, change the z into y

% 30.09.2011    - clear bug in D calculation
%               - now this is just a wrapper function for h2g
%                 (actually a protected inverse)

if nargin < 2, epsilon = 1e-12; end;

h = h2g(g, epsilon, 'hybrid-H');