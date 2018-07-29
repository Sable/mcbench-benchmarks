function [spec,t,f]=spectrogram_JU(x,fs,win,overlap,win_type)

%  
% Copyright: Jacek Urbanek, PhD, 2013 
% 
%INPUT:
% x - time signal
% fs - sampling frequency [hz]
% win - time window length [s]
% overlap - time window overlap [%] (0 - 100%)
% win_type - time window type (0 - no window, 1 - hanning, 2 - hamming, 3
% - gauss
%
%OUTPUT:
%
% spec - computed spectrogram
% t - time vector
% f - frequency vector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %for display:
% 
% figure;
% imagesc(f,t,spec);title('Spectrogram'); ylabel('Time[s]','fontsize',12); xlabel('frequency[Hz]','fontsize',12);
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x=x(:)';
N=length(x);
df=fs/N;

win=win*fs;
step=round((100-overlap)*win/100);

n_steps=floor((N-win)/step);

x=x(1:(n_steps*step)+win);
h=waitbar(0,'please wait...');

stft=zeros(n_steps,win/2+1);

%%%%%%%%%%%%%%%%%%%%%%%%%WINDOW SELECTION%%%%%%%%%%%%%%%

if win_type == 0
    window=ones(1,win)';
elseif win_type == 1
    window=hann(win);
elseif win_type == 2
    window=hamming(win);
elseif win_type == 3
    window=gausswin(win);
else
    disp('nieprawid³owy typ okna');
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:n_steps
    fft_xi=fft((x(1+step*(i-1):step*(i-1)+win)).*window');
    stft(i,:)=fft_xi(1:end/2+1);
    
waitbar(i/n_steps,h);
end
close(h);

spec=abs(stft)/(0.5*win);
fN=length(spec(1,:));
f=(0:fN-1)*(fs/2)/fN;
t=(1:n_steps)*(N/(fs*n_steps));

 figure('Position',[10,10,1000,400]);
imagesc(t,f,spec'); xlabel('Time[s]','fontsize',14); colorbar;%colormap(1-gray);
 ylabel('Frequency[Hz]','fontsize',14);set(gca,'YDir','normal');

 
