 close all;clear all;clc
tic;
%% inputs

options=odeset('RelTol',1e-9,'AbsTol',1e-9);

solinit = bvpinit(linspace(0,6,3),5*ones(3,1));

[T,Y]=bvpMSM('bvpme',solinit,@bcsme,@dbcsme,options);
figure(2);plot(T,Y);axis tight
toc