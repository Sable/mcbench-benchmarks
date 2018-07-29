% Desenarea graficelor :

figure

h=plot(tout,yout(:,1));
set(gca,'linewidth',1,'fontsize',18)
set(h,'linewidth',3)
grid
title('Volume [l]')
ylabel('V [l]')
xlabel('time [h]')
pause

h=plot(tout,yout(:,2));
set(gca,'linewidth',1,'fontsize',18)
set(h,'linewidth',3)
grid
title('Cell concentration [g/l]')
ylabel('cX [g/l]')
xlabel('timp [h]')
pause

h=plot(tout,yout(:,3));
set(gca,'linewidth',1,'fontsize',18)
set(h,'linewidth',3)
grid
title('Ethanol concentration [g/l]')
ylabel('cP [g/l]')
xlabel('time [h]')
pause

h=plot(tout,yout(:,4));
set(gca,'linewidth',1,'fontsize',18)
set(h,'linewidth',3)
grid
title('Glucoze concentration [g/l]')
ylabel('cS [g/l]')
xlabel('time [h]')
pause

h=plot(tout,yout(:,5));
set(gca,'linewidth',1,'fontsize',18)
set(h,'linewidth',3)
grid
title('Disolved O_2 concentration [mg/l]')
ylabel('cO2 [mg/l]')
xlabel('time [h]')
pause

h=plot(tout,yout(:,6));
set(gca,'linewidth',1,'fontsize',18)
set(h,'linewidth',3)
grid
title('Jacket temperature [°C]')
ylabel('Tag [°C]')
xlabel('time [h]')
pause

h=plot(tout,yout(:,7));
set(gca,'linewidth',1,'fontsize',18)
set(h,'linewidth',3)
grid
title('Reactor temperature [°C]')
ylabel('T [°C]')
xlabel('time [h]')

