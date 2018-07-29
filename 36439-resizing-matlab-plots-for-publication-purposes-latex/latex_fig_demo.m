close all
clear all
clc

x = -pi:.1:pi;
y = sin(x);
p = plot(x,y)
set(gca,'XTick',-pi:pi/2:pi)
set(gca,'XTickLabel',{'-pi','-pi/2','0','pi/2','pi'})
xlabel('-\pi \leq \Theta \leq \pi')
ylabel('sin(\Theta)')
title('Simulation Results')
text(-pi/4,sin(-pi/4),'\leftarrow sin(-\pi\div4)',...
     'HorizontalAlignment','left')
set(p,'Color','red','LineWidth',2)

latex_fig(10, 3, 1.5)
