function xdot=vxdot(xu)

% computes state derivatives as a function of state and input

global veh;

   de=xu(12+[1:8]);              % fin angles
   tau_b=xu(12+[9:14]);          % external force and moment wrt b
   tau_e=xu(12+[15:20]);         % external force and moment wrt e
   
   v_cee=xu(12+[21:23]);         % current velocity
   a_cee=xu(12+[24:26]);         % current acceleration

   p=xu(1:6);                    % generalized position (eta)
   v=xu(7:12);                   % generalized velocity (ni)

   % rotation matrix
   R_eb=rpy2R_eb(p(4:6));
   
   % vc and vcdot
   vc=[R_eb*v_cee; zeros(3,1)];
   vcdot=[R_eb*a_cee-vp(v(4:6),R_eb*v_cee); zeros(3,1)];
   
   % state derivative
   pdot=rpy2J(p(4:6))*v;
   vdot=vcdot+veh.iM*(tau_cor(veh,v,v-vc)+tau_damp(veh,v-vc,de)+...
        tau_rest(veh,p)+tau_b+[R_eb*tau_e(1:3);R_eb*tau_e(4:6)]);

   xdot=[pdot;vdot];        % final result
