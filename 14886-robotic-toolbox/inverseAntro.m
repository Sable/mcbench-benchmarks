%% Author: epokh
%% Website: www.epokh.org/drupy
%% This software is under GPL

%% This function implement the inverse kinematics for
%% the antropomorphic arm
%% input: position in 3-D coordinates of the end effector

function [theta1,theta2,theta3]=inverseAntro(px,py,pz,a2,a3)
theta1=[atand(py/px);180+atand(py/px)];
c3=(px^2+py^2+pz^2-a2^2-a3^2)/(2*a2*a3);
s3plus=sqrt(1-c3^2);
s3minus=-sqrt(1-c3^2);

theta3=[atand(s3plus/c3)+90;atand(s3minus/c3)+90];

s2plus=(a2+a3*c3)*pz-a3*s3plus*sqrt(px^2+py^2)/(px^2+py^2+pz^2);
s2minus=(a2+a3*c3)*pz-a3*s3minus*sqrt(px^2+py^2)/(px^2+py^2+pz^2);
c2plus=(a2+a3*c3)*sqrt(px^2+py^2)+a3*s3plus*pz/(px^2+py^2+pz^2);
c2minus=(a2+a3*c3)*sqrt(px^2+py^2)+a3*s3plus*pz/(px^2+py^2+pz^2);

theta2=[atand(s2plus/c2plus);atand(s2minus/c2minus)];

end