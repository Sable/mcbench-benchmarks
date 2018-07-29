function tt=torque3(kk)
q1=kk(1,:);
q2=kk(2,:);
q3=kk(3,:);
vq1=kk(4,:);
vq2=kk(5,:);
vq3=kk(6,:);
aq1=kk(7,:);
aq2=kk(8,:);
aq3=kk(9,:);
l1=1;l2=1;l3=0.5;
m1=1;m2=1;m3=0.5;
g=9.81;
t3= m3.*(l2.*(aq1+aq2).*cos(q3)+l2.*(vq1+vq2).^2.*sin(q3)+l1.*aq1.*cos(q2+q3)+l1.*vq1.^2.*sin(q2+q3)+g.*cos(q1+q2+q3)+l3.*(aq1+aq2+aq3)).*l3;
t2= t3+l2.*m2.*(l2.*(aq1+aq2)+l1.*aq1.*cos(q2)+l1.*vq1.^2.*sin(q2)+g.*cos(q1+q2))+l2.*(sin(q3).*m3.*(l2.*(aq1+aq2).*sin(q3)-l2.*(vq1+vq2).^2.*cos(q3)+l1.*aq1.*sin(q2+q3)-l1.*vq1.^2.*cos(q2+q3)+g.*sin(q1+q2+q3)-l3.*(vq1+vq2+vq3).^2)+cos(q3).*m3.*(l2.*(aq1+aq2).*cos(q3)+l2.*(vq1+vq2).^2.*sin(q3)+l1.*aq1.*cos(q2+q3)+l1.*vq1.^2.*sin(q2+q3)+g.*cos(q1+q2+q3)+l3.*(aq1+aq2+aq3)));
t1= t2+l1.*m1.*(l1.*aq1+g.*cos(q1))+l1.*(sin(q2).*(cos(q3).*m3.*(l2.*(aq1+aq2).*sin(q3)-l2.*(vq1+vq2).^2.*cos(q3)+l1.*aq1.*sin(q2+q3)-l1.*vq1.^2.*cos(q2+q3)+g.*sin(q1+q2+q3)-l3.*(vq1+vq2+vq3).^2)-sin(q3).*m3.*(l2.*(aq1+aq2).*cos(q3)+l2.*(vq1+vq2).^2.*sin(q3)+l1.*aq1.*cos(q2+q3)+l1.*vq1.^2.*sin(q2+q3)+g.*cos(q1+q2+q3)+l3.*(aq1+aq2+aq3))+m2.*(-l2.*(vq1+vq2).^2+l1.*aq1.*sin(q2)-l1.*vq1.^2.*cos(q2)+g.*sin(q1+q2)))+cos(q2).*(sin(q3).*m3.*(l2.*(aq1+aq2).*sin(q3)-l2.*(vq1+vq2).^2.*cos(q3)+l1.*aq1.*sin(q2+q3)-l1.*vq1.^2.*cos(q2+q3)+g.*sin(q1+q2+q3)-l3.*(vq1+vq2+vq3).^2)+cos(q3).*m3.*(l2.*(aq1+aq2).*cos(q3)+l2.*(vq1+vq2).^2.*sin(q3)+l1.*aq1.*cos(q2+q3)+l1.*vq1.^2.*sin(q2+q3)+g.*cos(q1+q2+q3)+l3.*(aq1+aq2+aq3))+m2.*(l2.*(aq1+aq2)+l1.*aq1.*cos(q2)+l1.*vq1.^2.*sin(q2)+g.*cos(q1+q2))));
tt=[t1;t2;t3];