function datain(imagefig,varargins)
global M
global Nsamples
set(gcf,'WindowButtonMotionFcn',[]);
set(gcf,'windowbuttondownfcn',{@track});

%%% This function performes the FFT and spectrum analysis of the 
%%% Input data. It is not related dirctely to the filtering process,
%%% But performs post-processing. 

ini=Nsamples;
temp=get(gcf,'userdata');
temp=temp(ini:size(temp,1),:);
len=length(temp(:,3));                  % Determines the length of x 
fs=1/(temp(end,3)-temp(ini,3))*len                % mean sample rate

Pad = 2 * fs * len;                  % Setting the length of ZeroPadded x 
Pad = floor(Pad);
w=0:(Pad-1);
half_w=floor(length(w)/2);
win=(kaiser(len,5))';   % Creates a Kaiser window
for k=1:2
    temp(:,k)=temp(:,k).*win';    % Passes x through the Kaiser window
end
FFX=(abs(fft(temp(:,1) ,Pad)));
FFY=(abs(fft(temp(:,2) ,Pad)));

figure
subplot(2,1,1), plot(fs / Pad * w(1:half_w), 20*log10(FFX(1:half_w)));
grid on, ylabel(['[dB]']), title('X axis motion spectrum');

subplot(2,1,2), plot(fs / Pad * w(1:half_w), 20*log10(FFY(1:half_w)));
grid on, ylabel(['[dB]']), xlabel(['[Hz]']), title('Y axis motion spectrum');