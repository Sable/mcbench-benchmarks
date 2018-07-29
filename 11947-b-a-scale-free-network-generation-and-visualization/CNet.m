function CNet(Net)

format compact
format long e
theta = linspace(0,2*pi,length(Net)+1);
xy = zeros(length(Net)+1,2);
x = cos(theta);
y = sin(theta);
xy(1:length(Net)+1,1) = x(1:length(Net)+1);
xy(1:length(Net)+1,2) = y(1:length(Net)+1);
figure, gplot(Net,xy,'.-');
set(gcf, 'Color', [1 1 1]);
axis('equal');
xlim([-1.1 1.1]);
ylim([-1.1 1.1]);
axis off;