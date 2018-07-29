function C = competitiveHebb2(C,bmu,secbmu,y,Theta,alpha)
% This function applies type 2 Competitive Hebbian Learning,
% as described by relation (2.4) of reference [1].
% [1] Bruske J., Sommer G., "Dynamic Cell Structure Learns Perfectly Topology Preserving Map",
%                                                Neural Computation, vol. 7, Issue 4, July 1995, pp. 845-865.    
c =  max(y(bmu)*y(secbmu),C(bmu,secbmu));

% Reduce all connections by multiplying by alpha:
C = alpha*C;

% Find those connections with: 0<strength<Theta:
[rows cols] = find(C<Theta & C>0);
... and erase them!
NumZeroConnections = length(rows);
for i=1:NumZeroConnections
     C(rows(i),cols(i)) = 0;
end
 
C(bmu,secbmu) = c;
C(secbmu,bmu) =  C(bmu,secbmu);