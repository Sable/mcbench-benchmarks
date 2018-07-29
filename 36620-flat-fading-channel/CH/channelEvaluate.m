% generating channels with fliter method and spectrum method
% evaluate autocorrelation functions
%%
clear all
clc
close all

% doppler
fDTs=0.01;
fD=100;  
% sampling time
Ts=fDTs/fD;

Ns=1E5;

%% spectrum method
h1=flat_spec(Ns,fD,fDTs);

% autocorrelation 
Acn=xcorr(h1,'biased');
l=length(Acn);
% truncate
w=ceil(4/fDTs);
TAc=Acn(ceil(l/2)-w:ceil(l/2)+w);

lt=length(TAc);
t=-Ts*floor(lt/2):Ts:Ts*floor(lt/2);
% theoritical value of autocorrelation
Ac_th=besselj(0,2*pi*fD*t);

figure;
plot(t,real(Ac_th),t,real(TAc),'r');
title('Autocorrelation');
xlabel('time');
legend('theory','spec. method');
grid on

%% filter method 
h1=flat_filter(Ns,fD,fDTs);

Acn=xcorr(h1,'biased');
l=length(Acn);
w=ceil(4/fDTs);
TAc=Acn(ceil(l/2)-w:ceil(l/2)+w);

l=length(TAc);
t=-Ts*floor(l/2):Ts:Ts*floor(l/2);
% theory
Ac_th=besselj(0,2*pi*fD*t);

figure;
plot(t,real(Ac_th),t,real(TAc),'r');
title('Autocorrelation');
xlabel('time');
legend('theory','filter method');
grid on