% Fig. 9.33   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%

clear all;
close all;
%saturation nonlinearity (Figure 9.33)

N=0.1;
k= 1;
n=10
j=1;
for i=0.1:0.01:n
    Keq(j) = (2/pi)*(k*asin(N/(k*i))+(N/i)*sqrt(1-(N/(k*i))^2));
    j=j+1;
end;
plot([0,0.1:0.01:n],[1 Keq]);
axis([0 10 0 1.1]) 
title('Describing function for saturation nonlinearity')
xlabel('a')
ylabel('K_{eq}');
nicegrid;
hold off