function r = rcPulse(Ts, Nos, alpha)

t1 = [-8*Ts:Ts/Nos:-Ts/Nos];
t2 = [Ts/Nos:Ts/Nos:8*Ts];

r1 = (sin(pi*t1/Ts)./(pi*t1)).*(cos(pi*alpha*t1/Ts)./(1-(4*alpha*t1/(2*Ts)).^2));
r2 = (sin(pi*t2/Ts)./(pi*t2)).*(cos(pi*alpha*t2/Ts)./(1-(4*alpha*t2/(2*Ts)).^2));

r = [r1 1/Ts r2];