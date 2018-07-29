%%%%%%%%%%%%%%%%%
%%%%     SLERP     %%%%%%
%%%%%%%%%%%%%%%%%

%        Sagi Dalyot %

%       This routine aims for calculating a unit quaternion,  describing a rotation matrix,
%       which lies between two known unit quaternions - q1 and q2,
%       using a spherical linear interpolation - Slerp.
%       Slerp follow the shortest great arc on a unit sphere,
%       hence, the shortest possible interpolation path.
%       Consequently, Slerp has constant angular velocity, 
%       so it is the optimal interpolation curve between two rotations.
%       (first published by Sheomake K., 1985 - Animating Rotation with Quaternion Curves)

%       end of file ->  explnation of rotation matrix and quaternions

%       in general:
%       slerp(q1, q2, t) = q1*(sin(1-t)*teta)/sin(t) + q2*(sin(t*teta))/sin(teta)
%       where teta is the angle between the two unit quaternions,
%       and t is between [0,1]

%       two border cases will be delt:
%       1: where q1 = q2 (or close by eps)
%       2: where q1 = -q2 (angle between unit quaternions is 180 degrees).
%       in general, if q1=q2 then Slerp(q; q; t) == q

function [qm] = slerp (qi, qn, t, eps)

%       where qi=[w1 x1 y1 z1] - start unit quaternions
%                      qn=[w2 x2 y2 z2] - end unit quaternions
%                      t=[0 to 1]
%                      eps=threshold value

if t==0 % saving calculation time -> where qm=qi
    qm=qi;
    
elseif t==1 % saving calculation time -> where qm=qn
    qm=qn;
    
else

    C=dot(qi,qn);                  % Calculating the angle beteen the unit quaternions by dot product

    teta=acos(C);

        if (1 - C) <= eps % if angle teta is close by epsilon to 0 degrees -> calculate by linear interpolation
            qm=qi*(1-t)+qn*t; % avoiding divisions by number close to 0

        elseif (1 + C) <= eps % when teta is close by epsilon to 180 degrees the result is undefined -> no shortest direction to rotate
            q2(1) = qi(4); q2(2) = -qi(3); q2(3)= qi(2); q2(4) = -qi(1); % rotating one of the unit quaternions by 90 degrees -> q2
            qm=qi*(sin((1-t)*(pi/2)))+q2*sin(t*(pi/2));

        else
            qm=qi*(sin((1-t)*teta))/sin(teta)+qn*sin(t*teta)/sin(teta);
        end
end


% eof
%  q = [w, (x, y, z)]    quaternion definition
% 
%  where
%  R = [1-2*y^2-2*z^2   2*x*y-2*w*z     2*x*z+2*w*y         R is function of 3  euler rotation angles
%         2*x*y+2*w*z    1-2*x^2-2*z^2   2*y*z-2*w*x
%         2*x*z-2*w*y     2*y*z+2*w*x    1-2*x^2-2*y^2]
%  => R = [M00 M01 M02
%                M10 M11 M12
%                M20 M21 M22]
%  => trace(R) = 4 - 4*(x^2+y^2+z^2), and x^2+y^2+z^2+w^2==1
%  => w=(trace)^.5
%  => x=(M21-M12)/4*w
%  => y=(M02-M21)/4*w
%  => x=(M10-M01)/4*w
%  => q = [w, (x, y, z)]