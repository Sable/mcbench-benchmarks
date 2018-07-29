% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
% Problem 10-  Noise filtering from a sinusoidal input 


t=0:.1:20;
x=cos(t);
w=randn(size(t));
y=x+w;
subplot(2,1,1);
plot(t,x)
legend('x(t)');
subplot(2,1,2);
plot(t,y)
legend('y(t)');


figure
X=fft(x);
Y=fft(y);
N=length(X);
subplot(2,1,1);
stem(0:N-1,abs(X));
legend('X_k');
subplot(2,1,2);
stem(0:N-1,abs(Y));
legend('Y_k');


figure
for i=1:length(Y)
    if abs(Y(i))<50
        Yclean(i)=0;
    else
        Yclean(i)=Y(i);
    end
end
yclean=ifft(Yclean);
subplot(2,1,1);
stem(0:N-1,abs(Yclean));
legend('Y_k noiseless ');
subplot(2,1,2);
plot(t,yclean)
legend('y(t) noiseless');
