%% ITERERAT - itererar fram kallt vattens uttemp (och även varmt)
%%
%%

function [aus, tkutg, tvut, dtl1] = itererat(tkutg,par)

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

tvut = -(mk*cp/(mv*cp)*(tkutg-tkin)-tvin);

a = tvin-tkutg;
b = tvut-tkin;
if (a == b), a = a*1.000001; end %Billigt och fel, men vad fan...
dtl1 = (a-b)/log(a/b);
dtl2 = mk*cp*(tkutg-tkin)/k/A;

aus = dtl1-dtl2;
