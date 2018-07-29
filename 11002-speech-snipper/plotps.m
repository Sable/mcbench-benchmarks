function plotps(x,Ts,N)
% Plot the power spectrum.
% plotps(x,[Ts,N])

if nargin < 2, Ts = 1; end
if nargin < 3, N  = 2^(ceil(log(length(x))/log(2))+2); end

Fs = 1/Ts;
X  = abs(fft(x,N)).^2;
%% X  = abs(2*pi*fft(x,N)/N*Ts).^2;

figure, plot(linspace(0,Fs/2,N/2+1),X(1:N/2+1));
set(gca,'FontSize',8,'XLim',[0 Fs/2],'YScale','log'); xlabel('Frequency'); ylabel('Amplitude');

%% figure, plot(linspace(0,Fs,N+1),[X,X(1)]);
%% set(gca,'FontSize',8,'XLim',[0 Fs],'YScale','log'); xlabel('Frequency'); ylabel('Amplitude');
