
g=-50;
Q=1;
f=10e3;

[x, Fs] = wavread('tea_16bit_48kHz_short.wav');

[b a]=get_high_shelving_filter(g,Q,f,Fs);

y=filter(b,a,x);
sound(y,Fs);
