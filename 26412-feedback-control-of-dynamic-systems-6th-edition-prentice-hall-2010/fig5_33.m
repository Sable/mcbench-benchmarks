% Fig. 5.33  Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
% script to generate figure 5.33
% response comparison of continuous and digital lead control.

sim('fig5_32')
figure(1)
plot(ycd(:,1),ycd(:,2),'--',ycd(:,1),ycd(:,3))
% plot(ycd(:,1),ycd(:,2))
title('Figure 5.33 Comparison of analog and digital control Output Response')
xlabel('Time (sec)');
ylabel('Amplitude');
%gtext('continuous controller')
%gtext('digital controller')
nicegrid
%pause;
%figure(2)
%plot(ucd(:,1),ucd(:,2),ucd(:,1),ucd(:,3))
% plot(ucd(:,1),ucd(:,2))
%xlabel('Time (sec)');
%ylabel('Amplitude');
%title('Figure 5.34 Comparison of analog and digital Control Response')
%gtext('continuous controller')
%gtext('digital controller')
%grid


