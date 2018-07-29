function val = straight_line_integral(xs,ys,zs,data3d,p1,p2)
%   
%   val = straight_line_integral(xs,ys,zs,data3d,p1,p2)
%
%   Perform straight line integration on the 3D data from point 1 to point
%   2
%
%   Deshan Yang, PhD
%	Department of radiation oncology
%	Washington University in Saint Louis
%   01/16/2011, Saint Louis, MO, USA
%
%   This function assumes that the point positions are given in the same
%   coordinate system as the 3D data. Any coordination transformation or
%   scaling should be done priorly. 
%
%   Both data and points should be in single, or double
%
% dim = [size(data3d) 1];
% if numel(xs)~=length(xs) || length(xs) ~= dim(2) || ...
% 		numel(ys)~=length(ys) || length(ys) ~= dim(1) || ...
% 		numel(zs)~=length(zs) || length(zs) ~= dim(3)
% 	fprintf('Incorrect image data: length does not match to the image dimension.\n');
% 	return;
% end

dx = xs(2)-xs(1);
dy = ys(2)-ys(1);
dz = zs(2)-zs(1);
d = [dx dy dz];
origin = [xs(1) ys(1) zs(1)];

% Transform the point coordinate into the image voxel index
% p1(1) = (p1(1) - xs(1))/dx+0.5;
% p2(1) = (p2(1) - xs(1))/dx+0.5;
% p1(2) = (p1(2) - ys(1))/dy+0.5;
% p2(2) = (p2(2) - ys(1))/dy+0.5;
% p1(3) = (p1(3) - zs(1))/dz+0.5;
% p2(3) = (p2(3) - zs(1))/dz+0.5;

p1 = (p1-origin)./d+0.5;
p2 = (p2-origin)./d+0.5;

if p1(1)<p2(1)
	nx = ceil(p1(1)):floor(p2(1));
	tx = (nx-p1(1))/(p2(1)-p1(1));
else
	nx = floor(p1(1)):-1:ceil(p2(1));
	tx = (nx-p1(1))/(p2(1)-p1(1));
end

if p1(2)<p2(2)
	ny = ceil(p1(2)):floor(p2(2));
	ty = (ny-p1(2))/(p2(2)-p1(2));
else
	ny = floor(p1(2)):-1:ceil(p2(2));
	ty = (ny-p1(2))/(p2(2)-p1(2));
end

% ny = ceil(min(p1(2),p2(2))):floor(max(p1(2),p2(2)));
% ty = (ny-p1(2))/(p2(2)-p1(2));

if p1(3)<p2(3)
	nz = ceil(p1(3)):floor(p2(3));
	tz = (nz-p1(3))/(p2(3)-p1(3));
else
	nz = floor(p1(3)):-1:ceil(p2(3));
	tz = (nz-p1(3))/(p2(3)-p1(3));
end
% nz = ceil(min(p1(3),p2(3))):floor(max(p1(3),p2(3)));
% tz = (nz-p1(3))/(p2(3)-p1(3));


txy = sort_ts1_ts2(tx,ty);
ts = sort_ts1_ts2(txy,tz);

% ts = sort([tx ty tz]);    % It may be slow here
val = straight_line_integral_inner(data3d,p1,p2,ts)*dx*dy*dz;
% return;
% 
% % dist = sqrt((p2(1)-p1(1)).^2+(p2(2)-p1(2)).^2+(p2(3)-p1(3)).^2);
% dist = norm(p1-p2);
% 
% nx = (p2(1)-p1(1))*ts+p1(1);
% ny = (p2(2)-p1(2))*ts+p1(2);
% nz = (p2(3)-p1(3))*ts+p1(3);
% 
% a = (nx>=0 & nx<=dim(2) & ny>=0 & ny<=dim(1) & nz>=0 & nz<=dim(3));
% idxes = find(a,1,'first') : find(a,1,'last');	%find(nx>=0 & nx<=dim(2) & ny>=0 & ny<=dim(1) & nz>=0 & nz<=dim(3));
% ts2 = ts(idxes);
% 
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
% %     if p2(1)~=p1(1)
% %         lengths = diff(nx)/(p2(1)-p1(1));
% %     else
% %         lengths = diff(ny)/(p2(2)-p1(2));
% %     end
%     lengths = diff(ts2);
% 	
%     val = sum(data3d(sub2ind(dim,yidx,xidx,zidx)).*lengths)*dist;
% 	val = val*dx*dy*dz;	% Convert the length back to the original image coordinate length
% else
%     val = 0;
% end
% 
% % fprintf('Val=%.4f, val2=%.4f\n',val,val2);




