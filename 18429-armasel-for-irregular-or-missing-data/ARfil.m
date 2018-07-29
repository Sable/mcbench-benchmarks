function [rc,fval,it] = ARfil(im,xm,rcinit,lagmax,p)

nobs = length(xm);

opties = optimset('Display','off','TolX',.001/sqrt(nobs),'TolFun',.0001);

[rc_tan,fval,exitflag,output]= fminunc('ARMA_MLfit',tan(.5*pi*rcinit),opties,im,xm,lagmax,p);
rc = 2/pi*atan(rc_tan);
it = output.iterations;
