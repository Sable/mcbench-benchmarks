A=2;
fc=3;
fs=20;
n=3;
t=0:1/(100*fc):1;
x=A*cos(2*pi*fc*t);%lay mau
ts=0:1/fs:1;
xs=A*cos(2*pi*fc*ts);%mau tin hieu goc Xs
%Luong tu hoa
x1=xs+A;
x1=x1/(2*A);
L=(-1+2^n); % muc
x1=L*x1;
xq=round(x1);
r=xq/L;
r=2*A*r;
r=r-A;%tin hieu luong tu r
%ma hoa
y=[];
for i=1:length(xq);
    d=dec2bin(xq(i),n);
    y=[y double(d)-48];
end
MSE=sum((xs-r).^2)/length(x);
Bitrate=n*fs;
Stepsize=2*A/L;
QNoise=((Stepsize)^2)/12;

subplot(3,1,1);
plot(t,x,'linewidth',2)
title('lay mau')
ylabel('bien do')
xlabel('thoi gian t(in sec)')
hold on
stem(ts,xs,'r','linewidth',2)
hold off
legend('tin hieu goc','tin hieu lay mau');

subplot(3,1,2);
stem(ts,x1,'linewidth',2)
title('luong tu hoa')
ylabel('muc L')
hold on
stem(ts,xq,'r','linewidth',2)
plot(ts,xq,'--r')
plot(t,(x+A)*L/(2*A),'--b')
grid
hold off
legend('tin hieu lay mau','tin hieu luong tu');

subplot(3,1,3);
stairs([y y(length(y))],'linewidth',2)
title('ma hoa')
ylabel('tin hieu nhi phan')
xlabel('bits')
axis([0 length(y) -1 2])
grid
