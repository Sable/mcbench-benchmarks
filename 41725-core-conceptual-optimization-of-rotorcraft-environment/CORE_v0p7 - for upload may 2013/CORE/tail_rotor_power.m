function P = tail_rotor_power(TORQ,AC,tState)
% Assumptions:
FinBlockage = .08;
InducedPowerFact = 1.1;
BladeProfileCD = .009;

V = tState.V;
FTRreq = (1+FinBlockage)*TORQ/AC.TRotor.X;
Vitail = sqrt(-(V.^2)/2+sqrt(((V.^2)/2).^2+(FTRreq./(2.*tState.rho.*AC.TRotor.DA)).^2));

Pind = InducedPowerFact*FTRreq*Vitail;

Ab = AC.TRotor.sigma*AC.TRotor.DA;
mu = tState.V/AC.TRotor.TS;
Pprof = tState.rho*Ab*(AC.TRotor.TS^3)*BladeProfileCD*(1+3*mu)/8;

P = Pprof + Pind;