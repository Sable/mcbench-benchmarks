function disabled = isDisabled(expression)
%isDisabled returns true if the given breakpoint expression is disabled.
% Copyright 2009 The MathWorks, Inc.   

    wrappingFalse = 'false&&(';
    disabled = strcmp(expression, 'false') ...
        || strncmp(expression, wrappingFalse, length(wrappingFalse));
    
end