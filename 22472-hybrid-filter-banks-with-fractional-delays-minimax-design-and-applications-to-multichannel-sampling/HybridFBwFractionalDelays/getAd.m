function Ad = getAd(phi, h, d)

% getAd: get the A-matrix as in equation (15)
%
% Usage:    Ad = getAd(phi, h, d)
%
% INPUTS:
%       phi: a cell containing all the systems Phi_i(s)
%       h: the fast sampling interval
%       d: the vector of fractional delays
%
% OUTPUT:
%       Ad: matrix Ad as in equation (15)
%
% SEE ALSO: getBd, getCd

A0 = phi{1}{1};
Ad = expm( h*A0 );

for i = 1:length(d)
    Ai = phi{i+1}{1};
    Ci = phi{i+1}{3};
    
    Adi = [expm( h*Ai ),                 zeros( size(Ai,1), 1);
           Ci * expm( (h-d(i))*Ai ),     zeros( size(Ci,1), 1) ];
    
    Ad = blkdiag(Ad, Adi);
end