% ASTROTIK by Francesco Santilli
%
% Usage: angles = euler(R)
%
% where: R = rotation matrix [-]
%        angles = [a b c] = euler angles [rad]

function angles = euler(R)

    if ~(nargin == 1)
        error('Wrong number of input arguments.')
    end
    
    [J,K] = check(R,2);

    if ~(J==3 && K==3)
        error('Wrong size of input arguments.')
    end

    a = atan2( R(3,1), -R(3,2) );
    b = acos( R(3,3) );
    c = atan2( R(1,3), R(2,3) );
    
    angles = [a b c];

end