function str_out = latex2fprintf(str_in)
% David Krause
% Queen's University
% June 30, 2006
% Convert a string that has single \ characters, i.e., '\mu / (2 \pi)'
% To double characters \  ->  \\, i.e., '\\mu / (2 \\pi)'
temp = findstr(str_in, '\');

str_out = [];
if ~isempty(temp)
    % For each \ found, add a \ just after
    for count = 1 : length(temp)
        if count == 1
            str_out = [str_out, str_in(1 : temp(1)), '\'];
        else
            str_out = [str_out, str_in((temp(count - 1) + 1) : temp(count)), '\'];
        end        
    end
    % Complete the string by adding the last characters
    str_out = [str_out, str_in((temp(end) + 1) : end)];   
else
    str_out = str_in;
end