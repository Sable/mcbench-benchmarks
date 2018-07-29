[v1,v2,v3]=vehicle; global veh; veh=v2;

x0=[zeros(6,1);3;zeros(5,1)];
u0=[zeros(8,1);416;zeros(17,1)];

[A,B,C,D]=linmod('xtrlmod',x0,u0);
[a,b,c,d]=ssselect(A,B,C,D,1:8,4:6,[4:12]);

Q=diag([20 20 20 ones(1,6)]);
R=eye(size(b,2));

K=lqr(a,b,Q,R);

save abcdk a b c d K