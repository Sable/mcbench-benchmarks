function K = Abrarov2010CPC(x,y,tau,N)
% This is an approximation of the Voigt function within the Humlicek
% regions 3 and 4. The approximation is one given by S.M. Abrarov et. al.
% "High-accurace approximation of the complex probability function by
% Fourier expansion of exponential multiplier" (2010).
% x = sqrt(ln(2))*(nu - nu0)/alphaD
% y = sqrt(ln(2))*alphaL/alphaD
% where 'ln' denotes the natural log, nu the wavenumber, nu0 the wavenumber
% at center, alphaD and alphaL the Doppler and Lorentzian half-width at
% half-maximum.
% Suggested values for N & tau are 23 and 12 respectively.

if nargin == 2
    tau = 12;
    N = 23;
end

K = zeros(size(x));
a = zeros(1,N);
for c = 1:length(x)
    summation = 0;
    for n = 0:N
        a(n+1) = 2*sqrt(pi)/tau*exp(-(n*pi/tau)^2);
        first = ((1i*n*pi*tau+tau^2*y)*(1-exp(-(1i*n*pi+tau*y))*cos(tau*x(c))) + exp(-(1i*n*pi+tau*y))*tau^2*x(c)*sin(tau*x(c)))/(tau^2*x(c)^2 - (n*pi - 1i*tau*y)^2);
        second = ((1i*n*pi*tau-tau^2*y)*(1-exp(1i*n*pi-tau*y)*cos(tau*x(c))) - exp(1i*n*pi-tau*y)*tau^2*x(c)*sin(tau*x(c)))/(tau^2*x(c)^2 - (n*pi + 1i*tau*y)^2);
        summation = summation + a(n+1)*(first - second);
    end
    third = (y-exp(-(tau*y))*(y*cos(tau*x(c))-x(c)*sin(tau*x(c))))/(2*sqrt(pi)*(x(c)^2+y^2));
    K(c) = summation/(2*sqrt(pi)) - a(1)*third;
end