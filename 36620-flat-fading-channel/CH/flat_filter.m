% time varying Rayleigh flat fading channel with Clark's model 
% using filter method
% Ns number of channel samples
% fDTs: fD*Ts doppler spread fD*Ts
% fdTs= .001 slow, .01 medioum, .03 fast


function out=flat_filter(Ns,fD,fDTs)

% parameters
Ts=fDTs/fD;
% filter window length at least three side lobs
Ng=ceil(2/fDTs);

% Complex Gaussian input
x=cxn(Ns,1);

% compute g(t) and g_hat(t)
t=(-Ng:Ng)*Ts;
g=besselj(1/4,2*pi*fD*abs(t))./((abs(t)).^(1/4));   
g(Ng+1)=((pi*fD)^(1/4))/gamma(5/4);
%verify filter
%plot(abs(g));

% compute K such that ... 
g_hat=g./sqrt(sum(g.^2));
% verify K
%sum_g_hat=sum(g_hat.^2);

% channel impulse response
cn=conv(x,g_hat)*Ts;

% reject transient
cn=cn(2*Ng+1:length(cn)-2*Ng);
out=cn/sqrt(var(cn));

end