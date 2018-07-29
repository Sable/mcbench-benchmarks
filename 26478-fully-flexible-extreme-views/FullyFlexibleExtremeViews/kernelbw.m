function [bw] = kernelbw(xi)
%% Silverman bandwidth 

N      = length(xi);
prop   = 1.0;
sig    = std(xi);
iqrSig = 0.7413 * iqr(xi);

if (max(iqrSig) == 0)
   iqrSig = sig;
end

bw = prop * min(sig, iqrSig) * N^(-1 / (4 + 1));

end