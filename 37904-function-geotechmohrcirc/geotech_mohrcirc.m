function []= geotech_mohrcirc (s3, s1)
close all
clear all
clc
s3= input('Minor principal stress sigma3 = ') % input sigma3
s1=input('Major principal stress sigma 1 =') % input sigma1
x=linspace(s3,s1,10000); % Divide the distance between s1 and s3 in 10000 parts
r=(s1-s3)/2; % finding radius of the circle
h=(s1+s3)/2;% finding center of the circle
y=sqrt(r^2-(x-h).^2); % calculating y
plot (x,y)% plotiing x and y
axis equal % applying equal scale for x and y axis
grid on % turn on the grid
axis([0,s1+r,0,1.25*r])% limiting x and y axis
xlabel('Normal stress \sigma_N (Units)')
ylabel ('Shear stress \tau (Units)')
