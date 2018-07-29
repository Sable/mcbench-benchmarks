% ASTROTIK by Francesco Santilli
%
% Usage: R = rotation(angles,axs)
%        R = rotation(angles)
%
% where: angles(k) = rotation angle [rad]
%        axs(k) = rotation axis (1,2,3) [3 1 3]
%        R = rotation matrix [-]

function R = rotation(angles,axs)

    if (nargin < 1) || (nargin > 2)
        error('Wrong number of input arguments.')
    end

    if nargin < 2
        axs = [3 1 3];
    end
    
    check(angles,1)
    K = check(axs,1);
    
    if ~(length(angles)==K)
        error('Wrong size of input arguments.')
    end
        
    if ~(sum(axs==1 | axs==2 | axs==3) == K)
        error('Invalid values for rotation axes.')
    end
    
    R = eye(3);
        
    c = cos(angles);
    s = sin(angles);
    for k = 1:K
        switch axs(k)
            case 1
                r = [ c(k)  s(k)
                     -s(k)  c(k)];
                q = [2 3];
            case 2
                r = [ c(k) -s(k)
                      s(k)  c(k)];
                q = [1 3];
            case 3
                r = [ c(k)  s(k)
                     -s(k)  c(k)];
                q = [1 2];
        end
        R(q,:) = r * R(q,:);
    end

end