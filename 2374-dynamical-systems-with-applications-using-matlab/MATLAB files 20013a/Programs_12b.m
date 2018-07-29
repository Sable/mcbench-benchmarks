% Chapter 12 - Bifurcation Theory.
% Programs_12b - Finding Critical Points.
% Copyright Birkhauser 2013. Stephen Lynch.

% Critical points for y=mu*x-x^3.
% Symbolic Math toolbox required.
syms x y
[x,y]=solve('mu*x-x^3','-y')

% Plot a simple bifurcation diagram (Fig. 7.11).
r=0:.01:2;
mu=.28*r.^6-r.^4+r.^2;
plot(mu,r)
fsize=15;
xlabel('\mu','Fontsize',fsize);
ylabel('r','Fontsize',fsize);

% End Programs_12b.