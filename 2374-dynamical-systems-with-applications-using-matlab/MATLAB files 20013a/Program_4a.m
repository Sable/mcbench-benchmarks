% Chapter 4 - Electromagnetic Waves and Optical Resonators.
% Program_4a - Iteration of the Ikeda Map.
% Copyright Birkhauser 2013. Stephen Lynch.

% Chaotic attractor for the Ikeda map (Figure 4.11(b)).
clear
echo off
A=10;
B=0.15;
N=10000;
E=zeros(1,N);x=zeros(1,N);y=zeros(1,N);
E(1)=A;x(1)=A;y(1)=0;
for n=1:N
    E(n+1)=A+B*E(n)*exp(1i*abs(E(n))^2);
    x(n+1)=real(E(n+1));
    y(n+1)=imag(E(n+1));
end
axis([8 12 -2 2])
axis equal
plot(x(50:N),y(50:N),'.','MarkerSize',1);
fsize=15;
set(gca,'XTick',8:1:12,'FontSize',fsize)
set(gca,'YTick',-2:1:2,'FontSize',fsize)
xlabel('Real E','FontSize',fsize)
ylabel('Imag E','FontSize',fsize)
    
% End of Program_4a.
