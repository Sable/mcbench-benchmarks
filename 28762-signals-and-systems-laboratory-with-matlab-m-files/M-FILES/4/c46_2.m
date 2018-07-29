% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 

% discrete time convolution of 
% x[n]=[1,2],n=0,1 and h[n]=[2,1,1,1],n=0,1,2,3

%the signals 
 kx=[0 1];
 x=[1 2];
 stem(kx,x);
 legend('x[k]')
 axis([-.1 3.1 -.1 2.1])

 figure
 kh=0:3;
 h=[2,1,1,1];
 stem(kh,h);
 axis([-.1 3.1 -.1 2.1])
 legend('h[k]')
 
 
 
 %reflection
 stem(-kh,h)
 axis([-3.1 .1 -.1 2.1])
 legend('h[-k]')

 
 
 %shifting
 %zero overlap
 figure
  stem(kx,x)
 axis([-5.1 3.1 -.1 2.1])
 legend('x[k]')
 figure
 n=-2;
 stem(-kh+n,h);
 axis([-5.1 3.1 -.1 2.1])
 legend('h[-2-k]')

  %overlap
 figure
 stem(kx,x)
 axis([-5.1 3.1 -.1 2.1])
 legend('x(k)')
 figure
 n=0;
 stem(-kh+n,h);
 axis([-5.1 3.1 -.1 2.1])
 legend('h(n-k)=h(0-k)')
 
 figure;
 n=1;
 stem(-kh+n,h);
 axis([-5.1 3.1 -.1 2.1])
 legend('h[n-k]=h[1-k]')

 figure;
 n=2;
 stem(-kh+n,h);
 axis([-5.1 3.1 -.1 2.1])
 legend('h[n-k]=h[2-k]')

 figure
 n=3;
 stem(-kh+n,h);
 axis([-2.1 6.1 -.1 2.1])
 legend('h[n-k]=h[3-k]')

 figure
 n=4;
 stem(-kh+n,h);
 axis([-2.1 6.1 -.1 2.1])
 legend('h[n-k]=h[4-k]')


 
%zero overlap
 n=5;
 stem(-kh+n,h);
 axis([-2.1 6.1 -.1 2.1])
 legend('h(n-k)=h(5-k)')

 
 
 %result
  n=0:4;
  y=[2,5,3,3,2];
  stem(n,y);
  axis([-.1 4.1 -.1 5.1])
  legend('y[n]')



 