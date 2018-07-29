function [SD] = Demodulator(RxIn, PN, MF, Walsh);
%
% DEMODULATOR			This function performs demodulation of the forward
%                                       Channel packet, based on RAKE Receiver
% 						Block Diagram
%						Input Signal -> [Matched Filter] -> [Sampler] -> [RAKE Receiver] -> [Walsh] -> [DeSpreading]
%
% 						Inputs: RxIn - input signal (I/Q) analoge
%                                    PN - PN sequence (used for De-spreading)
%                                    MF - matched filter taps
%                                    Walsh - Used row of Walsh matrix for  recovering
%
% 						Outputs: SD - Soft Decisions of RAKE receiver
%

global R 
N = length(RxIn)/R;

%--------------- Matched Rx Filter (Analog) --------------------
L = length(MF);
L_2 = floor(L/2);
rr = conv(flipud(conj(MF)), RxIn);
rr = rr(L_2+1: end - L_2);

%----------- Rx Symbols Sampling ------------
% R = 1.2288 Mcps
Rx = sign(real(rr(1:R:end))) + j*sign(imag(rr(1:R:end)));  

%----------- RAKE Receiver ------------
Rx = reshape(Rx, 64, N/64); 				% -------- column oriented

%-------- Walsh recovering ---------
Walsh = ones(N/64, 1)*sign(Walsh'-1/2);	%--- row oriented Walsh 
PN = reshape(PN, 64, N/64)'; 					%--- conjugated row oriented PN sequence
PN = PN.*Walsh;									%--- Walsh Orthogonalization 

%---------- Despreading (Correlate and Sum)
% Input Rate = 1.2288 Mpbs, Output Rate = 19.2 KBps
SD= PN*Rx;  	
SD= real(diag(SD));  % Find Soft Decisions (on main diagonal)

