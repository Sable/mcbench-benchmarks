%MAIN BODY
clear all;
clc;
disp('It will take approaximately 18 seconds for an INTEL PENTIUM 4 [2.4GHz], 256 RAM machine to finish a 2sec [16kHz] wavfile');


%TAKING INPUT WAVEFILE,
inpfilenm = 's2ofwb';
[x, fs] =wavread(inpfilenm); 
% x=wavrecord(,);


%LENGTH (IN SEC) OF INPUT WAVEFILE,
t=length(x)./fs;
sprintf('Processing the wavefile "%s"', inpfilenm)
sprintf('The wavefile is  %3.2f  seconds long', t)


%THE ALGORITHM STARTS HERE,
M=10;  %prediction order
[aCoeff, pitch_plot, voiced, gain] = f_ENCODER(x, fs, M);  %pitch_plot is pitch periods
synth_speech = f_DECODER (aCoeff, pitch_plot, voiced, gain);


%RESULTS,
beep;
disp('Press a key to play the original sound!');
pause;
soundsc(x, fs);

disp('Press a key to play the LPC compressed sound!');
pause;
soundsc(synth_speech, fs);

figure;
subplot(2,1,1), plot(x); title(['Original signal = "', inpfilenm, '"']); %title('original signal = "%s"', inpfilenm);
subplot(2,1,2), plot(synth_speech); title(['synthesized speech of "', inpfilenm, '" using LPC algo']);