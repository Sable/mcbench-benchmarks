% Duffing_Poincare_Section - Poincare section for the Duffing system.
% Copyright Springer 2013 Stephen Lynch.
% The program may take a few minutes to compile.
% Poincare section for the Duffing system (See Figure 1.8(b)).
clear
deq=@(t,x) [x(2);x(1)-0.3*x(2)-(x(1))^3+0.5*cos(1.25*t)];
options=odeset('RelTol',1e-4,'AbsTol',1e-4);
[t,xx]=ode45(deq,0:(2/1.25)*pi:(4000/1.25)*pi,[1,0]);
plot(xx(:,1),xx(:,2),'.','MarkerSize',1)
fsize=15;
axis([-2 2 -2 2])
xlabel('x','FontSize',fsize)
ylabel('y','FontSize',fsize)
title('Poincare Section of the Duffing System')

% End of Programs_14d.