function proj2d = compute_one_projection_method_2(xs,ys,zs,data3d,psrc,pcdet,su,sv,nu,nv)
%
%	proj2d = compute_one_projection_method_2(xs,ys,zs,data3d,psrc,pcdet,su,sv,nu,nv)
%
%	Method 2: compute the project based on the stack of planes perpendicular to the src-detector line
%	This method should be faster than the line-integral method
%
%   Deshan Yang, PhD
%	Department of radiation oncology
%	Washington University in Saint Louis
%   01/16/2011, Saint Louis, MO, USA
%

corner_points = [...
	xs(1) ys(1) zs(1);...
	xs(1) ys(1) zs(end);...
	xs(1) ys(end) zs(1);...
	xs(1) ys(end) zs(end);...
	xs(end) ys(1) zs(1);...
	xs(end) ys(1) zs(end);...
	xs(end) ys(end) zs(1);...
	xs(end) ys(end) zs(end)...
	];

corner_points_t = zeros(8,1);
for k =1:8
	p = corner_points(k,:);
	[q,corner_points_t(k)] = project_1_point_to_a_line(psrc,pcdet,p);
end

t_min = min(corner_points_t);
t_max = max(corner_points_t);

dist = norm(psrc-pcdet);

N = ceil(dist*(t_max-t_min));	% N planes
dt = (t_max-t_min)/N;
ts = t_min:dt:t_max;


proj2d = zeros(nv,nu,'single');
vecu = [0 0 1];

vecn = psrc-pcdet;
vecv = cross(vecn,vecu);
vecv = vecv/norm(vecv);

us = ((-nu/2+0.5):1:(nu/2-0.5))*su/nu;
vs = ((-nv/2+0.5):1:(nv/2-0.5))*sv/nv;
[uu,vv] = meshgrid(us,vs);

for T = 1:N
	vecu_t = vecu*ts(T);
	vecv_t = vecv*ts(T);
	pcdet_t = psrc+ts(T)*(pcdet-psrc);

	vdet_t_xs = pcdet_t(1) + vecu_t(1)*uu + vecv_t(1)*vv;
	vdet_t_ys = pcdet_t(2) + vecu_t(2)*uu + vecv_t(2)*vv;
	vdet_t_zs = pcdet_t(3) + vecu_t(3)*uu + vecv_t(3)*vv;
	
	proj2d = proj2d + interp3(xs,ys,zs,data3d,vdet_t_xs,vdet_t_ys,vdet_t_zs,'linear',0)*dt*dist;
end

% adjust the value according to the projection path length
vdet_t_xs = pcdet(1) + vecu(1)*uu + vecv(1)*vv;
vdet_t_ys = pcdet(2) + vecu(2)*uu + vecv(2)*vv;
vdet_t_zs = pcdet(3) + vecu(3)*uu + vecv(3)*vv;

dists = sqrt((vdet_t_xs-psrc(1)).^2+(vdet_t_ys-psrc(2)).^2+(vdet_t_zs-psrc(3)).^2);
dists = dists / min(dists(:));
proj2d = proj2d .* dists;




