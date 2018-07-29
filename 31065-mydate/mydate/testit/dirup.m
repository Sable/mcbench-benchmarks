function answer = dirup (dir)
    add_leading_filesep = false;
    if strcmp(dir(end), filesep())
        add_leading_filesep = true;
        dir = dir(1:end-1);
    end
    
    [answer, ignore] = fileparts(dir); %#ok<NASGU>
    
    if add_leading_filesep && ~strcmp(answer(end), filesep)
        answer = [answer filesep];
    end
    
    %answer  % DEBUG
end

%!test
%! myassert(dirup('C:\a\b\'), 'C:\a\');
%! myassert(dirup('C:\a\'), 'C:\');
%! myassert(dirup('C:\'), 'C:\');

%!test
%! myassert(dirup('C:\a\b'), 'C:\a');
%! myassert(dirup('C:\a'), 'C:\');
%! myassert(dirup('C:\'), 'C:\');

