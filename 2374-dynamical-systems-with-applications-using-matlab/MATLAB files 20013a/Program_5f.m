% Chapter 5 - Fractals and Multifractals.
% Program_5f - The f-alpha Spectrum of Dimensions.
% Copyright Birkhauser 2013. Stephen Lynch.

% An f-alpha curve for a multifractal Cantor set (Figure 5.16(c)).
k=500;p1=sym('1/9');p2=sym('8/9'); 
t=0:500;
x=(t*log(p1)+(k-t)*log(p2))/(k*log(1/3));
Y(length(t))=sym('0');
for i=1:length(t)
    Y(i)=-(log(nchoosek(k,t(i))))/(k*log(1/3));
end
plot(double(x),double(Y)) 

axis([0 2 0 .8])
fsize=15;
set(gca,'XTick',0:.5:2,'FontSize',fsize)
set(gca,'YTick',0:.2:.8,'FontSize',fsize)
xlabel('\it{\alpha}','FontSize',fsize)
ylabel('\it{f(\alpha)}','FontSize',fsize)
title(' ')
hold off

% End of Program_5f.