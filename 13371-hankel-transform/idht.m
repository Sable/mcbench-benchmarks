%h=idht(H,I,K,R)
%---------------
%
%Inverse quasi-discrete Hankel transform of integer order n.
%
%Input:
% H      Spectrum H(k)
% I      Integration kernel °
% K      Spectrum factors °
% R      Signal factors °
%
%Output:
% h      Signal h(r)
%
%
% °)  As computed with DHT.
%

% [1] M. Guizar-Sicairos, J.C. Gutierrez-Vega, Computation of
%     quasi-discrete Hankel transforms of integer order for
%     propagating optical wave fields, J. Opt. Soc. Am. A 21,
%     53-58 (2004).
%

%     Marcel Leutenegger © June 2006
%     Manuel Guizar-Sicairos © 2004
%
function h=idht(H,I,K,R)
h=I*(H./K).*R;
