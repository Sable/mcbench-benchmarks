%% ausvard - Utvärdera vvx för att se vilka flöden, k och volymer

par(1) = 1000; %rho
par(2) = 4200; %cp J/kg,K
par(3) = 0.03/1000; %kall m3/s
par(4) = 0.01/1000; %varm m3/s
par(5) = 2000; %k W/m2K
par(6) = 20;   %Tkin
par(7) = 60;   %Tvin
par(8) = 0.03*2/2; %m2
par(9) = 0.05/1000*2; %m3

n = 20;
tmax = 100;

[t,T]=ode23t('dTlabvvx2der',[0 tmax],[linspace(40,20,n-1) linspace(60,30,n-1)],[],par);
%[t,T]=ode23t('dTlabvvx2der',[0 tmax],T(nt,1:2*n-2),[],par);

Tkin = par(6);
Tvin = par(7);
nt = length(t);

%figure(1)
%subplot(2,1,1)
plot(1:n,[T(nt,1:n-1) Tkin],'-o',1:n,[Tvin T(nt,n:2*n-2)],'r-o')
xax = get(gca,'xtick');
yax = get(gca,'ytick');
axis([1 max(xax) min(yax) max(yax)])
grid on

figure(2)
%subplot(2,1,2)
plot(t,T(:,1))
title('Kallt ut')
grid on

% DTL

disp('-----:RESULTAT:-----')
disp('')
disp(['Varmt ut: ' num2str(T(nt,2*n-2))])
disp(['Kallt ut: ' num2str(T(nt,1))])
disp('')
disp(['Varmt DT: ' num2str(Tvin-T(nt,2*n-2))])
disp(['Kallt DT: ' num2str(T(nt,1)-Tkin)])
disp('')
a = Tvin - T(nt,1);
b = T(nt,2*n-2) - Tkin;
disp(['Delta TL: ' num2str((a-b)/log(a/b))])
disp('')
disp(['Kallt L/min: ' num2str(par(3)*1000*60)])
disp(['Varmt L/min: ' num2str(par(4)*1000*60)])
disp('')
disp(['Volym i vvx (L): ' num2str(par(9)*1000)])


