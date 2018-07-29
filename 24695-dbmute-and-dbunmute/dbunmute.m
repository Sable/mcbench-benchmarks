function dbunmute
%dbunmute enables all breakpoints currently set in MATLAB.
% Copyright 2009 The MathWorks, Inc.   

    % iterate over each entry in the result of dbstatus,
    % and enable each of the breakpoints.
    breakpoints = dbstatus('-completenames');
    for i=1 : length(breakpoints)
        unmuteDbStatusEntry(breakpoints(i));    
    end    
end

function unmuteDbStatusEntry(dbstatusEntry)
%muteDbStatusEntry disables each breapoint in the given entry.    
    for i=1 : length(dbstatusEntry.line)
        file = dbstatusEntry.file;
        line = dbstatusEntry.line(i);
        anonymousIndex = dbstatusEntry.anonymous(i);
        expression = dbstatusEntry.expression{i};
        
        lineNumberString = [num2str(line) '@' num2str(anonymousIndex)];
        newExpression = stripDisablingPartOfExpression(expression);        
        
        dbstop(file, lineNumberString, 'if', newExpression);
    end
end

function newExpression = stripDisablingPartOfExpression(expression)
%strips any disabling expresion from the given expression.
    if (~isDisabled(expression))
        newExpression = expression;
    elseif strcmp(expression, 'false')
        newExpression = '';
    else
        endPosition = length(expression) - 1;
        newExpression = expression(9:endPosition);
    end
end