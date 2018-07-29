% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni

%Fourier Transfrom properties

%	convolution 

%x1(t)=u(t)-u(t-2)   and x2(t)=u(t)-u(t-4) 


% F^-1{X1(w)X2(w)}
syms t w
x1=heaviside(t)-heaviside(t-2);
x2=heaviside(t)-heaviside(t-4);
X1=fourier(x1,w);
X2=fourier(x2,w);
right =ifourier(X1*X2,t);
ezplot(right,[0 8]);

% convolution of x1(t) with x2(t)
figure
t1=0:.01:2;
t2=2.01:.01:4;
x1=[ones(size(t1)) zeros(size(t2))];
x2=ones(size([t1 t2]));
y=conv(x1,x2)*.01;
plot(0:.01:8,y);
