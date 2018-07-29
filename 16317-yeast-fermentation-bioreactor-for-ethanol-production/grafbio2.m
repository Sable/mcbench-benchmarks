% Desenarea graficelor :

figure


subplot(3,2,1)
plot(tout,yout(:,1))
title('Volume [l]')
ylabel('V [l]')
xlabel('time [h]')

subplot(3,2,2)
plot(tout,yout(:,2))
%title('Concentratia celulelor [g/l]')
title('Yeast concentration [g/l]')
ylabel('cX [g/l]')
xlabel('time [h]')

subplot(3,2,3)
plot(tout,yout(:,3))
%title('Concentratia etanolului [g/l]')
title('Ethanol concentration [g/l]')
ylabel('cP [g/l]')
xlabel('time [h]')

subplot(3,2,4)
plot(tout,yout(:,4))
%title('Concentratia glucozei [g/l]')
title('Glucose concentration [g/l]')
ylabel('cS [g/l]')
xlabel('time [h]')

subplot(3,2,5)
plot(tout,yout(:,5))
%title('Concentratia oxigenului dizolvat [mg/l]')
title('Oxigen concentraion [mg/l]') 
ylabel('cO2 [mg/l]')
xlabel('time [h]')

if 0
 subplot(3,2,5)
 plot(tout,yout(:,5))
% title('Temperatura din manta [°C]')
title('Temperature of the jacket [°C]')
 ylabel('Tag [°C]')
 xlabel('time [h]')
end

if 0
  subplot(3,2,5)
  plot(tout,yout(:,6))
  title('Flow of cooling medium[kg/s]')
  ylabel('Fag [kg/s]')
  xlabel('time [h]')
end

subplot(3,2,6)
plot(tout,yout(:,7))
%title('Temperatura din reactor [°C]')
title('Reactor temperature [°C]')
ylabel('T [°C]')
xlabel('time h]')