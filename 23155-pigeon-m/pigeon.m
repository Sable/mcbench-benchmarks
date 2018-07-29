function [p1,p2,a,a1,a2,a3,h]=pigeon()
% PIGEON Draw a pigeon
% numandina@gmail.com
%

l=1; % pigeon size
hold on
axis([-5 5 -5 5 -5 5])
view(3)
grid on
rotate3d

% body
[a,b,c]=sphere(25);
aa1=surf(a.*l,b.*l,c.*l);
set(aa1,'edgecolor','none','facecolor',[.5 .5 .5])

% head
[a,b,c]=sphere(25);
aa2=surf(a.*.5.*l,b.*.5.*l+.5.*l,c.*.5.*l+1.*l);
set(aa2,'edgecolor','none','facecolor',[.5 .5 .5])

% eyes
[a,b,c]=sphere(25);
aa2=surf(a.*.1.*l,b.*.1.*l+.875.*l,c.*.1.*l+1.25.*l);
set(aa2,'edgecolor','none','facecolor',[0 0 0])
[a,b,c]=sphere(25);
aa2=surf(a.*.1.*l+.2,b.*.1.*l+.85.*l,c.*.1.*l+1.25.*l);
set(aa2,'edgecolor','none','facecolor',[0 0 0])

% beak
Cone2 = Cone([0 0.5 1].*l ,[0.5 1.5 0.5].*l,[.25 0].*l,25,[.9 .5 .5]);

% legs
l1=line([0 0]-.1,[-.2 -.2].*l,[-.5 -1.5].*l);
set(l1,'linewidth',2,'color',[.9 .5 .5])
l2=line([0 0]+.1,[-.2 -.2].*l,[-.5 -1.5].*l);
set(l2,'linewidth',2,'color',[.9 .5 .5])

a= [.5 0 0;
	.5 0 0;
	1.5 1 0;
	1.5 1 0;
	.5 0 1;
	.5 0 1;
	.5 1 1;
	.5 1 1].*l;
		
a(:,2)=a(:,2)-.5.*l;
a(:,3)=a(:,3)-.5.*l;
a(:,1)=a(:,1)+0.2.*l;
		
b= [1 2 6 5;
	2 3 7 6;
	3 4 8 7;
	4 1 5 8;
	1 2 3 4;
	5 6 7 8];
		
% wings, first position
p1=patch('vertices',a,'faces',b,'edgecolor',[.5 .5 .5],'facecolor',[.9 .9 .9]);
a1=a;
a1(:,1)=-a1(:,1);
p2=patch('vertices',a1,'faces',b,'edgecolor',[.5 .5 .5],'facecolor',[.9 .9 .9]);

% second position of wings
a2= [.5 0 2;
	.5 0 2;
	1.5 1 2;
	1.5 1 2;
	.5 0 1;
	.5 0 1;
	.5 1 1;
	.5 1 1].*l;
a2(:,2)=a2(:,2)-.5.*l;
a2(:,3)=a2(:,3)-.5.*l;
a2(:,1)=a2(:,1)+.2.*l;
a3=a2;
a3(:,1)=-a3(:,1);

% animate wings
while true
	set(p1,'vertices',a2)
	set(p2,'vertices',a3)
	pause(.25)
	set(p1,'vertices',a)
	set(p2,'vertices',a1)
	pause(.25)
end

% get everything's handle
h=[aa1,aa3,Cone2,EndPlate1,EndPlate2,l1,l2];

% edited from a file on the FEX, create a cone
	function Cone2 = Cone(X1,X2,R,n,cyl_color)
		length_cyl=norm(X2-X1);
		t=linspace(0,2*pi,n)';
		x1=[0 length_cyl];
		xx1=repmat(x1,n,1);
		xx2=[R(1)*cos(t) R(2)*cos(t)];
		xx3=[R(1)*sin(t) R(2)*sin(t)];
		Cone2=mesh(xx1,xx2,xx3);	
		unit_Vx=[1 0 0];
		angle_X1X2=acos( dot( unit_Vx,(X2-X1) )/( norm(unit_Vx)*norm(X2-X1)) )*180/pi;
		axis_rot=cross([1 0 0],(X2-X1) );
		if angle_X1X2~=0
			rotate(Cone2,axis_rot,angle_X1X2,[0 0 0])
		end
		set(Cone2,'XData',get(Cone2,'XData')+X1(1),'facecolor',cyl_color)
		set(Cone2,'YData',get(Cone2,'YData')+X1(2))
		set(Cone2,'ZData',get(Cone2,'ZData')+X1(3))
		set(Cone2,'EdgeAlpha',0)
	end
end