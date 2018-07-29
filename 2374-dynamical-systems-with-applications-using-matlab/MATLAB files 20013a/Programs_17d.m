% Chapter 17 - Neural Networks.
% Programs_17d - The Minimal Chaotic Neuromodule.
% Copyright Birkhauser 2013. Stephen Lynch.

% A chaotic attractor for a neural network (Figure 17.13).
clear
b1=-2;b2=3;w11=-20;w21=-6;w12=6;a=1;
N=7000;
x(1)=0;
y(1)=2;
x=zeros(1,N);y=zeros(1,N);
for n=1:N
    x(n+1)=b1+w11*1/(1+exp(-a*x(n)))+w12*1/(1+exp(-a*y(n)));
    y(n+1)=b2+w21*1/(1+exp(-a*x(n)));
end 

hold on
axis([-15 5 -5 5])
plot(x(50:N),y(50:N),'.','MarkerSize',1);
fsize=15;
set(gca,'XTick',-15:5:5,'FontSize',fsize)
set(gca,'YTick',-5:5:5,'FontSize',fsize)
xlabel('\itx','FontSize',fsize)
ylabel('\ity','FontSize',fsize)
hold off

% End of Programs_17d.