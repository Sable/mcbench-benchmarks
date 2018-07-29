function [ Z ] = chemsym2number( symbol )
%CHEMSYM2NUMBER Get the atomic number for a chemical symbol.
%   Z = CHEMSYM2NUMBER(symbol) returns the atomic number of the element 
%   with the given chemical symbol.
%
%   See also ATOMIC_RADIUS, NUMBER2CHEMSYM

    symbol = strtrim(symbol);
    Z = 1;
    while ~strcmp(number2chemsym(Z),symbol)
        Z = Z+1;
        if Z > 118
            error([ symbol ' is not a valid chemical symbol.']);
        end
    end

end

