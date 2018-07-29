function A = shiftAnglesFromMinus180To180(InA)

    %dont do anything to angles that are already in range
    %if we leave out this step, we get +180 shifted to -180
    idx = find(InA>180 | InA <-180);
    if(isempty(idx))
        A = InA;
    else
        A = InA;
        A(idx) = mod(InA(idx)+180,2*180)-180;  % input is in degrees
    end

end