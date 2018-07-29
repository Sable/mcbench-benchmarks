function [f,U]=Spectrum_Analyser(t,v,f1,f2,delta);
%This program operates as a signal spectrum analyzer 
%and a distortion meter at the same time.
%It can accept any numerical data representing few cycles of a signal.
%The data do not need to be equally separated. 
%At least ten data points per cycle are needed. 
%Higher number of data points will of course produce better results. 
%The main advantage of the program is its ability to
%automatically detect the fundamental frequency. 
%Any part of the spectrum within the frequency band f1-f2 
%can be calculated and plotted. 
%The input to the software are the time and signal
%voltage arrays t,v, the frequency band 
%limits f1 and f2 and the accuracy parameter delta. 
%The out puts of the program are the signal plot, 
%the spectral analysis plot, the frequencies and relative 
%amplitudes of the ten most prominent frequency contents. 
%The software has been successfully used to analyze data 
%obtained from oscilloscope screen pictures of many 
%signals using another program written by the author called oscilloscope. 
%The program can be called through entering
%[F,A]=spectrum_analysis(t,v,f1,f2,0.001)
%N.B
%ONE OTHER PROGRAM NEED TO BE PRESENT 
%IN THE WORK DIRECTORY
%It is "maxima"this is in the Zip file   

[x,y]=maxima(t,v);
close all
BW=delta;
plot(t,v,'k')
xlabel('Time (sec)')
ylabel('Voltage (mV)')
v=double(v);
t=double(t);
%calculating fundamental frequency by choosing two succesive peaks on the
%signal(statment (16)
tt=(x(2)-x(1));
M=length(v)*tt/max(t);
%Performing fast Fourier transformation
z=fft(v,floor(M/BW));
u=(z.*conj(z)).^.5;
f=floor(1:length(u)/2);
U=u(1:max(f))/max(u(1:max(f)));
% Assigning frequencies
f=f/tt;
f=f*BW;
k=find(f>f1&f<f2);
ff=f(k);
UU=U(k);
figure
plot(ff,UU,'k')
xlabel('Frequency (Hz)')
ylabel('Amplitude (arbitrary units)')
grid
[fff,UUU]=maxima(ff,UU);
[fff,UUU]=maxima(fff,UUU);
main_frequency_components=fff(1:10)'
Their_Relative_amplitudes=UUU(1:10)'
[A,k]=max(UUU);
UUUU=UUU;
UUUU(k)=[];
%Calculating distortion factor
Distortion=(sum(UUUU.^2)/sum(UUU.^2))^.5
f=ff;
U=UU;



