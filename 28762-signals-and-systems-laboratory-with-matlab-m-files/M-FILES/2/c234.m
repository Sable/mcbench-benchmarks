% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
%
% complex exponential sequence  


% exp(jwn)
n=-10:10;
w=0.8;
x=exp(j*w*n);
stem(n,real(x));

figure
stem(n,imag(x))
 
figure
stem(n,abs(x))
  
figure
stem(n,angle(x))



% r^n * exp(jwn)
figure
n=-10:10;
r=0.9;
w=1;
x=(r.^n).*exp(j*w*n);
stem(n,real(x));

figure
stem(n,imag(x))
 
figure
stem(n,abs(x))
  
figure
stem(n,angle(x))




%z=r*exp(jw) 
figure

z=0.9*exp(j*1)
n=-10:10;
x=z.^n; 

stem(n,real(x));
 
figure
stem(n,imag(x));