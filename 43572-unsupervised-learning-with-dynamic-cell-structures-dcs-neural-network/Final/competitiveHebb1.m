function C = competitiveHebb1(C,bmu,secbmu,Theta,alpha)
% This function applies type 1 Competitive Hebbian Learning,
% as described by relation (2.2) of reference [1].
% [1] Bruske J., Sommer G., "Dynamic Cell Structure Learns Perfectly Topology Preserving Map",
%                                                Neural Computation, vol. 7, Issue 4, July 1995, pp. 845-865.    

% First Reduce the strength of all connections by multiplying by factor alpha:
C = alpha*C;

% Find those connections with: 0<strength<Theta:
[rows cols] = find(C<Theta & C>0);
... and erase them!
NumZeroConnections = length(rows);
for i=1:NumZeroConnections
      C(rows(i),cols(i)) = 0;
end

% Set the strength of connection between bmu and secbmu 
% equal to the max possible value: 1.
C(bmu,secbmu) = 1;
C(secbmu,bmu) = 1;
