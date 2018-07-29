function Cd = getCd(phi, h, d)

% getCd: get the C-matrix as in equation (15)
%
% Usage:    Cd = getCd(phi, h, d)
%
% INPUTS:
%       phi: a cell containing all the systems Phi_i(s)
%       h: the fast sampling interval
%       d: the vector of fractional delays
%
% OUTPUT:
%       Cd: matrix Cd as in equation (15)
%
% SEE ALSO: getAd, getBd

C0 = phi{1}{3};
Cd = C0;

for i = 1:length(d)
    Ci = phi{i+1}{3};    
    Cd = blkdiag(Cd, [zeros( 1, size(Ci, 2) ), 1]);
end
