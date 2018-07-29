%  Figure 10.73      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
%
% Fig. 10.73
% Data for RTP Demo 3-3-99
% Data provided by Dr. Gwen van der Linden
% Data is from System Identification Studies
InputFlux=[3.460064464376177e-1 1.177299050104922e-1 2.838023866104041e-2;
   3.880303397347619e-11 8.024902450324316e-2 1.807231516460469e-2;
   8.004191616976514e-9 2.721604310757543e-3 3.171348842079633e-2];
M_inv=diag([1.000040130716728 5.557442686788876 13.63821806414694]);
Radiation=[5.47621193859299e-2 -8.570695054070524e-3 -8.296135532988507e-4... 
      -4.536181077856052e-2;
   -8.570695054070524e-3 8.570946319867835e-3 -1.621311365067015e-7...
      -8.913466080455817e-8;
   -8.296135532988507e-4 -1.621311365067015e-7 8.299854517643017e-4...
      -2.097673289443245e-7];
Conduction=[3.559939609150268e-7 -1.113667477845243e-7 -1.976161155515125e-7...
      -4.701109757899004e-8;
   -1.113667477845243e-7 1.160207476868843e-2 -2.502736022145532e-3...
      -9.099227379795117e-3;
   -1.976161155515125e-7 -2.502736022145532e-3 6.37364815665867e-3...
      -3.870714518397587e-3];
ScaleTemp=diag([0.01 0.01 0.01 0.01]);

clf;
%
sim('fig10_72')
%plot(tout,r,'-');
%hold on;
%plot(tout,y,'--');
%xlabel('Time (sec)');
%ylabel('Temperature (K)');
%hold off;
%pause;
ii=240:876;
plot(tout(ii),r(ii),'-',tout(ii),y(ii,2),'--');
legend('r','y');
grid on;
xlabel('Time (sec)');
ylabel('Temperature (K)');
title('Fig. 10.73(a) Temperature tracking response');
pause;
hold off;
ii=240:876;
plot(tout(ii),u(ii),'-');
xlabel('Time (sec)');
ylabel('Lamp voltage (V)');
grid on;
legend('u');
title('Fig. 10.73(b) Control effort');
%grid
nicegrid

