clear all; close all;

figure; hold on; set(gca,'FontSize',16); set(gca,'FontName','Times'); set(gcf,'Color',[1,1,1]);
xlabel('x');ylabel('y');title('a family plot with nice legend');
t  = 0:0.005:pi;
grey1 = [1 1 1]*0.5;
% line_fewer_markers(t*180/pi,cos(t)         ,9,  '--bs','spacing','curve');
% line_fewer_markers(t*180/pi,sin(t)         ,9,  '-.ro','MFC','g','Mks',6,'linewidth',2);
% line_fewer_markers(t*180/pi,sin(t).*cos(t) ,15, ':','Mk','p','color',grey1,'MFC',grey1,'linewidth',2,'LockOnMax',1);

line_fewer_markers(t*180/pi,cos(t)         ,9,  '--bs','spacing','curve','LegendLine','off');
line_fewer_markers(t*180/pi,sin(t)         ,9,  '-.ro','MFC','g','Mks',6,'linewidth',2,'LegendLine','off');
line_fewer_markers(t*180/pi,sin(t).*cos(t) ,15, ':','Mk','p','color',grey1,'MFC',grey1,'linewidth',2,'LockOnMax',1,'LegendLine','off');


leg = legend('cos','sin','sin*cos','location','best');
