function [rc,fval,it] = ARfil_irreg(msnn,rcinit,lagmax,nobs,p)

opties = optimset('Display','iter','TolX',.001/sqrt(nobs),'TolFun',.0001);
opties = optimset('Display','on');

[rc_tan,fval,exitflag,output]= fminunc('ARMLfit_irreg',tan(.5*pi*rcinit),opties,msnn,lagmax,p);
rc = 2/pi*atan(rc_tan);
it = output.iterations;
