function proj2d = compute_one_projection(xs,ys,zs,data3d,psrc,pcdet,su,sv,nu,nv)
%
%	proj2d = compute_one_projection(xs,ys,zs,data3d,psrc,pcdet,su,sv,nu,nv)
%
%	xs,ys,zs,data3d -	to describe the 3D object
%	psrc = [x,y,z]	-	the x-ray source point
%	pcdet = [x,y,z] -	the detect center point position
%	su,sv			-	the size of the detector
%	nu,nv			-	number of pixels on the detector
%
%	v - along the gantry rotation circle
%	u - perpendicular to the gantry rotation circle
%
%   Deshan Yang, PhD
%	Department of radiation oncology
%	Washington University in Saint Louis
%   01/16/2011, Saint Louis, MO, USA
%
[xs,ys,zs,data3d] = make_sure_positive(xs,ys,zs,data3d);

% vecu = pcdet;
% vecu(3) = vecu(3)+1;

vecu = [0 0 1];

vecn = psrc-pcdet;
vecv = cross(vecn,vecu);
vecv = vecv/norm(vecv);

proj2d = zeros(nu,nv,'double');
us = ((-nu/2+0.5):1:(nu/2-0.5))*su/nu;
vs = ((-nv/2+0.5):1:(nv/2-0.5))*sv/nv;
for ku = 1:nu
	if mod(ku,50)==0
		fprintf('ku=%d (total = %d)\n',ku,nu);
	end
	u = us(ku);
	for kv = 1:nv
		v = vs(kv);
		vdec = pcdet + u*vecu + v*vecv;	% detector pixel position in 3D
		proj2d(ku,kv) = straight_line_integral(xs,ys,zs,data3d,psrc,vdec);
	end
end



