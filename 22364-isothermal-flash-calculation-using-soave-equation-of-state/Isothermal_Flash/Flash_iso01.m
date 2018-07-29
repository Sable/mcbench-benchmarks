%-------------------------------------------------------------------------%
% Isothermal flash calculation using Soave equation of state 
% Author: Arnulfo Rosales-Quintero
% Email: arnol122@gmail.com 
% Main program calls function Flash_iso01

%This function solves the isothermal flash using two loops

%The inner loop solves the Rachford Rice equation.

%The outer loop minimize the difference between liquid and vapor
%fugacities for the mixture

%-------------------------------------------------------------------------%
function [beta,x,y] = Flash_iso01(nc,z,P,T)
%-------------------------------------------------------------------------%
    global nc xy01 beta01
    global EDO PT PT01    
    global Pc Tc w R
%-------------------------------------------------------------------------%
%Feed composition normalization
    z=z/sum(z(1:nc))
%-------------------------------------------------------------------------%   
%Initial values for the phase equilibria constant
   for i=1:nc
        K(i) = Pc(i)/P*exp(5.37*(1+w(i))*(1-Tc(i)/T));
   end
%-------------------------------------------------------------------------%
%Equation of State constants
switch EDO
    case ('SRK')
        m1=0.48000; m2=1.57400; m3=-0.17600;
        omega_a=0.42748;    omega_b=0.08664;
end
%-------------------------------------------------------------------------%
for i=1:nc
    %Reduced temperature and pressure
    Tr(i) = T/Tc(i);   Pr(i) = P/Pc(i);
    %Physical constants
    m(i)     = m1 + m2*w(i) + m3*w(i)^2;
    alpha(i) = (1.0 + m(i)*(1.0 - sqrt(Tr(i)))).^2;
    ac(i) = omega_a*(R*Tc(i)).^2/Pc(i);
    a(i)  = ac(i)*alpha(i);
    b(i)  = omega_b*(R*Tc(i))/Pc(i);
end
%-------------------------------------------------------------------------%
%Isothermal flash calculations
beta = 0.9;
epsilon1 = 1.0;	iter = 1;
while (epsilon1>=1.e-07)
	%++ ------------------------------------------------------------------%
	epsilon=1.0;
	while (epsilon >=1.e-07)	
		rc=0.0;		drc=0.0;
		for i=1:nc
		%Rachford-Rice Equation
			rc  = z(i)*(K(i)-1.0)/(1.0+beta*(K(i)-1.0))+rc;
		%Derivative of Rachford-Rice Equation
			drc = z(i)*(K(i)-1.0)^2/(1.0+beta*(K(i)-1.0))^2+drc;
		end
		drc=-drc;
	%---------------------------------------------------------------------%
	%					 Newton-Raphson
					 betan  = beta - (rc / drc);
	%---------------------------------------------------------------------%
        epsilon = abs( (betan-beta)/beta );	%Convergence
        beta = betan;
    end
	%++ ------------------------------------------------------------------%
	for i=1:nc
	   x(i) = z(i)/(1.0 + beta*(K(i)-1.0));
	   y(i) = K(i)*x(i);
	end
	%---------------------------------------------------------------------%
	for i=1:nc; 
		if (x(i)<0.0); x(i) = 1.0e-05; end;	
		if (y(i)<0.0); y(i) = 1.0e-05; end;	
	end
	x=x/sum(x(1:nc));		y=y/sum(y(1:nc));	
	%---------------------------------------------------------------------%
    %Vapor fugacity coeficcient 
    [phiv,Vv] = Phi(P,T,y,a,b,'vapor');
    %Liquid fugacity coeficcient 
    [phil,Vl] = Phi(P,T,x,a,b,'liquid');
	%---------------------------------------------------------------------%
    suma=0;
	for i=1:nc
	   Fv(i)  = y(i)*phiv(i)*P;
	   Fl(i)  = x(i)*phil(i)*P;
	   lnF(i) = log(Fv(i)/Fl(i));
	   Kn(i)  = K(i)*(Fl(i)/Fv(i));
       suma   = lnF(i) + suma;
    end
    %Convergence criteria
	epsilon1  = abs(suma/nc);
	K(1:nc)   = Kn(1:nc);
	%---------------------------------------------------------------------%
	iter = iter + 1;
end
%-------------------------------------------------------------------------%
	Suma = sum(x(1:nc)); x = x / Suma;
	Suma = sum(y(1:nc)); y = y / Suma;
%-------------------------------------------------------------------------%