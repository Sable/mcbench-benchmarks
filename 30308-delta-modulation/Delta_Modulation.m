function [y MSE]=Delta_Modulation(del, A)
%del=step size
%A=amplitude of signal
%y=output binary sequence
%Vary del value and check when MSE is least
%If you have any problem or feedback please contact me @
%%===============================================
%NIKESH BAJAJ
%Aligarh Muslim University
%+919915522564, bajaj.nikkey@gmail.com
%%===============================================
t=0:2*pi/100:2*pi;
x=A*sin(t);
plot(x)
hold on
y=[0];
xr=0;
for i=1:length(x)-1
    if xr(i)<=x(i)
        d=1;
        xr(i+1)=xr(i)+del;
    else
        d=0;
        xr(i+1)=xr(i)-del;
    end
    y=[y d];
    
end
stairs(xr)
hold off
MSE=sum((x-xr).^2)/length(x);
end
    
