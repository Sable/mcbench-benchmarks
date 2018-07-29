% Copyright Colin O'Flynn, 2011. All rights reserved.
% http://www.newae.com
%
% This file demonstrates how we can use a brute-force MAP algorithm to
% decode some bits. See the associated presentation on http://www.newae.com
% for full information about how this works.
%
% Redistribution and use in source and binary forms, with or without modification, are
% permitted provided that the following conditions are met:
% 
%    1. Redistributions of source code must retain the above copyright notice, this list of
%       conditions and the following disclaimer.
% 
%    2. Redistributions in binary form must reproduce the above copyright notice, this list
%       of conditions and the following disclaimer in the documentation and/or other materials
%       provided with the distribution.
% 
% THIS SOFTWARE IS PROVIDED BY COLIN O'FLYNN ''AS IS'' AND ANY EXPRESS OR IMPLIED
% WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
% FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL COLIN O'FLYNN OR
% CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
% ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
% ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

% SNR of -4 seemed to result in OK number of bits in error (1-3 most runs).
SNR = -4;

% If this is too high brute-force decoding becomes impossible.
nbits = 9;

%Force PRNG to a specific state, only so this always generates the same
%results. Comment out these lines if you will be running this and want
%different results each time (e.g.: for stats collection, etc). On my
%machine the following values result in 2 errors before decoding, and 0
%errors after decoding. You may need to try different values on your
%system.
rand('state', 1);
randn('state', 1);

%Generate random data
data = round( rand( 1, nbits ) );

fprintf('Information Bits:\n');
data

feedback = [1 0 1 1];
feedforward = [1 1 0 0];

%Encode data
codeword = rsc_encode([feedback; feedforward], data, 1);

fprintf('Codeword after RSC:\n');
codeword

txcodeword = reshape(codeword, 1, length(codeword)*2);

%% Send over AWGN Channel
%Turn into +/- 1 for BPSK modulation example
tx = -2*(txcodeword-0.5);

EbNo = 10^(SNR/10.0);
variance = 1/(2*EbNo);

%Generate AWGN of correct length
noise = sqrt(variance)*randn(1, length(tx) );

%Add AWGN
rx = tx + noise;     

fprintf('*** Send Over AWGN Channel ***\n\n');

%Demodulate
rx_demodulated = -2*rx./variance;
fprintf('Demodulated Signal (systematic part only):\n')
reshaped_rx_demodulated = reshape(rx_demodulated, 2, length(rx_demodulated)/2);
reshaped_rx_demodulated(1,1:length(data))


%Demodulate
received = (sign(rx_demodulated) + 1)/2;

%We reshape codeword & figure out systematic part
rxcodeword = reshape(received, 2, length(codeword));
rxSystematic = rxcodeword(1,1:length(data));

fprintf('Location of errors after demodulating:\n');
errors = abs(rxSystematic - data)
%fprintf('Errors before correction: %d\n', sum(errors));

%% Do MAP Algorithm
%Probability of bit being in error:
pberror = qfunc(sqrt(2*EbNo));

fprintf('Result of decoding:\n');
[llrs, resultingCodeword] = brute_force_map(feedback, feedforward, received, pberror, nbits)

fprintf('Location of errors after decoding:\n');
abs(resultingCodeword(1,1:length(data)) - data)
%fprintf('Errors after correction: %d\n', sum(abs(resultingCodeword(1,1:length(data)) - data)));
 
 
%% Compare against ACTUAL MAP algorithm (Hard Input):
%adjfactor = 2;
%This was tuned to give results close to brute-force output
adjfactor = 1.5;
LLR_hardactual = SisoDecode(zeros(1, nbits), sign(rx_demodulated)*adjfactor, [feedback; feedforward], 0, 4);
fprintf('Result of Actual LOG-MAP Algorithm SISO Decoder with HARD inputs:\n')
LLR_hardactual

%% Compare against ACTUAL MAP algorithm (Soft Input):
LLR_softactual = SisoDecode(zeros(1, nbits), rx_demodulated, [feedback; feedforward], 0, 4);
fprintf('Result of Actual LOG-MAP Algorithm SISO Decoder with SOFT inputs:\n')
LLR_softactual

