function f=vimpelplot(amplitude)

% Uppbyggnad och utritning av vimpel.
global vimpel

i=[-2 -1 1 2];
sinstartx=3.545; sinstopx=6;
Xv=[]; Yv=[]; Zv=[];
for x=1:0.05:2
  scaledx=(sinstopx-sinstartx)*(x-1)+sinstartx;
  Xv=[Xv;
      x*ones(size(i))];
  Yv=[Yv;
      amplitude*sin(0.5*scaledx^2)/(scaledx)*ones(size(i))];
  Zv=[2.6-i*(2-x)/20
      Zv];
end
Cv=zeros(size(Zv))+1;
Cv(:,2)=Cv(:,2)*0;
vimpel=surf(Xv,Yv,Zv,Cv);
