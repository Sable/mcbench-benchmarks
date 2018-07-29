% Chapter 2 - Nonlinear Discrete Dynamical Systems.
% Program 2d - Bifurcation Diagram of the Logistic Map.
% Copyright Birkhauser 2013. Stephen Lynch.

% Plot a bifurcation diagram (Figure 2.15).
% Plot 30 points for each r value.
clear
itermax=100;
finalits=30;finits=itermax-(finalits-1);
for r=0:0.005:4
    x=0.4;
    xo=x;
    for n=2:itermax
        xn=r*xo*(1-xo);
        x=[x xn];
        xo=xn;
    end
    plot(r*ones(finalits),x(finits:itermax),'.','MarkerSize',1)
    hold on
end
fsize=15;
set(gca,'XTick',0:1:4,'FontSize',fsize)
set(gca,'YTick',0:0.2:1)
xlabel('{\mu}','FontSize',fsize)
ylabel('\itx','FontSize',fsize)
hold off

% End of Program 2d.