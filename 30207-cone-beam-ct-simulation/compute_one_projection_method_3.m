function proj2d = compute_one_projection_method_3(xs,ys,zs,data3d,psrc,pcdet,su,sv,nu,nv)
%
%	proj2d = compute_one_projection_method_3(xs,ys,zs,data3d,psrc,pcdet,su,sv,nu,nv)
%
%	Method 3: compute projection in the way similar to MATLAB radon transformation method
%
%   Deshan Yang, PhD
%	Department of radiation oncology
%	Washington University in Saint Louis
%   01/16/2011, Saint Louis, MO, USA

[xs,ys,zs,data3d] = make_sure_positive(xs,ys,zs,data3d);
dx = xs(2)-xs(1);
dy = ys(2)-ys(1);
dz = zs(2)-zs(1);

new_xs = [xs xs]*0;	new_xs(1:2:end) = xs-dx/4; new_xs(2:2:end)=xs+dx/4;
new_ys = [ys ys]*0;	new_ys(1:2:end) = ys-dy/4; new_ys(2:2:end)=ys+dy/4;
new_zs = [zs zs]*0;	new_zs(1:2:end) = zs-dz/4; new_zs(2:2:end)=zs+dz/4;


proj2d = zeros(nu,nv,'single');

du = su/nu;
dv = sv/nv;

dim = size(data3d);
% dist = norm(psrc-pcdet);
dot_p1_p0 = dot(pcdet-psrc,pcdet-psrc);

vecu = [0 0 1];

vecn = psrc-pcdet;
vecv = cross(vecn,vecu);
vecv = vecv/norm(vecv);

for NZ = 1:length(new_zs)
	fprintf('NZ=%d\n',NZ);
	kz2 = ceil(NZ/2);
	[new_xx,new_yy,new_zz] = meshgrid(new_xs,new_ys,new_zs(NZ));
	
% 	tq = dot(p1-p0,p-p0)/dot(p1-p0,p1-p0);
	distq = -((psrc(1)-new_xx)*(pcdet(1)-psrc(1)) + (psrc(2)-new_yy)*(pcdet(2)-psrc(2)) + (psrc(3)-new_zz)*(pcdet(3)-psrc(3)))/dot_p1_p0;

% 	distq = sqrt((psrc(1)-new_xx).^2+(psrc(2)-new_yy).^2+(psrc(3)-new_zz).^2);
	proj_p_x = (new_xx-psrc(1))./distq+psrc(1)-pcdet(1);
	proj_p_y = (new_yy-psrc(2))./distq+psrc(2)-pcdet(2);
	proj_p_z = (new_zz-psrc(3))./distq+psrc(3)-pcdet(3);
	
	us = round(proj_p_z/du+nu/2);
	% 	vs = round(sqrt(proj_p_x.^2+proj_p_y.^2)/dv+nv/2);
	vs = round((proj_p_x*vecv(1)+proj_p_y*vecv(2))/dv+nv/2);
	
	kx2 = ceil((1:(dim(2)*2))/2);
	ky2 = ceil((1:(dim(1)*2))/2);
	
	ori_data = data3d(ky2,kx2,kz2);
	
	u = us(:);
	v = vs(:);
	data = ori_data(:);
	idxes = find(u>0 & u<nu & v>0 & v<nv);
	
	proj_idxes = sub2ind(size(proj2d),u(idxes),v(idxes));
	if ~isempty(proj_idxes)
		for m = 1:length(proj_idxes);
			proj2d(proj_idxes(m)) = proj2d(proj_idxes(m)) + data(idxes(m))/8;
		end
% 		proj2d(proj_idxes) = proj2d(proj_idxes) + data(idxes)/8;
	end
	
% 	for kx = 1:dim(2)*2
% 		kx2 = ceil(kx/2);
% 		for ky = 1:dim(1)*2
% 			ky2 = ceil(ky/2);
% 			kz=1;
% % 			for kz = 1:dim(3)*2
% 				u = us(ky,kx,kz);
% 				v = vs(ky,kx,kz);
% 				if u>0 && u<=nu && v>0 && v<=nv
% 					proj2d(u,v) = proj2d(u,v)+data3d(ky2,kx2,kz2)/8;
% 				end
% % 			end
% 		end
% 	end
end


