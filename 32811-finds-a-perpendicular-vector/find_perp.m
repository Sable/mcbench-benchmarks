function v_perp = find_perp(v_input)
%FIND_PERP Finds one of the infinitely number of perpendicular vectors of
%   the input. The input vector v_input is a size 3,1 or 3,1 vector (only
%   3-dim supported)
    
    if length(v_input) ~= 3     % Can't be wrong dim if len=3
        error('find_perp:WrongSize','Input vector has wrong size');
    end
    
    if sum(v_input ~= 0) == 0
        error('find_perp:GivenZeroVector','Zero vector given as input');
    end
    
    v_perp = zeros(size(v_input));
    
    if sum(v_input ~= 0) == 3       % Every element is not-zero
        v_perp(1) = 1;
        v_perp(3) = -v_input(1)/(v_input(3));
    elseif sum(v_input ~= 0) == 2
        if v_input(1) == 0
            v_perp(1:2) = [1 1];
            v_perp(3) = -v_input(2)/(v_input(3));
        elseif v_input(2) == 0
            v_perp(1:2) = [1 1];
            v_perp(3) = -v_input(1)/(v_input(3));
        else
            v_perp(2:3) = [1 1];
            v_perp(1) = -v_input(2)/(v_input(1));
        end
    else
        if v_input(1) ~= 0
            v_perp(2) = 1;
        else
            v_perp(1) = 1;
        end
    end
    
    if abs(dot(v_perp,v_input)) > 1E-09      % Must take round-off into account (the dot product is not always perfect zero)
        error('find_perp:DotProdNotZero',...
            'A perp vector could not be found (failed dot product test). Might there be a bug?');
    end
end

