%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  filtrinho.m
%
% [b,a]=filtrinho(n,f,fs)
%
%n = ordem do filtro butterworth
%f = frequencia central
%fs = frequencia de amostragem

function    [b,a]=filtrinho(n,f,fs)

MIN = -80;


tolup =  [.5 .5 .5 .5 .5 -1.6 -16.5 -41 -55 -60];%[ .15 .15 .15 .15 .15 -2.3 -18.0 -42.5 -62 -75];
tollow = [-.5 -.6 -.8 -1.6 -5.5 MIN];%[ -.15 -.2 -.4 -1.1 -4.5 MIN];
fup = f * 2.^([ 0 1/8 1/4 3/8 1/2 1/2 1 2 3 4 ]/3);   
ffup = f * 2.^([ 0 -1/8 -1/4 -3/8 -1/2 -1/2 -1 -2 -3 -4 ]/3); 
flow = f * 2.^([ 0 1/8 1/4 3/8 1/2 1/2]/3);   
fflow = f * 2.^([ 0 -1/8 -1/4 -3/8 -1/2 -1/2]/3);  

a=2^(1/6);      
%a=18;
N=1024;     %pontos para plot
F = logspace(0,log10(fs/2),N);

%-------------63--------------
[b,a]=butter(n,[f/(fs/2)/a,f/(fs/2)*a]);
H = freqz(b,a,2*pi*F/fs);
G = 20*log10(abs(H));

semilogx(F,[G]);
hold;
semilogx(fup,tolup,'r:');
semilogx(ffup,tolup,'r:');
semilogx(flow,tollow,'r:');
semilogx(fflow,tollow,'r:');
hold;

xlabel('Frequency [Hz]'); ylabel('Gain [dB]');
%title(['Octave filters: Fc =',int2str(f),' Hz, Fs = ',int2str(fs),' Hz']);
axis([20 20000 MIN 5]);
legend('|G|','IEC61260')
grid on