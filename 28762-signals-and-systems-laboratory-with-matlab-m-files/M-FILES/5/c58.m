%book : Signals and Systems Laboratory with MATLAB  
%by Alex Palamides & Anastasia Veloni

% line spectra 

%x(t)= -1,-1<t<0   , T=2 
%       0, 0<t<1  



syms t k n 
x=heaviside(t)-2*heaviside(t-1);
t0 =0; 
T=2;
w=2*pi/T; 

k=-5 :5 ; 
a=(1/T)*int(x*exp(-j*k*w*t),t,t0,t0+T); 
wk=w*k  
stem(wk,abs(eval(a)))
legend('Magnitude spectrum  k=-5:5')
xlabel('\Omega')

figure
stem(wk,angle(eval(a))*180/pi)
legend('Phase spectrum  k=-5:5')
xlabel('\Omega')
ylabel('degrees')

figure
k=-40 :40 ; 
a=(1/T)*int(x*exp(-j*k*w*t),t,t0,t0+T) ; 
wk=w*k  
stem(wk,abs(eval(a)))
legend(' Magnitude spectrum  k=-40:40')
xlabel('\Omega')

figure
stem(wk,angle(eval(a))*180/pi)
legend(' Phase spectrum  k=-40:40')
xlabel('\Omega')
ylabel('degrees')
