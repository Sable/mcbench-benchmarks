%% OFDM Syetem
% BER performance
% PAPR evaluation using Amplitude Clipping
% 
clear all;close all;clc;
cdata_o=zeros(1,72); 
%% Define Parameters
%--------------------------------------------------------------------------

N=input(' Number of Subcarriers N = ');
k=input(' Up samping factor k = ' );
n=input(' Number of all samples n = ');
M=input(' Mapping Order M = ');
P=input(' Phase Offset P = ');
%--------------------------------------------------------------------------
%Modems Creation
% ht=modem.qammod('M',M,'SymbolOrder','gray','PhaseOffset',P); % Tx - Modem
% hr=modem.qamdemod('M',M,'SymbolOrder','gray','PhaseOffset',P); % Rx - Modem
ht=modem.pskmod('M',M,'SymbolOrder','gray','PhaseOffset',P); % Tx - Modem
hr=modem.pskdemod('M',M,'SymbolOrder','gray','PhaseOffset',P); % Rx - Modem
%--------------------------------------------------------------------------
d=randi([0 M-1],1,n); % Data Generation
%--------------------------------------------------------------------------
% Generating the symbols before the mapping
[numberOfSymbols numberOfZeros symbols]=v2syms(d,N/k-16);

%--------------------------------------------------------------------------
% Mapping the data using the Tx-modem
mod_data=modulate(ht,symbols);
%--------------------------------------------------------------------------
%Zero Padding
for ct=1:size(mod_data,2)
    [z(ct) z_data(:,ct)]=zpp(mod_data(:,ct),N/k);
% 
end
%Up sampling by the factor of k
up_data=rectpulse(z_data,k);
%--------------------------------------------------------------------------
% Basic Information displaying
disp('---------------------------------------------------------- ')
disp(['number of OFDM-Symbols = ' num2str(numberOfSymbols)])
disp(['each OFDM-Symbol consists of N = ' num2str(size(up_data,1))])
disp(['number of added zeros = ' num2str(numberOfZeros)])
%% --------------------------------------------------------------------------
% IFFT modulation
ifft_data=ifft(up_data,N);

%--------------------------------------------------------------------------
% find the PAPR
% par_o=zeros(size(ifft_data,2));
for a=1:size(ifft_data,2)
par_o(a)=papr2(ifft_data(:,a));

end
%--------------------------------------------------------------------------

%% CCDF 
iterations=length(par_o);
for ii=1:iterations
 % PAPR Original
        t=1;
    for zk=0:0.25:18-0.25
        if par_o(ii)>10^(zk/10)
            cdata_o(t)=cdata_o(t)+1;
        end
        t=t+1;
    end

end
cdata_o=cdata_o/iterations;
t=0:0.25:18-0.25;
%% Original Case
figure;
semilogy(t,cdata_o,'-ro','LineWidth',1,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',5),grid;
hold on;
% xlim([4.5 13.5]);
xlabel('\gamma in dB');
ylabel('CCDF(\xi) = Pr(\xi >\gamma )');
legend('Original');
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%------------------------------Adding AWGN---------------------------------
%--------------------------------------------------------------------------
% Adding AWGN
endsnr=40;
start=0;
inc=2;
lo=0;
for L=start:inc:endsnr
    sn=awgn(ifft_data,L,'measured');
    
    %----------------------------------------------------------------------
%     % FFT demodulation
    sfft=fft(sn,N);
    
    %----------------------------------------------------------------------
    % Down sample by the factor of k
    sd0=intdump(sfft,k);
    
    %----------------------------------------------------------------------
    % removing the zero padding
    for q=1:size(sd0,2)
        sd(:,q)=zppr(sd0(:,q),z(q));
        
    end
    
    % Demapping 
    sdemap=demodulate(hr,sd);
        
    %----------------------------------------------------------------------
    % convert the received data from symbols to vector
    sv=syms2v(sdemap,numberOfZeros);

    % BER calculation    
    lo=lo+1;
    [n0 r(lo)]=symerr(d,sv);
   
end
   snrv=start:inc:endsnr; 
   figure;
semilogy(snrv,r,'-o'),grid;hold on;

legend('Original');
xlabel('SNR in dB');
ylabel('BER');
hold off;

% Power Spectral Density

fsMHz = 2;
[Pxx,W] = pwelch(ifft_data(:,10),[],[],2048,40);    

figure;
plot([-1024:1023]*fsMHz/2048,10*log10(fftshift(Pxx)),'g');grid;hold on;

legend('Original');
xlabel('frequency, MHz')
ylabel('power spectral density')
hold off;
% Power Spectral Density after the SSPA
ifft_data_sspa=ifft_data./((1+ifft_data.^4).^(1/4));
figure;
[Pxx_sspa,W] = pwelch(ifft_data_sspa(:,10),[],[],2048,100);    
plot([-1024:1023]*fsMHz/2048,10*log10(fftshift(Pxx_sspa)),'g');grid;hold on;

legend('Original');
xlabel('frequency, MHz')
ylabel('power spectral density')
hold off;