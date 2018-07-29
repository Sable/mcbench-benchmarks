function [K,tau,td]=ReactionCurve(t,y)
K=y(end)-y(1);
dy=diff(y);
dt=diff(t);
[mdy,I]=max(abs(dy./dt));
mdy=sign(K)*mdy;
tau=K/mdy;
td=t(I)-(y(I)-y(1))/mdy;
plot(t,y,[td td+tau],[y(1) y(end)]);
