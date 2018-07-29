function [BF_0, BF_D, BF_V, BF_t]=PriceFly(Sec)

% current price
Y=Sec.Y_0;
s=Sec.sig_0;
t=Sec.T;
K=Sec.K;
r=Sec.r;
sig=MapVol(s,Y,K,t);

[C_0,P_0]=blsprice(Y,K,r,t,sig);
BF_0=C_0+P_0;

% sensitivies
[DC, DP] = blsdelta(Y,K,r,t,sig);
BF_D=DC+DP;

[VC ] = blsvega(Y,K,r,t,sig);
VP=VC; % this is incorrect, but MATLAB does not provide the right output
BF_V=VC+VP;

% price at horizon
Y=Sec.Y_0*exp(Sec.DlnY);
s=max(Sec.sig_0+Sec.Dsig,10^(-6));
t=Sec.T-Sec.tau;
K=Sec.K;
r=Sec.r;
sig=MapVol(s,Y,K,t);

[C_t,P_t]=blsprice(Y,K,r,t,sig);
BF_t=C_t+P_t;