clear, clc

fs = 44100; % Hz
T = 10;     % s
N = fs*T;   % samples

xpink = pinknoise(N);
xred = rednoise(N);
xblue = bluenoise(N);
xviolet = violetnoise(N);

sound(xpink, fs)
sound(xred, fs)
sound(xblue, fs)
sound(xviolet, fs)