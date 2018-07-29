function  [yout, nfe] = mmid1(y, dy, xs, htot, nstep, odefun, la, kb, kk0)
% mmid.m is the algoritm for a 'modified midpoint' step in the Bulirsch-Stoer method
% for solving ode's, see W Press ea.in "Numerical Recipes" (1994) p723. This version
% is for parallel processing, see odeintp.m and mmid.m
%
% inputs : at xs(1..np) the dependent variable vector y(1..nv,1..np) and its derivative dy(1..nv,1..np)
% are input, also the total step htot(1..np) to be made  and the number of substeps used (nstep),
% a client function for calculating the derivatives (odefun) with some additional
% parameters la, kb(1..np), kk0 that are used only by odefun.
% 
% output : the estimated vector for the next step yout(1..nv, 1..np) and number of function evaluations (nfe)

% D Vangheluwe 8 mrt 2005, revised 2 may 2005
% remark 1 : we did not take nv = number of variables as input argument as this can also
%   be obtained from the length of vector y or dy.

nv = size(y,1);
nfe = 0;
h = htot/nstep;
ym = y;
hm = repmat(h, nv, 1);
yn = y + hm .* dy;
x = xs + h;
yout = feval(odefun, x, y, la, kb, kk0);
nfe = nfe + 1;
h2 = 2 * hm;
for i = 2: nstep
   swap = ym + h2 .* yout;
   ym = yn;
   yn = swap;
   x = x + h;
   yout = feval(odefun, x, yn, la, kb, kk0);
   nfe = nfe + 1;
end
yout = 0.5 * (ym + yn + hm .* yout);
return
