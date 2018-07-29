clear;
%
addpath '..';
%
fs=120;
nt=1000;
t=[1:nt]./fs;t=t(:);
%
f0=20;f1=40;
opm=log2(f1/f0)*60/t(end);
fup=f0*2.^(opm/60*t);fup=fup(:);
%
fc=30*ones(size(fup));
%
am1=0.5+0.5/t(end)*t;
am2=1*ones(size(am1));
%
x1=am1.*sin(2*pi*cumsum(fup/fs));
x2=am2.*sin(2*pi*cumsum(fc/fs));
%
fp=[fc,fup];
xp=[x2,x1];
[nt,nch]=size(xp);
%
nsens=1;
%A=randn(nsens,nch);
A=[1,1];
%
xe=(A*xp.').';
xc=A(ones(nt,1),:).*xp;
%
%xe=xe+0.05*randn(nt,nsens); % add noise
%
nfft=128;nwin=100;novlap=50;dflag='mean';
[Sxx_m,freq,time]=p_gram(xe,nfft,fs,nwin,novlap,dflag);
%
r=1600;
ford=1;
[xs(:,1),bw,T,xr(:,1)] = vk2(xe,fp(:,1),fs,r,ford);
[xs(:,2),bw,T,xr(:,2)] = vk2(xe,fp(:,2),fs,r,ford);
%
figure(1);
h=plot(t,xc,'--',t,abs(xs),'r');
set(h(2:end),'linewidth',2);
xlabel('Time [Sec]');
ylabel('Amplitude');
title('Single Order Extraction');
%
rm=1600;
tol=0.001;maxit=1000;
[xm,bwm,Tm,fl,rr,it,rv,xrm] = vkm(xe(:,1),[fc,fup],fs,rm*ones(nch,1),ford,tol,maxit);
%
figure(2);
h=plot(t,xc,'--',t,abs(xm),'r');
set(h(2:end),'linewidth',2);
xlabel('Time [Sec]');
ylabel('Amplitude');
title('Multiple Order Extraction');
%
figure(3);
semilogy(rv);
xlabel('Iteration');
ylabel('Residual');
%
figure(4);
typ='lin';f_min=0;f_max=50;
spec_plot2(Sxx_m,freq,time,typ,f_min,f_max,0,0.2);
colorbar('off');
g=colormap('gray');colormap(flipud(g));
title('Spectrogram of orders');
%
%%



