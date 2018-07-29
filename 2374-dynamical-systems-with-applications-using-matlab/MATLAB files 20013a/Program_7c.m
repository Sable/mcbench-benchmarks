% Chapter 7 - Differential Equations.
% Program_7c - Solving Simple Differential Equations.
% Copyright Birkhauser 2013. Stephen Lynch.

% Chemical kinetics (Example 8).
% Note that INLINE will be removed in future releases.
% deqn=inline('.00713*(4-c(1))^2*(1-c(1)/2)','t','c');
k=0.00713;
deqn = @(t,c) [k*(4-c)^2*(1-c/2)]; 
[t,ca]=ode45(deqn,[0 400],0);
plot(t,ca(:,1))
axis([0 400 0 3])
fsize=15;
set(gca,'XTick',0:100:400,'FontSize',fsize)
set(gca,'YTick',0:1:3,'FontSize',fsize)
xlabel('t','FontSize',fsize)
ylabel('c(t)','FontSize',fsize)
hold off

% End of Program_7c.