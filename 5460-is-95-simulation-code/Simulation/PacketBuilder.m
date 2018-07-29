function [ChipsOut, Scrambler] = PacketBuilder(DataBits, G, Gs);
%
% PACKET BUILDER 	This function build the IS-95 forward Channel Data Packets.
% 						Block Diagram:
%						InData -> [Viterbi Encoder] -> [Interleaver] -> [Scrambler]
%
% 						9.6 KBps for 20 msec packet --> 192 bits (including 8 zeros tail) 184 data bits netto
% 						9.6*2 = 19.2 KBps (384 bits) after Viterbi incoding
% 						19.2 KBps * 64 = 1.2288 Mbps after Walsh and Spreading
%
% 						Inputs: DataBits - data to transmit (binary form)
%                         G - Viterbi Encoder generation polynom
%                         Gs - Long sequence generation polynom (scrambler)
%
% 						Outputs: ChipsOut - The result chip sequnece entered to modulator (binary form)
%                          Scrambler - Scrambler sequence%

global Zs 

K = size(G, 2); 		% memory of Viterbi Polynoms
L = size(G, 1);      % number of chips per each data bit

N = 64*L*(length(DataBits)+K-1);		% Number of chips (9.6 Kbps -> 1.288 Mbps)

%====================== PACKET BUILDER =================
%-------- Create a Data Block (184 data bits) concatenated by 8 zeros
chips = VitEnc(G, [DataBits; zeros(K-1,1)]);	% Viterbi Encoder


%-------- Interleaver ---------
INTERL = reshape(chips, 24, 16);			% IN-> columns, OUT-> rows
chips = reshape(INTERL', length(chips), 1);  % Rate = 19.2 KBps

%----------- Scrambler---------
% Rate = 19.2 KBps
[LongSeq Zs] = PNGen(Gs, Zs, N);  % Long sequence Generation (at rate 1.2288 Mbps)
Scrambler = LongSeq(1:64:end); 	 % Decimation of Long Sequence 

ChipsOut = xor(chips, Scrambler); 		