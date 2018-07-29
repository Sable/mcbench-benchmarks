%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 Launch code for sinusoidal input                 %
% Case of ideal and mismatched binary weighted resistive array DAC %
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
 Vref=1;           % reference value for the DAC
 N=2^12;                    % fft points
 t=[1:(1/f_s):N*(1/f_s)];   % discrete time array
 bw=0.5;
 fin=antismear(f_in,f_s,N);
 [v,v_err]=trs(nbit,Vref)   % ideal & mismatched thresholds
 for i=1:N         % cycle for collect ADC outputs
     input=0.5+0.5*sin(2*pi*fin*t(i));
     counter2=kelvin_2(input,nbit,f_bw,sr,f_s,v);
     counter=kelvin_2(input,nbit,f_bw,sr,f_s,v_err);
     y(i)=counter;
     z(i)=counter2;
 end
 
 z=z-mean(z);                % eliminating DC tone
 y=y-mean(y);                % eliminating DC tone
 w=gausswin(N);              % window
 f=fin/f_s;                  % Normalized signal frequency
 fB=N*(bw/f_s);              % Base-band frequency bins
 [snr,ptot]=calcSNR(z(1:N),f,fB,w',N);
 ptot2=ptot-max(ptot);
 [snr,ptot]=calcSNR(y(1:N),f,fB,w',N);
 ptot=ptot-max(ptot);
 
figure(1);
clf;
plot(linspace(0,f_s/2,N/2), ptot(1:N/2)+4, 'r');
grid on;
title('Output PSD with ideal resistors')
xlabel('Frequency [Hz]')
ylabel('PSD [dB]')
axis([0.3 f_s/2 -120 5]);

figure(2);
clf;
plot(linspace(0,f_s/2,N/2), ptot2(1:N/2), 'r');
grid on;
title('Output PSD with real resistors & reference')
xlabel('Frequency [Hz]')
ylabel('PSD [dB]')
axis([0.3 f_s/2 -120 5]);
%                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%