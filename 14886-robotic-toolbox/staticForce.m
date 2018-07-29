%% Author: epokh
%% Website: www.epokh.org/drupy
%% This software is under GPL

%%Calculate the force/torque needed to produce the force torque needed
%%at the end effector:
%% we now that [T]=[J]'*[F]
%% where F=force\torque of the end effector (in this case only torques)
%% T=forces\torques of the joints (in this case only torques)

function T=staticForce(J6,F)

T=J6'*F;

end