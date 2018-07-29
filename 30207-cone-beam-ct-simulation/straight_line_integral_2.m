function val = straight_line_integral_2(xs,ys,zs,data3d,x1,y1,z1,x2,y2,z2)
%
%   Deshan Yang, PhD
%	Department of radiation oncology
%	Washington University in Saint Louis
%   01/16/2011, Saint Louis, MO, USA
%   
%   val = straight_line_integral_2(xs,ys,zs,data3d,x1,y1,z1,x2,y2,z2)
%
%   Perform straight line integration on the 3D data from point 1 to point
%   2
%
%   Deshan Yang, PhD
%   01/16/2011, Saint Louis, MO, USA
%
%   This function assumes that the point positions are given in the same
%   coordinate system as the 3D data. Any coordination transformation or
%   scaling should be done priorly. 
%
%   Both data and points should be in single, or double
%
dim = [size(data3d) 1];
% if numel(xs)~=length(xs) || length(xs) ~= dim(2) || ...
% 		numel(ys)~=length(ys) || length(ys) ~= dim(1) || ...
% 		numel(zs)~=length(zs) || length(zs) ~= dim(3)
% 	fprintf('Incorrect image data: length does not match to the image dimension.\n');
% 	return;
% end

% Make sure the image and the voxel coordinate be positively increasing. If not, then flip it
[xs,ys,zs,data3d] = make_sure_positive(xs,ys,zs,data3d);
psrc = [x1,y1,z1];
pcdet = [x2,y2,z2];

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

xst = psrc(1)+(pcdet(1)-psrc(1))*ts;
yst = psrc(2)+(pcdet(2)-psrc(2))*ts;
zst = psrc(3)+(pcdet(3)-psrc(3))*ts;

val = sum(interp3(xs,ys,zs,data3d,xst,yst,zst,'linear',0))*dt;

% % Transform the point coordinate into the image voxel index
% x1 = (x1 - xs(1))/dx+0.5;
% x2 = (x2 - xs(1))/dx+0.5;
% y1 = (y1 - ys(1))/dy+0.5;
% y2 = (y2 - ys(1))/dy+0.5;
% z1 = (z1 - zs(1))/dz+0.5;
% z2 = (z2 - zs(1))/dz+0.5;
% 
% 
% nx = ceil(min(x1,x2)):floor(max(x1,x2));
% tx = (nx-x1)/(x2-x1);
% 
% ny = ceil(min(y1,y2)):floor(max(y1,y2));
% ty = (ny-y1)/(y2-y1);
% 
% nz = ceil(min(z1,z2)):floor(max(z1,z2));
% tz = (nz-z1)/(z2-z1);
% 
% 
% 
% ts = sort([tx ty tz]);    % It may be slow here
% dist = sqrt((x2-x1).^2+(y2-y1).^2+(z2-z1).^2);
% 
% nx = (x2-x1)*ts+x1;
% ny = (y2-y1)*ts+y1;
% nz = (z2-z1)*ts+z1;
% 
% idxes = find(nx>=0 & nx<=dim(2) & ny>=0 & ny<=dim(1) & nz>=0 & nz<=dim(3));
% nx = nx(idxes);
% ny = ny(idxes);
% nz = nz(idxes);
% N_1 = length(nx)-1;
% 
% xidx = max(ceil((nx(1:N_1)+nx(2:end))/2),1);
% yidx = max(ceil((ny(1:N_1)+ny(2:end))/2),1);
% zidx = max(ceil((nz(1:N_1)+nz(2:end))/2),1);
% 
% if ~isempty(xidx)
%     if x2~=x1
%         lengths = diff(nx)/(x2-x1);
%     else
%         lengths = diff(ny)/(y2-y1);
%     end
%     
%     val = sum(data3d(sub2ind(dim,yidx,xidx,zidx)).*lengths)*dist;
% 	val = val*dx*dy*dz;	% Convert the length back to the original image coordinate length
% else
%     val = 0;
% end
% 
% 
% 
% 
