function [x2, y2, z2]=build_icosa(x, y, z)
% % Syntax;
% % 
% % [x2, y2, z2]=build_icosa(x, y, z);
% % 
% % ***********************************************************
% % 
% % Description
% % 
% % Program makes a hemispherical icosahedron of f frequency of type 2 
% % If f is even a full hemisphere is output.  
% % If f is odd only a partial hemisphere is output. 
% % Odd frequency icosahedra do not have a hemispherical cutting plane.  
% % 
% % ***********************************************************
% % 
% % Input Variables
% %
% % x, y, z are vectors with the rectangular coordinates of the 
% %         master triangle fro an icosahedron.
% % 
% % ***********************************************************
% % 
% % Output Variables
% % 
% % x2, y2, z2 are vectors with the rectangular coordinates for the nodes a
% % of a hemispherical icosahedron. 
% % 
% % 
% % ***********************************************************
% % 
% Example
% 
% f=2;  % 2 frequency icosahedron.
% 
% r=4;  % 4 meter radius.
% 
% [x2, y2, z2, it]=icosahedron_nodes(f, r);
% 
% [x, y, z]=build_icosa(x2, y2, z2, sphere);
% 
% % ***********************************************************
% % 
% % List of Sub Programs
% % 
% % rotate_transform2
% % shift_theta
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

nx=length(x);
radius=norm([x(1), y(1), z(1)]);

f=-3/2+sqrt(9/4+2*(length(x)-1));

% remove the right edge
% nre--> no right edge
re=(1:(f+1));
nre=setdiff(1:nx, re);

% remove the left edge
% nle--> no right edge
b=f+1; 
ig=1;

for e1=1:f;

    a=f+2-e1; 
    e2=0.5*(b^2+b-a^2+a)+1;
    ig=[ig e2];

end

le=ig;
nle=setdiff(1:nx, le);

% remove the bottom edge
% nbe--> no bottom edge
ib=[];

for e1=1:(f+1);
    ib=[ib ig(e1)+f+1-e1];
end

be=ib;
nbe=setdiff(1:nx, be);
    
% make master triangle

x3=x(nre);
y3=y(nre);
z3=z(nre);

x2=x3;
y2=y3;
z2=z3;

v=[x(f+1), y(f+1), z(f+1)];

[x4, y4, z4]=rotate_transform2(x3, y3, z3, v, 72);

x2=[x2 x4];
y2=[y2 y4];
z2=[z2 z4];

nrorbe=intersect(nre, nbe);

x3=x(nrorbe);
y3=y(nrorbe);
z3=z(nrorbe);

[x4, y4, z4]=rotate_transform2(x3, y3, z3, v, 144);

x2=[x2 x4];
y2=[y2 y4];
z2=[z2 z4];

x3=x(nle);
y3=y(nle);
z3=z(nle);

% To make a full sphere of odd frequency one line of nodes below z=0 
% must be kept.
% For the even frequencies only keep the nodes that are very close to z=0.
% 
if mod(f, 2) == 0  
    IX=find( z2 > -0.01*radius/(f+1));
else
    if isequal(sphere, 1)
        IX=find( z2 > -0.5*radius/(f+1));
    else
        IX=find( z2 > -0.01*radius/(f+1));
    end
end

x2=x2(IX);
y2=y2(IX);
z2=z2(IX);

x3=x2;
y3=y2;
z3=z2;

for e1=1:4;
    
    theta=e1*72/180*pi;

    [x1, y1, z1]=shift_theta(x3,y3,z3, theta);

    x2=[x2 x1];
    y2=[y2 y1];
    z2=[z2 z1];
    
end

x2=[x2 0];
y2=[y2 0];
z2=[z2 radius];

% The hemispherical dome is completed.
