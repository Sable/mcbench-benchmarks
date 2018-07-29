% calculate_gravity.m

% Copyright 2003-2010 The MathWorks, Inc.

%use symbolic math for measurement error
syms L g                    %original input variables (length, gravity)
T = 2*pi*sqrt(L/g);         %textbook equation period T=f(L,g)
f = char(finverse(T,g));    %solve for gravity g=f()
expr = strrep(f,'g','T');   %replace g with T in string expression
syms T                      %T variable now, not output function
g = expr                    %desired equation g=f(L,T)
dgdT = diff(g,T);           %partial derivative of g wrt T
dgdL = diff(g,L);           %partial derivative of g wrt L

%replace symbols L and T with numeric values
L = Ro*pixRes(1);       %length of pendulum (m)
T = period;             %period of oscillation (sec)
g0 = eval(char(g));     %calculate gravity (m/sec^2)

%measurement error
dL = Rerr*pixRes(1) + Ro*pixRes(2);             %length error (m)
dT = period*std(diff(t))/mean(diff(t));         %period error (sec)
dg = abs(eval(dgdT))*dT + abs(eval(dgdL))*dL;   %gravity error (m/sec^2)

disp(sprintf('Measured g = %.3g +/- %.2g m/sec^2 (%.2g%%)',g0,dg,dg/g0*100))
