%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%filtros.m
%
% [bandas] = filtros(sinal,fs)
%
%Banco de Filtros 1/8 e de compensacao A e C. A ultima linha apresenta a
%resposta impulsiva sem ser filtrada.
%Fs = frequencia de amostragem
%Os filtros de compensacao foram extraidos do tool box Octave.
%Realiza a filtragem em bandas de oitava, como recomendado pela norma
%IEC 61620.

function [bandas] = filtros(sinal,fs)

warning off MATLAB:nearlySingularMatrix


fc = 1000 * 2.^[-4 -3 -2 -1 0 1 2 3];   %frequencia central [63 125 250 500 1k 2k 4k 8k]
n = 3;                                  %ordem do filtro butterworth
t = 0;                                  %contador de bandas de frequencia
delta = inv(sqrt(2)*(sqrt(2)-1)^(1/2/n));   %Correcao para filtro causal
a = (delta+sqrt(delta^2+4))/2;

if fc(1)/(fs/2)*a < 1
%-------------63--------------
[b63,a63] = butter(n,[fc(1)/(fs/2)/a,fc(1)/(fs/2)*a]);
bandas(:,t+1) = filtfilt(b63,a63,sinal);
t=t+1;
end

if fc(2)/(fs/2)*a < 1
%-------------125--------------
[b125,a125] = butter(n,[fc(2)/(fs/2)/a,fc(2)/(fs/2)*a]);
bandas(:,t+1) = filtfilt(b125,a125,sinal);
t=t+1;
end

if fc(3)/(fs/2)*a < 1
%-------------250--------------
[b250,a250] = butter(n,[fc(3)/(fs/2)/a,fc(3)/(fs/2)*a]);
bandas(:,t+1) = filtfilt(b250,a250,sinal);
t=t+1;
end

if fc(4)/(fs/2)*a < 1
%-------------500--------------
[b500,a500] = butter(n,[fc(4)/(fs/2)/a,fc(4)/(fs/2)*a]);
bandas(:,t+1) = filtfilt(b500,a500,sinal);
t=t+1;
end

if fc(5)/(fs/2)*a < 1
%-------------1000--------------
[b1000,a1000] = butter(n,[fc(5)/(fs/2)/a,fc(5)/(fs/2)*a]);
bandas(:,t+1) = filtfilt(b1000,a1000,sinal);
t=t+1;
end

if fc(6)/(fs/2)*a < 1
%-------------2000--------------
[b2000,a2000] = butter(n,[fc(6)/(fs/2)/a,fc(6)/(fs/2)*a]);
bandas(:,t+1) = filtfilt(b2000,a2000,sinal);
t=t+1;
end

if fc(7)/(fs/2)*a < 1
%-------------4000--------------
[b4000,a4000] = butter(n,[fc(7)/(fs/2)/a,fc(7)/(fs/2)*a]);
bandas(:,t+1) = filtfilt(b4000,a4000,sinal);
t=t+1;
end

if fc(8)/(fs/2)*a < 1
%-------------8000--------------
[b8000,a8000] = butter(n,[fc(8)/(fs/2)/a,fc(8)/(fs/2)*a]);
bandas(:,t+1) = filtfilt(b8000,a8000,sinal);
t=t+1;
end

%-------------Compencao A-------
f1 = 20.598997; 
f2 = 107.65265;
f3 = 737.86223;
f4 = 12194.217;
A1000 = 1.9997;
NUMs = [ (2*pi*f4)^2*(10^(A1000/20)) 0 0 0 0 ];
DENs = conv([1 +4*pi*f4 (2*pi*f4)^2],[1 +4*pi*f1 (2*pi*f1)^2]); 
DENs = conv(conv(DENs,[1 2*pi*f3]),[1 2*pi*f2]);
[B,A] = bilinear(NUMs,DENs,fs); 
bandas(:,t+1) = filter(B,A,sinal);
t=t+1;

%-------------Compencao C-------
f1 = 20.598997; 
f4 = 12194.217;
C1000 = 0.0619;
pi = 3.14159265358979;
NUMs = [ (2*pi*f4)^2*(10^(C1000/20)) 0 0 ];
DENs = conv([1 +4*pi*f4 (2*pi*f4)^2],[1 +4*pi*f1 (2*pi*f1)^2]); 
[B,A] = bilinear(NUMs,DENs,fs); 
bandas(:,t+1) = filter(B,A,sinal);
t=t+1;

%-------------Linear------------
bandas(:,t+1) = sinal;
t=t+1;