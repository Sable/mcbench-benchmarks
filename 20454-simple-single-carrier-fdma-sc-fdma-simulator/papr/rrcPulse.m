function r = rrcPulse(Ts, Nos, alpha)

t1 = [-6*Ts:Ts/Nos:-Ts/Nos];
t2 = [Ts/Nos:Ts/Nos:6*Ts];

r1 = (4*alpha/(pi*sqrt(Ts)))*(cos((1+alpha)*pi*t1/Ts)+(Ts./(4*alpha*t1)).*sin((1-alpha)*pi*t1/Ts))./(1-(4*alpha*t1/Ts).^2);
r2 = (4*alpha/(pi*sqrt(Ts)))*(cos((1+alpha)*pi*t2/Ts)+(Ts./(4*alpha*t2)).*sin((1-alpha)*pi*t2/Ts))./(1-(4*alpha*t2/Ts).^2);

r = [r1 (4*alpha/(pi*sqrt(Ts))+(1-alpha)/sqrt(Ts)) r2];