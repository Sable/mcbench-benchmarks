% F1=figure;
% set(F1,'position',[18 144 560 420]);%Numero de paralelepipedos
lo=2;               %Lado del paralelepipedo base
deltax=5;           %Altura del paralelepipedo
xo=-lo/2;           %Punto de origen en x 
yo=-lo/2;           %Punto de origen en y
zo=0;               %Punto de origen en z




line([0 0],[0 0],[0 10],'color','r')
line([0 5],[0 0],[5 5],'color','g')
line([0 0],[0 5],[5 5],'color','b')

x1=xo;
x2=x1+lo;
x3=x1+lo;
x4=x1;
x5=x1;
x6=x1;
x7=x1+lo;
x8=x1+lo;

y1=yo;
y2=y1;
y3=y1+lo;
y4=y1+lo;
y5=y1+lo;
y6=y1;
y7=y1;
y8=y1+lo;

z1=zo;
z2=zo;
z3=zo;
z4=zo;
z5=zo+deltax;
z6=zo+deltax;
z7=zo+deltax;
z8=zo+deltax;

x=[x1 x2 x3 x4 x5 x6 x7 x8];
y=[y1 y2 y3 y4 y5 y6 y7 y8];
z=[z1 z2 z3 z4 z5 z6 z7 z8];



%///////////////////////////////////////////////////
%//////////////////////////////////////////////////
for n=1:8
T(1:4,n)=[cos(teta) -sin(teta) 0 0
   sin(teta) cos(teta) 0 0
   0 0 1 0 
   0 0 0 1]*[x(n);y(n);z(n);1];
end

a=0.4;
tcolor(1,1,1:3) = [0.8 0.4 0.3];
A1=patch([T(1,1) T(1,2) T(1,3) T(1,4)],[T(2,1) T(2,2) T(2,3) T(2,4)],[T(3,1) T(3,2) T(3,3) T(3,4)],tcolor);
A2=patch([T(1,1) T(1,2) T(1,7) T(1,6)],[T(2,1) T(2,2) T(2,7) T(2,6)],[T(3,1) T(3,2) T(3,7) T(3,6)],tcolor);
A3=patch([T(1,5) T(1,6) T(1,7) T(1,8)],[T(2,5) T(2,6) T(2,7) T(2,8)],[T(3,5) T(3,6) T(3,7) T(3,8)],tcolor);
A4=patch([T(1,2) T(1,3) T(1,8) T(1,7)],[T(2,2) T(2,3) T(2,8) T(2,7)],[T(3,2) T(3,3) T(3,8) T(3,7)],tcolor);
A5=patch([T(1,1) T(1,4) T(1,5) T(1,6)],[T(2,1) T(2,4) T(2,5) T(2,6)],[T(3,1) T(3,4) T(3,5) T(3,6)],tcolor);
A6=patch([T(1,3) T(1,4) T(1,5) T(1,8)],[T(2,3) T(2,4) T(2,5) T(2,8)],[T(3,3) T(3,4) T(3,5) T(3,8)],tcolor);
% 
% light('Position',[1 0 0],'Style','infinite');
% light('Position',[0 1 0],'Style','infinite');
% light('Position',[0 0 1],'Style','infinite');
% light('Position',[-1 0 0],'Style','infinite');
% light('Position',[0 -1 0],'Style','infinite');
% % light('Position',[0 0 -1],'Style','infinite');

deltax2=deltax;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ESLABON 2
lo=1.5;               %Lado del paralelepipedo base
deltax=1.5;           %Altura del paralelepipedo
l3=2;                 %Longitud del eslabon 3    
xo=-1;                %Punto de origen en x 
yo=1;                 %Punto de origen en y
zo=-1.5/2;            %Punto de origen en z
l2=7;
x1=xo;
x2=x1+l2;
x3=x1+l2;
x4=x1;
x5=x1;
x6=x1;
x7=x1+l2;
x8=x1+l2;

y1=yo;
y2=y1;
y3=y1+lo;
y4=y1+lo;
y5=y1+lo;
y6=y1;
y7=y1;
y8=y1+lo;

z1=zo;
z2=zo;
z3=zo;
z4=zo;
z5=zo+deltax;
z6=zo+deltax;
z7=zo+deltax;
z8=zo+deltax;
x=[x1 x2 x3 x4 x5 x6 x7 x8];
y=[y1 y2 y3 y4 y5 y6 y7 y8];
z=[z1 z2 z3 z4 z5 z6 z7 z8];

for n=1:8

T(1:4,n)=[cos(teta) -sin(teta) 0 0
   sin(teta) cos(teta) 0 0
   0 0 1 deltax2-deltax/2 
   0 0 0 1]*[cos(teta2) 0 sin(teta2) 0
          0 1 0 0
          -sin(teta2) 0 cos(teta2) 0
          0 0 0 1]*[x(n);y(n);z(n);1];

% Ta(1:4,n)=[cos(teta) -sin(teta) 0 0
%    sin(teta) cos(teta) 0 0
%    0 0 1 0 
%    0 0 0 1]*[x(n);y(n);z(n);1];
end


a=0.4;
tcolor(1,1,1:3) = [0.4 0.1 0.1 ];
A7=patch([T(1,1) T(1,2) T(1,3) T(1,4)],[T(2,1) T(2,2) T(2,3) T(2,4)],[T(3,1) T(3,2) T(3,3) T(3,4)],tcolor);
A8=patch([T(1,1) T(1,2) T(1,7) T(1,6)],[T(2,1) T(2,2) T(2,7) T(2,6)],[T(3,1) T(3,2) T(3,7) T(3,6)],tcolor);
A9=patch([T(1,5) T(1,6) T(1,7) T(1,8)],[T(2,5) T(2,6) T(2,7) T(2,8)],[T(3,5) T(3,6) T(3,7) T(3,8)],tcolor);
A10=patch([T(1,2) T(1,3) T(1,8) T(1,7)],[T(2,2) T(2,3) T(2,8) T(2,7)],[T(3,2) T(3,3) T(3,8) T(3,7)],tcolor);
A11=patch([T(1,1) T(1,4) T(1,5) T(1,6)],[T(2,1) T(2,4) T(2,5) T(2,6)],[T(3,1) T(3,4) T(3,5) T(3,6)],tcolor);
A12=patch([T(1,3) T(1,4) T(1,5) T(1,8)],[T(2,3) T(2,4) T(2,5) T(2,8)],[T(3,3) T(3,4) T(3,5) T(3,8)],tcolor);
% light('Position',[1 0 0],'Style','infinite');
% light('Position',[0 1 0],'Style','infinite');
% light('Position',[0 0 1],'Style','infinite');
% light('Position',[-1 0 0],'Style','infinite');
% light('Position',[0 -1 0],'Style','infinite');
% light('Position',[0 0 -1],'Style','infinite');

grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%//////Eslabon 3 //////////////////////////////////////////////////

lo=1;                   %Lado del paralelepipedo base
deltax=1;               %Altura del paralelepipedo
xo=-deltax/2;           %Punto de origen en x 
yo=0;                   %Punto de origen en y
zo=-.5;                 %Punto de origen en z
l2=5.5;
x1=xo;
x2=x1+l2;
x3=x1+l2;
x4=x1;
x5=x1;
x6=x1;
x7=x1+l2;
x8=x1+l2;

y1=yo;
y2=y1;
y3=y1+lo;
y4=y1+lo;
y5=y1+lo;
y6=y1;
y7=y1;
y8=y1+lo;

z1=zo;
z2=zo;
z3=zo;
z4=zo;
z5=zo+deltax;
z6=zo+deltax;
z7=zo+deltax;
z8=zo+deltax;
x=[x1 x2 x3 x4 x5 x6 x7 x8];
y=[y1 y2 y3 y4 y5 y6 y7 y8];
z=[z1 z2 z3 z4 z5 z6 z7 z8];


for n=1:8
T(1:4,n)=[cos(teta) -sin(teta) 0 0
   sin(teta) cos(teta) 0 0
   0 0 1 deltax2-deltax/2 
   0 0 0 1]*[cos(teta2) 0 sin(teta2) 0
          0 1 0 0
          -sin(teta2) 0 cos(teta2) 0
          0 0 0 1]*[cos(teta3) 0 sin(teta3) 5+deltax
          0 1 0 0
          -sin(teta3) 0 cos(teta3) 0
          0 0 0 1]*[x(n);y(n);z(n);1];
end      

crgb=[249 193 120]/255;
tcolor(1,1,1:3) = [crgb(1) crgb(2) crgb(3)];

A13=patch([T(1,1) T(1,2) T(1,3) T(1,4)],[T(2,1) T(2,2) T(2,3) T(2,4)],[T(3,1) T(3,2) T(3,3) T(3,4)],tcolor);
A14=patch([T(1,1) T(1,2) T(1,7) T(1,6)],[T(2,1) T(2,2) T(2,7) T(2,6)],[T(3,1) T(3,2) T(3,7) T(3,6)],tcolor);
A15=patch([T(1,5) T(1,6) T(1,7) T(1,8)],[T(2,5) T(2,6) T(2,7) T(2,8)],[T(3,5) T(3,6) T(3,7) T(3,8)],tcolor);
A16=patch([T(1,2) T(1,3) T(1,8) T(1,7)],[T(2,2) T(2,3) T(2,8) T(2,7)],[T(3,2) T(3,3) T(3,8) T(3,7)],tcolor);
A17=patch([T(1,1) T(1,4) T(1,5) T(1,6)],[T(2,1) T(2,4) T(2,5) T(2,6)],[T(3,1) T(3,4) T(3,5) T(3,6)],tcolor);
A18=patch([T(1,3) T(1,4) T(1,5) T(1,8)],[T(2,3) T(2,4) T(2,5) T(2,8)],[T(3,3) T(3,4) T(3,5) T(3,8)],tcolor);
% 
% light('Position',[1 0 0],'Style','infinite');
% light('Position',[0 1 0],'Style','infinite');
% light('Position',[0 0 1],'Style','infinite');
% light('Position',[-1 0 0],'Style','infinite');
% light('Position',[0 -1 0],'Style','infinite');
% light('Position',[0 0 -1],'Style','infinite');


lo=10;                %Lado del paralelepipedo base
deltax=1;             %Altura del paralelepipedo
xo=-lo/2;             %Punto de origen en x 
yo=-lo/2;             %Punto de origen en y
zo=-deltax;           %Punto de origen en z

x1=xo;
x2=x1+lo;
x3=x1+lo;
x4=x1;
x5=x1;
x6=x1;
x7=x1+lo;
x8=x1+lo;

y1=yo;
y2=y1;
y3=y1+lo;
y4=y1+lo;
y5=y1+lo;
y6=y1;
y7=y1;
y8=y1+lo;

z1=zo;
z2=zo;
z3=zo;
z4=zo;
z5=zo+deltax;
z6=zo+deltax;
z7=zo+deltax;
z8=zo+deltax;
a=0.4;
tcolor(1,1,1:3) = [0.3 0.5 0.4];
patch([x1 x2 x3 x4],[y1 y2 y3 y4],[z1 z2 z3 z4],tcolor);
patch([x1 x2 x7 x6],[y1 y2 y7 y6],[z1 z2 z7 z6],tcolor);
patch([x5 x6 x7 x8],[y5 y6 y7 y8],[z5 z6 z7 z8],tcolor);
patch([x2 x3 x8 x7],[y2 y3 y8 y7],[z2 z3 z8 z7],tcolor);
patch([x1 x4 x5 x6],[y1 y4 y5 y6],[z1 z4 z5 z6],tcolor);
patch([x3 x4 x5 x8],[y3 y4 y5 y8],[z3 z4 z5 z8],tcolor);
% 
% light('Position',[1 0 0],'Style','infinite');
% light('Position',[0 1 0],'Style','infinite');
% light('Position',[0 0 1],'Style','infinite');
% light('Position',[-1 0 0],'Style','infinite');
% light('Position',[0 -1 0],'Style','infinite');
% light('Position',[0 0 -1],'Style','infinite');

p=[0;0;0;1];

Tf=[cos(teta) -sin(teta) 0 0
   sin(teta) cos(teta) 0 0
   0 0 1 deltax2-deltax/2 
   0 0 0 1]*[cos(teta2) 0 sin(teta2) 0
          0 1 0 0
          -sin(teta2) 0 cos(teta2) 0
          0 0 0 1]*[cos(teta3) 0 sin(teta3) 5+deltax
          0 1 0 0
          -sin(teta3) 0 cos(teta3) 0
          0 0 0 1]*p
Tf(2)=T(2,8)
Tf(3)=T(3,8)
Tf(1)=T(1,8)

E1=gca;
axis([-10 8 -10 8 0 15])
hold on
plot3(E1,p(1),p(2),p(3));
grid on

