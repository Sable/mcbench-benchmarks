function [TRI4, x4, y4, z4]=make_sphere(TRI, x, y, z)
% % Syntax;
% % 
% % [TRI3, x3, y3, z3]=make_sphere(TRI, x, y, z);
% % 
% % ***********************************************************
% % 
% % Description
% % 
% % Program makes the dome of an even frequency icosahedron 
% % into a full spherical icosahedron.  
% % 
% % ***********************************************************
% % 
% % Input Variables
% % 
% % x, y,and z are row vector of the x, y, and z coordinates of the   
% % icosahedron nodes of the dome. 
% % 
% % TRI is the triangularization of the icosahedron nodes. 
% % 
% % ***********************************************************
% % 
% % Output Variables
% % 
% % x4,y4,and z4 are row vector of the x4, y4, and z4 coordinates of the   
% % full spherical icosahedron nodes. 
% % 
% % TRI4 is the triangularization of the spherical icosahedron nodes. 
% % 
% % ***********************************************************
% % 
% Example
% 
% f=2; % 2 freuqency similar to soccer ball 
% 
% r=4; % 4 meter radius
% 
% [x2, y2, z2, it]=icosahedron_nodes(f, r);
% 
% [x, y, z]=build_icosa(x2, y2, z2);
% 
% [rho, theta, phi]=spherical_angle_ed(x, y, z);
% 
% [x10, y10, z10]=splat(rho, theta, phi);
% 
% TRI = delaunay(x10, y10);
% 
% [TRI, x, y, z]=make_sphere(TRI, x, y, z);
% 
% figure(1);
% h=trisurf(TRI,x,y,z, 'FaceColor', [1 0 0], 'EdgeColor', 0*[1 1 1], ...
% 'LineWidth', 1 );
% title('Red Soccer Ball');
% axis equal
% 
% % ***********************************************************
% % 
% % This program was written by Edward L. Zechmann 
% % 
% % date 7   March   2008  
% % 
% % modified 11   March   2008  added examples and comments
% % 
% % ***********************************************************
% % 
% % Feel free to modify this code.
% % 

nn=length(x);
r=sqrt((x(1, 1).^2+y(1, 1).^2+z(1, 1).^2));

% Calculate the frequency from the length of x
% Assuming that x,y,and z are for a dome.
% length(x)=5*f^2+5/2*f+1;
% using the quadratic equation
f=round(0.25*(sqrt(1/5*(16*length(x)-11))-1));


% For a full sphere the freuqency can be caculated from teh number 
% of nodes by the formulas
% length(x)=10*f^2+2;
% Using the quadratic equation
% f=round(sqrt((length(x)-2)/10));

ix1=find( abs(z) < 0.01*r/(f+1));
ix2=setdiff(1:nn, ix1);

trix2=[];
trix3=[];
m=length(TRI);

for e1=1:m;
    
   tri1=TRI(e1, :);
    
    aa=intersect(tri1,ix1);
    
    if ~isempty(aa)
        trix2=[trix2 e1];
    else
        trix3=[trix3 e1];
    end
    
end


TRI2=TRI(trix2, :);
TRI3=TRI(trix3, :); 
TRI33=zeros(size(TRI3));

for e1=1:length(TRI3);    
    for e2=1:3;
        TRI33(e1, e2)=find(TRI3(e1, e2)==ix2);
    end
end

TRI22=zeros(size(TRI2));

for e1=1:length(TRI2);    
    for e2=1:3;
        
        ix3=find(TRI2(e1, e2)==ix1);
        if ~isempty(ix3)
            TRI22(e1, e2)=ix1(ix3);
        else
            ix4=nn+find(TRI2(e1, e2)==ix2);
            TRI22(e1, e2)=ix4;
        end
        
    end
end

x4=[x x(ix2)];
y4=[y y(ix2)];
z4=[z -z(ix2)];

TRI4=[TRI' [nn+TRI33]' TRI22']';

