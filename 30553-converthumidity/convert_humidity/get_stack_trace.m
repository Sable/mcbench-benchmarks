function msg = get_stack_trace (s)
    msg = '';
    if ~isfield(s, 'stack'),  return;  end
    stack = s.stack;
    for i=1:length(stack)
        %stack(i)  % DEBUG
        %if (stack(i).name(1) == '@')  % WRONG!
        if strfind(stack(i).name, '@')
            % inline or function handle.
            full_name = '';
            name = '(inline function)';
            temp = stack(i).name;
        else
            full_name = which(stack(i).file);
            name = stack(i).name;
            temp = sprintf('dbtype ''%s'' %d', full_name, stack(i).line);
            %disp(temp)  % DEBUG
            temp = evalc(temp);
                temp = temp(8:end-2);  % discard line # and \n\n
        end
            
        msg = [msg, sprintf(...
            '\n\nError in ==> <a href="error:%s,%d,1">%s at %d</a>\n%s', ...
            full_name, stack(i).line, ...
            name, stack(i).line, ...
            temp)]; %#ok<AGROW>
    end
end

%!test
%! s.stack.file = '';
%! s.stack.line = 0;
%! s.stack.name = '@(param, obs, const)         [cos(param(2)*const*2*pi), param(1)*(-sin(param(2)*X*2*pi)*X*2*pi)]';
%! msg = get_stack_trace (s);

%!#test
%! % doesn't work becayse "display" is a builtin function, and dbtype can't do that.
%! s.stack.file = 'display';
%! s.stack.line = 1;
%! s.stack.name = 'display';
%! msg = get_stack_trace (s);

%!test
%! s.stack.file = 'C:\Program Files\MATLAB\R2006a\toolbox\matlab\specgraph\fplot.m';
%! s.stack.name = 'fplot';
%! s.stack.line = 12;
%! msg = get_stack_trace (s);

%!test
%! s.stack.file = 'C:\Users\FGNIEV~1\AppData\Local\Temp\tp8ad88c96_418d_41fe_850b_7470c01b3904\testit.m';
%! s.stack.name = 'testit/@(input)reshape(list,[n*n,1])';
%! s.stack.line = 0;
%! msg = get_stack_trace (s);
