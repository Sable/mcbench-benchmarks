%Example demonstrating peak interpolation (finds the peak of a function,
%interpolated between samples using the peak and its two neighbors). 
%This example finds the peak of sin(2*pi*f*x+phi) for unevenly spaced x

N_p=10;%number of points
f=1/N_p;%frequency (relative to sampling frequency)

x=2*pi*rand(1,N_p);
x=sort(x);
y=sin(2*pi*f*x);

x_max_th=N_p/4;%theoretical x for maximum y
y_max_th=1;%theoretical maximum y

[y_max_int idx_max]=max(y);
x_max_int=x(idx_max);%integer estimate of peak position

%do a parabolic estimate
[x_max_p y_max_p A_p]=crit_interp_p(y(idx_max+(-1:1)),x(idx_max+(-1:1)));

%do a Gaussian estimate
[x_max_g y_max_g A_g]=crit_interp_g(y(idx_max+(-1:1)),x(idx_max+(-1:1)));

%plot the curves
N_plot=1000;%number of points to plot
x_plot=linspace(x(idx_max-2),x(idx_max+2),N_plot);
y_th=sin(2*pi*f*x_plot);
y_p=A_p(1)*x_plot.^2+A_p(2)*x_plot+A_p(3);
y_g=A_g(1)*exp(-A_g(2)*(x_plot-A_g(3)).^2);

fprintf('True: y_max=%f at x_max=%f\nParabolic Estimate: y_max=%f at x_max=%f\nGaussian Estimate: y_max=%f at x_max=%f\n',...
    y_max_th,x_max_th,y_max_p,x_max_p,y_max_g,x_max_g)

figure(1)
clf
subplot(2,1,1)
plot(x,y,'o',x_plot,y_th,'g',x_plot,y_p,'k',x_plot,y_g,'r')
xlabel('x')
ylabel('y')
legend('Sampled points','Theoretical Curve','Parabolic interpolation','Gaussian Interpolation','location','Best')

subplot(2,1,2)
plot(x(idx_max+(-1:1)),y(idx_max+(-1:1)),'o',x_plot,y_th,'g',x_plot,y_p,'k',x_plot,y_g,'r',x_max_p, y_max_p,'kx',x_max_g, y_max_g,'rx',x_max_th, y_max_th,'gx')
xlabel('x')
ylabel('y')
legend('Sampled points','Theoretical Curve','Parabolic interpolation','Gaussian Interpolation','location','Best')