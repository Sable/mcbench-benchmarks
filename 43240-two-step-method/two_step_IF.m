function IF=two_step_IF(x,fs,win,df,overlap,start,tol)

% Instantaneous frequency (IF) estimation based on Two-step method
% introduced in:
%
% "A Two-Step Procedure for Estimation of Instantaneous Rotational Speed With Large Fluctuations, 
% Urbanek, T. Barszcz, J. Antoni, Mechanical Systems and Signal Processing 38 (1) , pp. 96-102"
%  
% Copyright: Jacek Urbanek, PhD, 2013 
% 
% INPUT:
% x - time signal
% fs - sampling frequency [Hz]
% win - time window length [s]
% df - frequency window width for filtration [Hz] 
% overlap - time window overlap [%] (0 - 100%)
% start - starting point for the estimation [Hz]
% tol - tolerance for time-frequency IF estimation [Hz]
%
% EXAMPLE:
% For exemplary signal:
% IF=two_step_IF(x,25000,0.2,20,95,600,15);
% 
% TIP: 
% For improved results try to manipulate "df" and "tol" parameters. You
% might also change spectrogram options.


x=x(:)';
N=length(x);
dt=1/fs;

[spec,t,f]=spectrogram_JU(x,fs,win,overlap);

dfs=(f(2)-f(1));
tol=ceil(tol/dfs);

IF_spec=spectrogram_IF_track(spec',t,f,start,tol);
IF_spec_I=interp1(linspace(0,1,length(t)),IF_spec,linspace(0,1,N));

phase_spec=cumsum(IF_spec_I)/fs;
x_ps=x.*exp(-1i*2*pi*phase_spec);

fft_x_ps=fft(x_ps);
fft_x_ps(ceil((df/2)/(fs/N))+1:end-ceil((df/2)/(fs/N)))=0;
xf=ifft(2*fft_x_ps).*exp(1i*2*pi*phase_spec);

phase=unwrap(angle(xf))/(2*pi);
IF=diff(phase)/dt;
IF(end+1)=IF(end);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[spec_xf,t,f]=spectrogram_JU(real(xf),fs,win,overlap);

figure;

subplot(3,1,1); imagesc(t,f,spec'); xlabel('Time[s]','fontsize',14);
 ylabel('Frequency[Hz]','fontsize',14);set(gca,'YDir','normal');
 hold on; plot(t,IF_spec,'r.','linewidth',3);ylim([min(IF_spec)-df/2 max(IF_spec)+df/2]);
 
 subplot(3,1,2); imagesc(t,f,spec_xf'); xlabel('Time[s]','fontsize',14); 
 ylabel('Frequency[Hz]','fontsize',14);set(gca,'YDir','normal');ylim([min(IF_spec)-df/2 max(IF_spec)+df/2]);


subplot(3,1,3);
plot((0:N-1)/fs,IF_spec_I,'r','linewidth',3);  hold on; plot((0:N-1)/fs,IF,'linewidth',1);
 xlabel('Time[s]','fontsize',14);ylabel('IF[Hz]','fontsize',14); ylim([min(IF_spec)-df/2 max(IF_spec)+df/2]);
 legend('Time-Frequency based IF','Two-step method based IF','Location','Best');
linkaxes


function [spec,t,f]=spectrogram_JU(x,fs,win,overlap)

x=x(:)';
N=length(x);
df=fs/N;

win=win*fs;
step=round((100-overlap)*win/100);

n_steps=floor((N-win)/step);

x=x(1:(n_steps*step)+win);
h=waitbar(0,'please wait...');

stft=zeros(n_steps,win/2+1);

window=hann(win);

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


function IF=spectrogram_IF_track(spectr,t,f,start,tol)

N=length(t);
temp=abs(f-start);
[temp,start]=min(temp);


 [temp,IF(1)]=max(spectr(start-tol:start+tol,1));
 IF(1)=IF(1)+start-tol-1;
for i=2:N
    
    [temp,IF(i)]=max(spectr(IF(i-1)-tol:IF(i-1)+tol,i));
    IF(i)=IF(i)+IF(i-1)-tol-1;
end

IF=f(IF);