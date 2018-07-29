function [q] = MeshQuality(EToV,VX,VY)
%
% Purpose: Assess the triangle mesh quality using a mesh quality indicators.
%          q=2r/R, where r is the inradius and R is the circumradius of a
%          triangle.
%
%          Function is useful for detecting degenerate triangles.
%
%          EToV : Element-To-Vertice table
%          VX   : x-table for vertices
%          VY   : y-table for vertices
%
% By Allan P. Engsig-Karup, apek@imm.dtu.dk.

% Compute side lengths of triangles
lx = VX(EToV(:,[1 2 3])) - VX(EToV(:,[3 1 2]));
ly = VY(EToV(:,[1 2 3])) - VY(EToV(:,[3 1 2]));
l = sqrt(lx.^2+ly.^2);
a = l(:,1); b = l(:,2); c = l(:,3);
q = (b+c-a).*(c+a-b).*(a+b-c)./(a.*b.*c);

N = 100; 
x = linspace(0,1,N+1);
dx = x(2)-x(1);
subdivision = x(1:N)+dx/2;
count = zeros(1,N);
K = size(EToV,1);
for i = 1 : length(subdivision)
    count(i) = length(find(q>subdivision(i)-dx/2 & q<=subdivision(i)+dx/2))/K*100;
end
figure
bar(subdivision,count,1)
minlimit = find(q<0.7);
if isempty(minlimit)
    axis([0.7 1 -1 max(count)*1.05])
else
    axis([min(q) 1 -1 max(count)*1.05])
    hold on
    plot([0.7 0.7],[0 100],'r--')
end
xlabel('Mesh quality')
ylabel('Percentage of elements')
colormap(cool)
