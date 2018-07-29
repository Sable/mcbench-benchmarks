% SFR_Bif_Diag_Second_Method - Bifurcation diagram with history.
% Copyright Springer 2013 Stephen Lynch.
clear
format long;
halfN=19999;N=2*halfN+1;N1=1+halfN;
E(1)=0.4;B=0.15;Pmax=16;

% Ramp the power up
for n=1:halfN
    E(n+1)=sqrt(n*Pmax/N1)+B*E(n)*exp(1i*abs(E(n))^2);
    Esqr(n+1)=abs(E(n+1))^2;
end

% Ramp the power down
for n=N1:N
    E(n+1)=sqrt(2*Pmax-n*Pmax/N1)+B*E(n)*exp(1i*abs(E(n))^2);
    Esqr(n+1)=abs(E(n+1))^2;
end

for n=1:halfN
    Esqr1(n)=Esqr(N+1-n);
    ptsup(n)=n*Pmax/N1;
end

% Plot the bifurcation diagrams
fsize=15;
hold on
set(gca,'xtick',0:4:16,'FontSize',fsize)
set(gca,'ytick',0:5:25,'FontSize',fsize)
plot(ptsup(1:halfN),Esqr(1:halfN),'.','MarkerSize',1);
plot(ptsup(1:halfN),Esqr1(1:halfN),'.','MarkerSize',1);
xlabel('Input Power','FontSize',fsize);
ylabel('Output Power','FontSize',fsize);
hold off





