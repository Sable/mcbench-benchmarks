function [u,v,psi,phi] = addPotential(xmesh,ymesh,x_c,y_c,q,type)
% Updates u,v,psi and phi when a potential is added
% xmesh,ymesh - meshgrid of x and y
% x_c,y_c - point location of the origin of the potential flow
% type - string, 'source','sink','vortex' or 'doublet'

% Copyright 2013 The MathWorks, Inc.
r = sqrt((xmesh-x_c).^2+(ymesh-y_c).^2);
switch type
    case 'source'
        v_r = q/2/pi./r;
        v_th = 0;
        psi = q/2/pi*atan2((ymesh-y_c)./r,(xmesh-x_c)./r);
        phi = -q/2/pi.*log(r);
    case 'sink'
        v_r = -q/2/pi./r;
        v_th = 0;
        psi = -q/2/pi*atan2((ymesh-y_c)./r,(xmesh-x_c)./r);
        phi = q/2/pi.*log(r);
    case 'vortex'
        v_r = 0;
        v_th = q/2/pi./r;
        psi = -q/2/pi.*log(r);
        phi = -q/2/pi*atan2((ymesh-y_c)./r,(xmesh-x_c)./r);
    case 'doublet'
        v_r = -q./r.^2.*((xmesh-x_c)./r);
        v_th = -q./r.^2.*((ymesh-y_c)./r);
        psi = -q./r.*((ymesh-y_c)./r);
        phi = -q./r.*((xmesh-x_c)./r);
end
u = v_r.*(xmesh-x_c)./r - v_th.*(ymesh-y_c);
v = v_r.*(ymesh-y_c)./r + v_th.*(xmesh-x_c);
end


