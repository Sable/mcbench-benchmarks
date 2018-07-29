% Chapter 6 - Controlling Chaos.
% Program_6a - Controlling Chaos in the Logistic Map.
% Copyright Birkhauser 2013. Stephen Lynch.

% Control to a period-2 orbit (Figure 6.3(b)).
clear
itermax=200;
mu=4;k=0.217;x=zeros(1,itermax);
x(1)=0.6;
for n=1:2:itermax
    x(n+1)=mu*x(n)*(1-x(n));    
    x(n+2)=mu*x(n+1)*(1-x(n+1));
    if n>60                       % Switch on the control when n>60.
    x(n+1)=k*mu*x(n)*(1-x(n));    % Nudge the system every second iterate.
    x(n+2)=mu*x(n+1)*(1-x(n+1));
    end
end
hold on
    plot(1:itermax,x(1:itermax))
    plot(1:itermax,x(1:itermax),'o')
fsize=15;
set(gca,'XTick',0:50:itermax,'FontSize',fsize)
set(gca,'YTick',[0,1],'FontSize',fsize)
xlabel('n','FontSize',fsize)
ylabel('\itx_n','FontSize',fsize)
hold off

% End of Program_6a.