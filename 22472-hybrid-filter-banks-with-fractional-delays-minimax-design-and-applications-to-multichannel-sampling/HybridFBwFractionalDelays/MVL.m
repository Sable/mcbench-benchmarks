function y = MVL(Ai, Bi, Aj, Bj, t)

% MVL: compute the integral Mij(t) of equation (51)
%
% Usage:    y = MVL(Ai, Bi, Aj, Bj, t)
% 
% INPUTS:
%       Ai, Aj, Bi, Bj: matrices of the operators Phi_i(s) and Phi_j(s)
%       t: upper limit of the integral
%
% OUTPUT: 
%       y = MVL(t) = int_0^t expm(tau*Ai)*Bi*Bj'*expm(tau*Aj')dtau
%
% SEE ALSO: reference [19]

F = expm([-Ai                                   Bi*Bj'; 
          zeros( size(Aj',1), size(Ai,2) )      Aj'] * t );

y = expm(Ai*t) * F( 1:size(Ai,1), (1+size(Ai,2)):end );