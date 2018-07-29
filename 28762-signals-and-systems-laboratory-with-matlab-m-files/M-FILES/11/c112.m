% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% Transfer Function definition 
% 
% 
%          s^2
% H(s)=----------
%       s^2+3s+1
%       
%       
      
num = [1  0 0];
den = [1  3  1];
Hs=tf(num,den)  




%H(s) with delay
num = [1  2];
den = [1  3  1];
H=tf(num,den,'inputdelay',2)




%delay demonstration 
syms t s
H1=s/(s^2+4) ;
h1=ilaplace(H1,t);
ezplot(h1,[0 20]);
grid; 
legend('h_1(t)')

figure
H2=exp(-3*s) *(s/(s^2+4)); 
h2=ilaplace(H2,t)
ezplot(h2,[0 20]);
grid;
legend('h_2(t)')

