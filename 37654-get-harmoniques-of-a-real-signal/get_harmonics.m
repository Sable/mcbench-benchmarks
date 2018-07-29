function [wc,w0,a0,ak,bk,c0,ck]=get_harmonics(y,pas)
%[wc,w0,a0,ak,bk,c0,ck]=get_harmonics(y,pas)
% given a signal x(t),y=x(t)
% the function get_harmoniques returns the pulse w0(rd/s) of the signal y(t)
% the coefficients ak (a1,a2,...)  and bk (b1,b2,...)  of the trigonomical
% representation  of the  signal y(t):
% y(t)= a0/2+ a1.cos(w0t)+b1.sin(w0t)+a2.cos(2w0t) +b2*sin(t*w0)+...
% it also returns the coefficients c0 and ck of the complex representation
% y(t)= ...+c(-1).exp(-jw0t)+c(0)+c(1).exp(jw0t)+c(2).exp(2jw0t)+...
% wc is the interval pulse;
% to plot the amplitude spectrum: stem(wc,abs(ck))
%[wc,w0,a0,ak,bk,c0,ck]=get_harmoniques(y,pas)
% be a signal x(t).
% For more theorical details look at www.azzimalik.com
N=length(y);
Y=fft(y);
if size(Y,2)==1;
    Y=Y';
end
w=2*(0:(N-1))*pi/(N*pas);
w0=w(2);
nc2=fix(N/2);
if nc2~=N/2;
    nc3=nc2+1;
    wc=[fliplr(-w(2:nc2+1)) w(1:nc2+1)];
    Yc=[Y(nc2+2:N) Y(1:nc2+1)];Yc=Yc/N;
else
    nc3=nc2;
    wc=[fliplr(-w(2:nc2+1)) w(1:nc2+1)];
    Yc=[Y(nc2+1:N) Y(1:nc2+1)];Yc=Yc/N;
end
%-------------------------------------------------------------
N1=length(Yc);
for l=2:nc2+1
    ak(l-1)=real(Y(l)+Y(N-l+2))/N;
    bk(l-1)=-imag(Y(l)-Y(N-l+2))/N;
    ckp(l-1)=(ak(l-1)-j*bk(l-1))/2;
    ckm(l-1)=(ak(l-1)+j*bk(l-1))/2;
end
a0=2*Y(1)/N;
c0=a0/2;ck=[fliplr(ckm) c0 ckp];
