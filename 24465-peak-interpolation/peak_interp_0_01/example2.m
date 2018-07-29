%Example demonstrating peak interpolation (finds the peak of a function,
%interpolated between samples using the peak and its two neighbors). 
%This is an example of subample delay estimation:  finding the subsample 
%peak of the cross correlation between a signal and its delayed version.
%Note that this isn't necessarily the best method of delay estimation, it's
%an example of peak interpolation

N_p=128;%number of points in signal
x1=randn(1,N_p);

d=N_p/4*rand;%delay (allows fractional samples)

x2=interp1(-N_p:(2*N_p-1),[x1 x1 x1],(0:(N_p-1))-d,'spline');%delay signal 
%(I know this isn't the proper way to interpolate, but it's close)

[xc lags]=xcorr(x2-mean(x2),x1-mean(x1));

[xc_max idx_max]=max(xc);%find peak of xcorr (to integer sample accuracy)

d_int=lags(idx_max);%delay (integer)

[d_p xc_max_p A_p]=crit_interp_p(xc(idx_max+(-1:1)),lags(idx_max+(-1:1)));
%interpolate peak


bias=-min(xc(idx_max+(-1:1)))+N_p;%add a bias to ensure no negative values
[d_g xc_max_g A_g]=crit_interp_g(xc(idx_max+(-1:1))+bias,lags(idx_max+(-1:1)));
%interpolate peak
xc_max_g=xc_max_g-bias;%remove bias

%plot the curves
N_plot=1000;%number of points to plot
x_plot=linspace(lags(idx_max-2),lags(idx_max+2),N_plot);
y_p=A_p(1)*x_plot.^2+A_p(2)*x_plot+A_p(3);
y_g=A_g(1)*exp(-A_g(2)*(x_plot-A_g(3)).^2)-bias;

fprintf('Delay = %f\nCross-correlation Integer Estimate=%d\nParabolic Estimate=%f\nGaussian Estimate=%f\n',d,d_int,d_p,d_g)

figure(1)
clf
subplot(2,1,1)
plot(lags,xc,'o',x_plot,y_p,'k',x_plot,y_g,'r')
xlabel('delay')
ylabel('cross correlation')
legend('Sampled points','Parabolic interpolation','Gaussian Interpolation','location','Best')

subplot(2,1,2)
plot(lags(idx_max+(-2:2)),xc(idx_max+(-2:2)),'o',x_plot,y_p,'k',x_plot,y_g,'r',d_p, xc_max_p,'kx',d_g, xc_max_g,'rx')
xlabel('delay')
ylabel('cross correlation')
legend('Sampled points','Parabolic Interpolation','Gaussian Interpolation','location','Best')
