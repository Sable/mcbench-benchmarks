% Fig. 5.33  Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
% script to generate figure 5.33(a) and (b)
% response comparison of continuous and digital lead control.
sim('fig533sim')
figure(1)
plot(ycd(:,1),ycd(:,2),ycd(:,1),ycd(:,3))
% plot(ycd(:,1),ycd(:,2))
title('Figure 5.33a Comparison of analog and digital control(a) Output Response')
xlabel('Time (sec)');
ylabel('Amplitude');
gtext('continuous controller')
gtext('digital controller')
grid
pause;
figure(2)
plot(ucd(:,1),ucd(:,2),ucd(:,1),ucd(:,3))
% plot(ucd(:,1),ucd(:,2))
xlabel('Time (sec)');
ylabel('Amplitude');
title('Figure 5.33(b) Control Responses')
gtext('continuous controller')
gtext('digital controller')
grid


