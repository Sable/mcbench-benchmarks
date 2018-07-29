function [wpos,ypos]=rlasymp(G)
G=zpk(G); 
zer=G.z{1}; pol=G.p{1}; gain=G.k;
ii=find(abs(zer)<1e10); 
if length(ii)>0, zer=zer(ii); end
nExcess=length(pol)-length(zer); 
if nExcess>0
   pp=(sum(real(pol))-sum(real(zer)))/nExcess;
   deltaP=pi/nExcess; 
   xx=get(gca,'Xlim'); 
   yy=get(gca,'YLim');
   xx1=(xx(1)-pp)*tan(deltaP); 
end
wpos=[pp*ones(1,nExcess); zeros(1,nExcess)];
ypos=zeros(2,nExcess); 
for i=1:nExcess
   PAngle=(2*i-1)*deltaP; 
   Kslp=tan(PAngle); 
   if (pi/2>=PAngle & PAngle>=0)
      xP=xx(2); yP=yy(2);
   elseif (pi>=PAngle&PAngle>pi/2)
      xP=xx(1); yP=yy(2);
   elseif (3*pi/2>=PAngle&PAngle>pi)
      xP=xx(1); yP=yy(1);
   else
      xP=xx(2); yP=yy(1);
   end
   xx1=xP; yy1=Kslp*(xx1-pp); 
   if yy1>yy(2) | yy1<yy(1), 
      yy1=yP; xx1=yy1/Kslp+pp; 
   end
   wpos(2,i)=xx1; ypos(2,i)=yy1;
end
