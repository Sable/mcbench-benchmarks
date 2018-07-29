%% Define Feedforward Convolutional Code
SNR_dB = 3
LM = 1600         % Mesg Length excluding pre-determined bits for starting & ending trellis at state 0
TREL_TYPE = 'Feedback'  % {'Feedback', 'Feedforward'}

%% Matlab Generator Polynomial convention
% Build a binary number representation by placing a 1 in each spot where a connection line from the shift register feeds into the adder,
% and a 0 elsewhere. The leftmost spot in the binary number represents the current input, while the rightmost spot represents the 
% oldest input that still remains in the shift register.

if strcmp(TREL_TYPE, 'Feedback')    
%     CL = 2		% Rate 1/2 Feedback encoder with 2 states
%     GenPoly0_1by2 = 3 % in octal
%     GenPoly1_1by2 = 2
%     FeedBackCoef = [1,1];  % For computing i/p bits needed to terminate trellis at state =0.
%     TREL = poly2trellis(CL, [GenPoly0_1by2, GenPoly1_1by2], GenPoly0_1by2)

%% Rate 1/2 Feedback encoder with 8-states used in 3GPP cellular 3G/4G standard
    CL = 4  
    GenPoly0_1by2 = 13 % in octal
    GenPoly1_1by2 = 15
    FeedBackCoef = [1,0,1,1];% For computing i/p bits needed to terminate trellis at state =0.
    TREL = poly2trellis(CL, [GenPoly0_1by2, GenPoly1_1by2], GenPoly0_1by2)    
    
else
    %% Rate 1/3 Feedforward encoder with 4 states
%     CL = 3; % constraint length
%     GenPoly0_third = 4; % in octal
%     GenPoly1_third = 5;
%     GenPoly2_third = 7;
%     TREL = poly2trellis( CL, [GenPoly0_third, GenPoly1_third, GenPoly2_third])    

%     CL = 4 % constraint length
%     GenPoly0_1by4 = 13 % in octal
%     GenPoly1_1by4 = 15
%     GenPoly2_1by4 = 15
%     GenPoly3_1by4 = 17
%     TREL = poly2trellis( CL, [GenPoly0_1by4, GenPoly1_1by4, GenPoly2_1by4, GenPoly3_1by4])

end
LM = LM + 2*(CL-1); % space for start & tail bits

%% Verify trellis-structure is OK
[isok, status] = istrellis(TREL) 

randn('state', sum(100*clock)); % initialize to random state

%% The encoder is assumed to have both started and ended at the all-zeros state
%% Ensure msg is s.t. trellis starts at "0" state and ends at "0" state. 
%%  Generate Random binary stream & encode 
if strcmp(TREL_TYPE, 'Feedback')
    msg1(1 : CL-1) = zeros(1, CL-1); % 1st (CL-1) bits must be 0
    msg1(CL : LM -CL+1) = randint(LM -2*CL +2, 1, 2)' ; % Random data
% 	msg1(CL : LM -CL+1) = [0 1];

    % Encode first part of msg, recording final state for later use.
    [cenc_o1, final_state1] = convenc(msg1, TREL);

    % Rest of msg depends on final_state1; it makes trellis terminate at final_state=0. 
    bvec_fs = bitget(final_state1, (CL-1) : -1 : 1); % All possible binary-vectors of length EncoderN
    for idx = 1 : (CL-1)
        msg2(idx) = rem( [0, bvec_fs]*FeedBackCoef', 2);
        bvec_fs = [0, bvec_fs(1: (end-1))];
    end
%     msg2(1 : CL -1) = bvec_fs; % Last (CL-1) bits depend on state at time=(LM-CL+1)
    [cenc_o2, final_state] = convenc(msg2, TREL, final_state1);
    
    msg = [msg1, msg2]; clear msg1 msg2
    [cenc_o] = [cenc_o1, cenc_o2]; clear cenc_o1 cenc_o2
    final_state    
else % Feedforward
    msg(1 : CL-1) = zeros(1,CL-1); % 1st (CL-1) bits must be 0
    msg(CL : LM -CL+1) = randint(LM -2*CL +2, 1, 2)' ; % Random data    
    msg(LM -CL + 2 : LM) = zeros(CL-1, 1) % Last (CL-1) bits must be 0
    [cenc_o, final_state] = convenc(msg, TREL);
end

if final_state ~= 0
    disp('trellis not terminated properly: check last (CL-1) bits of mesg')
    return
end

%%	Map to BPSK constellation: bit0 -> 1, bit1 -> -1
signal_power = 1;
chan_in = (1 - 2*cenc_o)*sqrt(signal_power);

%%	Generate and add Gaussian-noise mean=0, variance= noise_power
noise_power = signal_power / 10^(SNR_dB/10);
noise = randn(size(chan_in))*sqrt(noise_power);
chan_o = chan_in + noise;
% chan_o = chan_in;

Es = log2(TREL.numOutputSymbols)*signal_power;
No = noise_power;
Lc = 4*Es/No

%%	Soft-Decision decoding, map to decision values
soft_in = chan_o;
% decodeds = vitdec_htm(TREL, soft_in');

[LLR, Alpha, Beta] = LogMAPdecode_htm(TREL, chan_o, Lc);

decd_msg = (1 - sign(LLR))/2;
err_vec = abs(decd_msg - msg);

sprintf('# of Bit-Errors = %d out of %d info-bits ', sum(abs(err_vec)), LM -CL -2)
