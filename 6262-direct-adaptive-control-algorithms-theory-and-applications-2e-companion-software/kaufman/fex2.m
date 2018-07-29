
%fex2 called by ex2.m 
%    ________________________________________________________________________
%  /Program:  fex2.m							   \
% / Description:  This program is called by ex2.m.     		            \
% \ Programmed Summer 1996 by Kenyon Thayer under Howard Kaufmh, RPI.	    /
%  \_______________________________________________________________________/
%
 
%Copyright

% Programmed Summer 1996 by Kenyon Thayer, RPI, Troy, NY
	
function yprime=fex2(t,x)
%xp(nx1),up(mx1),yp(rx1),xm(nmx1),um(mmx1),ym(rx1),xf(nfx1),uf(mfx1),yf(rfx1)
% ki(m,r+rf+nm+m),x(n+nm+nf+m*(r+rf+nm+m))=x(xp;xm;xf;ki stacked by columns)
% global matrices to be set in main program
global ap bp cp am bm cm Af Bf Cf Df T Tbar G Qp Qf algor a b u
[n,m]=size(bp);
[nm,mm]=size(bm);
[r,n]=size(cp);
[nf,mf]=size(Bf);
[rf,nf]=size(Cf);
stack=m*(r+rf+nm+mm);

a1=[ap,zeros(n,nm),zeros(n,nf),zeros(n,stack)];
a2=[zeros(nm,n),am,zeros(nm,nf),zeros(nm,stack)];
a3=[zeros(nf,n),zeros(nf,nm),Af,zeros(nf,stack)];
a4=[zeros(stack,n),zeros(stack,nm),zeros(stack,nf),zeros(stack,stack)];
a=[a1;a2;a3;a4];
b1=[bp,zeros(n,mm),zeros(n,mf),zeros(n,stack)];
b2=[zeros(nm,m),bm,zeros(nm,mf),zeros(nm,stack)];
b3=[zeros(nf,m),zeros(nf,mm),Bf,zeros(nf,stack)];
b4=[zeros(stack,m),zeros(stack,mm),zeros(stack,mf),eye(stack)];
b=[b1;b2;b3;b4];
               %set reference model input um
um=0.3;
if t>10
	um=-um;
end;
%um=0.3;if t>20,um=-um;end;
               %end model input
xp=x(1:n);xm=x(n+1:n+nm);xf=x(n+nm+1:n+nm+nf);
ym=cm*xm;yp=cp*xp;yf=Cf*xf;eyp=ym-yp;
v1=Qp*eyp-Qf*yf;
rvec=[eyp;-yf;xm;um];
%                            unstack ki
ii=0;
for j=1:r+rf+nm+mm
	for i=1:m
		ii=ii+1;
		ki(i,j)=x(n+nm+nf+ii);
	end;
end;
%                end unstack ki
[ng,ng]=size(G);
up=inv(eye(ng)-G*rvec'*Tbar*rvec)*(ki+v1*rvec'*Tbar)*rvec;
v=v1+G*up;
%                 choose algorithm
if algor==1
	uf=eyp;
elseif algor==2
	uf=up;
elseif algor==3
	uf=up;up=Df*uf-yf;
end;
			%end choose algorithm
                        %stack v*r'*t
temp1=v*rvec'*T;
ii=0;
for j=1:r+rf+nm+mm
	for i=1:m
		ii=ii+1;
		temp2(ii)=temp1(i,j);
	end;
end;
temp2=temp2';
u=[up;um;uf;temp2];
%u=[u; 0;];
yprime=a*x+b*u;
