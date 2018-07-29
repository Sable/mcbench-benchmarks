% Copyright (C) 2012 Quan Wang <wangq10@rpi.edu>, 
% Signal Analysis and Machine Perception Laboratory, 
% Department of Electrical, Computer, and Systems Engineering, 
% Rensselaer Polytechnic Institute, Troy, NY 12180, USA
% 
% You are free to use this software for academic purposes if you cite our paper: 
% Quan Wang, Kim L. Boyer, 
% The active geometric shape model: A new robust deformable shape model and its applications, 
% Computer Vision and Image Understanding, Volume 116, Issue 12, December 2012, Pages 1178-1194, 
% ISSN 1077-3142, 10.1016/j.cviu.2012.08.004. 
% 
% For commercial use, please contact the authors. 

function [xc yc a b phi]=fit_arb_ellipse_force(init,increment,threshold,bound,field_x,field_y,iter,show_fitness)

x0=init(1);
y0=init(2);
a0=init(3);
b0=init(4);
phi0=init(5);
d_xc=increment(1);
d_yc=increment(2);
d_a=increment(3);
d_b=increment(4);
d_phi=increment(5);
t_xc=threshold(1);
t_yc=threshold(2);
t_a=threshold(3);
t_b=threshold(4);
t_phi=threshold(5);
a_low=bound(1);
a_up=bound(2);
b_low=bound(3);
b_up=bound(4);

%%  Fit an arbitrary ellipse in the force filed. xc, yc, a, b and phi will be returned.
%   The parametric equations of the arbitrary ellipse:
%       x=xc+a*cos(theta)*cos(phi)-b*sin(theta)*sin(phi)
%       y=yc+a*cos(theta)*sin(phi)+b*sin(theta)*cos(phi)
%   x0, y0: initial position of center
%   a0, b0: initial semi-major and semi-minor axes
%   phi0: initial orientation
%   d_xc, d_yc: increment of xc and yc in each loop
%   d_a, d_b: increment of a and b in each loop
%   d_phi: increment of phi in each loop
%   t_xc, t_yc: threshold needed to update xc and yc
%   t_a, t_b: threshold needed to update a and b
%   t_phi: threshold needed to update phi
%   a_low, a_up: lower bound and upper bound of a
%   b_low, b_up: lower bound and upper bound of b
%   field_x: the x component of force field
%   field_y: the y component of force field
%   iter: number of iterations
%   show_fitness: a flag of whether to show the fitness function

% note: m rows and n columns, but x is column and y is row here
[m n]=size(field_x);

xc=x0;
yc=y0;
a=a0;
b=b0;
phi=phi0;

for it=1:iter
    [x,y,theta]=arb_ellipse_in_image(m,n,xc,yc,a,b,phi);
    N=max(size(x));
    
    %% torque along the ellpise about center
    torque_v=[0 0 0]; % the torque as a vector
    for i=1:max(size(theta))
        torque_v=torque_v+cross([x(i)-xc,y(i)-yc,0],...
            [field_x(y(i),x(i)),field_y(y(i),x(i)),0]);
    end
    torque=torque_v(3);
    torque=torque/N^2;
    if torque>t_phi
        phi=phi+d_phi;
    elseif torque<-t_phi
        phi=phi-d_phi;
    end
    
    %% F_around
    F_round=[0,0];
    for i=1:max(size(theta))
        F_round=F_round+[field_x(y(i),x(i)),field_y(y(i),x(i))];
    end
    F_round=F_round/max(size(theta));
    
    %% F_left, which is on the left quarter of the ellipse, and inward
    index = find( theta>pi*3/4 & theta<pi*5/4 );
    F_left=0;
    for i=index
        F_left=F_left+dot([field_x(y(i),x(i)),field_y(y(i),x(i))],[cos(phi),sin(phi)]);
    end
    F_left=F_left/max(size(index));
    
    %% F_right, which is on the right quarter of the ellipse, and inward
    index = find( theta<pi/4 | theta>pi*7/4 );
    F_right=0;
    for i=index
        F_right=F_right+dot([field_x(y(i),x(i)),field_y(y(i),x(i))],[-cos(phi),-sin(phi)]);
    end
    F_right=F_right/max(size(index));
    
    %% F_up, which is on the up quarter of the ellipse, and inward
    index = find( theta>pi/4 & theta<pi*3/4 );
    F_up=0;
    for i=index
        F_up=F_up+dot([field_x(y(i),x(i)),field_y(y(i),x(i))],[sin(phi),-cos(phi)]);
    end
    F_up=F_up/max(size(index));
    
    %% F_down, which is on the low quarter of the ellipse, and inward
    index = find( theta>pi*5/4 & theta<pi*7/4 );
    F_down=0;
    for i=index
        F_down=F_down+dot([field_x(y(i),x(i)),field_y(y(i),x(i))],[-sin(phi),cos(phi)]);
    end
    F_down=F_down/max(size(index));
    
    %% update xc and yc
    F_left_right=dot(F_round,[1,0]);
    if F_left_right>t_xc
        xc=xc+d_xc;
    elseif F_left_right<-t_xc
        xc=xc-d_xc;
    end
    
    F_down_up=dot(F_round,[0,1]);
    if F_down_up>t_yc
        yc=yc+d_yc;
    elseif F_down_up<-t_yc
        yc=yc-d_yc;
    end
    
    %% update xc and yc again according to diagonal force
    F_diag1=dot(F_round,[0.7071,0.7071]);
    if F_diag1>t_xc+t_yc
        xc=xc+d_xc;
        yc=yc+d_yc;
    elseif F_diag1<-t_xc-t_yc
        xc=xc-d_xc;
        yc=yc-d_yc;
    end
    
    F_diag2=dot(F_round,[-0.7071,0.7071]);
    if F_diag2>t_xc+t_yc
        xc=xc-d_xc;
        yc=yc+d_yc;
    elseif F_diag2<-t_xc-t_yc
        xc=xc+d_xc;
        yc=yc-d_yc;
    end
    
    %% update a and b
    
    if F_left+F_right>t_a
        a=a-d_a;
    elseif F_left+F_right<-t_a
        a=a+d_a;
    end
    
    if F_up+F_down>t_b
        b=b-d_b;
    elseif F_up+F_down<-t_b
        b=b+d_b;
    end
    
    if b>a
        temp=a;a=b;b=temp;
        phi=mod(phi+pi/2,pi);
    end
    
    %% restrict a and b using lower and upper bounds
    if a>a_up
        a=a_up;
    end
    if a<a_low
        a=a_low;
    end
    if b>b_up
        b=b_up;
    end
    if b<b_low
        b=b_low;
    end
    
    %% fitness function
    if show_fitness==1
        beta=0.9;
        fit0=0;
        fit1=0;
        fit2=0;
        [x,y,theta]=arb_ellipse_in_image(m,n,xc,yc,a,b,phi);
        [x1,y1,theta1]=arb_ellipse_in_image(m,n,xc,yc,a*beta,b*beta,phi);
        [x2,y2,theta2]=arb_ellipse_in_image(m,n,xc,yc,a/beta,b/beta,phi);
        for i=1:max(size(theta))
            fit0=fit0+norm([field_x(y(i),x(i)),field_y(y(i),x(i))]);
        end
        for i=1:max(size(theta1))
            fit1=fit1+norm([field_x(y1(i),x1(i)),field_y(y1(i),x1(i))]);
        end
        for i=1:max(size(theta2))
            fit2=fit2+norm([field_x(y2(i),x2(i)),field_y(y2(i),x2(i))]);
        end
        fit0=fit0/max(size(theta));
        fit1=fit1/max(size(theta1));
        fit2=fit2/max(size(theta2));
        fit_save(it)=fit0-fit1/2-fit2/2;
    end
    
end

if show_fitness==1
    figure;hold on;
    plot(1:iter,fit_save,'b','LineWidth',2);
    legend('fitness function');
    grid on;
    xlabel('iteration');
    ylabel('fitness function');
    title('fitness function in each iteration');
end