function [x, y, z, it]=icosahedron_nodes(f, r)
% % Syntax;
% % 
% % [x, y, z, it]=icosahedron_nodes(f, r);
% % 
% % ***********************************************************
% % 
% % Description
% % 
% % Program makes the master triangle for an icosahedron of 
% % f frequency of type 2. 
% % 
% % ***********************************************************
% % 
% % Input Variables
% % 
% % f is the frquency of the icosahedron.  
% % f=2 is similar to a soccer ball.
% % 
% % r is the radius of the icosahedron.  
% % 
% % ***********************************************************
% % 
% % Output Variables
% % 
% % x, y, and z are vectors with the rectangular coordinates for the nodes 
% %             of a hemispherical icosahedron. 
% % 
% % it is the matrix of coordinate indices for the rectangular coordinate 
% %    vectors.  
% % 
% % ***********************************************************
% % 
% 
% Example
% 
% f=2;  % 2 frequency icosahedron.
% 
% r=4;  % 4 meter radius.
% 
% [x2, y2, z2, it]=icosahedron_nodes(f, r);
% 
% % 
% % ***********************************************************
% % 
% % This program was written by Edward L. Zechmann 
% % 
% %     date     January 2007  
% % 
% % modified 11   March   2008  added examples
% % 
% % ***********************************************************
% % 
% % Feel free to modify this code.
% % 


%calculate the coordinate indices
% i1 -> x
% i2 -> y
% i3 -> z

num_pts=0.5*((f+1)^2+(f+1));

it=zeros(3,num_pts);

for e1=1:(f+1);
    i1=f-e1+1;
    for e2=1:(e1);
        i2=(e2-1);
        i3=(f-i1-i2);
        
        a=e1+1;
        b=f+1;
        if a <= f+1;
            pt=0.5*(b^2+b-a^2+a)+i2+1;
        else
            pt=i2+1;
        end
        
        it(1, pt)=i1;
        it(2, pt)=i2;
        it(3, pt)=i3;
    end
end

x1=1:num_pts;
y1=1:num_pts;
z1=1:num_pts;

% Coordinate formulas for base pentagon
% Icosahedron class 1, type 2, frequency f
tau=0.5*(1+sqrt(5));

for e1=1:num_pts;
    
    i1=it(1, e1);
    i2=it(2, e1);
    i3=it(3, e1);
    
    x1(e1)=i1*sin(72/180*pi);
    y1(e1)=i2+i1*cos(72/180*pi);
    z1(e1)=f/2+i3/tau;

end

[rho, theta, phi]=spherical_angle_ed(x1, y1, z1);
[x, y, z]=spherical_to_rectangular(r, theta, phi);




