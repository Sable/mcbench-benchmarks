% NOLM_Attractor - Plot a chaotic attractor for the NOLM.
% Copyright Springer 2013 A.L. Steele and S. Lynch.
clear
N=50000;P=100;start=500;
lambda=1.55E-6;n2=3.2E-20;Aeff=30E-12;L=80;
E1(1)=0;phi=0*pi;
Eout(1:N)=0; 
phif=0*pi; E6p=0;

kappa1=0.25;kappa2=0.8;kappa3=0.8;
rootk1 = sqrt(kappa1); irootk1 = 1i*sqrt(1-kappa1);
rootk2 = sqrt(kappa2); irootk2 = 1i*sqrt(1-kappa2);
rootk3 = sqrt(kappa3); irootk3 = 1i*sqrt(1-kappa3);

G=sqrt((1-kappa2)*(1-kappa3));
% iterate
for n=1:N
    
    E1 = rootk3*sqrt(P)+irootk3*E6p;
    P1 = abs(E1)^2;
    
    E3 = rootk1*E1;
    E4 = irootk1*E1;
    
    phic=2*pi*n2*L*(2-kappa1)*P1/(lambda*Aeff);
    phicc=2*pi*n2*L*(1+kappa1)*P1/(lambda*Aeff);
    
    E3p = E3*exp(-1i*(phi+phic));
    E4p = E4*exp(-1i*(phi+phicc));
    
    E5 = rootk1*E3p+irootk1*E4p;
    
    Eout(n) = rootk2*E5;
    x(n)=real(Eout(n));
    y(n)=imag(Eout(n));
    E6 = irootk2*E5;
    
    E6p = E6*exp(1i*phif);
    
end
axis([-10 10 -10 10])
axis equal
plot(x(start:N),y(start:N),'.','MarkerSize',1);
fsize=15;
set(gca,'xtick',-10:5:10,'FontSize',fsize)
set(gca,'ytick',-10:5:10,'FontSize',fsize)
xlabel('Real E','FontSize',fsize)
ylabel('Imag E','FontSize',fsize)





