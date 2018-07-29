function [N, D] = ratpolyfit(x,y,kn,kd)
% Ratpolyfit Rational Polynomial Fitting
%
%  This programs finds 2 polynomials N(x) and D(x),
%  of user given order kn and kd respectively,
%  such that N(xi)/D(xi) ~= y(xi) in a least squares sense.
%
%usage: [N, D] = ratpolyfit(x, y, kn, kd)
%
%note: kn and kd must be large enough to get a good fit.
%      usually, kn=kd gives good results
%
%note: If you "overfit" the data, then you will usually have pole-zero
%      cancellations and/or poles and zeros with a very large magnitude.
%      If that happens, then reduce the values of kn and/or kd
%
%note: Often, if you have a good fit, you will find that your polynomials
%      have roots where the real function has zeros and poles. 
%
%note: Polynomial curve fitting becomes ill conditioned
%      as the range of x increases and as kn and kd increase
%
%note: If you think that your function goes to infinity at some x value
%      then make sure y(xi) is set equal to Inf at that point.
%      The program will compensate for all +/- Inf values
%
%For example, here's a rational polynomial approximation to the Gamma function:
%   x=[-5:1/32:5]'; y=gamma(x);
%   [N, D]=ratpolyfit(x,y,10,10);
%   figure(1); plot(roots(N),'ob'); hold on; plot(roots(D),'xr'); grid on   
%   yy=polyval(N,x)./polyval(D,x);
%   figure(2);plot(x,y,'b', x,yy,'dr'); grid on; axis([min(x) max(x) -25 25]);
%
%other demos are in the text listing at the end of this program
%
%tested under version 6.5 (R13)
%
%see also: polyfit, padefit, polyval, vander
%

%Paul Godfrey
%pgodfrey@conexant.com
%May 31, 2006

%default length if none given
if exist('kn','var')
   kn=round(real(kn));
   if kn<0, kn=0; end
else
   kn=5;
end
if exist('kd','var')
   kd=round(real(kd));
   if kd<0, kd=0;end
else
   kd=5;
end

x=x(:);
y=y(:);

% we must remove +/- Inf values from y first
% and insert those as separate poles at the end
p=find(~isfinite(y)); % find Nan 0/0 and Inf a/0 values
% or find abs(y) values > than some really big number

dinf=[];
while length(p)>0
   y=y.*(x-x(p(1))); %adjust remaining y values
   y(p(1))=[]; % remove bad y value, now a NaN
   dinf=[dinf; x(p(1))]; % remember where pole was   
   x(p(1))=[]; % now remove that x value too
   if kd>0, kd=kd-1; end; %reduce expected order of den
   p=find(~isfinite(y)); % have all Inf values been removed yet?
end

yy=length(y);
an=ones(yy,kn+1);
for k=kn:-1:1
    an(:,k)=x.*an(:,k+1); % form vandermonde matrix
end

ad=ones(yy,kd+1);
for k=kd:-1:1
    ad(:,k)=x.*ad(:,k+1);
end
for k=1:yy
    ad(k,:)=y(k)*ad(k,:);
end

% A is basically N-y*D
A=[an -ad]; % LS solution is in the null space of A

[u,s,v]=svd(A); % null space is in the cols of V
ND=v(:,end); % use the "most null" vector

N=ND(1:kn+1).';
D=ND(kn+2:end).';

D1=D(1);
if D1==0; D1=1; end
% we have to make the D polynomial monic since thats
% what poly makes, so we have to first adjust N
N=N/D1;
D=D/D1;
% and then add the removed +/- Inf poles back in
D=poly([dinf; roots(D)]);

Dmax=max(abs(D));
if Dmax==0; Dmax=1; end
% normalize max Den value to be +/- 1
N=N/Dmax;
D=D/Dmax;

return

%a demo of this program is
clc
clear all
close all
x=[-5:1/16:5]';

y=gamma(x);
[N, D]=ratpolyfit(x,y,10,10);
yy=polyval(N,x)./polyval(D,x);
figure(1);plot(x,y,'b', x,yy,'dr');
grid on; axis([min(x) max(x) -15 15]);

y=erf(x);
[N, D]=ratpolyfit(x,y,10,10);
yy=polyval(N,x)./polyval(D,x);
figure(2);plot(x,y,'b', x,yy,'dr');
grid on; axis([min(x) max(x) -1.5 1.5]);

y=1./(1+x.*x);
[N, D]=ratpolyfit(x,y,10,10);
yy=polyval(N,x)./polyval(D,x);
figure(3);plot(x,y,'b', x,yy,'dr');
grid on; axis([min(x) max(x) 0 1]);

y=tan(x);
[N, D]=ratpolyfit(x,y,10,10);
yy=polyval(N,x)./polyval(D,x);
figure(4);plot(x,y,'b', x,yy,'dr');
grid on; axis([min(x) max(x) -5 5]);

y=exp(-x.*x);
[N, D]=ratpolyfit(x,y,10,10);
yy=polyval(N,x)./polyval(D,x);
figure(5);plot(x,y,'b', x,yy,'dr');
grid on; axis([min(x) max(x) 0 1]);

y=zeta(x);
[N, D]=ratpolyfit(x,y,10,10);
yy=polyval(N,x)./polyval(D,x);
figure(6);plot(x,y,'b', x,yy,'dr');
grid on; axis([min(x) max(x) -2 2]);

y=psi(x);
[N, D]=ratpolyfit(x,y,10,10);
yy=polyval(N,x)./polyval(D,x);
figure(7);plot(x,y,'b', x,yy,'dr');
grid on; axis([min(x) max(x) -5 5]);

x=x-min(x);

y=log(x);
[N, D]=ratpolyfit(x,y,10,10);
yy=polyval(N,x)./polyval(D,x);
figure(8);plot(x,y,'b', x,yy,'dr');
grid on; axis([min(x) max(x) -5 5]);

x=(x-min(x))*pi/2;

y=besselj(0,x);
[N, D]=ratpolyfit(x,y,10,10);
yy=polyval(N,x)./polyval(D,x);
figure(9);plot(x,y,'b', x,yy,'dr');
grid on; axis([min(x) max(x) -0.5 1]);

y=sin(x)./x;
[N, D]=ratpolyfit(x,y,10,10);
yy=polyval(N,x)./polyval(D,x);
figure(10);plot(x,y,'b', x,yy,'dr');
grid on; axis([min(x) max(x) -0.5 1]);

return
