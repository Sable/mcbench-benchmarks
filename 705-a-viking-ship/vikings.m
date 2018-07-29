% 
% VIKINGASKEPP -- THE REVENGE
%
%    Huvudprogram
%
%    Överarbetning av laboration 3:10, Numeriska Metoder gkII.
%    Pontus Axelsson (d94-pax) & Fredrik Sandberg (d94-fsa).

clear,clf,format compact

global ztop           % Global variabel ztop
ztop=0.5;             % initieras.

ny=10;		      % Antal indelningar på bredden.
nx=45;       	      % Antal indelningar på längden.
n1=round(nx*0.45);    % Del av nx för den första bézierkurvan.
n2=nx-n1-1;           % Del av nx för den andra bézierkurvan.

% Start- och stopppunkter för relingens två bézierkurvor.
p1=[0 0 ztop+0.5]; p2=[2 0.8 ztop]; p3=[4 0 ztop+0.7];

% Styrpunktsavstånd och riktningar för relingens två bézierkurvor.
alfa1=0.7; alfa2=1.2; gamma1=1.5; gamma2=0.7;
k1=[3 2 -2]; k2=[1 0 0]; k3=[-3 2 -1];

% Styrpunkter för relingens två bézierkurvor.
b1=p1+alfa1*k1/norm(k1);
c1=p2+gamma1*(-k2);
b2=p2+alfa2*k2;
c2=p3+gamma2*k3/norm(k3);

% Uppbyggnad av bézierkurvorna på båda sidor om y-axeln.
rpos=[bezier(p1,b1,c1,p2,n1); 
      bezier(p2,b2,c2,p3,n2);
      p3];
rneg=[rpos(:,1) -rpos(:,2) rpos(:,3)];

% Kölens koordinater.
botten=[rpos(:,1) 0*rpos(:,2) vbottfunc(rpos(:,1), ztop+0.5,ztop+.7)];

% Uppbyggnad av skrovets x-, y- och z-punkter till SURFL-kommandot.
% Skrovet plottas utmed x-axeln.
X=[]; Y=[]; Z=[];
for i=1:nx
  Q=rpos(i,:); P=botten(i,:); Q2=Q.*[1 -1 1]; % Start- och stoppunkter.

  alfa=0.4*norm(Q-P); gamma=0.6*norm(Q-P);    % Styrpunktsavstånd
  k1=[0 0 -1]; k2=[0 1 1];                    % Styrpunktsriktingar
  
  b1=Q+alfa*k1;                               % Styrpunkter
  c1=P+gamma*k2/norm(k2);
  b2=(c1-P).*[1 -1 1]+P;
  c2=b1-Q+Q2;
  
  r=[bezier(Q,b1,c1,P,ny);                    % Bézierkurvor
     bezier(P,b2,c2,Q2,ny);
     Q2];   
  X=[X r(:,1)];                               % Punkter till SURFL
  Y=[Y r(:,2)];
  Z=[Z r(:,3)];
end

% Skrovet ritas upp med SURFL-kommandot.
surfl(X,Y,Z), hold on

% Beräkning av vattenlinjen medelst sekantmetoden.
vikt=.5; 		% Farkostens vikt angett i ton.
zguess1=0.3;		% Gissningar av vattenlinjens höjd
zguess2=0.4;		% för lösning med sekantmetoden.
spunkter=[];		% Skärningspunkter med vattnet,
                        % för att kunna plotta detsamma.
iter=0; zfel=1;
[spunkter v1]=volymunder(rpos,botten,nx,ny,zguess1);
v1=v1-vikt;             % Ger avvikelsen från den önskade volymen.
while abs(zfel)>1e-4 & iter<10
  [spunkter v2]=volymunder(rpos,botten,nx,ny,zguess2);
  v2=v2-vikt;
  zfel=(zguess2-zguess1)/(v2-v1)*v2;
  zguess1=zguess2;
  v1=v2;
  zguess2=zguess2-zfel;
  iter=iter+1;
end

Vattenlinjen=zguess2;	% Vår uppskattning av vattenlinjen

% Uppbyggnad av vattenytans x-, y- och z-koordinater.
% Vattnet plottas med PLOT3.
watersurface=Vattenlinjen;
qx=[]; qy=[]; qz=[];
for j=0:0.05:4
  wx=[]; wy=[]; wz=[];
  stop=-vlinjefunc(j,spunkter,1);   % Vattnets skärning med båten.
  for i=-2:0.05:stop
    wx=[wx j];
    wy=[wy i];
    wz=[wz 0.01*sin(j*10)+0.01*sin(i*10)+watersurface];
  end
  waterlinepos(round(j*20+1))=plot3(wx,wy,wz,'b'); hold on
  waterlineneg(round(j*20+1))=plot3(wx,-wy,wz,'b');
end

% Uppbyggnad och utritning av sköldar.
% Utnyttjar funktionen RITADELTA.
n=20; r=0.16;col=[0.3 0.2 0.1];
t=0:2*pi/n:2*pi;
x=r*cos(t);y=-0.9*ones(1,size(t,2));z=r*sin(t)+0.5;
for i=1.25:0.5:2.75
  fill3(x+i,y,z,col)
  fill3(x+i,-y,z,col)
  ritadelta(i+.1,-1,.54,0.015)
end

% Uppbyggnad och utritning av mast.
n=10; r=0.03;
t=0:2*pi/n:2*pi;
xx=r*cos(t)+2;yy=r*sin(t);zz=0*ones(size(xx));
xm=[];ym=[];zm=[];
for i=0:0.1:2.7
  xm=[xm;xx];ym=[ym;yy];zm=[zm;zz+i];
end
surfl(xm,ym,zm)

% Uppbyggnad och utritning av åror.
n=10; r=0.02; a=r;b=r;
t=0:2*pi/n:2*pi;
x=[];y=[];z=[];dz=0;
for i=0.4:0.1:2
  xx=a*cos(t);
  zz=b*sin(t)+dz;
  yy=0*ones(size(xx));
  x=[x;xx];y=[y;yy+i];z=[z;zz];
  if abs(i-1.5)<0.05
    a=a-0.015;b=b+0.03;
  end
  dz=dz-0.02;
end
for i=1.5:0.5:2.5
  surfl(x+i,y,z+0.6)
  surfl(x+i,-y,z+0.6)
end


% Uppbyggnad av seglet.
sailsurface=0.2;
sailtop=2.5; sailbottom=0.7; sailhalfwidth=1.05; sailstep=0.1;
xm=[]; ym=[]; zm=[];
for z=sailbottom:sailstep:sailtop
  xx=[]; yy=[]; zz=[];
  for y=-sailhalfwidth:sailstep:sailhalfwidth
    yy=[yy y];
    zz=[zz z];
    xx=[xx 2.3-(z-(sailtop-sailbottom)/2-0.7)^2/3-y^2/5+sailsurface];
  end
  xm=[xm;xx];ym=[ym;yy];zm=[zm;zz];
end

% Uppbyggnad av magisk färgskalningsmatris som ser till att
% endast en begränsad del av vald 'CLUT' används.
magiccolornumber=(46+30)/(30+46+30);
sailmin=min(min(zm)); sailmax=max(max(zm)); sailrange=sailmax-sailmin;
magicallyscaledmatrix=(1-magiccolornumber)/sailrange*zm;
scaledsailmin=min(min(magicallyscaledmatrix));
finalmagicmatrix=magicallyscaledmatrix-(scaledsailmin-magiccolornumber);

noofstripes=7;
stripewidth=2*sailhalfwidth/noofstripes/sailstep;
for i=1:2*stripewidth:noofstripes*stripewidth
  for j=i:1:i+stripewidth-1
    finalmagicmatrix(:,round(j))=finalmagicmatrix(:,round(j))-magiccolornumber;
  end
end
  
% Utritning av seglet med magiska färger.
surf(xm,ym,zm,finalmagicmatrix)

% Uppbyggnad och utritning av vimpel.
i=[-2 -1 1 2];
sinstartx=3.545; sinstopx=6;
Xv=[]; Yv=[]; Zv=[];
for x=1:0.05:2
  scaledx=(sinstopx-sinstartx)*(x-1)+sinstartx;
  Xv=[Xv;
      x*ones(size(i))];
  Yv=[Yv;
      0.5*sin(0.5*scaledx^2)/(scaledx)*ones(size(i))];
  Zv=[2.6-i*(2-x)/20
      Zv];
end
Cv=zeros(size(Zv))+1;
Cv(:,2)=Cv(:,2)*0;
vimpel=surf(Xv,Yv,Zv,Cv);
    
% Utritningsinställningar.
title('Roddbåt DeLuxe av d94-fsa och d94-pax')
colormap(vcol)
axis([0 4 -2 2 0 4]), axis square, axis off, view ([47 15])
% axis([0 4 -2 2 0 4]), axis square, axis off, view ([60 35])

% Återinställningar.
format
return





