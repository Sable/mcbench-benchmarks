function GOLDEN_RATIO = GoldenRatio()
% Returns the golden ratio, commonly denoted by the Greek letter PHI.
% The golden ratio holds many interesting mathematical properties.  Refer to
% http://en.wikipedia.org/wiki/Golden_ratio for more information.
% 
%    usage: GOLDEN_RATIO = GoldenRatio()
    
    persistent PHI;
    if (isempty(PHI))
        PHI = 2 * cos(pi / 5);
        % This is the most efficient way to compute the golden ratio.
    end
    GOLDEN_RATIO = PHI;
    % Only compute the golden ratio once, and cache the result in a persistent
    % variable.  GOLDEN_RATIO cannot be a persistent variable, because it is the
    % return value of the function, so instead the persistent result must be
    % cached in a separate variable.
    
end