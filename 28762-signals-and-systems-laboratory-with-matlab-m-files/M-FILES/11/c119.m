% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% Stability

%not stable
n=[2 1];
d=[1 3 2];
zer=roots(n);
pol=roots(d);
plot(real(pol),imag(pol),'*',real(zer),imag(zer),'o');
xlim([-3 1]);
legend('poles','zeros');

%second way
figure
H=tf(n,d,0.1);
poles=pole(H)
zeros=zero(H)
pzmap(H)
xlim([-3 1.2])




% stable
figure
n=[4  -1.4  .15];
d=[1  -.7  .15  -.025];
zplane(n,d)

figure
H=tf(n,d,0.1);
pzmap(H)

poles=pole(H)
mag=abs(poles)




% Zero/pole/gain form 
n=[2 0 -1];
d=[1 1 -12];
H=tf(n,d,0.5);
zpk(H)


