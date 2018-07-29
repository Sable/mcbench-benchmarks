function [n maxLflag] = loadfactor(tState)

if tState.omega >= 0 % if level flight or sustained turn
    n = sqrt((tState.omega*tState.V/g0)^2+1);
    maxLflag = false;
elseif tState.omega < 0 % if instantaneous turn indicated by negative omega
    % NB: rotor itertia doesn't help an inst. turn
    n = abs(tState.omega).*tState.V/g0;
    maxLflag = true;
else
    disp('Ill-defined turning condition')
end

end