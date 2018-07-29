%% Simulering av PI-reglering av VVX
%%
%% Jon Bolmstedt 2000-08-09

par(1) = 1000; %rho
par(2) = 4200; %cp J/kg
par(3) = 0.03/1000; %kall m3/s
par(4) = 0.07/1000; %varm m3/s
par(5) = 2000; %k W/m2K
par(6) = 20;   %Tkin
par(7) = 60;   %Tvin
par(8) = 0.03*2; %m2
par(9) = 0.05/1000; %m3

regpar(1) = 0.00001; %regk 
regpar(2) = 60; %itime s
regpar(3) = 40; %önskad Tkv

f = 18; % n CSTR i VVX (2 fiktiva tillkommer)
%load vvxlabT02 %18 st
options = odeset('abstol', 1e-8);
[t,ut] = ode23('labtest',[0:480],[T02 3],options,regpar,par);

%ipartinit = ut(n,19); Tinit = ut(n,1:18);
%save initvalues Tinit ipartinit

n = size(t,1);
% Omvandla t till minuter
t = t./60;
tmax = t(n)/60;

ipart = ut(:,f+1);
Tset = regpar(3);
regk = regpar(1);
itime = regpar(2);

figure(1)
plot(t,ut(:,1),'-')
hold on
%plot(t,ut(:,f),'r-')
l = line([0, t(n)],[Tset, Tset]);
set(l,'color',[0 1 0])
title('Utgående Tkv och Tvv')
xlabel('min')
hold off

figure(2)
plot(t,ut(:,f+1))
title('ipart')

figure(3)
plot(1:f/2+1,[ut(n,1:f/2) par(6)],'-o',1:f/2+1,[par(7) ut(n,f/2+1:f)],'r-o')
xax = get(gca,'xtick');
yax = get(gca,'ytick');
axis([1 max(xax) min(yax) max(yax)])
title('Temperaturprofil i VVX')

%-Återskapa varmvattenflöde (inget noise i mätning då)
Tmeas = ut(:,1);
ipart = ut(:,19);
Fv = [];
for i = 1:n,
   if t(i) > 5, 
      Tset(i) = 40;
   else
      Tset(i) = 40;
   end
   e(i) = Tset(i) - Tmeas(i);
   regut(i) = regk*(e(i) + ipart(i)) + 0.07/1000/2; %u0 halva flödet
   regut(i) = regut(i)*1;
   Fv(i) = max(min(regut(i),0.07/1000),0);
end
figure(4)
plot(t,Fv*1000*60)
title('Varmvattenflöde (L/min)')








