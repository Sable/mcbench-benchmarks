

%% Author: epokh
%% Website: www.epokh.org/drupy
%% This software is under GPL

%% Function description:
%% input:differential rotation vector delta
%% differential traslations vector p
%% output: differential change in frame T relative to current frame
%% delta it's the differential operator relative to the current moving frame
%% [Tdelta]=[T]^(-1)*[delta]*[T]

function tdelta=deltaDiffInter(T,delta,p,d)
n=T(:,1); o=T(:,2); a=T(:,3);
tdeltax=dot(delta,n);
tdeltay=dot(delta,o);
tdeltaz=dot(delta,a);

tdx=n*(cross(delta,p)+d);
tdy=o*(cross(delta,p)+d);
tdz=a*(cross(delta,p)+d);
tdelta=[0,-tdeltaz,tdeltay,tdx;
       tdeltaz,0,-tdeltax,tdy;
       -tdeltay,tdeltax,0,tdz;
       0      , 0    ,0 ,0];

end