%% Script to plot MOP1
% This scripts plot the objective space for MOP1 given in Homework
% Assignment # 5. It used the function eveluate_objective to determine the
% objective values and plots the two dimensional objective space.
hold on
plot3(0,0,0);
axis([0 2 0 2 0 2]);
for i = 1 : 10
    s = sprintf('%d',i);
    %plot3(x(i,13),x(i,14),x(i,15),'String',i);
    %text(x(i,13)+.05,x(i,14)+.05,x(i,14)+.05,s);
    text(x(i,13),x(i,14),x(i,14),s);
end
hold off
