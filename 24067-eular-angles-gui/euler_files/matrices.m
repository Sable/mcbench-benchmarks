function an=matrices(phi,theta,psi)
% calculate rotation matricies

% RE=R(z,alpha)*R(x,beta)*R(z,gamma)
% RE=R(z,phi)*R(x,theta)*R(z,psi)

cph=cos(phi);
sph=sin(phi);

ct=cos(theta);
st=sin(theta);

cps=cos(psi);
sps=sin(psi);

Mph=[cph -sph 0;
     sph cph  0;
     0   0    1];

Mt=[1   0   0;
     0  ct  -st;
     0  st  ct];
 
Mps=[cps -sps 0;
     sps cps  0;
     0   0    1];
 
an={Mph,Mt,Mps};


