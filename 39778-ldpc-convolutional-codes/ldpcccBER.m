% Run the LDPC-CC simulation
%
% Bagawan S. Nugroho 2007

clear all; clc;

% --------------- Variables --------------

% Convolutional code period
T = 256;

% Number of data bits
numberOfBits = 10000;

% Number of iteration
iteration = 50;

% Eb/N0 in dB
EbN0dB = [0.8 1.5 2];

% ----------- Initialization -------------

% Convolutional code memory
Ms = T + 1;

% Create random binary sequence (0/1)
u = round(rand(1, numberOfBits));

% Create base matrix H transpose
baseHT = makeBaseLdpccc(T, 2);

% --------------- Encoding ---------------

% Encoded sequence
v = encodeLdpccc(u, T, baseHT);

% ------- Modulation and channel ---------

% BPSK modulation
tx = 2*v - 1;

for snr = 1:length(EbN0dB)

   % AWGN channel - Noise variance
   N0 = 1/(exp(EbN0dB(snr)*log(10)/10));

   % Received vector - Noise variance is set for bit rate = 1/2
   rx = tx + sqrt(N0)*randn(size(tx));

% --------------- Decoding ---------------

   vHat = decodeLdpccc(rx, baseHT, T, N0, iteration);

   uHat = [];
   for i = 2:length(v)/(2*(Ms + 1)) - 1

      % Get the estimated bits
      tmp = reshape(vHat(:, i), 2, length(vHat(:, i))/2); 
      uHat = [uHat tmp(1, :)];
   
   end % for i

   % Bit error rate
   [n ber(snr)] = biterr(uHat(1:numberOfBits), u);

end % for snr

figure;
semilogy(EbN0dB, ber, 'v-');
grid on;
