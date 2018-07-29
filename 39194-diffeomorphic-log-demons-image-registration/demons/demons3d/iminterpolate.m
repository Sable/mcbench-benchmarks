%% Interpolate image
%  Changed: Dec 31st, 2011
%
% In Matlab, (x,y) are:
%
%      j               x
%   o------>        o------>
%   |               |
% i |  . I(i,j)   y |  . I(x,y)
%   |               |
%   v               v
%

function I = iminterpolate(I,sx,sy,sz,mode)

    if size(size(I),2)==4; I = iminterpolate_multichannel(I,sx,sy,sz,mode); return; end;
    
    if nargin<5; mode = 'linear'; end;
    
    % Find update points on moving image
    nx = size(I,1); ny = size(I,2); nz = size(I,3);
    [y,x,z] = ndgrid(1:nx, 1:ny, 1:nz); % coordinate image
    x_prime = x + sx; % updated x values (1st dim, rows)
    y_prime = y + sy; % updated y values (2nd dim, cols)
    z_prime = z + sz; % updated z values (3rd dim, slices)
    
    % Interpolate updated image
    I = interpn(y,x,z,I,y_prime,x_prime,z_prime,mode,0); % moving image intensities at updated points
    
end
