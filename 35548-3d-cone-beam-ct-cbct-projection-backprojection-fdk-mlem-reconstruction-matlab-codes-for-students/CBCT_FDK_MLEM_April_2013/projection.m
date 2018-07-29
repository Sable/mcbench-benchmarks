function proj2d = projection(data3d,param, angle_rad)

proj2d = zeros(param.nu,param.nv,'single');

[uu,vv] = meshgrid(param.us,param.vs);

[xx,yy] = meshgrid(param.xs,param.ys);

rx = xx.*cos(angle_rad) - yy.*sin(angle_rad);
ry = xx.*sin(angle_rad) + yy.*cos(angle_rad);

for iz = 1:param.nz   
    
    data3d(:,:,iz) = interp2(xx,yy ,data3d(:,:,iz),rx,ry,'linear');
    
end

data3d(isnan(data3d))=0;

data3d = permute(data3d,[1 3 2]);

[xx,zz] = meshgrid(param.xs,param.zs);

for iy = 1:param.ny
    
    Ratio = (param.ys(iy)+param.DSO)/(param.DSD);
    
    pu = uu*Ratio;
    pv = vv*Ratio;    
    
    pu = (pu - xx(1,1))/(param.dx)+1; 
    pv = (pv - zz(1,1))/(param.dz)+1; 
    
    tmp = interp2(data3d(:,:,iy),pv,pu,'linear');
    
    tmp(isnan(tmp))=0;
    
    proj2d = proj2d + tmp';
end

dist = sqrt((param.DSD)^2 + uu.^2 + vv.^2)./(param.DSD)*param.dy;

proj2d = proj2d .* dist';





