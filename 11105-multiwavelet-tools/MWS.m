function [P,Q]=MWS(wavnam)
%MWS Multiwavelet scaling and wavelet function shapes.
%   [P,Q]=MWS('wname') plots the shape of the multi-scaling and 
%   multi-wavelet functions with respect to a particular multi-wavelet
%   family specified by ('wname'). The families supported by MWS
%   include GHM, SAS, and CL multi-wavelets
%
%   The values of the scaling functions and the wavelet functions are
%   returned in P and Q respectively where P contains the scaling functions
%   [phi1;phi2;...ect.] and Q contains the wavelet functions 
%   [psi1;psi2;...etc.];
%
%   See also MULTIDEMO, WAVEDEMO, WAVEINFO.

%   Auth: Dr. Bessam Z. Hassan
%   Date: 3-3-2004
%   Copyright 1995-2002 The MathWorks, Inc.
% $Revision: 1.0 $

% Check the inputs

if strcmp(wavnam,'ghm')
    C0=[3/5,4*sqrt(2)/5;-1/(10*sqrt(2)),-3/10];
    C1=[3/5,0;9/(10*sqrt(2)),1];
    C2=[0,0;9/(10*sqrt(2)),-3/10];
    C3=[0,0;-1/(10*sqrt(2)),0];
    D0=[-1/(10*sqrt(2)),-3/10;1/10,3*sqrt(2)/10];
    D1=[9/(10*sqrt(2)),-1;-9/10,0];
    D2=[9/(10*sqrt(2)),-3/10;9/10,-3*sqrt(2)/10];
    D3=[-1/(10*sqrt(2)),0;-1/10,0];
    n=4;
elseif strcmp(wavnam,'sas')
    C0=[0,(2+sqrt(7))/4;0,(2-sqrt(7))/4];
    C1=[3/4,1/4;1/4,3/4];
    C2=[(2-sqrt(7))/4,0;(2+sqrt(7))/4,0];
    n=3;
elseif strcmp(wavnam,'cl')
    C0=[0.5,-0.5;sqrt(7)/4,-sqrt(7)/4];
    C1=[1,0;0,0.5];
    C2=[0.5,0.5;-sqrt(7)/4,-sqrt(7)/4];
    n=3;
else
    error(['***  Invalid wavelet name : ',wavnam,'  ***']);
end
P=[ones(2,128),zeros(2,128)];
for j=1:1024

    %Down sampling

    [M,N]=size(P);N2=ceil(N/2);N4=ceil(N/4);
    i=1:2:N;
    P=[P(:,i),zeros(2,N/2)];

    %translation

    P0=P;
    P1=[P(:,N2+N4+1:N),P(:,1:N2+N4)];
    P2=[P(:,N2+1:N),P(:,1:N2)];
    P3=[P(:,N4+1:N),P(:,1:N4)];

    %iteration

    if n==3
        P=[C0,C1,C2]*[P0;P1;P2];
    elseif n==4
        P=[C0,C1,C2,C3]*[P0;P1;P2;P3];
    end
end
i=0:255;i=i/128;
plot(i,P(1,:));title('first scaling function');
figure(2);
plot(i,P(2,:));title('second scaling function');
if n==4
    Q=[D0,D1,D2,D3]*[P0;P1;P2;P3];
    figure(3);
    plot(i,Q(1,:));title('first wavelet function');
    figure(4);
    plot(i,Q(2,:));title('second wavelet function');
end