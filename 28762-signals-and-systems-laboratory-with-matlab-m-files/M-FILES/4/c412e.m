% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 
% problem 5 - convolution of x(t) and h(t) 


t1=0:.1:.9;
t2=1:.1:3;
t3=3.1:.1:5;
x1=zeros(size(t1));
x2=t2;
x3=ones(size(t3));
x=[x1 x2 x3];
h1=zeros(size(t1));
h2=exp(-t2);
h3=zeros(size(t3));
h=[h1 h2 h3];
y=conv(x,h)*0.1;
plot(0:.1:10,y);
legend('y(t)')


figure
th=1:.01:3;
h=exp(-th);
tx1=1:.01:3;
x1=tx1;
tx2=3.01:.01:5;
x2=ones(size(tx2));
x=[x1 x2];
y=conv(x,h)*0.01;
plot(2:.01:8,y);
legend('y(t)')
