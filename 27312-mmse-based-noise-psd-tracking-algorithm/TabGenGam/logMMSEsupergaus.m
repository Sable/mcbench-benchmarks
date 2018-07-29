nu=0.2;vec=[];
xi=10^(0/10);
vec=[];
zeta=10.^((-10:1:15)/10);
for I=1:150
R=I;vec(I,:)=((gamma(nu+R)*psi(nu+R)-gamma(nu+R)*psi(nu))/(2*gamma(nu)*(factorial(R)^2)))*(((xi.*zeta./(xi+nu))).^R);
end
vec2=ConflHyperGeomFun(nu,1,(xi.*zeta./(xi+nu))).';
G=sqrt((xi./(zeta*((xi+nu))))) .*exp(0.5*psi(nu)+(sum(vec,1))./vec2.');

TEMP=xi/(xi+1);G2=TEMP.*exp(0.5*ei(TEMP.*zeta));