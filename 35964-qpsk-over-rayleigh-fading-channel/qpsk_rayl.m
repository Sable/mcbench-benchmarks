clear; clc;
N = 10^5;   % Total no of of bits per simulation per SNR_dB

bitstrm1 = [];             %initialisation of matrices
bitstrm2 = [];  

for i = 1:N 
             bitstrm1 = [bitstrm1 (-1+2*round(rand(1,1)))];    %creating random data for INPHASE component
             bitstrm2 = [bitstrm2 (-1+2*round(rand(1,1)))];    %creating random data for QUADRATURE component
end
    Data = [bitstrm1; bitstrm2];     %putting the two random bitstreams together

Eb_No_dB = [0:20]; % multiple Eb/N0 values

for i = 1:length(Eb_No_dB)
   
   sig = sqrt(1/10^(Eb_No_dB(i)/10)); % noise variance 
   n = sig*(randn(2,N) + 1i*randn(2,N));  % Additive white gaussian noise prototype 
   
   h = randn(2,N) + 1i*randn(2,N);  % Rayleigh channel
   
   y = h.*Data + n; % bit-streams corrupted by Rayleigh channel & AWGN

   
   y_rcv = y./h; % equalization of received data by channel information at the receiver
   
   
   Data_rcv = [Refresh(real(y_rcv(1,:))); Refresh(real(y_rcv(2,:)))]; % Regenerating the received bits by threshold comparison
   
    
   Err(i) = sum(sum(round(Data) ~= round(Data_rcv))); % computing the bit error in each simulation

end
   
simBer = Err/(2*N); % average BER on total no. of bits simulated

EbNo_lin = 10.^(Eb_No_dB/10);
theoryBer_AWGN = 0.5*erfc(sqrt(EbNo_lin/2)); % theoretical BER of QPSK over AWGN channel

theoryBer_Rayl = 0.5.*(1-sqrt(EbNo_lin./(EbNo_lin+1))); % theoretical BER of QPSK over Rayleigh channel

% plotting the simulated results
semilogy(Eb_No_dB,theoryBer_AWGN,'g--*');
hold on
semilogy(Eb_No_dB,theoryBer_Rayl,'b-');
semilogy(Eb_No_dB,simBer,'m--*');
axis([0 20 10^-5 0.5])

legend('QPSK over AWGN channel- Theoretical','QPSK over Rayleigh channel- Theoretical', 'QPSK over Rayleigh channel- Simulation');
xlabel('Eb/No, dB');
ylabel('Bit Error Rate');
title('BER for QPSK modulation in Rayleigh channel');   
   
   
   