% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni



%problem 6- Fourier Transform of x(t)=t+1, -1<t<0
%                                    =-t+1, 0<t<1 

syms t w
x=(t+1)*(heaviside(t+1)- heaviside(t))+(1-t)*(heaviside(t)-heaviside(t-1))
ezplot(x,[-3 3]); 
legend('x(t)'); 
grid

figure
X=fourier(x,w)
ezplot(X,[-20 20])
legend('X(\Omega)')

