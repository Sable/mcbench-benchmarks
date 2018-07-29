%  Testing the function  y=Kalman1D(x,q)
%  Note : many test were done for  better performance by choosing  
%  the values R and Q in the function Kalman1D(X) to be respectively
%  : Q=1e-2, and R=0.05.
%  For other functions, tery choosing optimal Q and R values .
%  july 2012
%  KHMOU Youssef

fprintf('>>Simulating 1D Kalman Filter: \n\n'); 
%Global parameters
t=0:pi/100:200;
F=200.00;
n=length(t);

% First test
fprintf('>>1st Signal : f(t)=4*sin(t/10)*exp(-t/200)\n');
x1=(4*sin(t./10)).*exp(-inv(F).*t);
W1=randn(size(x1));
X1=(x1+W1);
Q1=1e-4;
fprintf('>>AWGN1 parameters : m1=%3.f\tv1=%.3f\n',mean(W1),var(W1));
[Y1,K1,P1]=Kalman1D(X1,Q1);
% Statistical parametrs for the first signal
Max_x1= max(x1);
Max_y1= max(Y1);
MSE1 = 0.00 ;
for i=1:n
    MSE1=MSE1+((x1(i)-Y1(i))^2);
end
MSE1=MSE1/n;
PSNR1=20*log10(max(Max_x1,Max_y1)/(MSE1^2));
fprintf('>>Mean Square Error1 mse1=%3.f\n',MSE1);
fprintf('>>Peak Signal to Noise Ratio1 psnr1=%.3f\tdB\n\n',PSNR1);
f1=figure(1);set(f1,'Name','Testing 1: f(t)=4*sin(t/10)*exp(-t/200)+W, W~N(m,v)');
subplot(2,3,1), plot(t,x1,'MarkerSize',1.2), title(' original signal '), grid on ,
subplot(2,3,2), plot(t,X1,'g'), title(' noisy signal  (awgn)'), grid on,
subplot(2,3,3), plot(t,Y1,'r'), title(' Filtered signal,R=1e-2,Q=1e-5'), grid on,
subplot(2,3,4), plot(t,x1,'b--','MarkerSize',2), hold on, plot(t,X1,'g+','MarkerSize',1.2), plot(t,Y1,'r--'),...
    title(' Superposition'), legend(' original','noisy','filtered'), grid on,
subplot(2,3,5), plot(K1(1:100)), title(strcat(' Kalman Gain',' convergence=',num2str(K1(100)))), grid on,xlabel(' iterations')
subplot(2,3,6), plot(P1(1:100)), title(strcat(' variance error',' convergence=',num2str(min(P1)))), grid on,xlabel('iterations')

% Second test
fprintf('>>2nd  Signal : g(t)=0.5*square(pi*t/20);\n');
x2=0.5*square(pi*t/20);
W2=randn(size(x2))/10;
X2=(x2+W2);
Q2=1e-4;
fprintf('>>AWGN2 parameters : m2=%.3f\tv2=%.3f\n',mean(W2),var(W2));
[Y2,K2,P2]=Kalman1D(X2,Q2);
% Statistical parameters for the second signal
Max_x2= max(x2);
Max_y2= max(Y2);
MSE2 = 0.00 ;
for i=1:n
    MSE2=MSE2+((x2(i)-Y2(i))^2);
end
MSE2=MSE2/n;
PSNR2=20*log10(max(Max_x2,Max_y2)/(MSE2^2));
fprintf('>>Mean Square Error2 mse2=%3.f\n',MSE2);
fprintf('>>Peak Signal to Noise Ratio2 psnr2=%.3f\tdB\n',PSNR2);
f2=figure(2);set(f2,'Name','Testing 2: g(t)=1/2 *square(pi*t/20)+W, W~N(m,v)');
subplot(2,3,1), plot(t,x2,'MarkerSize',1.2), title(' original signal, Square(pulsetr) '), grid on ,axis([0 200 -1 1])
subplot(2,3,2), plot(t,X2,'g'),axis([0 200 -1 1]), title(' noisy signal  (awgn)'), grid on,
subplot(2,3,3), plot(t,Y2,'r'), title(' Filtered signal,R=1e-2,Q=1e-5'), grid on,
subplot(2,3,4), plot(t,x2,'b--','MarkerSize',2), hold on, plot(t,X2,'g+','MarkerSize',1.2), plot(t,Y2,'r--'),...
    title(' Superposition'), legend(' original','noisy','filtered'), grid on,
subplot(2,3,5), plot(K2(1:100)), title(strcat(' Kalman Gain',' convergence=',num2str(K2(100)))), grid on,xlabel(' iterations')
subplot(2,3,6), plot(P2(1:100)), title(strcat(' variance error',' convergence=',num2str(min(P2)))), grid on,xlabel('iterations')


