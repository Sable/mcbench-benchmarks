function areBadVals = AreBadValues(A)
% Only returns true for bad array elements.
% Bad array elements include Inf (infinity), NA (missing), and NaN (not a
% number).
% 
%    usage: areBadVals = AreBadValues(A)
    
    areBadVals = ~isfinite(A);
    % Inf, NA, and NaN are non-finite values.
    
end