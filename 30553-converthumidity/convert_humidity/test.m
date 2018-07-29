function test (varargin)
% TODO: in stack information, replace pointers to temporary files with 
%       pointes to test section in the mfile being tested.
% TODO: add test case for get_stack_trace
% TODO: add test case for functions other than m-files that have 
%       an accompanying homonymous m-file containing the test blocks.
% TODO: support subfunctions. (Nested functions will never be supported 
%!      because they cannot stand alone.)
% TODO: is seems that a test block, at the end of a file, without a blank 
%       line after it, is not supported.

    %%%%%%%%%%
    switch nargin
    case 0
        error('test:notEnoughInputs', ...
        'Not enough input arguments.');
    case 1
        mfunc = varargin{1};
        param = '';
        
        mfile = which(mfunc);
        if isempty(mfile)
            error('test:UndefinedFunction', ...
            'Function %s not found in path.', mfunc);
        end
        [mdir, mfunc, ext] = fileparts(mfile);
        if ~strcmp(ext, '.m')
            mfile = fullfile(mdir, [mfunc '.m']);
            if ~exist(mfile, 'file')
                error('test:FileNotFound',...
                'File not found: %s', mfile);
            end
        end
        
        %[tdir, tfunc] = fileparts(tempname);
        %tfile = fullfile(tdir, [tfunc '.m']);
        % under Vista, it's significantly faster to addpath 
        % an empty directory rather than the standard temporary dir.
        tdir = tempname;
        tfunc = 'testit';
        tfile = fullfile(tdir, [tfunc '.m']);
        
        pdir = tdir;
        create_pdir = true;
        
        test_type = 'func';
    case 2
        mfunc = varargin{1};
        param = varargin{2};
        
        eval(sprintf('%s;', param));
        mfunc2 = sprintf('%s(%s)', mfunc, param);
        mfile = which(mfunc2);
        if isempty(mfile)
            error('test:UndefinedFunction',...
            'Function %s not found in path.', mfunc2);
        end
        [mdir, mfunc, ext] = fileparts(mfile);
        if ~strcmp(ext, '.m')
            mfile = fullfile(mdir, [mfunc '.m']);
            if ~exist(mfile, 'file')
                error('test:FileNotFound',...
                'File not found: %s', mfile);
            end
        end
        
        %[tdir, tfunc] = fileparts(tempname);
        %tfile = fullfile(tdir, [tfunc '.m']);
        % under Vista, it's significantly faster to addpath 
        % an empty directory rather than the standard temporary dir.
        tdir = tempname;
        tfunc = 'testit';
        tfile = fullfile(tdir, [tfunc '.m']);
        
        pdir = tdir;
        create_pdir = true;
        
        test_type = 'method';
    case 3
        mfunc = varargin{1};
        param = char(varargin{2});  % so that printf works when param = []
        mdir  = varargin{3};

        if ~isempty(param) && strcmp(mdir, 'private')
            mdir = [fileparts(which(param)) '\private'];
        end
        if ~(   strend([filesep 'private' filesep], mdir) ...
             || strend([filesep 'private']        , mdir) )
            error('test:DirEndInPrivate',...
            ['Third parameter %s should end in '...
            '"%cprivate".'], mdir, filesep);
        end
        
        mfile = fullfile(mdir, [mfunc '.m']);
        if ~exist(mfile, 'file')
            error('test:FileNotFound',...
            'File not found: %s', mfile);
        end
        
        tdir = dirup(mdir);
        create_pdir = false;
        while true
            [temp, tfunc] = fileparts(tempname); %#ok<ASGLU>
            tfile = fullfile(tdir, [tfunc '.m']);
            if ~exist(tfile, 'file'),  break;  end
        end
        
        if isempty(param)
            pdir = tdir;
            test_type = 'priv_func';
        else
            if ~strend([filesep '@' param], tdir)
                error('test:DirEndInClass',...
                ['Third parameter %s should end in '...
                '"%c@%s%cprivate".'], mdir, filesep, param, filesep);
            end
            pdir = dirup(tdir);
            test_type = 'priv_method';
        end
    otherwise
        error('test:tooManyInputs',...
        'Too many input parameters.');
    end
    %mdir, tdir, pdir  % DEBUG
   
    
    %%%%%%%%%%
    %mfile  % DEBUG
    %type(mfile)  % DEBUG
    [mfid, msg] = fopen (mfile, 'rt');
    if (mfid == -1)
        error('test:FileOpening', msg);
    end

    % extract blocks (test, error, shared) in m-file
    block_start = [];
    is_in_block = false;
    i = 1;  % # of %! lines
    j = 1;  % # of test or error blocks
    mline = fgets(mfid);
    while ~isequal(mline, -1)  % while not end of file
        if (   strncmp(mline, '%!test', 6) ...
            || strncmp(mline, '%!error', 7) ...
            || strncmp(mline, '%!shared', 8) )
            % start block
            is_in_block = true;
            block_start(j) = i;
            if strncmp(mline, '%!test', 6)
                block_type{j} = 'test';
            elseif strncmp(mline, '%!error', 7)
                block_type{j} = 'error';
            elseif strncmp(mline, '%!shared', 8)
                block_type{j} = 'shared';
            end
        elseif is_in_block && strncmp(mline, '%!', 2)
            % read block contents
            tline{i} = mline(4:end);  
            i = i + 1;
        elseif is_in_block
            % end block
            block_end(j) = i-1;
            j = j + 1;
            is_in_block = false;
        end
        mline = fgets(mfid);
    end
    if is_in_block
        % end latest block
        block_end(j) = i-1;
    end
    fclose(mfid);

    if isempty(block_start) || all(strcmp(block_type, 'shared'))
        error('test:noBlock',...
        'Found no test or error section in file %s.', mfile);
    end
    myassert (length(block_start), length(block_end));
    myassert (length(block_start), length(block_type));

    
    %%%%%%%%%%
    
    %% create test file
    old_path = path;    
    if create_pdir,  mkdir(pdir);  end
    addpath(pdir);                
    %addpath(pdir, '-frozen');                
    
    %% write and run each block
    for j=1:length(block_start)
        if strcmp(block_type{j}, 'shared'),  continue;  end
            
        [tfid, msg] = fopen(tfile, 'wt');
            if (tfid == -1),  error('test:FileOpening', msg);  end
                
        if strcmp(test_type, 'priv_method')
            fprintf(tfid, 'function %s (obj)\n', tfunc);
        else
            fprintf(tfid, 'function %s\n', tfunc);
        end
        
        found_mfunc_call = false;

        %% Write optional, previous, shared block.
        k = find (strcmp({block_type{1:j}}, 'shared'), 1, 'last');
        if ~isempty(k)
            myassert (strcmp(block_type{k}, 'shared'));
            fprintf(tfid, '%% shared\n');
            for i=block_start(k):block_end(k)
                fprintf(tfid, '%s', tline{i});
                found_mfunc_call = found_mfunc_call ...
                                   || is_function_called (tline{i}, mfunc);
            end
            fprintf(tfid, '\n');
        end
        
        %% Is it an error block?
        if strcmp(block_type{j}, 'error')
            fprintf(tfid, 'try\n');
            % In an error block, error is the expected behaviour.
            % We do we following:
            %     try,
            %         % INSERT USER CODE HERE
            %     catch,
            %         return;
            %     end
            %     error('test:error:fail', '');
            % If the user code generates an error, it is catched and
            % the test runs OK. If the user code does _not_ generate 
            % an error(contrary to what was expected), then the test fails.
        end

        for i=block_start(j):block_end(j)
            fprintf(tfid, '%s', tline{i});
            found_mfunc_call = found_mfunc_call ...
                               || is_function_called (tline{i}, mfunc);
        end
        
        if (~found_mfunc_call)
            warning('test:noFuncCall', ...
                'Found no call to function %s itself in its %s block #%d.',...
                mfunc, block_type{j}, j);
        end

        if strcmp(block_type{j}, 'error')
            fprintf(tfid, 'catch\n');
            fprintf(tfid, '    return;\n');
            fprintf(tfid, 'end\n');
            fprintf(tfid, 'clear s;\n');
            fprintf(tfid, 's.identifier=''test:error:fail'';\n');
            fprintf(tfid, 's.message=''No error found in error section.'';\n');
            fprintf(tfid, 'error(s);\n');
        end
        
        fprintf(tfid, 'end\n');
        fclose(tfid);
        %type(tfile); % DEBUG

        % reload function definition:
        clear(tfile);
        if strcmp(test_type, 'priv_method')
            % we have added a new class methods; reload the class:
            clear(which(param));
        else
            clear(which(tfunc));
        end
        
        %% run test file
        try
            if strcmp(test_type, 'priv_method')
                eval(sprintf('%s(%s);', tfunc, param));
            else
                %which(tfunc),  type(which(tfunc))  % DEBUG
                feval(tfunc);
                %run([tdir filesep tfunc]);
            end
        catch %#ok<CTCH>
            s = lasterror; %#ok<LERR>
            idx = strcmp({s.stack.name}, mfunc);
            if strcmp(test_type, 'priv_func') && any(idx)
                s.stack(idx).file = mfile;  % it needs full path
            end
            type(which(tfunc));
            s.message = [s.message, get_stack_trace(s)];
            %if ~strcmp(s.identifier, 'MATLAB:UndefinedFunction')
                delete(tfile);
            %end
            path(old_path);
            if create_pdir,  rmdir(pdir);  end
            rethrow(s);
        end
    end
    
    %% remove test file
    if exist(tfile, 'file'),  delete(tfile);  end
    path(old_path);
    if create_pdir,  rmdir(pdir);  end
end

%!#test
%! % test()
%! myassert (false)

%!test
%! % test
%! myassert(true);
%! lasterr('', 'test:testing');

%!test
%! % test
%! s = lasterror;
%! myassert(s.identifier, 'test:testing');
%! lasterr('', '');

%!error
%! % test
%! myassert(false);

%!shared
%! var = pi;

%!test
%! % test
%! myassert (var == pi);
%! var = 2*pi;

%!test
%! % test
%! myassert (var == pi);

%!shared
%! var = 3*pi;

%!test
%! % test
%! myassert (var == 3*pi);

%!shared  % to clear previous %!shared


%!error
%! test;

%! % test
%! s = lasterror;
%! myassert(s.identifier, 'test:notEnoughInputs');

%!error
%! test(tempname);

%! % test
%! s = lasterror;
%! myassert(s.identifier, 'test:UndefinedFunction');

%!error
%! test(1, 2, 3, 4);

%! % test
%! s = lasterror;
%! myassert(s.identifier, 'test:tooManyInputs');


%!test
%! % It's not an error to have a single, empty test section.
%! func = tempname;
%! file = [func '.m'];
%!
%! fid = fopen(file, 'wt');
%! fprintf(fid, '%%!test\n');
%! fprintf(fid, '%%! %% %s\n', func);
%! fclose(fid);
%!     
%! old_path = path;
%! addpath(fileparts(file));
%! 
%! lasterr ('', '');
%! try,  test(func);  end
%! s = lasterror;
%! %type (file);  % DEBUG
%! delete (file);
%! path(old_path);
%! myassert (isempty(s.identifier));

%!test
%! % Issue an error if there is shared section but not test or error sections.
%! func = tempname;
%! file = [func '.m'];
%!
%! fid = fopen(file, 'wt');
%! fprintf(fid, '%%!shared\n');
%! fprintf(fid, '%%! \n');
%! fclose(fid);
%!     
%! old_path = path;
%! addpath(fileparts(file));
%! 
%! lasterr ('', '');
%! try,  test(func);  end
%! s = lasterror;
%! %type (file);  % DEBUG
%! delete (file);
%! path(old_path);
%! myassert (s.identifier, 'test:noBlock');

%!shared
%! % Here we generate the following directory-tree:
%! % dir/
%! %     @aclass/
%! %         aclass.m  % class constructor
%! %         afunc.m
%! % Then test() creates:
%! % dir/
%! %     atest.m
%! 
%! class_code = {...
%!     'function answer = aclass (value)'
%!     '    if (nargin < 1),  value = [];  end'
%!     '    answer.value = value;'
%!     '    answer = class(answer, ''aclass'');'
%!     'end'
%! };
%! func_code = {...
%!     'function answer = afunc (obj)'
%!     '    answer = obj.value;'
%!     'end'
%!     ''
%!     '%!shared'
%!     '%! value = pi;'
%!     '%! obj = aclass(value);'
%!     ''
%!     '%!error'
%!     '%! % afunc'
%!     '%! myassert(false);'
%!     ''
%!     '%!test'
%!     '%! myassert(afunc(obj), value);' 
%! };
%! %class_code, func_code  % DEBUG
%! 
%! dir = tempname;
%! class_dir = fullfile(dir, '@aclass');
%! temp = mkdir(class_dir);
%!     myassert(temp ~= 0);
%! 
%! class_file = fullfile(class_dir, 'aclass.m');
%! [class_fid, msg] = fopen (class_file, 'wt');
%!     if (class_fid == -1),  error(msg);  end
%! fprintf(class_fid, '%s\n', class_code{:});
%! temp = fclose(class_fid);
%!     myassert (temp ~= -1);
%! 
%! func_dir = class_dir;
%! func_file = fullfile(func_dir, 'afunc.m');
%! func_fid = fopen (func_file, 'wt');
%!     myassert (func_fid ~= -1);
%! fprintf(func_fid, '%s\n', func_code{:});
%! temp = fclose(func_fid);
%!     myassert (temp ~= -1);
%! 
%! %type(class_file);  type(func_file);  % DEBUG
%! %pause  % DEBUG
%! 
%! old_path = path;
%! addpath (dir);  % NOT addpath (class_dir);

%!test
%! % Test a class method:
%! % test('afunc', 'aclass');
%!      
%! try,
%!     test('afunc', 'aclass');
%! catch,
%!     s = lasterror;
%!     if ~strcmp(s.identifier, 'MATLAB:UndefinedFunction')
%!         path (old_path);
%!         [status, msg, msgid] = rmdir(dir, 's');
%!             if (status == 0),  error(msgid, msg);  end
%!     end
%!     rethrow (s);
%! end
%! 
%! path (old_path);
%! [status, msg, msgid] = rmdir(dir, 's');
%!     if (status == 0),  error(msgid, msg);  end

%!test
%! % Test a class private method:
%! % test('afunc', 'aclass', 'adir');
%! % 
%! % Here we generate the following directory-tree:
%! % dir/
%! %     @aclass/
%! %         aclass.m  % class constructor
%! %         private/
%! %             afunc.m
%! % Then test() creates:
%! % dir/
%! %     @aclass/
%! %         atest.m
%! 
%! func_file_old = func_file;
%! func_dir = fullfile(class_dir, 'private');
%! temp = mkdir(func_dir);
%!     myassert(temp ~= 0);
%! func_file = fullfile(func_dir, 'afunc.m');
%! [status, msg, msgid] = movefile (func_file_old, func_file);
%!     if (status ~= 1),  error(msgid, msg);  end
%! 
%! try,
%!     %keyboard  % DEBUG
%!     test('afunc', 'aclass', func_dir);
%! catch,
%!     s = lasterror;
%!     if ~strcmp(s.identifier, 'MATLAB:UndefinedFunction')
%!         path (old_path);
%!         [status, msg, msgid] = rmdir(dir, 's');
%!             if (status == 0),  error(msgid, msg);  end
%!     end
%!     rethrow (s);
%! end
%! 
%! path (old_path);
%! [status, msg, msgid] = rmdir(dir, 's');
%!     if (status == 0),  error(msgid, msg);  end

%!test
%! % Test a class private method, letting test() guess adir:
%! % test('afunc', 'aclass', 'private');
%! % 
%! % Here we generate the following directory-tree:
%! % dir/
%! %     @aclass/
%! %         aclass.m  % class constructor
%! %         private/
%! %             afunc.m
%! % Then test() creates:
%! % dir/
%! %     @aclass/
%! %         atest.m
%! 
%! func_file_old = func_file;
%! func_dir = fullfile(class_dir, 'private');
%! temp = mkdir(func_dir);
%!     myassert(temp ~= 0);
%! func_file = fullfile(func_dir, 'afunc.m');
%! [status, msg, msgid] = movefile (func_file_old, func_file);
%!     if (status ~= 1),  error(msgid, msg);  end
%! 
%! try,
%!     %keyboard  % DEBUG
%!     test('afunc', 'aclass', 'private');
%! catch,
%!     s = lasterror;
%!     if ~strcmp(s.identifier, 'MATLAB:UndefinedFunction')
%!         path (old_path);
%!         [status, msg, msgid] = rmdir(dir, 's');
%!             if (status == 0),  error(msgid, msg);  end
%!     end
%!     rethrow (s);
%! end
%! 
%! path (old_path);
%! [status, msg, msgid] = rmdir(dir, 's');
%!     if (status == 0),  error(msgid, msg);  end

%!shared  % to clear previous %!shared


%!test
%! % Test a private function:
%! % test('afunc', [], 'adir');
%! % 
%! % Here we generate the following directory-tree:
%! % dir/
%! %     private/
%! %         afunc.m
%! % Then test() creates:
%! % dir/
%! %     atest.m
%!      
%! func_code = {...
%!     'function out = afunc (in)'
%!     '    if isequal(in, 0),  error(''afunc:any'', '''');  end'
%!     '    out = 1/in;'
%!     'end'
%!     ''
%!     '%!error'
%!     '%! afunc(0)';
%!     ''
%!     '%!test'
%!     '%! myassert(afunc(pi), 1/pi);'
%! };
%! %func_code  % DEBUG
%! 
%! dir = tempname;
%! temp = mkdir(dir);
%!     myassert(temp ~= 0);
%! temp = mkdir(dir, 'private');
%!     myassert(temp ~= 0);
%! 
%! func_dir = fullfile(dir, 'private');
%! func_file = fullfile(func_dir, 'afunc.m');
%! [func_fid, msg] = fopen (func_file, 'wt');
%!     if (func_fid == -1),  error(msg);  end
%! fprintf(func_fid, '%s\n', func_code{:});
%! temp = fclose(func_fid);
%!     myassert (temp ~= -1);
%! %type(func_file);  % DEBUG
%! 
%! old_path = path;
%! addpath (dir);  % NOT addpath (func_dir);
%! test('afunc', [], func_dir);
%! path (old_path);
%! 
%! [status, msg, msgid] = rmdir(dir, 's');
%!     if (status == 0),  error(msgid, msg);  end


%!#test
%! % Check if test files are being deleted,
%! % even in case of error.
%! 
%! code = {...
%!     'function answer = func'
%!     '    persistent temp'
%!     '    if isempty(temp)'
%!     '        temp = which(get_caller_name);'
%!     '    end'
%!     '    answer = temp;'
%!     'end'
%! };
%! test1 = {...
%!     '%!test'
%!     '%! func;'
%!     '%! myassert(true);'
%! };
%! test2 = {...
%!     '%!test'
%!     '%! func;'
%!     '%! myassert(false);  % THROW ERROR' 
%! };
%! 
%! dir = tempname;
%! mkdir(dir);
%! file = fullfile(dir, 'func.m');
%! 
%! old_path = path;
%! addpath(dir);
%!
%! for i=1:2
%!     switch i
%!     case 1
%!         testi = test1;
%!     case 2
%!         testi = test2;
%!     end
%!     
%!     fid = fopen(file, 'wt');
%!     fprintf(fid, '%s\n', code{:});
%!     fprintf(fid, '%s\n', testi{:});
%!     fclose(fid);
%!     
%!     clear('func');
%!     try,  test('func');  end
%!     
%!     tfile = func;
%!     try,
%!         switch i
%!         case 1
%!             myassert (~exist(tfile, 'file'));
%!         case 2
%!             myassert (~exist(tfile, 'file'));
%!         end
%!     catch,
%!         s = lasterror;
%!         path(old_path);
%!         rmdir(dir, 's');
%!         rethrow (s);
%!     end
%! end
%! path(old_path);
%! rmdir(dir, 's');


%!test
%! % test ()
%! lastwarn('', '');  % clear last warning
%! warning('off', 'test:noFuncCall'); 

%!test
%! % generate warning

%!test
%! % test ()
%! [msg, msgid] = lastwarn;
%! myassert (msgid, 'test:noFuncCall');  % check warning
%! warning('on', 'test:noFuncCall');


%!test
%! % test ()
%! lastwarn('', '');  % clear last warning

%!shared
%! % test ()  % avoid test()'s warning

%!test
%! [msg, msgid] = lastwarn;
%! myassert (msgid, '');  % check warning is still clear

