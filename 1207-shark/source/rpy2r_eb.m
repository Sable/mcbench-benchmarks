function R_eb=rpy2R_eb(rpy)

% R_eb=rpy2R_eb(rpy), computes the rotation matrix of e-frame wrt b-frame,
% given in input a vector containing roll, pitch and yaw angles.

sf = sin(rpy(1));
cf = cos(rpy(1));
st = sin(rpy(2));
ct = cos(rpy(2));
sp = sin(rpy(3));
cp = cos(rpy(3));

R_eb = [         +ct*cp               +ct*sp         -st
        +sf*st*cp-cf*sp      +sf*st*sp+cf*cp      +sf*ct
        +cf*st*cp+sf*sp      +cf*st*sp-sf*cp      +cf*ct ];
