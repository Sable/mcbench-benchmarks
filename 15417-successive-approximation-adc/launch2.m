%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 Launch code for sinusoidal input                 %
%       code by Fabrizio Conso, university of pavia, student       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                launch code example                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%                                                       %
 format short;
 f_s=1;            % normalized sampling frequency
 f_in=0.4;         % normalized signal frequency
 f_bw=5;                    % DAC's bandwidth
 sr=2;                      % DAC's slew-rate
 nbit=12;                   % converter bits
 N=2^12;                    % fft points
 t=[1:(1/f_s):N*(1/f_s)];   % discrete time array
 bw=0.5;
 fin=antismear(f_in,f_s,N);
 for i=1:N         % cycle for collect ADC outputs
     input=0.5+0.5*sin(2*pi*fin*t(i));
     counter2=Approx_2(input,nbit,f_bw,sr,f_s);
     counter=Approx(input,nbit,f_bw,sr,f_s);
     y(i)=counter;
     z(i)=counter2;
 end
 
 z=z-mean(z);                % eliminating DC tone
 y=y-mean(y);                % eliminating DC tone
 w=gausswin(N);              % window
 f=fin/f_s;                  % Normalized signal frequency
 fB=N*(bw/f_s);              % Base-band frequency bins
 [snr2,ptot2]=calcSNR(z(1:N),f,fB,w',N);
 ptot2=ptot2-max(ptot2);
 [snr,ptot]=calcSNR(y(1:N),f,fB,w',N);
 ptot=ptot-max(ptot);
 
figure(1);
clf;
plot(linspace(0,f_s/2,N/2), ptot(1:N/2), 'r');
grid on;
title('Output PSD without correction')
xlabel('Frequency [Hz]')
ylabel('PSD [dB]')
axis([0.3 f_s/2 -120 0]);

figure(2);
clf;
plot(linspace(0,f_s/2,N/2), ptot2(1:N/2), 'r');
grid on;
title('Output PSD with correction')
xlabel('Frequency [Hz]')
ylabel('PSD [dB]')
axis([0.3 f_s/2 -120 0]);
%                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%