function [rc,fval,it] = ARJones_irreg(msnnr,rcinit,pAR,nobs)


opties = optimset('Display','iter','TolX',.001/sqrt(nobs),'TolFun',.0001);
opties = optimset('Display','off');

[rc_tan,fval,exitflag,output]= fminunc('Jonesfit_irreg',tan(.5*pi*rcinit),opties,msnnr,pAR);
rc = 2/pi*atan(rc_tan);
it = output.iterations;
