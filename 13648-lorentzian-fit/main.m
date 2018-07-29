function main
%% starting
fclose all;
close all;
clear all; 
clc;
disp('# starting');
pause(0.1);

%% creating rand data
% x=0:0.25:12;
% y0=3;
% A=4;
% w=5;
% x0=6;
% v=[y0,A,w,x0];
% fprintf('Orig:  y0=%f  A=%f  w=%f  x0=%f\n',v(1),v(2),v(3),v(4)); 
% y=fun(v,x)+0.02*(randn(size(x))-0.5);
% figure;
% plot(x,y,'.');

%% saving rand data
% fid=fopen('data.txt','w');
% for n=1:length(x)
%     fprintf(fid,'%f\t %f\n',x(n),y(n));
% end
% fclose(fid);
% clear all;

%% loading data from file
d=load('data.txt');
x=d(:,1);
yOrig=d(:,2);
figure;
plot(x,yOrig,'ob');
hold on;

%% define start point
y0=2.5;
A=5;
w=4;
x0=7;
vStart=[y0,A,w,x0];
fprintf('Start:  y0=%f  A=%f  w=%f  x0=%f\n',vStart(1),vStart(2),vStart(3),vStart(4)); 
yStart=fun(vStart,x);
plot(x,yStart,'-r');

%% using nlinfit
vEnd=nlinfit(x,yOrig,@fun,vStart);
yEnd=fun(vEnd,x);
fprintf('End:  y0=%f  A=%f  w=%f  x0=%f\n',vEnd(1),vEnd(2),vEnd(3),vEnd(4)); 
plot(x,yEnd,'-g');
legend('Orig','Start','End');
set(gca,'Color',[0.7,0.7,0.7]);
set(gcf,'Color',[1,1,1]);

%% ending
disp('# ending');
