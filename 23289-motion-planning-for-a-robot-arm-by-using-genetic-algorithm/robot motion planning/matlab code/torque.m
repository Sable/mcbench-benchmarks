function rr=torque(kk)
q1=kk(1,:);
q2=kk(2,:);
qd1=kk(3,:);
qd2=kk(4,:);
qdd1=kk(5,:);
qdd2=kk(6,:);
l1=1;l2=1;m1=1;m2=1;g=9.81;
g2=g*m2*l2*cos(q1+q2);
g1=g*(m1+m2)*l1*cos(q1)+g2;
c=m2*l1*l2*sin(q2);
dc=m2*((l2^2)+2*l1*l2*cos(q2));
d2=m2*l2^2;
d1=m1*(l1^2)+m2*(l1^2+l2^2+2*l1*l2*cos(q2));
t2=dc.*qdd1+d2.*qdd2+c.*qd1.^2+g2;
t1=d1.*qdd1+dc.*qdd2-c.*qd2.^2-2*c.*qd1.*qd2+g1;
rr=[t1;t2];

