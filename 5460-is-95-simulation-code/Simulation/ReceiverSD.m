function [DataOut, Metric] = ReceiverSD(SDchips, G, Scrambler);
%
% ReceiverSD    Soft Decision Receiver. This function performs transmitted packet data recovering,
%                          based on Viterbi Decoder.
%
% 						Block Diagram:
%						SDchips -> [DeScrambler] -> [De-Interleaver] -> [Viterbi Decoder]
%
%
% 						Inputs: SDchips - Soft Decision RAKE receiver symbols
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

%====================== R E C E I V E R =================

%----------- DeScrambler---------
% Rate = 19.2 KBps 
SDchips = SDchips.*sign(1/2-Scrambler);

%-------- DeInterleaver ---------
INTERL = reshape(SDchips, 16, 24);		% IN-> rows, OUT-> columns
SDchips = reshape(INTERL', length(SDchips), 1);  % Rate = 19.2 KBps

%-------- SD Input Viterbi Decoder ----------
[DataOut Metric] = SoftVitDec(G, SDchips, 1);


