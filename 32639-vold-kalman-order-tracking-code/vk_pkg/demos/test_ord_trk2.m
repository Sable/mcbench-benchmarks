clear;
%
addpath '..';
%
fs=100;
nt=1000;
t=[1:nt]./fs;t=t(:);
%
f0=1.5;f1=10/2.15;
opm=log2(f1/f0)*60/t(end);
fup=f0*2.^(opm/60*t);fup=fup(:);
%
f0=10-(10-1.5)/2;f1=10;
inc=(f1-f0)/nt;
fdn=[f1:-inc:f0+inc];fdn=fdn(:);
%
f=0.75/t(end);
am1=0.25*sin(2*pi*f*t-pi/4);am1=am1+0.75;
am2=0.25*sin(2*pi*f*t-pi/1.7);am2=am2+0.75;
am3=0.25*sin(2*pi*f*t-pi/8);am3=am3+0.75;
am4=0.25*sin(2*pi*f*t-pi/2.5);am4=am4+0.75;
am5=0.25*sin(2*pi*f*t-pi/5);am5=am5+0.75;
am6=0.25*sin(2*pi*f*t-pi/10);am6=am6+0.75;
%
x1=am1.*sin(1*2*pi*cumsum(fup/fs));x1=x1./std(x1);
x2=am2.*sin(2*2*pi*cumsum(fup/fs));x2=x2./std(x2);
x3=am3.*sin(3*2*pi*cumsum(fup/fs));x3=x3./std(x3);
x4=am4.*sin(1*2*pi*cumsum(fdn/fs));x4=x4./std(x4);
x5=am5.*sin(2*2*pi*cumsum(fdn/fs));x5=x5./std(x5);
x6=am6.*sin(3*2*pi*cumsum(fdn/fs));x6=x6./std(x6);
%
fp=[fdn,2*fup,fup];
xp=[x4,x2,x1];
[nt,nch]=size(xp);
%
nsens=1;
%A=randn(nsens,nch);
A=[1,1,1];
%
xe=(A*xp.').';
xc=A(ones(nt,1),:).*xp;
%
%xe=xe+0.05*randn(nt,nsens); % add noise
%
nfft=128;nwin=100;novlap=50;dflag='mean';
[Sxx_m,freq,time]=p_gram(xe,nfft,fs,nwin,novlap,dflag);
%
r=4000;
ford=1;
[xs1,bw,T] = vk2(xe,fp(:,1),fs,r,ford);
[xs2,bw,T] = vk2(xe,fp(:,2),fs,r,ford);
[xs3,bw,T] = vk2(xe,fp(:,3),fs,r,ford);
xs=[xs1,xs2,xs3];
%
figure(1);
h=plot(t,xc,'--',t,abs(xs),'r');
set(h(2:end),'linewidth',2);
xlabel('Time [Sec]');
ylabel('Amplitude');
title('Single Order Extraction');
%
rm=4000;
tol=0.001;maxit=1000;
[xm,bwm,Tm,fl,rr,it,rv] = vkm(xe,fp,fs,rm*ones(nch,1),ford,tol,maxit);
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
typ='lin';f_min=0;f_max=32.5;
spec_plot2(Sxx_m,freq,time,typ,f_min,f_max,0,0.8);
colorbar('off');
g=colormap('gray');colormap(flipud(g));
title('Spectrogram of orders');
%
%%



