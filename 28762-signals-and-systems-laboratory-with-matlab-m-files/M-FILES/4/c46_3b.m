% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 
% Discrete time convolution
%  x[n]=1,10<=n<=20 
%  h[n]=n,-5<=n<=5




%1st approach  
n1=-5:9;
 x1=zeros(size(n1));
 n2=10:20;
 x2=ones(size(n2));
 x=[x1 x2];
 n1=-5:5;
 h1=n1;
 n2=6:20;
 h2=zeros(size(n2));
 h=[h1 h2];
 y=conv(x,h);
 stem(-10:40,y);
 ylim([-16 16]);
 grid ;
 legend('y[n]');
 
 
 
 
%2nd approach 
figure
nx=10:20;
 x=ones(size(nx));
 nh=-5:5;
 h=nh;
 y=conv(x,h);
 stem(5:25,y)
 axis([-10 40 -16 16]);
 grid;
 legend('y[n]');
