%*****************THE MAIN PROGRAMME*****************
%====================================================
%Practise problem for the course of CAO
%Prof P.Beckers 
%====================================================
%Porpose :Drawing the orthotomic surface of a Bezier surface  %
% Student: BUI QUOC TINH
% European Master Mechanices of Contructions	(EMMC)					     				 
% University the Liege. Belgium										    		     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%====================================================
clear all;

%Definition of the control points directly			 
P00=[-10 0 10];P01=[-10 5 5];P02=[-10 5 -5];P03=[-10 0 -10];
P10=[-5 5 10];P11=[-5 5 5];P12=[-5 5 -5];P13=[-5 5 -10];
P20=[5 5 10];P21=[5 5 5];P22=[5 5 -5];P23=[5 5 -10];
P30=[10 0 10];P31=[10 5 5];P32=[10 5 -5];P33=[10 5 -10];

%Matrix control points of Bezier surface 
PP=[P00 P01 P02 P03;...
    P10 P11 P12 P13;...
    P20 P21 P22 P23;...
    P30 P31 P32 P33];
 
 %S source point
%disp('INPUT S SOURCE POINT ')
%xs=input('input xs = ');
%ys=input('input ys = ');
%zs=input('input zs = ');
xs=-5;
ys=3;
zs=5;
S=[xs;ys;zs];
 
%Calculation of the points in the surface   
k=20;
for i=1:k
	if i>9 & mod(i,10)==0
		disp(i) % Using show is the progress of the calculations.
	end
for j=1:k
u=0.01*i;
v=0.01*j;

%=============================================
%the function of bezier surafce polynomial
q=P00*B(0,3,u)*B(0,3,v)+P01*B(0,3,u)*B(1,3,v)+P02*B(0,3,u)*B(2,3,v)+P03*B(0,3,u)*B(3,3,v)+...
+P10*B(1,3,u)*B(0,3,v)+P11*B(1,3,u)*B(1,3,v)+P12*B(1,3,u)*B(2,3,v)+P13*B(1,3,u)*B(3,3,v)+...
+P20*B(2,3,u)*B(0,3,v)+P21*B(2,3,u)*B(1,3,v)+P22*B(2,3,u)*B(2,3,v)+P23*B(2,3,u)*B(3,3,v)+...
+P30*B(3,3,u)*B(0,3,v)+P31*B(3,3,u)*B(1,3,v)+P32*B(3,3,u)*B(2,3,v)+P33*B(3,3,u)*B(3,3,v);

%the first derivatives u parametic of bezier surface function
q_u=P00*B_daoham(0,3,u)*B(0,3,v)+P01*B_daoham(0,3,u)*B(1,3,v)+P02*B_daoham(0,3,u)*B(2,3,v)+P03*B_daoham(0,3,u)*B(3,3,v)+...
+P10*B_daoham(1,3,u)*B(0,3,v)+P11*B_daoham(1,3,u)*B(1,3,v)+P12*B_daoham(1,3,u)*B(2,3,v)+P13*B_daoham(1,3,u)*B(3,3,v)+...
+P20*B_daoham(2,3,u)*B(0,3,v)+P21*B_daoham(2,3,u)*B(1,3,v)+P22*B_daoham(2,3,u)*B(2,3,v)+P23*B_daoham(2,3,u)*B(3,3,v)+...
+P30*B_daoham(3,3,u)*B(0,3,v)+P31*B_daoham(3,3,u)*B(1,3,v)+P32*B_daoham(3,3,u)*B(2,3,v)+P33*B_daoham(3,3,u)*B(3,3,v);

%%the first derivatives v parametic of bezier surface function
q_v=P00*B(0,3,u)*B_daoham(0,3,v)+P01*B(0,3,u)*B_daoham(1,3,v)+P02*B(0,3,u)*B_daoham(2,3,v)+P03*B(0,3,u)*B_daoham(3,3,v)+...
+P10*B(1,3,u)*B_daoham(0,3,v)+P11*B(1,3,u)*B_daoham(1,3,v)+P12*B(1,3,u)*B_daoham(2,3,v)+P13*B(1,3,u)*B_daoham(3,3,v)+...
+P20*B(2,3,u)*B_daoham(0,3,v)+P21*B(2,3,u)*B_daoham(1,3,v)+P22*B(2,3,u)*B_daoham(2,3,v)+P23*B(2,3,u)*B_daoham(3,3,v)+...
+P30*B(3,3,u)*B_daoham(0,3,v)+P31*B(3,3,u)*B_daoham(1,3,v)+P32*B(3,3,u)*B_daoham(2,3,v)+P33*B(3,3,u)*B_daoham(3,3,v);

%===============
qx(i,j)=q(1);%Saving points matrix into the remember computer  
qy(i,j)=q(2);
qz(i,j)=q(3);

%===============
qx_u=q_u(1);
qy_u=q_u(2);
qz_u=q_u(3);

%===============
qx_v=q_v(1);
qy_v=q_v(2);
qz_v=q_v(3);

%===============

%The geomatric information matrix of tangent plane 
R=[qx(i,j) qx_u qx_v;...
  qy(i,j) qy_u qy_v;...
  qz(i,j) qz_u qz_v];

%The normal vector of tangent plane as same as the orient vector of a traigh lines 
%perpendicular with it and through source point 
nn=[(qy_u.*qz_v)-(qz_u.*qy_v);...
    (qz_u.*qx_v)-(qz_v.*qx_v);...
    (qx_u.*qy_v)-(qx_v.*qy_u)];

%The geomatric information matrix of straigh lines d perpendicular with it and through source point 
d=[xs nn(1);...
   ys nn(2);...
   zs nn(3)];

%Solving the equations
AA=[nn(1) -qx_u -qx_v;...
   nn(2) -qy_u -qy_v;...
   nn(3) -qz_u -qz_v];
syms t1 t2 t3 % parametric variables
T=[t1; t2; t3];
BB=[(qx(i,j)-xs);...
    (qy(i,j)-ys);...
    (qz(i,j)-zs)];
T=inv(AA)*BB;

%The intersection points between the tangent plane and the straigh d
H=S+T(1)*nn;

%The reflective points of the source point about the tangent plane 
S_dx=2*H-S;
%==================
S_dxx(i,j)=S_dx(1);
S_dxy(i,j)=S_dx(2);
S_dxz(i,j)=S_dx(3);
end
end


% Drawing the bezier surface
view(3); 
grid
surface(qx,qy,qz); xlabel('x');ylabel('y');zlabel('z');%
title('The orthotomic surface of a bezier surface');

%Drawing the source point
hold on
plot3(xs,ys,zs,'Pr','ButtonDownFcn','animator start','EraseMode','xor','LineWidth',2, ... 
'Marker','>','MarkerSize',5,'Tag','pointer');
text(xs+0.2,ys+0.2,zs+0.2,'S')
hold on

%Drawing the orthotomic surface
surface(S_dxx,S_dxy,S_dxz); xlabel('x');ylabel('y');zlabel('z');

% Thank you very much for your course !







