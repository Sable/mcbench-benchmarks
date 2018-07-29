function T=x2t(x,str)

% T=x2t(x,str)
% 
% Converts a generalized position vector x, which contains
% position and orientation vectors of B with respect to A,
% into transformation matrix T between B and A coordinate frames.
% Orientation can be expressed with quaternions, euler angles
% (xyz or zxz convention), unit vector and rotation angle.
% Also both orientation and position can be expressed with
% Denavitt-Hartemberg parameters.
% 
% ---------------------------------------------------------------------------
% 
% The transformation matrix T between B and A coordinate
% frames is a 4 by 4 matrix such that:
% T(1:3,1:3) = Orientation matrix between B and A = unit vectors
%              of x,y,z axes of B expressed in the A coordinates.
% T(1:3,4)   = Origin of B expressed in A coordinates.
% T(4,1:3)   = zeros(1,3)
% T(4,4)     = 1
%
% ---------------------------------------------------------------------------
% 
% The generalized position vector x contains the origin of B
% expressed in the A coordinates in the first four entries,
% and orientation of B with respect to A in the last four entries.
% In more detail, its shape depends on the value of str as 
% specified below :
% 
% ---------------------------------------------------------------------------
% 
% str='van' : UNIT VECTOR AND ROTATION ANGLE 
% 
%           [ Ox ]     origin of the B coordinate frame    
%  x(1:4) = [ Oy ]     with respect to A.
%           [ Oz ]     
%           [  1 ]     
% 
%           [ Vx ]     Vx,Vy,Vz = unit vector respect to A, 
%  x(5:8) = [ Vy ]     which B is rotated about.
%           [ Vz ]     
%           [ Th ]     Th = angle which B is rotated (-pi,pi].
% ---------------------------------------------------------------------------
% 
% str='qua' : UNIT QUATERNION 
% 
%           [ Ox ]     origin of the B coordinate frame    
%  x(1:4) = [ Oy ]     with respect to A.
%           [ Oz ]     
%           [  1 ]     
% 
%           [ q1 ]     q1,q2,q3 = V*sin(Th/2)
%  x(5:8) = [ q2 ]     q0 = cos(Th/2) where :
%           [ q3 ]     V = unit vector respect to A, which B is 
%           [ q0 ]     rotated about, Th = angle which B is rotated (-pi,pi].
% ---------------------------------------------------------------------------
% 
% str='erp' : EULER-RODRIGUEZ PARAMETERS
% 
%           [ Ox ]     origin of the B coordinate frame    
%  x(1:4) = [ Oy ]     with respect to A.
%           [ Oz ]     
%           [  1 ]     
% 
%           [ r1 ]     r1,r2,r3 = V*tan(Th/2), where :
%  x(5:8) = [ r2 ]     V = unit vector with respect to A, which B is 
%           [ r3 ]     rotated about.
%           [  0 ]     Th = angle which B is rotated (-pi,pi) (<> pi).
% ---------------------------------------------------------------------------
% 
% str='rpy' : ROLL, PITCH, YAW ANGLES (euler x-y-z convention) 
% 
%           [ Ox ]     origin of the B coordinate frame    
%  x(1:4) = [ Oy ]     with respect to A.
%           [ Oz ]     
%           [  1 ]     
% 
%            [ r ]     r = roll angle  ( fi    (-pi,pi], about x,          )
%  x(5:8) =  [ p ]     p = pitch angle ( theta (-pi,pi], about y, <> +-pi/2)
%            [ y ]     y = yaw angle   ( psi   (-pi,pi], about z,          )
%            [ 0 ]     
% ---------------------------------------------------------------------------
% 
% str='rpm' : ROTATION, PRECESSION, MUTATION ANGLES (euler z-x-z convention) 
% 
%           [ Ox ]     origin of the B coordinate frame    
%  x(1:4) = [ Oy ]     with respect to A.
%           [ Oz ]     
%           [  1 ]     
% 
%            [ r ]     r = rotation angle   ( (-pi,pi] ,about z           )
%  x(5:8) =  [ p ]     p = precession angle ( (-pi,pi] ,about x , <> 0,pi )
%            [ y ]     y = mutation angle   ( (-pi,pi] ,about z           )
%            [ 0 ]     
% ---------------------------------------------------------------------------
% 
% str='dht' : DENAVITT-HARTEMBERG PARAMETERS 
% 
%            [ b ]                [ a ]     this four-parameter 
%  x(1:4) =  [ d ] ,   x(5:8) =   [ t ] ,   description does not involve
%            [ 0 ]                [ 0 ]     a loss of information if and 
%            [ 0 ]                [ 0 ]     only if T has this shape:
% 
%           [    ct   -st     0     b ]     where : 
%  T =      [ ca*st ca*ct   -sa -d*sa ]     
%           [ sa*st sa*ct    ca  d*ca ]     sa = sin(a), ca = cos(a)
%           [     0     0     0     1 ]     st = sin(t), ct = cos(t)
% ---------------------------------------------------------------------------
% 
% Example (see also t2x):
% x=[rand(3,1);1;rand(3,1);0];x-t2x(x2t(x,'rpm'),'rpm')
% 
% Giampiero Campa 1/11/96
% 

rnd=0;

if [ str=='van' size(x)==[8 1] ],

th=x(8);
v=x(5:7);
O=x(1:3);

if norm(v) < 1e-10
    disp(' ');
    disp('x2T warning: zero lenght vector, direction assumed to be [0 0 1]''.');
    disp(' ');
    v=[0 0 1]';
end

v=v/norm(v);
R=(cos(th)*eye(3,3)+(1-cos(th))*v*v'-sin(th)*vp(v))';

% This was simpler but a little bit slower
% R=expm(vp(v,th));

T=[ R, O; 0 0 0 1 ];
if rnd,T=round(T*1e14)/1e14;end

% ---------------------------------------------------------------------------
% UNIT QUATERNION 

elseif [ str=='qua' size(x)==[8 1] ],

q=x(5:8);
O=x(1:3);

if norm(q) < 1e-10
    disp(' ');
    disp('x2T warning: zero lenght vector, direction assumed to be [0 0 0 1]''.');
    disp(' ');
    q=[0 0 0 1]';
end

q=q/norm(q);

qv=q(1:3);
q0=q(4);

R=((q0'*q0-qv'*qv)*eye(3,3)+2*(qv*qv'-q0*vp(qv)))';

T=[ R, O; 0 0 0 1 ];
if rnd,T=round(T*1e14)/1e14;end

% ---------------------------------------------------------------------------
% EULER-RODRIGUEZ PARAMETERS

elseif [ str=='erp' size(x)==[8 1] ],

r=x(5:7);
O=x(1:3);

S=vp(r);
R=(eye(3,3)+2/(1+r'*r)*S*(S-eye(3,3)))';

T=[ R, O; 0 0 0 1 ];
if rnd,T=round(T*1e14)/1e14;end

% ---------------------------------------------------------------------------
% ROLL, PITCH, YAW ANGLES (euler x-y-z convention) 

elseif [ str=='rpy' size(x)==[8 1] ],

O=x(1:3);
r=x(5);
p=x(6);
y=x(7);

R=expm(vp([0 0 1]',y))*expm(vp([0 1 0]',p))*expm(vp([1 0 0]',r));

T=[ R, O; 0 0 0 1 ];
if rnd,T=round(T*1e14)/1e14;end

% ---------------------------------------------------------------------------
% ROTATION, PRECESSION, MUTATION ANGLES (euler z-x-z convention) 

elseif [ str=='rpm' size(x)==[8 1] ],

O=x(1:3);
r=x(5);
p=x(6);
m=x(7);

R=expm(vp([0 0 1]',r))*expm(vp([1 0 0]',p))*expm(vp([0 0 1]',m));

T=[ R, O; 0 0 0 1 ];
if rnd,T=round(T*1e14)/1e14;end

% ---------------------------------------------------------------------------
% DENAVITT-HARTEMBERG PARAMETERS 

elseif [ str=='dht' size(x)==[8 1] ],

ca=cos(x(5));
sa=sin(x(5));
ct=cos(x(6));
st=sin(x(6));
b=x(1);
d=x(2);

T=[    ct   -st   0     b
    ca*st ca*ct -sa -d*sa
    sa*st sa*ct  ca  d*ca
        0     0   0     1];
if rnd,T=round(T*1e14)/1e14;end

% ---------------------------------------------------------------------------
% OTHER STRING

else

disp('   ');
disp('   T=x2T(x,str)');
disp('   where x is an 8 by 1 vector (see help for details)');
disp('   and str can be : ''van'',''qua'',''erp'',''rpy'',''rpm'',''dht''. ');
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
