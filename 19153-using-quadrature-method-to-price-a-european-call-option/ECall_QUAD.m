function [OptionValue] = ECall_QUAD(S0,T,E,r,sig,D)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dt = T;
x = log(S0/E);
k = (r-D)/(0.5*sig^2) - 1;
% let y = log(S_T/E)
% payoff function: Max(S_T-E,0) --> E*Max(e^y-1,0)
% For an European call option, we only integrate from 0 to inf.
dy = sqrt(dt) / 4;
ymax = log(S0/E) + 10*sig*sqrt(T); % Upper bound of integration range to approximate inf
NPlus = round( (ymax-0)/dy );
A = exp( (-0.5*k*x-0.125*dt*(sig*k)^2-r*dt) ) / sqrt(2*pi*dt*sig^2);
int = 0;
%%%%%%%%%%%%%%%%%%%%%%
for i = 0:NPlus-1
    for ii = 1:2
        y(i+1,ii) = 0 + ( i + 0.5*(ii-1) )*dy;
        V(i+1,ii) = E*(exp(y(i+1,ii))-1);              
        Bxy(i+1,ii) = exp(0.5*k*y(i+1,ii)-(x-y(i+1,ii))^2/(2*dt*sig^2));
        f = Bxy(i+1,ii)*V(i+1,ii);
        if ( i==0 & ii ==1)
            int = int + f;
        elseif ( i==0 & ii ==2)
            int = int + 4*f;
        elseif ( i~=0 & ii ==2)
            int = int + 4*f;
        else
            int = int + 2*f;
        end
    end
end
y(NPlus+1,1) = 0 + NPlus*dy;
V(NPlus+1,1) = E*(exp(y(NPlus+1,1))-1);              
Bxy(NPlus+1,1) = exp(0.5*k*y(NPlus+1,1)-(x-y(NPlus+1,1))^2/(2*dt*sig^2));
f = Bxy(NPlus+1,1)*V(NPlus+1,1);
int = int + f;
%%%%%%%%%%%%%%%%
OptionValue = A*(dy/6)*int;