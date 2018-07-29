function [f,modulo]=transform(suono)
f=0;
modulo=0;
fc=8000;

N=length(suono);               % numero campioni
L=2.^nextpow2(N);                %lunghezza fft
FFT_intera=fft(suono,L)/N;     % fft normalizzata
f=linspace(0,1,L/2)*fc/2;        % asse delle frequenza: f=F*fc/2 (frequenze da zero a fc/2)
FFT=FFT_intera(1:L/2);           % seleziono i campioni da 0 a fc/2
modulo=2*abs(FFT);              % ottengo il modulo (riscalato di un fattore 2)



