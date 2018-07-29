% transform_to_polar.m

% Copyright 2003-2010 The MathWorks, Inc.

%transform coordinates from cartesian to polar
[th,rho]=cart2pol(X-x0,Y-y0);
Ro=mean(rho);
Rerr=std(rho);
disp(sprintf('Radius %.3g +/- %.2g pixels',Ro,Rerr))

%display angular oscillations & frequency spectrum
figure, subplot(211), plot(t,th), axis tight
xlabel t(sec), ylabel th(rad), title oscillation
TH=fft(th);
Ts=mean(diff(t));
i=1:nFrames;
f=(i-1)/nFrames/Ts;
subplot(212), plot(f(1:end/2),abs(TH(1:end/2))/nFrames)
xlabel f(Hz), ylabel ampl, title spectrum, shg
