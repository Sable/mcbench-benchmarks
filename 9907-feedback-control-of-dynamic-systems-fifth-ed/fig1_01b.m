%Figure 1.1       Feedback Control of Dynamic Systems, 5e
%                      Franklin, Powell, Emami

% script to generate figure 1.1
clf
sim('fig1_01bsim',16)
plot(roomtemp(:,1),roomtemp(:,2))
grid on;
axis([0 16 0 70]);
title('Figure 1.1(b) Plot of room temperature and thermostat setting')
hold on
plot(heatin(:,1),10*heatin(:,2))
x=[0 16];
y=[50 50];
plot(x,y)
xlabel('Time (hours)');
ylabel('Temperature (degrees F)');
gtext('Room Temperature')
gtext ('Outside Temperature')
gtext(' Furnace on')
gtext(' Furnace off')