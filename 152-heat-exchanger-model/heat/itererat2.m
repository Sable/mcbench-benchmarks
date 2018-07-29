function [aus, dtlg, tvut, tkut] = itererat2(dtlg,par)

rho = par(1);
cp = par(2);
Fk = par(3);
Fv = par(4);
k = par(5);
tkin = par(6);
tvin = par(7);
A = par(8);

mk = rho*Fk;
mv = rho*Fv;

tkut = dtlg*k*A/mk/cp + tkin;
tvut = -(mk*cp/(mv*cp)*(tkut-tkin)-tvin);

a = tvin-tkut;
b = tvut-tkin;
if (a == b), a = a*1.000001; end %Billigt och fel, men vad fan...


dtlny = (a-b)/log(a/b);

aus = dtlny-dtlg;
