function Stall_margin = retreating_stall_envelope(mu_act,Cts_act)
% Datum Rotor Coefficients (mu verus Cw/s)      High Speed Rotor Coefficients (mu verus Cw/s)			
% a:	-7.6568	Squared term                    a:	-7.4029	Squared term	
% b:	0.2992	Linear term                     b:	1.2392	Linear term	
% c:	0.5357	Constant                        c:	0.4827	Constant	

highspeed = 0; %0: datum; 1: high speed

% Datum Rotor Coefficients (mu verus Cw/s)      
Cdat=[-7.6568   ;     
0.2992;              
0.5357];	

% High Speed Rotor Coefficients (mu verus Cw/s)			
Chs=[-7.4029	;	
1.2392	;
0.4827	];	

C = highspeed*Chs+(1-highspeed)*Cdat;
a = C(1); b = C(2); c = C(3);


Cts_act=Cts_act*2; %because of the way to find Ct in the place where this data comes from (with a 1/2 in Ct calc)

mu_all = a*Cts_act.^2+Cts_act*b+c;

Cts_all = (-b-sqrt(b^2-4*a*(c-mu_act)))/(2*a);

Stall_margin = (mu_all-mu_act)/abs(mu_all);
if isreal(Cts_all)
    Ct_margin = (Cts_all-Cts_act)/abs(Cts_all);
    Stall_margin = (Stall_margin+Ct_margin)/2;
else
    Stall_margin = -abs(Stall_margin);
end
