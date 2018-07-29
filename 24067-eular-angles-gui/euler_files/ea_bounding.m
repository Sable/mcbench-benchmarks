function an=ea_bounding(phi,theta,psi)
% bounding of euler angles
% 0<=phi<2*pi
% 0<=theta<pi
% 0<=psi<2*pi

ifchange=false; % if anles come out from boundaries

if (0<=phi)&&(phi<2*pi)
    
else
    ifchange=true;
end

if (0<=theta)&&(theta<pi)
    
else
    ifchange=true;
end

if (0<=psi)&&(psi<2*pi)
    
else
    ifchange=true;
end



%theta=mod(theta+pi,2*pi)-pi; % -pi<=theta<pi
theta=-(mod(theta*(-1)+pi,2*pi)-pi); % -pi<theta<=pi

if theta<0
    theta=-theta;
    phi=pi+phi;
    psi=pi+psi;
end

phi=mod(phi,2*pi);
psi=mod(psi,2*pi);

an=[ifchange phi theta psi];
    