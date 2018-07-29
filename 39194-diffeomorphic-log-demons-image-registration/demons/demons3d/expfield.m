%% Exponentiate vector field
%  Changed: Dec 31st, 2011
%
function [vx,vy,vz] = expfield(vx, vy, vz)

    % Find n, scaling parameter
    normv2 = vx.^2 + vy.^2 + vz.^2;
    m = sqrt(max(normv2(:)));
    n = ceil(log2(m/0.5)); % n big enough so max(v * 2^-n) < 0.5 pixel)
    n = max(n,0);          % avoid null values
    
    % Scale it (so it's close to 0)
    vx = vx * 2^-n;
    vy = vy * 2^-n;
    vz = vz * 2^-n;

    % square it n times
    for i=1:n
        [vx,vy,vz] = compose(vx,vy,vz, vx,vy,vz);
    end

end

