function [xx, BestMetric] = SoftVitDec(G, y, ZeroTail);

%
% SoftVitDec			This function performs Viterbi Decoding for Soft Decision Inputs
%
% 						Inputs: G = [g1; g2; ...; gN] - matrix of generation polynomials
%                                    y - encoded sequence
%                                    ZeroTail - 1/0 - defines if contains zero tail
%
% 						Outputs: xx - recovered encoded bits
%                                       BestMetric - final best metric
%
%           Rule =  MAXIMAL METRIC WINS (Likelihood function)
%           

L = size(G, 1);     % --- num of output chips
K= size(G, 2);      % --- length of generation polinom
N = 2^(K-1);         % --- number of states
T = length(y)/L;                % --- maximum trellis depth

%------- Output Generation Matrix Definition (contains all possible state transactions)-------------
OutMtrx = zeros(N, 2*L);
for s = 1:N
    in0 = ones(L, 1)*[0, (dec2bin((s-1), (K-1))-'0')];
    in1 = ones(L, 1)*[1, (dec2bin((s-1), (K-1))-'0')];
    
    out0 = mod(sum((G.*in0)'), 2);
    out1 = mod(sum((G.*in1)'), 2);
    
    OutMtrx(s, :) = [out0, out1];
end
OutMtrx = sign(OutMtrx-1/2);

%---------------------------------------------------------------------------------------------
%------------------------------------ Trellis SECTION ----------------------------------
%---------------------------------------------------------------------------------------------
%------- Path Mertrix Initialization -------------
PathMet = [100; zeros((N-1), 1)];       % Initial State = 100 (better initial conditions)
PathMetTemp = PathMet(:,1);

Trellis = zeros(N, T);
Trellis(:,1) = [0 : (N-1)]';

%------------------------ MAIN Trellis Calculation Loop ---------------------------
y = reshape(y, L, length(y)/L);
for t = 1:T
    
    yy = y(:, t);
    for s = 0:N/2-1
        [B0 ind0] = max(  PathMet(1+[2*s, 2*s+1]) + [OutMtrx(1+2*s, 0+[1:L]) * yy; OutMtrx(1+(2*s+1), 0+[1:L])*yy] );
        [B1 ind1] = max(  PathMet(1+[2*s, 2*s+1]) + [OutMtrx(1+2*s, L+[1:L]) * yy; OutMtrx(1+(2*s+1), L+[1:L]) * yy] );
        
        PathMetTemp(1+[s, s+N/2]) =  [B0; B1];
        Trellis(1+[s, s+N/2], t+1) = [2*s+(ind0-1); 2*s + (ind1-1)];        
    end
   PathMet = PathMetTemp;
    
end

%---------------------------------------------------------------------------------------------
%---------------------------------- Trace Back Section -----------------------------
%---------------------------------------------------------------------------------------------
%------- Find Best Path Mertric -------------
xx = zeros(T, 1);
if (ZeroTail)
    BestInd = 1;
else
    [Mycop, BestInd]  = max(PathMet);
end

BestMetric = PathMet(BestInd);
xx(T) = floor((BestInd-1)/(N/2));

%------------------------ MAIN Trace Back Loop ---------------------------
NextState = Trellis(BestInd, (T+1));
for t=T:-1:2
    xx(t-1) = floor(NextState/(N/2));
    NextState = Trellis( (NextState+1), t);
end

if (ZeroTail)
    xx = xx(1:end-K+1);
end
