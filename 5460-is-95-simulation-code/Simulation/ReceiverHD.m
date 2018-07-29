function [DataOut, Metric] = ReceiverHD(HDchips, G, Scrambler);
%
% ReceiverHD    Hard Decision Receiver. This function performs transmitted packet data recovering,
%                          based on Viterbi Decoder.
%
% 						Block Diagram:
%						HDchips -> [DeScrambler] -> [De-Interleaver] -> [Viterbi Decoder]
%
%
% 						Inputs: HDchips - Hard Decision RAKE receiver symbols
%                         G - Viterbi Encoder generation polynom
%                         Scrambler - Scrambler sequence
%
% 						Outputs: DataOut - Received data (binary form)
%                                       Metric - The  best metric of Viterbi Decoder
%

%====================== COMMON DEFINITIONS =================
%------- Viterbi Polynom ---------
if (nargin == 1)
   G = [1 1 1 1 0 1 0 1 1; 1 0 1 1 1 0 0 0 1];
end

%============================== R E C E I V E R ==========================

%----------- DeScrambler---------
% Rate = 19.2 KBps 
HDchips = xor(HDchips, Scrambler);

%-------- DeInterleaver ---------
INTERL = reshape(HDchips, 16, 24);		% IN-> rows, OUT-> columns
HDchips = reshape(INTERL', length(HDchips), 1);  % Rate = 19.2 KBps

%-------- HD Input Viterbi Decoder ----------
[DataOut Metric] = VitDec(G, HDchips, 1);


