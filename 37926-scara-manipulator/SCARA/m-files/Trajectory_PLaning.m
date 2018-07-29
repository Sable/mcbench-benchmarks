
function Trajectory_PLaning(OI,OF,to,tf,TH4)
 
a1=1;
a2=1;
d1=1;
d2=.1;
d=.1;
L=.3;
Xi=OI(1,1);
Yi=OI(2,1);
Zi=OI(3,1);
flag=0;
Xf=OF(1,1);
Yf=OF(2,1);
Zf=OF(3,1);
 
Vo=0;
Vf=0;
ao=0;
af=0;
if sqrt(Xi^2+Yi^2)>2
    
fprintf('Out of work space')
 
flag=1;
end
 
if sqrt(Xf^2+Yf^2)>2
    
fprintf('Out of work space')
flag=1;
end
 
[q1i q2i T4 d3]=Scara_Inverse(Xi,Yi,Zi,d1,d2,a1,a2)
[q1f q2f T4 d3]=Scara_Inverse(Xf,Yf,Zi,d1,d2,a1,a2)
 
A=[1,to,((to)^2),((to)^3),((to)^4),((to)^5);
    0,1,2*to,3*((to)^2),4*((to)^3),5*((to)^4);
    0,0,2,6*to,12*((to)^2),20*((to)^3);
    1,tf,((tf)^2),((tf)^3),((tf)^4),((tf)^5);
    0,1,2*tf,3*((tf)^2),4*((tf)^3),5*((tf)^4);
    0,0,2,6*tf,12*((tf)^2),20*((tf)^3)]
 
B1=[q1i;Vo;ao;q1f;Vf;af]
B2=[q2i;Vo;ao;q2f;Vf;af]
C1=inv(A)*B1
C2=inv(A)*B2
T=[];
Q1=[];
Q2=[];
X=[];
Y=[];
V1=[];
V2=[];
AC1=[];
AC2=[];
for t=to:.01:tf-.01
q1=C1(1,1)+C1(2,1)*t+C1(3,1)*t^2+ C1(4,1)*t^3+C1(5,1)*t^4+C1(6,1)*t^5;  
q2=C2(1,1)+C2(2,1)*t+C2(3,1)*t^2+ C2(4,1)*t^3+C2(5,1)*t^4+C2(6,1)*t^5;
v1=C1(2,1)+(2*C1(3,1)*t)+ (3*C1(4,1)*t^2)+(4*C1(5,1)*t^3)+(5*C1(6,1)*t^4); 
v2=C2(2,1)+(2*C2(3,1)*t)+ (3*C2(4,1)*t^2)+(4*C2(5,1)*t^3)+(5*C2(6,1)*t^4);
ac1=(2*C1(3,1))+ (6*C1(4,1)*t)+(12*C1(5,1)*t^2)+(20*C1(6,1)*t^3);
ac2=(2*C2(3,1))+ (6*C2(4,1)*t)+(12*C2(5,1)*t^2)+(20*C2(6,1)*t^3);
 
x=a1*cosd(q1)+a2*cosd(q1+q2);
y=a1*sind(q1)+a2*sind(q1+q2);
X=[X x];
Y=[Y y];
Q1=[Q1,q1];
Q2=[Q2,q2];
V1=[V1 v1];
V2=[V2 v2];
AC1=[AC1 ac1];
AC2=[AC2 ac2];
 
T=[T t];
end
 SCARA30 = vrworld('SCARA30.wrl');
  open(SCARA30)
  view(SCARA30);
% plot(T,Q1)
% title('position of the First JOINT')
% figure
% plot(T,Q2)
% title('position of the Second JOINT')
% figure
% plot(T,V1)
% title('Velocity of the First JOINT')
% figure
% plot(T,V2)
% title('Velocity of the Second JOINT')
% figure
% plot(T,AC1)
% title('Accelaration of the First JOINT')
% figure
% plot(T,AC2)
% title('Accelaration of the Second JOINT')
 
figure
 Zl=Zi*ones(1,length(X));
  plot3(X,Y,Zl,'red','linewidth',2)
 
inc=.01
 
for Z=0:inc:Zi
    d3=d1-Z-d2;
  
 SCARA_plot(Q1(1),Q2(1),0,a1,a2,d1,d3,d2,L,d)
 
 
 SCARA_VR_PLOT(Q1(1),Q2(1),0,-d3,d)
 hold on 
 plot3([Xi Xi],[Yi  Yi],[0 Zi],'red','linewidth',2)
 
 
    
 plot3(X,Y,Zl,'red','linewidth',2)
  plot3([Xf Xf],[Yf  Yf],[Zi Zf],'red','linewidth',2)
hold off
 pause(.01)
end
 
 
 Z=Zi*ones(1,length(X));
  plot3(X,Y,Z,'red','linewidth',2)
 
 
 
  plot3([Xi Xi],[Yi  Yi],[0 Zi],'red','linewidth',2)
 
 for i=1:1:length(Q1)
plot3([Xi Xi],[Yi  Yi],[0 Zi],'red','linewidth',2)
hold on
  plot3([Xf Xf],[Yf  Yf],[Zi Zf],'red','linewidth',2)
hold on
 plot3(X,Y,Z,'red','linewidth',2)
hold on
 SCARA_plot(Q1(i),Q2(i),0,a1,a2,d1,d3,d2,L,d)
    SCARA_VR_PLOT(Q1(i),Q2(i),0,-d3,d)
 
 
  pause(.01)  
hold off
 end
 
inc=-.01;
 
 
 
for Z=Zi:inc:Zf
    d3=d1-Z-d2;
    plot3([Xi Xi],[Yi  Yi],[0 Zi],'red','linewidth',2)
    hold on
    plot3([Xf Xf],[Yf  Yf],[Zi Zf],'red','linewidth',2)
    hold on
      plot3(X,Y,Zl,'red','linewidth',2) 
    
 SCARA_plot(Q1(length(Q1)),Q2(length(Q1)),0,a1,a2,d1,d3,d2,L,d)
 
 
 
  
 
 
SCARA_VR_PLOT(Q1(length(Q1)),Q2(length(Q1)),0,-d3,d)
 pause(.01)
 hold off
end
 
for T4=0:1:TH4
 
 plot3([Xi Xi],[Yi  Yi],[0 Zi],'red','linewidth',2)
 
hold on
    
 
 plot3(X,Y,Zl,'red','linewidth',2) 
 hold on
 
 
plot3([Xf Xf],[Yf  Yf],[Zi Zf],'red','linewidth',2)
 
 
 SCARA_plot(Q1(length(Q1)),Q2(length(Q1)),T4,a1,a2,d1,d3,d2,L,d)
 
 
SCARA_VR_PLOT(Q1(length(Q1)),Q2(length(Q1)),T4,-d3,d)
 
  pause(.01) 
 
  end 
 
hold off
end
