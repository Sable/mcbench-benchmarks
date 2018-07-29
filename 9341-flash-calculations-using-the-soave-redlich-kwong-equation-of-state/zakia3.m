% Authors: Nasri Zakia and Housam Binous

% True Vapor Pressure using the SRK equation of state

function f=zakia3(x)

phi=0;
z=[0.025 0.35 0.60 0.025];
Pc=[709.8 617.4 550.4 489.5];
Tc=[550.0 665.9 765.3 845.6];
w=[0.1064 0.1538 0.1954 0.2387];
T=100+459.67;
Tre=T./Tc;
Pre=x(9)./Pc;
m=0.480+1.574.*w-0.176.*w.^2;
a=(1+m.*(1-Tre.^0.5)).^2;
Ap=0.42747.*a.*Pre./Tre.^2;
Bp=0.08664.*Pre./Tre;
for i=1:4
    for j=1:4
        Ab(i,j)=(Ap(i)*Ap(j))^0.5;
    end
end
Av=0;
for i=1:4
    for j=1:4
        Av=Av+x(i+4)*x(j+4)*Ab(i,j);
    end
end
Bv=0;
for i=1:4
        Bv=Bv+x(i+4)*Bp(i);
end
Bl=0;
for i=1:4
        Bl=Bl+x(i)*Bp(i);
end
Al=0;
for i=1:4
    for j=1:4
        Al=Al+x(i)*x(j)*Ab(i,j);
    end
end
Zv=max(roots([1 -1 Av-Bv-Bv^2 -Av*Bv]));
Zl=min(roots([1 -1 Al-Bl-Bl^2 -Al*Bl]));
phiv=exp((Zv-1).*Bp/Bv-log(Zv-Bv)...
    -Av/Bv*log((Zv+Bv)/Zv).*(2.*Ap.^0.5./Av^0.5-Bp./Bv));
phil=exp((Zl-1).*Bp/Bl-log(Zl-Bl)...
    -Al/Bl*log((Zl+Bl)/Zl).*(2.*Ap.^0.5./Al^0.5-Bp./Bl));
K=phil./phiv;

for i=1:4
    f(i)=x(i+4)-K(i)*x(i);
end
for i=1:4
    f(i+4)=x(i)-z(i)/(1+phi*(K(i)-1));
end
f(9)=0;
for i=1:4
    f(9)=f(9)+z(i)*(K(i)-1)/(1+phi*(K(i)-1));
end
