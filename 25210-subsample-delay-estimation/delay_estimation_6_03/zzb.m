function [e f_e G P]=zzb(s,n1,n2, f_s, D, N_calc)
%calculates the modified Ziv-Zakai lower bound for time delay estimation.
%s is the signal vector, n1 and n2 are the noise vectors.
%f_s is the sample rate (this is only tested for f_s=1 for now).
%D is the range of possible delays (from -D/2 to D/2).
%N_calc controls how many points are used for the numerical integration.
%Note that this calculates the bounds for e, the RMSE, not e^2, the MSE.
%This follows the method in Weinstein and Weiss, "Fundamental Limitations
% in Passive Time-Delay Estimation - Part II: Wide Band Systems" IEEE Trans
% ASSP 32, No 5, 1984.

if nargin<4
f_s=1;
end

N_p=numel(s);
if nargin<5
D=N_p/2;
end

if nargin<6
N_calc=2^10;
end

S=fft(s);
S=S.*conj(S);
N1=fft(n1);
N1=N1.*conj(N1);
N2=fft(n2);
N2=N2.*conj(N2);


SNR=((S./N1).*(S./N2))./(1+(S./N1)+(S./N2));

idx=find(N1==0);
SNR(idx)=S(idx)./N2(idx);

idx=find(N2==0);
SNR(idx)=S(idx)./N1(idx);
%note that there may be problems if both N1 and N2 are zero at a given frequency if it isn't at f=0;



%x=linspace(0,D,N_calc);
x=[0 logspace(-5,log10(D),N_calc-1)];

P=zeros(0,N_calc);
for i=1:N_calc
P(i)=p_ww (x(i),SNR,f_s);
end



G0=(D-x).*P;
G=G0;
for i=(N_calc-1):-1:1;
	if (G(i)<G(i+1))
		G(i)=G(i+1);
	end
end

f_e=x.*G;
e_2=1/D*trapz(x,f_e);%minimum e^2
e=sqrt(e_2);



%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%
function P=p_ww(x,SNR,f_s)

N_p=numel(SNR);%number of samples
T=N_p/f_s;%observation time

omega=(0:(N_p-1))/N_p*f_s*2*pi;



N_max=N_p/2;

a_fn=log(1+SNR.*sin(omega*x/2).^2);
a_fn(1)=0;%omega(1)=0;

a=-T/(2*pi)*trapz(omega(1:N_max),a_fn(1:N_max));

b_fn=(SNR.*sin(omega*x/2).^2)./(1+SNR.*sin(omega*x/2).^2);
b_fn(1)=0;%omega(1)=0;

b=T/(2*pi)*trapz(omega(1:N_max),b_fn(1:N_max));

phi=1/2*erfc(sqrt(b));

P=exp(a+b)*phi;

