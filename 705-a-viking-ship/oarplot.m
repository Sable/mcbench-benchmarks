function f=oarplot()

% Uppbyggnad och utritning av åror.
global oars

n=10; r=0.02; a=r;b=r;
t=0:2*pi/n:2*pi;

x=[];y=[];z=[];dz=0;

for i=0.4:0.1:2

  if i<0.8
    xx=a*cos(t); % +rowfactor*0.5*(0.4-i);
  else
    xx=a*cos(t); % +rowfactor*0.5*(i-0.4);
  end

  zz=b*sin(t)+dz;
  yy=0*ones(size(xx));
  x=[x;xx];y=[y;yy+i];z=[z;zz];

  if abs(i-1.5)<0.05
    a=a-0.015;b=b+0.03;
  end

  dz=dz-0.02;
end

for i=1.5:0.5:2.5
  oars(i/0.5-2)=surf(x+i,y,z+0.6,0.5*ones(size(z)));
  oars(i/0.5+1)=surf(x+i,-y,z+0.6,0.5*ones(size(z)));
end

% Utritningsinställningar.
colormap(vcol)
axis([0 4 -2 2 0 4]), axis square, axis off, view ([47 15])