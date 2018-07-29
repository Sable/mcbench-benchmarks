function FIR_Filter_WindowingMethod

%  Design and Implementation of FIR Filter Package
% Date: 04/16/2011
%  Author: Gang LIU
% Contacts: liug "at" yahoo dot cn


%
% This code is based on the some code from MATLAB Singal Processing
% Toolbox.
% 
%.  Example MATLAB M-file illustrating FIR filter design and evaluation. 

% Finite Impulse Response filter design example
% found in the MATLAB Signal Processing Toolbox
% using the MATLAB FIR1 function (M-file) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
Fs=8000;  %Specify Sampling Frequency
Ts=1/Fs; %Sampling period.
Ns=512;  %Nr of time samples to be plotted.

t=[0:Ts:Ts*(Ns-1)];  %Make time array that contains Ns elements
                     %t = [0, Ts, 2Ts, 3Ts,..., (Ns-1)Ts]
f1=500;
f2=1500;
f3=2000;
f4=3000;

x1=sin(2*pi*f1*t); %create sampled sinusoids at different frequencies
x2=sin(2*pi*f2*t);
x3=sin(2*pi*f3*t);
x4=sin(2*pi*f4*t);

x=x1+x2+x3+x4;  %Calculate samples for a 4-tone input signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%N=16;            %FIR1 requires filter order (N) to be EVEN 
                 %when gain = 1 at Fs/2.
%W=[0.4 0.6];     %Specify Bandstop filter with stop band between 
                 %0.4*(Fs/2) and 0.6*(Fs/2)

%B=FIR1(N,W,'DC-1'); %Design FIR Filter using default (Hamming window.

disp('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');        
disp('Please specify the filter type'); 
FilterType={'low','high','bandpass','stop'};
disp('Here is the filter option:');
disp('1:    Low Pass Filter ');
disp('2:    High Pass Filter');
disp('3:    Band Pass Filter');
disp('4:    Band Stop Filter');
disp('You only need enter number. EX. 4 means Band Stop filter')
FilterOption=input('FilterOption=');
while FilterOption ~=1 && FilterOption ~=2 && FilterOption ~=3 && FilterOption ~=4 
    disp('You only need enter number : 1,2,3 or 4. EX. 4 means Band Stop filter');
    FilterOption=input('FilterOption=');
end
userFilterType=FilterType{FilterOption};
disp('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');  
disp('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');        
disp('Enter the order of the filter(Must be a positive even number, should be less than 100');

FilterOrder=input('FilterOrder=');
str=sprintf('Here is all the frequency infromation in this experiment:Fs=%d;    f1=%d;  f2=%d;  f3=%d;  f4=%d;',Fs,f1,f2,f3,f4);
disp(str);
if FilterOption==1
        disp('Enter the Edge Freq. in Hz. Note: the value should be within 0~Fs');W=input('omega=');
elseif FilterOption==2
        disp('Enter the Edge Freq. in Hz. Note: the value should be within 0~Fs');W=input('omega=');
elseif FilterOption==3
        disp('Enter the Edge Freq. in Hz. Note: the value should be within 0~Fs');W=input('omega cutoff1=');W2=input('omega cutoff2=');        W=[W W2];
elseif FilterOption==4
        disp('Enter the Edge Freq. in Hz. Note: the value should be within 0~Fs');W=input('omega cutoff1=');W2=input('omega cutoff2=');        W=[W W2];
end
  
  %Fs,    W,    
  W=W./(Fs/2);  % [1600 2400]
N=FilterOrder;


disp('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');  
disp('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');  
Window_Option={'hamming','kaiser','rectwin'};
disp('Here is the Windowing option:');
disp('1:    hamming');
disp('2:    kaiser');
disp('3:    rectwin');
WindowOption=input('WindowOption=');
while WindowOption ~=1 && WindowOption ~=2 && WindowOption ~=3 
    disp('You only need enter number : 1,2,or 3. EX. 3 means rectwin');
    WindowOption=input('WindowOption=');
end


%WindowOption='rectwin';
switch Window_Option{WindowOption}
    case 'hamming'        
        userWindow=hamming(N+1);
    case 'kaiser'
        userWindow=kaiser(N+1);
    case 'rectwin'
        userWindow=rectwin(N+1);
    otherwise
        disp('Wrong windowing option. EXIT');
        eixt
end

disp('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');  
disp('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');

%B=FIR1(N,W,'bandpass',userWindow); %Design FIR Filter using default (Hamming window.
B=fir1(N,W,userFilterType,userWindow); %Design FIR Filter using default (Hamming window.
%B               %Leaving off semi-colon causes contents of 
                %B (the FIR coefficients) to be displayed.
A=1;            %FIR filters have no poles, only zeros.
figure;
zerophase(B,A); % plot zero phase figure

disp('Checking the Zero-Phase Response of the designed filter, enter any key to continue');
pause;


figure;       %Create a new figure window, so previous one isn't lost.

freqz(B,A);		 %Plot frequency response - both amp and phase response.

disp('Checking the Freq. Response of the designed filter, enter any key to continue');
pause;
figure;

subplot(2,1,1); %Two subplots will go on this figure window.
Npts=200;
plot(t(1:Npts),x(1:Npts)) %Plot first Npts of this 4-tone input signal
title('Time Plots of Input and Output');
xlabel('time (s)');
ylabel('Input Sig');
   %Now apply this filter to our 4-tone test sequence

y = filter(B,A,x);

subplot(2,1,2);  %Now go to bottom subplot.
plot(t(1:Npts),y(1:Npts)); %Plot first Npts of filtered signal.    
xlabel('time (s)');
ylabel('Filtered Sig');
disp('Checking the Filtering Effect of the designed filter in time domain, enter any key to continue');
pause;

figure;  %Create a new figure window, so previous one isn't lost.
subplot(2,1,1);
xfftmag=(abs(fft(x,Ns)));   %Compute spectrum of input signal.
xfftmagh=xfftmag(1:length(xfftmag)/2);
   %Plot only the first half of FFT, since second half is mirror imag
   %the first half represents the useful range of frequencies from 
   %0 to Fs/2, the Nyquist sampling limit. 
f=[1:1:length(xfftmagh)]*Fs/Ns;   %Make freq array that varies from 
                                  %0 Hz to Fs/2 Hz.
plot(f,xfftmagh);		%Plot frequency spectrum of input signal
title('Input and Output Spectra');
xlabel('freq (Hz)');
ylabel('Input Spectrum');
subplot(2,1,2);
yfftmag=(abs(fft(y,Ns)));
yfftmagh=yfftmag(1:length(yfftmag)/2);
   %Plot only the first half of FFT, since second half is mirror image
   %the first half represents the useful range of frequencies from 
   %0 to Fs/2, the Nyquist sampling limit. 
plot(f,yfftmagh);		%Plot frequency spectrum of input signal
xlabel('freq (Hz)');
ylabel('Filtered Signal Spectrum');
