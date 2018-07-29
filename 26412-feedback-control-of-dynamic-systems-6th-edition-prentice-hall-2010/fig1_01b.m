%Figure 1.1       Feedback Control of Dynamic Systems, 6e
%                      Franklin, Powell, Emami

% script to generate figure 1.1
clf
sim('fig1_01bsim',24)
plot(roomtemp(:,1),roomtemp(:,2))
axis([0 24 -1 21]);
title('Figure 1.1(b) Plot of room temperature and thermostat setting')
hold on
plot(heatin(:,1),heatin(:,2))
xlabel('Time (hours)');
ylabel('Temperature (degrees F)');
gtext('Room Temperature')
gtext(' Furnace on')
gtext(' Furnace off')
nicegrid;