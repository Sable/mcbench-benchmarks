%% update_vel_pos(p,n);
function update_vel_pos()
global vel El El_lim_up El_lim_low
global n w k_pb_i R iteration k_pb_f  k_gb_i k_gb_f k_pb k_gb c_gb c_pb delta_t;
global NumVer p pbest_loc gbest_loc
R = n /iteration;
k_pb = k_pb_i + R*(k_pb_f - k_pb_i);
k_gb = k_gb_i + R*(k_gb_f - k_gb_i);
c_pb = rand*k_pb;
c_gb = rand*k_gb;  

      vel(1,1:NumVer,p) = w*vel(1,1:NumVer,p) + c_pb*(pbest_loc(1,1:NumVer,p) - El(1,1:NumVer,p)) + c_gb*(gbest_loc(1,1:NumVer) - El(1,1:NumVer,p));

%Velocity Upper Bound Velocity Lower Bound
     for chgdir=1:NumVer
      if((vel(1,chgdir,p) > (El_lim_up(1,chgdir) - El(1,chgdir,p))))
          vel(1,chgdir,p) = -0.5*vel(1,chgdir,p);%(El_lim_up(1,1:NumVer) - El(1,1:NumVer,p));%             x(i)=x(i)+2*v(i);
      end
      if((vel(1,chgdir,p) < (El_lim_low(1,chgdir) - El(1,chgdir,p))))
          vel(1,chgdir,p) = -0.5*vel(1,chgdir,p);%(El_lim_up(1,1:NumVer) - El(1,1:NumVer,p));
      end
     end
      
 El(1,1:NumVer,p)= El(1,1:NumVer,p)+delta_t*vel(1,1:NumVer,p);
end