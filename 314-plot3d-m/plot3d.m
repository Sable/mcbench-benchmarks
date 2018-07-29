function [b,d]=plot3d(a,alfa,beta);
% To use: [b,d]=plot3d(a,alfa,beta);
% This function produces an image of a 3D object
% defined by matrix a(l,m,n) in terms of voxels
% the image is a view after rotating the object 
% by angles alfa and beta (in degree)
% b is the image and d is its ditance to the viewer matrix
% The first figure depicts the object using only its gray level values
% The second image depicts the object using some lighting effect
% rotate3d may be used for reorientation but the obtained image is planner
% Kindly be patient the prog. is very slow!
% July-9-1998 Dr. H Azhari
%
% Example:
% x=zeros(40,40,40);
% x(10:30,10:30,10:30)=ones(21,21,21);
% x(15:25,15:25,:)=zeros(11,11,40);
% plot3d(x,30,20);
% colormap gray


time0=clock;
%-----------------
% Intial values
[l,m,n]=size(a);
M=max(size(a));
M1=round(sqrt(2)*M)+2;
b=zeros(M1,M1);
d=-M1*ones(M1,M1);
alfa=alfa*pi/180;
beta=beta*pi/180;
T=zeros(3,3); % Rotation matrix
T(1,1)=cos(alfa);
T(1,2)=sin(alfa);
T(1,3)=0;
T(2,1)=-cos(beta)*sin(alfa);
T(2,2)=cos(beta)*cos(alfa);
T(2,3)=sin(beta);
T(3,1)=sin(beta)*sin(alfa);
T(3,2)=-sin(beta)*cos(alfa);
T(3,3)=cos(beta);
xyz=[1,1,1]';
%-------------------------
for i=1:l,
    for j=1:m,
	for k=1:n,
	xyz=round(T*[i-l/2,j-m/2,k-n/2]');
	x1=round(M1/2+xyz(1)+1);
	y1=round(M1/2+xyz(2)+1);
	z1=round(M1/2+xyz(3)+1);
		if a(i,j,k)>0,
			if d(x1,y1)<z1,
			b(x1,y1)=a(i,j,k);
			d(x1,y1)=z1;
			end
		end


	end
    end
end

imagesc(b)
figure
[fx,fy]=gradient(d);
h=(b.*(d.^1.5+mean(mean(d/2))*(cos((atan(fy)+atan(fx))/2)).^2));
pcolor(flipud(h));shading 'interp' ;
%pcolor(flipud((b.*d).^1.5)); 
%shading 'interp'

%------------------------------
Elapsed_Time=etime(clock,time0)
