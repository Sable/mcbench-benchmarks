%% PURPOSE:
%       Implement the Log-MAP algorithm for binary-convolutional-codes invented by Bahl etal. Computes the A-Posteriori-Probability 
% of each i/p bit being 1 or 0 given the received sequence. The channel must be Discrete-Memoryless.  
% 
%% INPUTS:
%   TREL		= matlab trellis structure from poly2trellis()
%   RX			 = real-valued received signal. Assumes bit0 -->+K, bit1 --> -K where K is proportional to signal-power. RX can be
%                    linearly-quantized.
%   Lc           =  4*energy(symbol)/one-sided-noise-PSD = (4*Es/No).
%				      Example: Lc=1 iff (Es/No = 1/4) => SNR = -6.02 dB.
%				      Lc=8 iff (Es/No = 2) => SNR= 3.01 dB
%% USAGE:
%% HISTORY:
% 11-Jul-09: initial version
% 20-Jul-09: verified on both "feedforward" and "feedback" codes. verified BER=0 on noiseless case for all codes.
%% Author: Hari ThiruMoorthy
%  Copyright 2009. All Rights Reserved
function [LLR, Alpha, Beta] = LogMAPdecode_htm(TREL, RX, Lc)

if 0
    return;
end

EncoderN = log2(TREL.numOutputSymbols); % cardinality of set of all possible o/p bitvecs
EncoderK = log2(TREL.numInputSymbols); % cardinality of set of all possible i/p bitvecs
RX = reshape(RX, 1, numel(RX)); % Make RX a row
NumBran = length(RX)/EncoderN; % number of branches sent by TX to RX
if rem(length(RX), EncoderN) ~= 0,
    disp('ERROR: Make length(RX) = multiple of EncoderN')
end

%%	Pre-compute {contributing prior-states, corresponding i/p bitvec, branch
%%	o/p bitvec} for each current-state. Reqd for forward-recursion. This is
%%	independent of RX.
prevStates = NaN(TREL.numStates, TREL.numInputSymbols);
prevStateIn = NaN(TREL.numStates, TREL.numInputSymbols);
prevStateOut = NaN(TREL.numStates, TREL.numInputSymbols);
for dest_st = 0 : (TREL.numStates -1)
    % Find all origin-states from-which there could be a transition into dest_st
    % and store in row-(dest_st +1)
    [row, col] = find(TREL.nextStates == dest_st);
    prevStates(dest_st +1, :) = row' -1; % origin-state of transition
    prevStateIn(dest_st +1, :) = col' -1; % Corresponding i/p bit-vec causing transition
    prevStateOut(dest_st +1, :) = TREL.outputs( sub2ind(size(TREL.nextStates), row, col) )'; % Corresponding o/p branch bit-vec (in octal)
end

%%	Compute branch-metrics gamma*(m', m) fev branch fev time using segments of RX. There
%%	are numOutputSymbols distinct branches. col-i contains all possible
%%	branch-metrics at time i, i= 1,...,NumBran.
BranMetric = NaN(TREL.numOutputSymbols, NumBran);
for time = 1 : NumBran,
   rxvec = RX((time-1)*EncoderN +1 : time*EncoderN); % [1, N], [N+1, 2*N] , ...
    for BranIdx = 1 : TREL.numOutputSymbols
        bitvec = bitget(BranIdx-1, EncoderN : -1 : 1); % All possible binary-vectors of length EncoderN
        symbvec = 1 -2*bitvec; % bit0 ==> 1, bit1 ==> +1
        BranMetric(BranIdx, time) = ComputeCorr(symbvec, rxvec, Lc); %metric at "time" for branch = binary-representation(BranIdx-1)
    end
end

%% Alpha*(t, m) = sum_{m'=0,...,NS-1} [ Alpha*(t-1, m') * gamma*(m', m)]
%% Initialize Alpha*(time=0) as below, since TX ensures encoder starts trellis at state=0 at time t=0.
Alpha = NaN(NumBran +1, TREL.numStates);
Alpha(1, 1) = 0; Alpha(1, 2:end) = -1e9;
for time = 1 : NumBran,
%     rx_seg = RX((time-1)*EncoderN +1 : time*EncoderN);
    for dest_st = 0 : (TREL.numStates -1)
        sum1 = -1e9;
        for idx = 1 : length( prevStates(dest_st+1, :) )
            orig_s = prevStates(dest_st+1, idx);            
            enc_out_bitv = prevStateOut(dest_st+1, idx);
            sum1 = ln_of_sum_of_exps( sum1, Alpha(time -1 +1, orig_s +1) + BranMetric(oct2dec(enc_out_bitv) +1, time)  );
        end
        Alpha(time+1, dest_st+1) = sum1;
    end
end

%% Beta*(t-1, m) = sum_{m'=0,...,NS-1} [ Beta*(t, m') * gamma*(m', m)]
%% Initialize Beta*(time= NumBran) as below, since TX ensures encoder terminates trellis at state=0 at time t=NumBran
Beta = NaN(NumBran +1, TREL.numStates);
Beta(NumBran +1, 1) = 0; Beta(NumBran +1, 2:end) = -1e9;
for time = (NumBran -1) : -1 : 0
%     rx_seg = RX(time*EncoderN +1 : (time+1)*EncoderN);
    for orig_st = 0 : (TREL.numStates -1)
        sum2 = -1e9;
        for idx = 1 : length( TREL.nextStates(orig_st+1, :) )
            dest_st = TREL.nextStates(orig_st+1, idx);
            enc_out_bitv = TREL.outputs(orig_st+1, idx);
            sum2 = ln_of_sum_of_exps( sum2, Beta(time +2, dest_st +1) + BranMetric(oct2dec(enc_out_bitv) +1, time+1) );
        end
        Beta(time+1, orig_st+1) = sum2;
    end
end

%% Final LLR computation for each time
%% L(U(k)|Y) = ln( . / .)
LLR = zeros(1,NumBran);
for time = NumBran : -1 : 1
%% prob of all transitions arising from i/p bit = 0. Works only for EncoderK = 1. 
    total_prob_bit0 = -1e9;
    for orig_st = 0 : (TREL.numStates -1)
        dest_st = TREL.nextStates(orig_st+1, 1);
        branch = oct2dec(TREL.outputs(orig_st+1, 1));
        incr_prob = Alpha(time, orig_st+1) + Beta(time+1, dest_st+1) + BranMetric(branch+1, time);
        total_prob_bit0 = ln_of_sum_of_exps( total_prob_bit0, incr_prob);
    end

%% prob of all transitions arising from i/p bit = 1. Works only for EncoderK = 1. 
    total_prob_bit1 = -1e9;
    for orig_st = 0 : (TREL.numStates -1)
        dest_st = TREL.nextStates(orig_st+1, 2);
        branch = oct2dec(TREL.outputs(orig_st+1, 2));
        incr_prob = Alpha(time, orig_st+1) + Beta(time+1, dest_st+1) + BranMetric(branch+1, time);
        total_prob_bit1 = ln_of_sum_of_exps( total_prob_bit1,  incr_prob);
    end

    LLR(time) = total_prob_bit0 - total_prob_bit1;
end

return;
%%=========================================================================

%%	Function ComputeCorr(): correlation 
function Corr_Met = ComputeCorr(X, Y, Scaled_EsoverNo)
    Corr_Met = Scaled_EsoverNo/2*(X*Y');
return;    

%%	Function ln( e^x + e^y) = max(x, y) + ln(1 + e^-|x-y|)
function a = ln_of_sum_of_exps(x, y)
	a = max(x, y) + log( 1 + exp(-abs(x - y)) );
return;

%%	Valid time indices are 0,1,...,NumBran
%%	gamma*(t, m', m) = sum_over_{all i/p bitvecs U causing transitions from state m' @ time (t-1) to state m @ time t} ...
%%  [ Pt(m | m') R(Y(t) | X(t)=U ) ]
% gamma = zeros(NumBran, TREL.numStates, TREL.numStates);
% for time = 1 : NumBran,
%     rx_seg = RX((time-1)*EncoderN +1 : time*EncoderN);
%     for orig_st = 0 : (TREL.numStates -1)
%         for idx = 1 : length( TREL.nextStates(orig_st+1, :) )
%             dest_st = TREL.nextStates(orig_st+1, idx);
%             branch = oct2dec(TREL.outputs(orig_st+1, idx));
%         end
%     end
% end
