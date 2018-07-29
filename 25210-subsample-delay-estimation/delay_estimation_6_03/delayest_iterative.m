function [ delay, N_i ] = delayest_iterative(u2,u1,N_i_max,d_tol);
%[ delay, N_i ] = delayest_iterative(u2,u1,N_i_max,d_tol);
%Estimates delay using successive parabolic interpolation of the cross 
%correlation function (interpolated using Nyquist sampling theorem).
%N_i_max is the maximum number of iterations
%d_tol is the tolerance to stop at (samples)

%    Copyright Travis Wiens 2009 travis.mlfx@nutaksas.com

if nargin<3
	N_i_max=20;%max iterations
end
if nargin<4
	d_tol=1e-5;%stopping tolerance
end

N_p=numel(u2);%number of points

U1=fft(u1);
U2=fft(u2);
XC=U2.*conj(U1);%circular cross correlation
xc=ifft(XC);
[tmp idx]=max(xc);%find peak

R=zeros(1,3);%three points to interpolate through
R(2)=xc(idx);

%neighbors
if idx==1
    R(1)=xc(end);
    R(3)=xc(2);
elseif idx==numel(xc)
    R(1)=xc(end-1);
    R(3)=xc(1);
else
    R(1)=xc(idx-1);
    R(3)=xc(idx+1);
end

d_R=[-1 0 1]+idx-1;%delay corresponding to R


for N_i=1:N_i_max
    [d_R_max]=crit_interp_p(R,d_R);%interpolate peak from R using parabola
    R_max=fourier_series(XC,d_R_max);%calculate new xc from Fourier coefficients
    if d_R_max<d_R(2)%replace worst value
        d_R(3)=d_R(2);
        R(3)=R(2);
    else
        d_R(1)=d_R(2);
        R(1)=R(2);
    end
    diff_d=abs(d_R(2)-d_R_max);%difference between iterations
    d_R(2)=d_R_max;
    R(2)=R_max;

    if diff_d<d_tol%check tolerance for stopping condition
        break
    end
end
delay=d_R(2);%delay

