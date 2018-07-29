% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 
% Invertible and non-invertible  

n=-2:2; 
x=2*n
y1=3*x
y2=x.^2

%invertible
y1 = [ -12  -6   0  6   12]; 
z1=(1/3)*y1


%not invertible
y2=[ 16   4    0    4    16];
z2=sqrt(y2)
