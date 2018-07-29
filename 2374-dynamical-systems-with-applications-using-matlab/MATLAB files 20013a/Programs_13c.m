% Chapter 13 - Three-Dimensional Autonomous Systems and Chaos.
% Programs_13c - The Chapman Cycle. A Stiff System.
% Copyright Birkhauser 2013. Stephen Lynch.

% x=[O], y=[0_2], z=[O_3]. Exercise 6 in Section 13.6.
% Simple model of ozone production.
clear
deq=@(t,x) [2*3e-12*x(2)+5.5e-4*x(3)-1.22e-33*x(1)*x(2)*9e17-6.86e-16*x(1)*x(3);5.5e-4*x(3)+2*6.86e-16*x(1)*x(3)-3e-12*x(2)-1.22e-33*x(1)*x(2)*9e17;1.22e-33*9e17*x(1)*x(2)-5.5e-4*x(3)-6.86e-16*x(1)*x(3)]; 
[t,xa]=ode23s(deq,[0 1e8],[4e16,2e16,2e16]);
last=size(xa,1);
O=xa(last,1);
O2=xa(last,2);
O3=xa(last,3);

fprintf('[O]= %E\n',O)
fprintf('[O2]= %E\n',O2)
fprintf('[O3]= %E\n',O3)

% End of Programs_13c.