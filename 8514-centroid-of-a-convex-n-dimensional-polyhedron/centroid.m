% CENTROID - computes the center of gravity of a convex polyhedron in any
%            number of dimensions
%
% USAGE: C = centroid(P)
% 
% P = Matrix of convex polyhedron vertices: each row is a vertex, and each
%     column is a dimension.
% C = Row vector of centroid coordinates. Each column is a dimension.
%
% Notes: (1) This function computes the centroid by partitioning into
%            simplices and determining the weighted sum of their centroids.
%        (2) Written in response to a posting on comp.soft-sys.matlab
%
% Michael Kleder, Sep 2005
%
% EXAMPLE:
%
% % create 10-point convex polyhedron:
% k=0;
% while length(unique(k))<10
% x=rand(10,1);
% y=rand(10,1);
% z=rand(10,1);
% k=convhulln([x y z]);
% end
% P=[x y z]; % polyhedron points
% C=centroid(P);
% close all
% fn=figure;hold on;axis equal;grid on
% plot3(x,y,z,'b.','markersize',20)
% for m = 1:length(k)
%     f = k(m,:);
% patch(x(f),y(f),z(f),'g','facealpha',.5)
% end
% plot3(C(1),C(2),C(3),'r.','markersize',24)
% view(45,45)
% axis vis3d
% set(gca,'xticklabel','','yticklabel','','zticklabel','')
% for az=45:5:405
%     if ~ishandle(fn)
%         break
%     end
%     view(az,45)
%     drawnow
%     pause(.1)
% end


function C = centroid(P)
k=convhulln(P);
if length(unique(k(:)))<size(P,1)
    error('Polyhedron is not convex.');
end
T = delaunayn(P);
n = size(T,1);
W = zeros(n,1);
C=0;
for m = 1:n
    sp = P(T(m,:),:);
    [null,W(m)]=convhulln(sp);
    C = C + W(m) * mean(sp);
end
C=C./sum(W);
return