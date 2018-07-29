%% funtion [an,bn,RCSTheta,RCSPhi,output] = mieHKURCS(a,f,erb,urb,erp,urp,N)
%% Based on [*]L.Tsang,J.A.Kong,and K.H.Ding's "Scattering of Electromagnetic waves (volume I,Theories and Applications)"
% Author: Shao Ying HUANG, 29 Sept 2010
%% Input
% a: radius;
% f: frequency;
% erb: relative epsilon (background);
% urb: relative mu (background);
% erp: relative epsilon (the sphere) e.g. -5.3336+1.9698*i;
% urp: relative mu (the sphere);
% N: number of iteration, e.g. 20 (Criteria for N: aN ~ 0; bN ~ 0; cN ~ 0; dN ~ 0)
%% Output
% an,bn (note: need to double check whether an and bn converge)
% RCSTheta,RCSPhi,
% output[theta, RCSTheta(phi=0, ei=x),RCSPhi(phi=90,ei=x)]
% output(:,2) is the MOM case
% MoM comparison:: plot(output(:,1),output(:,2))
%%
function [an,bn,RCSTheta,RCSPhi,output] = mieHKURCS(a,f,erb,urb,erp,urp,N)
format long;

e0=1/(4*pi*9*10.^9); %farads/m
u0=4*pi*1e-7; %henries/m

ub = urb*u0;
eb = erb*e0;
up = urp*u0;
ep = erp*e0;
omega = 2*pi*f;
kb = omega * sqrt(ub*eb);
kp = omega * sqrt(up*ep);

for n=1:N
%% [*] p34
an(1,n)=(kp*kp*JSph(n,kp*a)*JDerPack(n,kb*a)-kb*kb*JSph(n,kb*a)*JDerPack(n,kp*a))...
       /(kp*kp*JSph(n,kp*a)*HDerPack(n,kb*a)-kb*kb*HSph(n,kb*a)*JDerPack(n,kp*a));
bn(1,n) = (JSph(n,kp*a)*JDerPack(n,kb*a)-JSph(n,kb*a)*JDerPack(n,kp*a))...
         /(JSph(n,kp*a)*HDerPack(n,kb*a)-HSph(n,kb*a)*JDerPack(n,kp*a));
end
%% phi = 0, ei=x, e-field in the plane of observation
numTheta=361;
theta = 1e-7:pi/(numTheta-1):pi+1e-7;
for j = 1:numTheta
EsThetaTemp = 0;
for n=1:N
     EsThetaTemp = EsThetaTemp + ((2*n+1)/n/(n+1))*(an(1,n)*TAU(n,theta(j))+bn(1,n)*PI(n,theta(j)));
end
RCSTheta(1,j)=(abs(EsThetaTemp)^2)*4*pi/kb/kb;
end 
RCSTheta = 10.*log10(RCSTheta);
xaxis = 180:-0.5:0;
output(:,1) = xaxis';
output(:,2) = RCSTheta';

%% phi = 90 degree, ei=x,e-field normal to the plane of observation
for j = 1:numTheta
EsPhiTemp = 0;
for n=1:N
     EsPhiTemp = EsPhiTemp + ((2*n+1)/n/(n+1))*(an(1,n)*PI(n,theta(j))+bn(1,n)*TAU(n,theta(j)));
end
RCSPhi(1,j)=(abs(EsPhiTemp)^2)*4*pi/kb/kb;
end 
RCSPhi = 10.*log10(RCSPhi);
output(:,3) = RCSPhi';
function output=Pn0Cos(n,theta)
output = legendre(n,cos(theta));
output=output(1);

function output=Pn1Cos(n,theta)
output = legendre(n,cos(theta));
output=output(2);

function output=PI(n,theta)
output=-1*Pn1Cos(n,theta)/sin(theta); 

function output = TAU(n,theta)
output = (sin(theta)/(1-cos(theta)^2))...
    *((n+1)*cos(theta)*Pn1Cos(n,theta)-n*Pn1Cos(n+1,theta));
% Spherical Bessel
function output = JSph(n,z)
output = sqrt(0.5*pi/z)*besselj(n+0.5,z);

function output = JSphDer(n,z)
output = JSph(n-1,z)-((n+1)/z)*JSph(n,z);

function output = JDerPack(n,z)
output = JSph(n,z)+z*JSphDer(n,z);

% Spherical Hankel of the 1st kind
function output = HSph(n,z)
output = sqrt(0.5*pi/z)*besselh(n+0.5,z);

function output = HSphDer(n,z)
output = HSph(n-1,z)-((n+1)/z)*HSph(n,z);

function output = HDerPack(n,z)
output = HSph(n,z)+z*HSphDer(n,z);