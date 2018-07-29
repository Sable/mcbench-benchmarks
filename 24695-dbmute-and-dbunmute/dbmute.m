function dbmute
%dbmute disables all breakpoints currently set in MATLAB.
% Copyright 2009 The MathWorks, Inc.   

    % iterate over each entry in the result of dbstatus,
    % and disable each of the breakpoints.
    breakpoints = dbstatus('-completenames');
    for i=1 : length(breakpoints)
        muteDbStatusEntry(breakpoints(i));    
    end
    
end

function muteDbStatusEntry(dbstatusEntry)
%muteDbStatusEntry disables each breapoint in the given entry.    
    for i=1 : length(dbstatusEntry.line)
        file = dbstatusEntry.file;
        line = dbstatusEntry.line(i);
        anonymousIndex = dbstatusEntry.anonymous(i);
        expression = dbstatusEntry.expression{i};
        
        lineNumberString = [num2str(line) '@' num2str(anonymousIndex)];
        newExpression = createDisabledExpression(expression);        
        
        dbstop(file, lineNumberString, 'if', newExpression);
    end
end

function newExpression = createDisabledExpression(expression)
%createDisabledExpression wraps the given expression in a disabling 
%  expression if necessary.
    if (isDisabled(expression))
        newExpression = expression;
    elseif strcmp(expression, '')
        newExpression = 'false';
    else
        newExpression = ['false&&(' expression ')'];
    end
end
