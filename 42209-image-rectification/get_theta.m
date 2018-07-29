function [theta,l] = get_theta(e,dim)

%% Let K be a cone originated at (polar)origin
%  \theta(1),\theta(2) are K's borders
%

theta   = nan(2,1);
p       = epip_quadrant(e,dim);
ep1     = p(1:2,1)-e(1:2);
ep1     = ep1/norm(ep1);
ep2     = p(1:2,2)-e(1:2);
ep2     = ep2/norm(ep2);
theta(1)= atan2(ep1(2),ep1(1));
theta(2)= atan2(ep2(2),ep2(1));
l(:,1)  = cross(e,p(:,1));
l(:,2)  = cross(e,p(:,2));

if theta(1) < 0
    theta(1) = pi+theta(1);
end
if theta(2) < 0
    theta(2)= pi+theta(2);
end

if theta(1)>theta(2)
    theta = flipud(theta);
    l = fliplr(l);
end
