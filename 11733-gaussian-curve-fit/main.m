function main

%% clearing
fclose all; close all; clear all; 
clc; pause(0.1);

%% data
x=1:100;
sigma=15; mu=40; A=3;
y=A*exp(-(x-mu).^2/(2*sigma^2))+rand(size(x))*0.3;
plot(x,y,'.');

%% fitting
[sigmaNew,muNew,Anew]=mygaussfit(x,y);
y=Anew*exp(-(x-muNew).^2/(2*sigmaNew^2));
hold on; plot(x,y,'.r');


