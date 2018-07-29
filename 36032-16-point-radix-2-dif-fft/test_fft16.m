% This is the comparison between matlab fft() and our fft function

%create the time domain data
a=16;
t=0:1/a:(a-1)/a;
x=5*(sin(2*pi*12*t));

%compute using Matlab fft function
f=fft(s);

%plot Matlab fft function output
subplot(211); %upper
plot(t,abs(f));

%call our function
g=fft16(x);

%plot the output of our function
subplot(212); %lower
plot(t,abs(g));