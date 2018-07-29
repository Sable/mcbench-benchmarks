function Mb=m2m(Ma,T)

% Mb=m2m(Ma,T) generalized mass transformation.
% Trasforms generalized mass with respect to coordinate frame a,
% in the generalized mass with respect to coordinate frame b.
% 
% Generalized mass with respect to coordinate frame x, 
% is a 6 by 6 matrix defined like this : 
% 
%      [ eye(3,3)*m , -S(cx)*m ] 
% Mx = [                       ] 
%      [    S(cx)*m ,       Ix ] 
% 
% Where m is the mass of the body, cx its center of mass,
% and Ix its inertia tensor (both with respect to x).
% S(v) = [0 -v3 v2; v3 0 -v1; -v2 v1 0] is the cross 
% product matrix of v. 
% 
% The transformation matrix T between b and a coordinate
% frames is a 4 by 4 matrix such that:
% T(1:3,1:3) = Orientation matrix between b and a = unit vectors
%              of x,y,z axes of b expressed in the a coordinates.
% T(1:3,4)   = Origin of b expressed in a coordinates.
% T(4,1:3)   = zeros(1,3)
% T(4,4)     = 1
% 
% Example (see also x2t and t2x):
% m1=rand*eye(3);m2=rand(3);m3=rand(3);
% M=[m1 (m2-m2')/2;(m2'-m2)/2 (m3+m3')/2];
% x=[rand(3,1);1;rand(3,1);0];m=m2m(M,x2t(x,'rpy'));
% M-m2m(m,inv(x2t(x,'rpy')))
% 
% 
% Giampiero Campa 06/11/96

if [ size(Ma)==[6 6] size(T)==[4 4] ],

m=trace(Ma(1:3,1:3))/3;
ca=[Ma(2,6)+Ma(6,2)-Ma(5,3)-Ma(3,5); Ma(4,3)+Ma(3,4)-Ma(1,6)-Ma(6,1); Ma(1,5)+Ma(5,1)-Ma(2,4)-Ma(4,2)]/4/m;
Ia=Ma(4:6,4:6);

cb=inv(T)*[ca;1];

if norm(Ia-Ia')>1e-10
    disp('   ');
    disp('M2M warning: non symmetrical Ia tensor');
    disp('   ');
end

Ia=(Ia+Ia')/2;
R=T(1:3,1:3);
Ob=T(1:3,4);

Ib=R'*(Ia+m*((Ob-2*ca)'*Ob*eye(3,3)+Ob*(ca-Ob)'+ca*Ob'))*R;

Mb=[eye(3,3)*m,-vp(cb,m);vp(cb,m),Ib];

else

disp('   ');
disp('   Mb=m2m(Ma,T)');
disp('   where Ma is 6 by 6 and T is 4 by 4, (see help for details)');
disp('   ');

end

function z=vp(x,y)

% z=vp(x,y); z = 3d cross product of x and y
% vp(x) is the 3d cross product matrix : vp(x)*y=vp(x,y).
%
% by Giampiero Campa.  

z=[  0    -x(3)   x(2);
    x(3)    0    -x(1);
   -x(2)   x(1)    0   ];

if nargin>1, z=z*y; end
