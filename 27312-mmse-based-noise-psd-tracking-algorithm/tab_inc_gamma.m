function [G ]=tab_inc_gamma(Rprior,par);
 
Rprior=10.^(Rprior(:)/10);
 

G=gammainc(1./(1+Rprior),2);
