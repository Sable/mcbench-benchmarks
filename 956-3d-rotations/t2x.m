function x=t2x(T,str)

% x=t2x(T,str);
% 
% Converts transformation matrix T between B and A coordinate
% frames into a generalized position vector x, which contains
% position and orientation vectors of B with respect to A.
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
% Example (see also x2t):
% x=[rand(3,1);1;rand(3,1);0];x-t2x(x2t(x,'rpm'),'rpm')
% 
%
% Giampiero Campa 1/11/96
% 

% ---------------------------------------------------------------------------
% UNIT VECTOR AND ROTATION ANGLE 

if [ str=='van' size(T)==[4 4] ],

O=T(1:3,4);
R=T(1:3,1:3);
d=round(.5*(trace(R)-1)*1e12)/1e12;

if d==1,
   v=[0 0 1]';
   th=0;

elseif d==-1,
    v0=sum(R'+eye(3,3))';

    if v0 == 0 
	 v0=R(:,2)+R(:,3)+[0 1 1]';
    end;

    if v0 == 0 
	 v0=R(:,3)+[0 0 1]';
    end;

    v=v0/norm(v0);
    th=pi;

else 

   sg=(vp([1 0 0]',R(:,1))+vp([0 1 0]',R(:,2))+vp([0 0 1]',R(:,3)));

    if norm(sg) < 1e-12
        disp(' ');
        disp('T2x warning: det(R)<>1, unit vector assumed to be [0 0 1]''.');
        disp(' ');
        sg=[0 0 1]';
    end

   v=sg/norm(sg);
   th=atan2(norm(sg)/2,d);

end

x=[O;1;v;th];

% ---------------------------------------------------------------------------
% UNIT QUATERNION 

elseif [ str=='qua' size(T)==[4 4] ],

O=T(1:3,4);
R=T(1:3,1:3);
d=round(.5*(trace(R)-1)*1e12)/1e12;

if d==1,
   v=[0 0 1]';
   th=0;

elseif d==-1,
    v0=sum(R'+eye(3,3))';

    if v0 == 0 
	v0=R(:,2)+R(:,3)+[0 1 1]';
    end;

    if v0 == 0 
	v0=R(:,3)+[0 0 1]';
    end;

    v=v0/norm(v0);
    th=pi;

else 

   sg=(vp([1 0 0]',R(:,1))+vp([0 1 0]',R(:,2))+vp([0 0 1]',R(:,3)));

    if norm(sg) < 1e-12
        disp(' ');
        disp('T2x warning: det(R)<>1, unit vector assumed to be [0 0 1]''.');
        disp(' ');
        sg=[0 0 1]';
    end

   v=sg/norm(sg);
   th=atan2(norm(sg)/2,d);
   
end

q=v*sin(th/2);
q0=cos(th/2);

x=[O;1;q;q0];

% ---------------------------------------------------------------------------
% EULER-RODRIGUEZ PARAMETERS

elseif [ str=='erp' size(T)==[4 4] ],

O=T(1:3,4);
R=T(1:3,1:3);
d=round(.5*(trace(R)-1)*1e12)/1e12;

if d==1,
   v=[0 0 1]';
   th=0;

elseif d==-1,
    v0=sum(R'+eye(3,3))';

    if v0 == 0 
	v0=R(:,2)+R(:,3)+[0 1 1]';
    end;

    if v0 == 0 
	v0=R(:,3)+[0 0 1]';
    end;

    v=v0/norm(v0);
    th=pi;

else 

   sg=(vp([1 0 0]',R(:,1))+vp([0 1 0]',R(:,2))+vp([0 0 1]',R(:,3)));

    if norm(sg) < 1e-12
        disp(' ');
        disp('T2x warning: det(R)<>1, unit vector assumed to be [0 0 1]''.');
        disp(' ');
        sg=[0 0 1]';
    end

   v=sg/norm(sg);
   th=atan2(norm(sg)/2,d);
   
end

p=v*tan(th/2);
x=[O;1;p;0];

% ---------------------------------------------------------------------------
% ROLL, PITCH, YAW ANGLES (euler x-y-z convention) 

elseif [ str=='rpy' size(T)==[4 4] ],

O=T(1:3,4);
R=T(1:3,1:3);
d=round([0 0 1]*R(:,1)*1e12)/1e12;

if d==1,
   y=atan2([0 1 0]*R(:,2),[1 0 0]*R(:,2));
   p=-pi/2;
   r=-pi/2;

elseif d==-1
   y=atan2([0 1 0]*R(:,2),[1 0 0]*R(:,2));
   p=pi/2;
   r=pi/2;

else 
   sg=vp([0 0 1]',R(:,1));
   j2=sg/sqrt(sg'*sg);
   k2=vp(R(:,1),j2);

   r=atan2(k2'*R(:,2),j2'*R(:,2));
   p=atan2(-[0 0 1]*R(:,1),[0 0 1]*k2);
   y=atan2(-[1 0 0]*j2,[0 1 0]*j2);
end

y1=y+(1-sign(y)-sign(y)^2)*pi;
p1=p+(1-sign(p)-sign(p)^2)*pi;
r1=r+(1-sign(r)-sign(r)^2)*pi;

% takes smaller values of angles

if norm([y1 p1 r1]) < norm([y p r])
    x=[O;1;r1;-p1;y1;0];
else
    x=[O;1;r;p;y;0];
end

% ---------------------------------------------------------------------------
% ROTATION, PRECESSION, MUTATION ANGLES (euler z-x-z convention) 

elseif [ str=='rpm' size(T)==[4 4] ],

O=T(1:3,4);
R=T(1:3,1:3);
d=round([0 0 1]*R(:,3)*1e12)/1e12;

if d==1,
   m=0;
   p=0;
   r=atan2([0 1 0]*R(:,1),[1 0 0]*R(:,1));

elseif d==-1
   m=0;
   p=pi;
   r=atan2([0 1 0]*R(:,1),[1 0 0]*R(:,1));

else 
   sg=vp([0 0 1]',R(:,3));
   i2=sg/norm(sg);
   j2=vp(R(:,3),i2);

   m=atan2(j2'*R(:,1),i2'*R(:,1));
   p=atan2([0 0 1]*j2,[0 0 1]*R(:,3));
   r=atan2([0 1 0]*i2,[1 0 0]*i2);
   
end

r1=r+(1-sign(r)-sign(r)^2)*pi;
p1=p;
m1=m+(1-sign(m)-sign(m)^2)*pi;

% takes the smaller values of angles

if norm([r1 p1 m1]) < norm([r p m])
    x=[O;1;r1;-p1;m1;0];
else
    x=[O;1;r;p;m;0];
end

% ---------------------------------------------------------------------------
% DENAVITT-HARTEMBERG PARAMETERS 

elseif [ str=='dht' size(T)==[4 4] ],

% b calculation
b=T(1,4);

% d calculation
if norm(T(3,3)) > norm(T(2,3))
    d=T(3,4)/T(3,3);
else
    d=T(2,4)/T(2,3);
end

% alfa and theta computation by mean of euler-zxz angles
R=T(1:3,1:3);
dl=round([0 0 1]*R(:,3)*1e12)/1e12;

if dl==1,
   th=0;
   alfa=0;
   n=atan2([0 1 0]*R(:,1),[1 0 0]*R(:,1));
elseif dl==-1
   th=0;
   alfa=pi;
   n=atan2([0 1 0]*R(:,1),[1 0 0]*R(:,1));
else 
   sg=vp([0 0 1]',R(:,3));
   i2=sg/norm(sg);
   j2=vp(R(:,3),i2);

   th=atan2(j2'*R(:,1),i2'*R(:,1));
   alfa=atan2([0 0 1]*j2,[0 0 1]*R(:,3));
   n=atan2([0 1 0]*i2,[1 0 0]*i2);
end

th1=th+(1-sign(th)-sign(th)^2)*pi;
alfa1=alfa;
n1=n+(1-sign(n)-sign(n)^2)*pi;

% takes the smaller values of angles

if norm([th1 alfa1 n1]) < norm([th alfa n])
   x=[b;d;0;0;-alfa1;th1;0;0];
else
   x=[b;d;0;0;alfa;th;0;0];
end

% ---------------------------------------------------------------------------
% OTHER STRING

else

disp('   ');
disp('   x=T2x(T,str)');
disp('   where T is a 4 by 4 matrix (see help for details)');
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

