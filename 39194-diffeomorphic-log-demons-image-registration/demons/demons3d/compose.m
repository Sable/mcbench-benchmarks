%% Compose two vector fields
%  Changed: Dec 31st, 2011
%
function [vx,vy,vz] = compose(ax,ay,az, bx,by,bz)

    % Piggyback
    piggybackscale = 1.2; % just to get too many outside values
    [ax,lim] = piggyback(ax,piggybackscale);
    [ay,lim] = piggyback(ay,piggybackscale);
    [az,lim] = piggyback(az,piggybackscale);
    [bx,lim] = piggyback(bx,piggybackscale);
    [by,lim] = piggyback(by,piggybackscale);
    [bz,lim] = piggyback(bz,piggybackscale);

    % Coordinates
    nx = size(ax,1);
    ny = size(ax,2);
    nz = size(ax,3);
    
    [y,x,z] = ndgrid(1:nx, 1:ny, 1:nz); % coordinate image

    % Where points are going
    xp  = iminterpolate(x+ax, bx,by,bz);
    yp  = iminterpolate(y+ay, bx,by,bz);
    zp  = iminterpolate(z+az, bx,by,bz);
    
    % Update field
    vx = xp - x;
    vy = yp - y;
    vz = zp - z;
    
    % Zero vectors going outside the image
    zr  = (xp==0 & yp==0 & zp==0);
    vx(zr) = 0;
    vy(zr) = 0;
    vz(zr) = 0;

    % Unpiggyback
    vx = vx(lim(1):lim(2),lim(3):lim(4),lim(5):lim(6));
    vy = vy(lim(1):lim(2),lim(3):lim(4),lim(5):lim(6));
    vz = vz(lim(1):lim(2),lim(3):lim(4),lim(5):lim(6));
    
end

