% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


% DFT of circular convolution 



y=[3.75 6.75 6 6];
Left=dft(y);
Left.'


x1=[1 0 2.5 1.5];
x2=[1 1 .5 2];
X1=dft(x1);
X2=dft(x2);
Right=X1.*X2;
Right.'
