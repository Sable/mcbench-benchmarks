% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
%   Stability 
% 
% 


%stable system
den=[1 3 6 4];
poles=roots(den)


plot(real(poles),imag(poles),'*')
xlim([-2 2])
legend('poles')



%poles and zeros
figure
num=[3 0 5];
zeros=roots(num);
plot(real(poles),imag(poles),'*',real(zeros), imag(zeros),'o')
xlim([-2 2])
legend('poles', 'zeros')



num=[3  0 5];
den=[1 3 6 4];
H=tf(num,den)
poles=pole(H)
zeros=zero(H)


figure
pzmap(H) 
xlim([-2 2])


