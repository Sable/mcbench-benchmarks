%% fnc_getSobolSetMatlab: give a set of sobol quasi-random 
%
% Usage:
%   X = fnc_getSobolSetMatlab(dim, N)
%
% Inputs:
%    dim                number of variables, the MAX number of variables is 40
%    N                  number of samples
%
% Output:
%     X                matrix [N x dim] with the quasti-random samples
%
% ------------------------------------------------------------------------
%
%
% Author : Flavio Cannavo'
% e-mail: flavio(dot)cannavo(at)gmail(dot)com
% Release: 1.0
% Date   : 07-02-2011
%
% History:
% 1.0  07-02-2011  First release.
%
%
%

%%

function X = fnc_getSobolSetMatlab(dim, N)

p = sobolset(dim);
p = scramble(p,'MatousekAffineOwen');
X = net(p,N);
  