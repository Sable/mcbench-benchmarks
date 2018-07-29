function an=euler2axan(phi,theta,psi,M)
% From Euler angles (phi,theta,psi) to axis angle (x y z alpha)/(gamma,delta):

% v=[(cos(al-gm)+1)*(1-cos(bt));
%    sin(al-gm)*(1-cos(bt));
%    sin(bt)*(sin(al)+sin(gm))]

cost=cos(theta);
sint=cos(theta);
omcost=(1-cost);
if sint==0
    x=0;
    y=0;
    z=1;
else
    x = (cos(phi-psi)+1)*omcost;
    y = sin(phi-psi)*omcost;
    z = sint*(sin(phi)+sin(psi));
end

if (x==0)&&(y==0)&&(z==0)
    x=1;
    y=0;
    z=0;
else
    vn=sqrt(x^2+y^2+z^2);
    x=x/vn;
    y=y/vn;
    z=z/vn;
end

v=[x y z]';

%[THETA,PHI,R] = cart2sph(X,Y,Z)

[gamma,delta,tmp] = cart2sph(x,y,z);

cppp=cos(phi+psi);
Tr=cppp+cppp*cost+cost;
alpha=atan2(-(M(1,2)*v(3)+M(2,3)*v(1)+M(3,1)*v(2)-M(1,3)*v(2)-M(3,2)*v(1)-M(2,1)*v(3)),Tr-1);
% if (-(M(1,2)*v(3)+M(2,3)*v(1)+M(3,1)*v(2)-M(1,3)*v(2)-M(3,2)*v(1)-M(2,1)*v(3)))>=0
%     alpha=acos((Tr-1)/2);
% else
%     alpha=-acos((Tr-1)/2);
% end

an={{gamma,delta,alpha},v};


