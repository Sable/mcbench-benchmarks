% Microfiber_Bifurcation_Diagram.
% Copyright Springer 2013 A.L. Steele and S. Lynch.
% Based on J. Opt. A Pure Appl. Opt, 10, (2008) 025303.
rho=0.05; K=0.95;
sqrho=sqrt(1-rho); sqrK=sqrt(K); sqr1K=sqrt(1-K);
D=0.0011;L=pi*D;
gam_eff=0.09;
Nmax=1000;
Pmax=50; Nmaxby2 = round(Nmax/2);
E2=0;phi0=-pi/2-0.1422;
Pin(1:Nmax)=0; Pout(1:Nmax)=0;phi_inspect(1:Nmax)=0;
%
B=K/(1-K)^2;
%
for n = 1:Nmax;
    %
    %Ein = sqrt(Pmax*exp(-0.01*((n*Pmax/Nmax-Pmax/2))^2));
    if n<Nmaxby2
        Ein = sqrt(Pmax*n/Nmaxby2);
    else
        Ein = sqrt(Pmax-Pmax*(n-Nmaxby2)/Nmaxby2);
    end
    %
    Eout = sqrho*(1i*sqrK*Ein+sqr1K*E2);
    E1 = sqrho*(sqr1K*Ein+1i*sqrK*E2);
    %
    phi = phi0+gam_eff*L*(E1*conj(E1));
    E2 = E1*exp(1i*phi);
    %
    Pin(n) = Ein*conj(Ein);
    Pout(n) = Eout*conj(Eout);
    phi_inspect(n)=phi;
    Pan_out = Pin*(1-rho)*B*phi*phi/(1+B*phi*phi);
end   

figure(1)
clf
plot(Pin,Pout,'.','MarkerSize',1);
xlabel('Input Power','FontSize',fsize);
ylabel('Output Power','FontSize',fsize);
