function [ dz ] = odesys( ~,z,param )
% Copyright 2011 The MathWorks, Inc.
% Uses natural frequency (wn) and damping ratio (zeta) to form state
% equations for a standard 2nd order system.  The time derivative of 
% the state vector is:

dz = [0 1; -param.wn^2 -2*param.zeta*param.wn]*z;

end
