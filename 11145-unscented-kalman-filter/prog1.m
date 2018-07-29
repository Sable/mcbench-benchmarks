% THIS PROGRAM IS FOR IMPLEMENTATION OF DISCRETE TIME PROCESS UNSCENTED KALMAN FILTER
% FOR GAUSSIAN AND LINEAR STOCHASTIC DIFFERENCE EQUATION.
% (19 JULY 2005).
% UNSCENTED KALMAN FILTER (UKF) AT ITS BEST.
%(Under Nonlinear conditions,UNSCENTED KALMAN FILTER 
% performs to a much better extent as compared to EXTENDED KALMAN FILTER).

clc;  close all;  clear all;

format long g;
Xo = [1; 0; 0; 0; 0; 0; 0; 0; 0; 0];
nx = length(Xo);
beta = 2;
elfa = 1*(10^-1);
lambda = (((elfa^2)*(nx)) - nx);
mn1 = mean(Xo);                                   %FIRST STEP
CV1 = (Xo-mn1)*(Xo-mn1)';
%CV1 = (Xo)*(Xo)';
PO = CV1;
FX = size(CV1);
VTt = [1 0 0 0 0 0 0 0 0 0]';
ADP1 = randn(1,200);
mn2 = mean(VTt);
NTt = [1 0 0 0 0 0 0 0 0 0]';
ADP2 = randn(1,200);
mn3 = mean(NTt);
Qo = (VTt-mn2)*(VTt-mn2)';
Ro = (NTt-mn3)*(NTt-mn3)';
%Qo = (VTt)*(VTt)';
%Ro = (NTt)*(NTt)';
FX = zeros(10,10);
PAO = [PO FX FX; FX Qo FX;FX FX Ro];
Xao = [mn1 0 0]';
lam = sqrt((elfa^2)*(nx));

Wmo = lambda/(nx+lambda);
Wmi = 1/(2*(nx+lambda));
Wmin = 1/(2*(nx+lambda));

Wco =  (lambda/(nx+lambda)) + (1-(elfa^2)+ beta);
Wci = Wmi;
Wcin = Wmin;

%CALCULATION OF SIGMA POINTS
[Sg11,Sg12,Sg13,Sg21,Sg22,Sg23,Sg31,Sg32,Sg33] = sigmacal(mn1,CV1,mn2,Qo,mn3,Ro,lam);

%TIME UPDATE EQUATIONS.
[Xinew1,Xinew2,Xinew3,Yinew1,Yinew2,Yinew3,Xbark,Ybark,Pbark] = TMUPDT(Wmo,Wmi,Wmin,Wco,Wci,Wcin,Sg11,Sg12,Sg13,Sg21,Sg22,Sg23,Sg31,Sg32,Sg33);

%MEASUREMENT UPDATE EQUATIONS.
[KGain,XNEW,PT1,PT2,PT3] = MSMTUPDT(Xinew1,Xinew2,Xinew3,Yinew1,Yinew2,Yinew3,Xbark,Ybark,Pbark,Wco,Wci,Wcin,Xo,VTt);

for ii = 1:1:100
    
    VTt = [ADP1(ii+1) 0 0 0 0 0 0 0 0 0]';
    NTt = [ADP2(ii+1) 0 0 0 0 0 0 0 0 0]';
    
    %CV1 = (XNEW)*(XNEW)';
    mn1 = mean(XNEW);
    mn2 = mean(VTt);
    mn3 = mean(NTt);
    % Qo = (VTt)*(VTt)';
    % Ro = (NTt)*(NTt)';
    
    CV1 = (XNEW-mn1)*(XNEW-mn1)';
    Qo = (VTt-mn2)*(VTt-mn2)';
    Ro = (NTt-mn3)*(NTt-mn3)';
    
    lam = sqrt((elfa^2)*(nx));
    
    [Sg11,Sg12,Sg13,Sg21,Sg22,Sg23,Sg31,Sg32,Sg33] = sigmacal(mn1,CV1,mn2,Qo,mn3,Ro,lam);
    
    [Xinew1,Xinew2,Xinew3,Yinew1,Yinew2,Yinew3,Xbark,Ybark,Pbark] = TMUPDT(Wmo,Wmi,Wmin,Wco,Wci,Wcin,Sg11,Sg12,Sg13,Sg21,Sg22,Sg23,Sg31,Sg32,Sg33);
    
    [KGain,XNEW,PT1,PT2,PT3,YNEW] = MSMTUPDT(Xinew1,Xinew2,Xinew3,Yinew1,Yinew2,Yinew3,Xbark,Ybark,Pbark,Wco,Wci,Wcin,XNEW,VTt);
    
    INP1(ii) = XNEW(1,1);
    INP2(ii) = YNEW(1,1);
    
end

T = 1:1:100;  
figure(1);     subplot(211);    plot(real(INP1));   title('ORIGINAL SIGNAL');
subplot(212);  plot(real(INP2));   title('ESTIMATED SIGNAL (UNDER Nonlinear MODEL)');

figure(2);    plot(T,abs(INP1),T,abs(INP2));  title('Combined plot'); legend('original','estimated');

