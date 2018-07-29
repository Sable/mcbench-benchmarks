% P2.7
clear;  clc;
n1 = 0:20;
x1 = 0.9.^n1;
subplot(3,2,1); stem(n1,x1,'ko');  title('First given sequence x1(n)');
axis([-20 20 0 1]);
[x1f,n1f] = sigfold(x1,n1);                 % obtain x1(-n)
n2 = -20:0;
x2 = 0.8.^(-n2);
subplot(3,2,2); stem(n2,x2,'ko');  title('Second given sequence x2(n)');
axis([-20 20 0 1]);
[x2f,n2f] = sigfold(x2,n2);                 % obtain x2(-n)
[r,nr] = conv_m(x1,n1,x1f,n1f);             % auto-correlation
subplot(3,2,3); stem(nr,r,'ko');  title('Auto-Correlation x1(n)*x1(-n)');
[r,nr] = conv_m(x2,n2,x2f,n2f);             % auto-correlation
subplot(3,2,4); stem(nr,r,'ko');  title('Auto-Correlation x2(n)*x2(-n)');
[r,nr] = conv_m(x1f,n1f,x2,n2);             % cross-correlation
subplot(3,1,3); stem(nr,r,'ko');  title('Cross-Correlation');