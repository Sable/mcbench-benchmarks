% NOLM_Bifurcation_Diagram.
% Copyright Springer 2013 A.L. Steele and S. Lynch.
clear
N=49999;halfN=N/2;
lambda=1.55E-6;n2=3.2E-20;Aeff=30E-12;L=80;
E1(1)=0;Pmax=40;phi=0;Gauss(1)=0;
Pin(1:N)=0; Pout(1:N)=0; 
phif=0*pi; E6p=0;
kappa1=0.25;kappa2=0.8;kappa3=0.8;
rootk1 = sqrt(kappa1); irootk1 = 1i*sqrt(1-kappa1);
rootk2 = sqrt(kappa2); irootk2 = 1i*sqrt(1-kappa2);
rootk3 = sqrt(kappa3); irootk3 = 1i*sqrt(1-kappa3);
G=sqrt((1-kappa2)*(1-kappa3));
% Ramp the power up and down
for n=1:N
    
    Ein = sqrt(Pmax*exp(-0.02*((n*Pmax/N-Pmax/2))^2));
    E1 = rootk3*Ein+irootk3*E6p;
    P1 = abs(E1)^2;
    
    E3 = rootk1*E1;
    E4 = irootk1*E1;
    
    phic=2*pi*n2*L*(2-kappa1)*P1/(lambda*Aeff);
    phicc=2*pi*n2*L*(1+kappa1)*P1/(lambda*Aeff);
    
    E3p = E3*exp(-1i*(phi+phic));
    E4p = E4*exp(-1i*(phi+phicc));
    
    E5 = rootk1*E3p+irootk1*E4p;
    
    Pout(n) = abs(rootk2*E5)^2;
    Pin(n) = abs(Ein)^2;
    E6 = irootk2*E5;
    
    E6p = E6*exp(1i*phif);
   
end

% Plot the bifurcation diagrams
figure(1)
clf
fsize=15;
subplot(2,1,1)
hold on
plot(Pout(1:N),'.','MarkerSize',1)
plot(Pin(1:N),'.','MarkerSize',1);
xlabel('Number of Ring Passes','FontSize',fsize);
ylabel('Output Power','FontSize',fsize);
hold off

subplot(2,1,2)
hold on
plot(Pin,Pout,'.','MarkerSize',1);
xlabel('Input Power','FontSize',fsize);
ylabel('Output Power','FontSize',fsize);
hold off





