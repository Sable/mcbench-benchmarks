% -------------------------------------------------------------------------
% duff.m
% Duffing oscillator with noise.
% Dependencies: noise.m
% -------------------------------------------------------------------------

function xdot = duff(t,x,gam,alpha,beta,A,w0,n)

xdot(1) = x(2);

xdot(2) = -gam*x(2) - alpha*x(1)^3 + beta*x(1) + ...
    A*sin(w0*t) + sqrt(n)*noise(t); 

xdot = xdot(:); 
