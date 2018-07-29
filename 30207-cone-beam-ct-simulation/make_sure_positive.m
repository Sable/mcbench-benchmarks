function [xs,ys,zs,data3d] = make_sure_positive(xs,ys,zs,data3d)
%
%	[xs,ys,zs,data3d] = make_sure_positive(xs,ys,zs,data3d)
%
% Make sure the image and the voxel coordinate be positively increasing. If not, then flip it
%   Deshan Yang, PhD
%	Department of radiation oncology
%	Washington University in Saint Louis
%   01/16/2011, Saint Louis, MO, USA
%
xs = makeRowVector(xs);
ys = makeRowVector(ys);
zs = makeRowVector(zs);

dx = xs(2)-xs(1);
if dx<0
	xs = fliplr(xs);
	data3d = flipdim(data3d,2);
end
	
dy = ys(2)-ys(1);
if dy<0
	ys = fliplr(ys);
	data3d = flipdim(data3d,1);
end

dz = zs(2)-zs(1);
if dz<0
	zs = fliplr(zs);
	data3d = flipdim(data3d,3);
end
end

function vecout = makeRowVector(vecin)
vecout = (vecin(:))';
end
