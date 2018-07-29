%book: Signals and Systems Laboratory with MATLAB  
%by Alex Palamides & Anastasia Veloni


% problem 4 -  y[n]=x[-n]

%dynamic
n=-2:2;
x=2*n;
stem(n,x);
legend('x[n]');
xlim([-2.1 2.1]);
ylim([-4.3 4.3]);
figure
stem(-n,x);
legend('y[n]')
xlim([-2.1 2.1]);
ylim([-4.3 4.3]);

%linear
figure
n=-2:4;
x1=2*n;
x2=n/3;
a1=2;  a2=3;
z=a1*x1+a2*x2;
n1=-fliplr(n)
y=fliplr(z)
stem(n1,y);
xlim([-4.1 2.1]);
ylim([-11 21]);
legend('S[a_1x_1[n]+a_2x_2[n]]')

figure
y1=fliplr(x1);
y2=fliplr(x2);
stem(n1,a1*y1+a2*y2);
legend(' a_1S[x_1[n]]+ a_2S[x_2[n]]')
xlim([-4.1 2.1]);
ylim([-11 21]);


% shift variant
figure
n=-2:4;
x=2*n;
y=fliplr(x);
ny=-fliplr(n);
stem(ny+3,y);
xlim([-1.1 5.1]);
ylim([-4.5 8.5])
legend('y[n-3]');

figure
stem(-(n+3),x)
xlim([-7.1 -.9]);
ylim([-4.5 8.5])
legend('S[x[n-3]]')


