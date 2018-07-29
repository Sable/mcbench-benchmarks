function [rc,fval,it] = ARjones(ti,xi,rcinit,p)

nobs = length(xi);

opties = optimset('Display','off','TolX',.001/sqrt(nobs),'TolFun',.0001);

[rc_tan,fval,exitflag,output]= fminunc('Jonesfit',tan(.5*pi*rcinit),opties,ti,xi,p);
rc = 2/pi*atan(rc_tan);
it = output.iterations;
