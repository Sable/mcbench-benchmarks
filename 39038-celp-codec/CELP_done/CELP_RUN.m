% The script to run the CELP codecs: 16 kbps CELP & 9.6 kbps CELP
clc,clear;
% Create WAV file in current folder.
load handel.mat
hfile = 'handel.wav';
wavwrite(y, Fs, hfile)
clear y Fs;

% Taking the input data from speech file
x = wavread(hfile);
N = 160;    % Frame length
L = 40;     % Sub-frame length
M = 12;     % Order of LP analysis
c = 0.85;   % constant parameter for perceptual weighted filter
Pidx = [16 160];

% Entering into the CELP analysis-by-synthesis codec
% creating the Gaussian codebook
randn('state',0);
cb = randn(L,1024);

% invoking the CELP codecs
[xhat1, e, k, theta0, P, b] = celp9600(x,N,L,M,c,cb,Pidx);
[xhat2, e, k, theta0, P, b] = celp16k(x,N,L,M,c,cb,Pidx);

% playing all the sound files
for i = 1:3,
    if(i==1),
        display('Playing the original sound file...');
        wavplay(x,8000);
    elseif(i==2),
        display('Playing the 16 kbps CELP generated sound file...');
        wavplay(xhat1,8000);
    elseif(i==3),
        display('Playing the 9.6 kbps CELP generated sound file...');
        wavplay(xhat2,8000);
    end
end
% plotting all the speech profiles
figure(1)
subplot(3,1,1)
plot(x)
axis([0 7*10^4 -1 1]);
xlabel('time'); ylabel('Amplitude');
title('The original speech samples');
subplot(3,1,2)
plot(xhat1,'m')
axis([0 7*10^4 -1 1]);
xlabel('time'); ylabel('Amplitude');
title('The CELP 16 kbps synthetic samples');
subplot(3,1,3)
plot(xhat2,'c')
axis([0 7*10^4 -1 1]);
xlabel('time'); ylabel('Amplitude');
title('The CELP 9.6 kbps synthetic samples');

% comparing all the synthetic speech profiles with original speech
figure(2)
plot([x xhat1]);
axis([0 7*10^4 -1 1]);
legend('original speech','16 kbps CELP speech');
xlabel('time'); ylabel('Amplitude');
title('The comparison of original speech & 16 kbps CELP synthetic samples');        
        
figure(3)
plot([x xhat2]);
axis([0 7*10^4 -1 1]);
legend('original speech','9.6 kbps CELP speech');
xlabel('time'); ylabel('Amplitude');
title('The comparison of original speech & 9.6 kbps CELP synthetic samples'); 
        