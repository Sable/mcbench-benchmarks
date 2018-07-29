function trajectory(x,y,z,pitch,roll,yaw,scale_factor,step)

%   function traiettoria(x,y,z,pitch,roll,yaw,scale_factor,step)
%   
%
%   x,y,z               center trajectory (vector)    [m]
%   pitch,roll,yaw      euler's angles                [rad]
%   scale_factor        normalization factor
%   step                attitude sampling factor   
%
%   *******************************
%   Function Vesrion 1.0 
%   17/02/2004
%   Valerio Scordamaglia
%   *******************************
if (length(x)~=length(y))||(length(x)~=length(z))||(length(y)~=length(z))
    disp('  Error:');
    disp('      Uncorrect Dimension of the center trajectory Vectors. Please Check the size');
    return;
end
if ((length(pitch)~=length(roll))||(length(pitch)~=length(yaw))||(length(roll)~=length(yaw)))
    disp('  Error:');
    disp('      Uncorrect Dimension of the euler''s angle Vectors. Please Check the size');
    return;
end
if length(pitch)~=length(x)
    disp('  Error:');
    disp('      Size mismatch between euler''s angle vectors and center trajectory vectors');
    return
end
if step>=length(x)
    disp('  Error:');
    disp('      Attitude samplig factor out of range. Reduce step');
    return
end
if step<1
    step=1;

end

[xxx,yyy,zzz]=miss_shape(scale_factor);



ii=length(x);
resto=mod(ii,step);

for i=1:step:(ii-resto)
  
theta=pitch(i);
phi=roll(i);
psi=yaw(i);
Tbe=[cos(psi)*cos(theta) sin(psi)*cos(theta) -sin(theta);((cos(psi)*sin(theta)*sin(phi))-(sin(psi)*cos(phi))) ((sin(psi)*sin(theta)*sin(phi))+(cos(psi)*cos(phi))) cos(theta)*sin(phi);((cos(psi)*sin(theta)*cos(phi))+(sin(psi)*sin(phi))) ((sin(psi)*sin(theta)*cos(phi))-(cos(psi)*sin(phi))) cos(theta)*cos(phi)];

Tbe=Tbe';

x_hat=0.*xxx;
y_hat=0.*yyy;
z_hat=0.*zzz;

for iii=1:size(xxx,1)
    for jjj=1:size(xxx,2)
        tmp_b=[xxx(iii,jjj);yyy(iii,jjj);zzz(iii,jjj)];
        tmp_e=Tbe'*tmp_b;
        x_hat(iii,jjj)=x(i)+tmp_e(1,1);
        y_hat(iii,jjj)=y(i)+tmp_e(2,1);
        z_hat(iii,jjj)=z(i)+tmp_e(3,1);
    end
end

plot3(x_hat,y_hat,z_hat);


hold on;
patch(x_hat,y_hat,z_hat,[1 0 0]);

end
axis equal;
%grid off
hold on;
plot3(x,y,z);
light;
grid on;
view(82.50,2);


xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');


%the following function is a remake of the matlab function

function [x,y,z]=miss_shape(ss)

	num=30;				% Number of z-y segments to make the circle
	count=1;			% Counter for number of individual patches
	theta=[360/2/num:360/num:(360+360/2/num)]*pi/180;

	len 			= 25.7;				% Total Length (no units)
    
	radius		= 1.5/2;				% Radius of body
 	s_fore	 	= 5;					% Start of main body (w.r.t. nose)
   	thr_len 		= 1.4;				% Length of Motor exit
 	rad_throt	= 1.3/2;				% radius of motor exit
   	l_fore=len-s_fore-thr_len;			% Length of main body
   	c_g 			= 14;				% Position of c.g. w.r.t nose
   
%
% Fore Body Shape
%
	yc_range =  radius*sin(theta);
	zc_range = -radius*cos(theta);
	for i = 1:num
	   xcraft{i}=[s_fore s_fore s_fore+l_fore s_fore+l_fore ]-c_g;
	   ycraft{i}=[yc_range(i) yc_range(i+1) yc_range(i+1) yc_range(i)];
	   zcraft{i}=[zc_range(i) zc_range(i+1) zc_range(i+1) zc_range(i)];
	end
   count=num+1;   
%
% Throttle Shape
%
	yc_range2 =  rad_throt*sin(theta);axis
	zc_range2 = -rad_throt*cos(theta);
	for i = 1:num
	   xcraft{count}=[len-thr_len len-thr_len len len]-c_g;
	   ycraft{count}=[yc_range(i) yc_range(i+1) yc_range2(i+1) yc_range2(i)];
      zcraft{count}=[zc_range(i) zc_range(i+1) zc_range2(i+1) zc_range2(i)];
      count=count+1;
	end

%
% Nose Shape
%
	for i = 1:num
	   xcraft{count}=[s_fore s_fore 0 s_fore]-c_g;
	   ycraft{count}=[yc_range(i) yc_range(i+1) 0 yc_range(i)];
      zcraft{count}=[zc_range(i) zc_range(i+1) 0 zc_range(i)];
      count=count+1;
	end
%
% Wing shapes 
%
	xcraft{count}=[10.2 13.6 14.6 15]-c_g;
	ycraft{count}=[-zc_range(1) -zc_range(1)+1.5 -zc_range(1)+1.5 -zc_range(1)];
	zcraft{count}=[0 0 0 0 ];
	xcraft{count+1}=xcraft{count};
	ycraft{count+1}=-ycraft{count};
	zcraft{count+1}=zcraft{count};
% 	xcraft{count+2}=xcraft{count};
% 	ycraft{count+2}=zcraft{count};
% 	zcraft{count+2}=ycraft{count};
% 	xcraft{count+3}=xcraft{count};
% 	ycraft{count+3}=zcraft{count};
% 	zcraft{count+3}=-ycraft{count};
%
% Tail shapes 
%
   count=count+2;
	xcraft{count}=[22.1 22.9 23.3 23.3]-c_g;
	ycraft{count}=[-zc_range(1) -zc_range(1)+1.1 -zc_range(1)+1.1 -zc_range(1)];
	zcraft{count}=[0 0 0 0];
  	xcraft{count+1}=xcraft{count};
	ycraft{count+1}=-ycraft{count};
	zcraft{count+1}=zcraft{count};
	xcraft{count+2}=xcraft{count};
	ycraft{count+2}=zcraft{count};
	zcraft{count+2}=ycraft{count};
% 	xcraft{count+3}=xcraft{count};
% 	ycraft{count+3}=zcraft{count};
% 	zcraft{count+3}=-ycraft{count};
   	count=count+2;
      
%
% Combine individual objects into a single set of co-ordinates and roll through 45 degrees
%
   x=[];y=[];z=[];
   roll = [1 0 0;0 cos(0/180*pi) sin(0/180*pi);0 -sin(0/180*pi) cos(0/180*pi)];
   for i = 1:count
      x = [x xcraft{i}'];
	  y = [y ycraft{i}'];
	  z = [z zcraft{i}'];
	end
   
   for i =1:4
      dum = [x(i,:);y(i,:);z(i,:)];
      dum = roll*dum;
      x(i,:)=dum(1,:);
      y(i,:)=dum(2,:);
      z(i,:)=dum(3,:);
   end
%
% Rescale vertices
%

% x = -x/len;
% 	y = y/len;
%    	z = z/len;
   
x = -x/ss;
y = y/ss;
    	z = z/ss;
   
% End miss_shape










