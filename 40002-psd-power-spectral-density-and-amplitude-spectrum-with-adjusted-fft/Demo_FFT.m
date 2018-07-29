% SPECTRAL ANALYSIS
% Demo application of the FFT function
%                 [fy]=FFT(y,Fs)
%
% (c),KHMOU Youssef ; Signal Processing 2013



clear,clc
close all,


% Info Display=============================================================
% 1st Part : we compute the spectrum of sinusoidal signal with frequency Fc

fprintf(' Welcome to this demonstration of using the function FFT :  \n\n\n')
fprintf(' This simple demo is divided into 2 parts :\n');
fprintf(' 1st Part :  we compute the fft of an analytic signal Y(t) of 2 secondes \n');
fprintf(' Y(t)= Ampiltude * exp ( j* 2 * pi * t * Fc)\n');
fprintf(' 2nd Part :  we compute the fft of the squared  Y(t)²\n');
fprintf(' Type  "return" to begin : \n\n');
keyboard;
clc
f1=input(' Enter a Fundamental frequency  Fc of the signal in Hz \n' );
%Fs1=input(' Enter the sample rat in Hz such that ONLY IN THIS CASE Fs>4*Fc !\n');
Fs1=4*f1+round(f1/5);
fprintf(strcat(' The sample rate in this cas is  Fs=',num2str(Fs1),' Hz \n'));


%  Testing the input values =============================================
%if(Fs1<4*f1 || Fs1==4*f1) 
%    msg1='The values entered do not satisfy  Fs>4*Fc\n';
%    msg2='Re-execute the program to enter new values for Fc and Fs !';
%    warning(strcat(msg1,msg2));
%end


% Variables  initialization===============================================
Tf1=2;
t1=0:1/Fs1:Tf1;
Amp1=11.55;
y1=Amp1*exp(j*2*pi*f1*t1);
sigma1=1.33;
noise1=(sigma1/sqrt(2))*(randn(size(t1))+j*randn(size(t1))); 
y1=y1+noise1;


% FFT[Y(t)]=============================================================
FY1=FFT(y1,Fs1);



% Figures setting=======================================================
pause(1.2)
set(figure(1),'Position',[1070 400 300 300])
set(figure(2),'Position',[745 400 300 300])
set(figure(3),'Position',[375 400 300 300])
set(figure(4),'Position',[25 400 300 300])
figure(5), plot3(t1,real(y1),imag(y1)), xlabel(' time (s)'),ylabel('mag Re[Y(t)] (v)'),
zlabel('mag(Imag[Y(t)]'), view(-63,30), grid on
t=strcat(' Y(t)=',num2str(Amp1),'*Exp(2* pi *',num2str(f1),'*t ) ',...
    ',  Fs=',num2str(Fs1),'Hz');
title(t);


fprintf('\n\n\n\n\n\n\n\n Resluts for the signal  Y(t)');
fprintf(' Type  "return" to move to the second part\n\n');
keyboard;


%2nd Part : FFT[Y²(t)]=================================================
close all;
FY2=FFT(y1.^2,Fs1);


% Figures setting======================================================
pause(1.2)
set(figure(1),'Position',[1070 400 300 300])
set(figure(2),'Position',[745 400 300 300])
set(figure(3),'Position',[375 400 300 300])
set(figure(4),'Position',[25 400 300 300])
info=strcat('Y(t) has   Fc=',num2str(f1),' Hz, Y²(t) has 2*Fc=',num2str(2*f1),' Hz');
fprintf(info);
fprintf('\n\n Thank you for viewing this DEMO : )\n');



