function ydot=goveqn2(t,y)

global Pe Da

ydot(1)=y(2);
ydot(2)=Pe*y(2)+Pe*Da*y(1)^2;

ydot=ydot';

