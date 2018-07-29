function [TxOut, PN, MF] = Modulator(chips, MFType, Walsh);
%
% MODULATOR			This function modulate the forward Channel chips.
% 						Block Diagram
%						InChips -> [Walsh] -> [Spreading] -> [Output Tx Shaping Filter]
%
% 						Inputs: chips - chips sequence to transmit
%                                    MFType - Shaping Filter type (default - Rise Cosine)
%                                    Walsh - Used row of Walsh matrix
%
% 						Outputs: TxOut - Transmitted signal (analog signal)
%                                       PN - PN sequence for I/Q Channels
%									    MF - mathed filter taps (Shaping Filter)

global Zi Zq show R Gi Gq

N = length(chips)*length(Walsh);  	% Number of output chips

%-------- Walsh covering ---------
% Input Rate = 19.2 KBps, Output Rate = 1.2288 Mcps
tmp = sign(Walsh-1/2)*sign(chips'-1/2);
chips = reshape(tmp, prod(size(tmp)), 1);

%-------- PN Spreading sequences generation---------
% Rate = 1.2288 Mcps
[PNi Zi] = PNGen(Gi, Zi, N);  % I-channel PN generation
[PNq Zq] = PNGen(Gq, Zq, N);  % Q-channel PN generation

PN = sign(PNi-1/2) + j*sign(PNq-1/2);

%--------------- Signal Spreading --------------------
% Rate = 1.2288 Mcps
chips_out = chips.*PN;     % (I-Q signal)

chips = [chips_out, zeros(N, R-1)];	% Pulse generation
chips = reshape(chips.' , N*R, 1);


%--------------- Shaping Filter --------------------
switch (MFType)
case 1
   %----------------- Raised Cosine filter ------------   
   L = 25;
   L_2 = floor(L/2);
   n = [-L_2:L_2];
   B = 0.7;
   MF = sinc(n/R).*(cos(pi*B*n/R)./(1-(2*B*n/R).^2));
   MF = MF/sqrt(sum(MF.^2));
   
case 2
   %----------------- Rectangular Filter ------------   
   L = R;
   L_2 = floor(L/2);
   MF = ones(L, 1);
   MF = MF/sqrt(sum(MF.^2));
   
case 3
   %----------------- Triangular Filter ------------   
   L = R;
   L_2 = floor(L/2);
   MF = hamming(L);
   MF = MF/sqrt(sum(MF.^2));
   
end

MF = MF(:);

%---------------- Transmit -----------------
TxOut = sqrt(R)*conv(MF, chips)/sqrt(2);
TxOut = TxOut(L_2+1: end - L_2);


if (show)
   figure;
   subplot(211); plot(MF, '-o'); title('Matched Filter'); grid on;
   subplot(212); psd(TxOut, 1024, 1e3, 113); title('Spectrum');
end


