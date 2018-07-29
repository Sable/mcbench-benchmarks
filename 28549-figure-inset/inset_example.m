% The script is an example for the function "inset"
% figure 1 is a plot of 'zero order bessel function of the first kind' in the range of x=0 to x=50.
% figure 2 is a close-up of this function around its first zero.
% figure 3 shows the function in the main plot, and the close-up in the
% inset plot.
% 
% Moshe Lindner, August 2010 (C).

close all
x1=0:50;
y1=besselj(0,x1);
x2=2.35:.001:2.45;
y2=besselj(0,x2);
fig1=figure(1);
plot(x1,y1,'b','linewidth',2)
hold on
plot(x1,0*x1,':k')
set(gca,'fontsize',15)
title ('bessel function')
xlabel('X')
ylabel('Y')
fig2=figure(2);
plot(x2,y2,'r')
hold on
plot(x2,0*x2,':k')
title ('close-up')
[h_m h_i]=inset(fig1,fig2);

set(h_i,'xtick',2.35:.025:2.45,'xlim',[2.35,2.45])