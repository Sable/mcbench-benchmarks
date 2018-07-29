function A = shiftAnglesFromMinusPIToPI(InA)
    %dont do anything to angles that are already in range
    %if we leave out this step, we get +180 shifted to -180
    idx = find(InA>pi | InA <-pi);
    if(isempty(idx))
        A = InA;
    else
        A = InA;
        A(idx) = mod(InA(idx)+pi,2*pi)-pi;  % input is in radians
    end
end