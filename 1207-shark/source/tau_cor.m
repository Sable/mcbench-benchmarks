function tc=tau_cor(veh,v,vr)

% tc=tau_cor(veh,v,vr) calculates coriolis forces from 
% vehicle variables and generalized velocities v and vr


Crb=[ zeros(3,3),           -vp(veh.Mrb(1:3,:)*v);
     -vp(veh.Mrb(1:3,:)*v), -vp(veh.Mrb(4:6,:)*v)];

Ca= [ zeros(3,3),           -vp(veh.Ma(1:3,:)*vr);
     -vp(veh.Ma(1:3,:)*vr), -vp(veh.Ma(4:6,:)*vr)];

tc=Crb*v+Ca*vr;
