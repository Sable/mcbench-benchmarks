%Thanks for Dr. Ma Zheng's X-ray diffraction Datas.
%You can test ma.mat, ma2.mat yourself.
%Enjoy!!!
load ma3.mat;
plot(A,B,'-');
grid on;
hold on;
t=fpeak(A,B,30,[23,90,700,inf]);
plot(t(:,1),t(:,2),'o');
title('\fontsize{24}Perfect!');
hold off;