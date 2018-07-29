% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
%
% Transformations of the time variable - discrete time signals 


%upsampling-downsampling 
 x=[1,2,3,4,5,6]
 a=2;
 xds=downsample(x,a)
 xds=x(1:a:end)
 
 a=1/2; 
 xups=upsample(x,1/a)
 xups=zeros(1,1/a*length(x))
 xups(1:1/a:end)=x  

 %all transformations
 n=-20:20; 
 p=( (n>=-10)&(n<=10));
 x=(0.9.^n).*p;
 stem(n,x);
 legend('x[n]') ;
 
 figure
 stem(n+10,x)
 legend('x[n-10]') 
 
 figure
 stem(n-10,x) 
 legend('x[n+10]') 
 
 figure
 a=2;
 xd=downsample(x,a)
 nd=-10:10;
 stem(nd,xd);
 legend('x[2n]') 
 
 figure
 a=1/3
 xup=upsample(x,1/a)
 nup=-61:61
 stem(nup,xup)
 legend('x[(1/3) n]')
 
 figure
 stem(-n,x)
 legend('x[-n]') 
 
 
 
 figure
 n=-2:4;
 n1=-fliplr(n)
 x=0.9.^n
 x1=fliplr(x)
 subplot(121);
 stem(n,x);
 title('x[n]=0.9^n');
 subplot(122);
 stem(n1,x1);
 title('x[-n]');


 