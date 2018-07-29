
%Create A figure
figure
mainAxes = axes;
plot(mainAxes ,1:5,1:5,'r',1:5,1:0.5:3,'b');
xlabel 'This is an X Axis Label'
ylabel 'This is a Y Axis Label'
title('A Generic Title');
legend('Red Line','Blue Line');
set(gca,'Layer','Top')

%Break The Axes
h = breakxaxis([2 3]);

%Un-Break The X Axes
%unbreakxaxes(h)

