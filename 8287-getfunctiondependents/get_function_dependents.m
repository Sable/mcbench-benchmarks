% get_function_dependents(funct_nam,options)
%
% What this function is set up for is when you have written a big function,
% that depends on a bunch of smaller functions, that you have also written.
% Someone wants to borrow the function, but you don't know all the sub
% functions required to run it.  If you run this, it will create a sub
% directory in the current directory with the name 'funct_nam', 
% and copy the main function, and all the user written sub functions into 
% the directory.  You can then create a zip file or just copy the directory
% and give to the person the complete directory,
% and they should be able to run the function without any problems.
%
% You must specify any toolbox names you want included (if any), and the main MATLAB
% install directory, as we don't want to include files included in the main
% MATLAB distribution.  This function also assumes that the user created
% functions are not in the MATLAB install directory.

function get_function_dependents(funct_nam,option)

if nargin < 2 | option == 'v'
    verbose = 1;
else
    verbose = 0;
end

% Set any toolboxes that the function may depend on that you want to
% include functions from
% tool = 'stats';

% Set the MATLAB install directory, we are assuming that all user written
% functions are not in this directory.
matDirect = matlabroot; 

list = depfun(funct_nam,'-quiet');

dirnam = [funct_nam, '_dir'];
status = mkdir(dirnam);
if status == 0
    error('Cannot create directory.  Are you sure you have write permissions?');
end
cd(dirnam);

copy_file = cell(1);
count_copy = 1;
nfiles = length(list);
% check if toolbox variable has been set
istool = exist('tool','var');

for i = 1:nfiles
    str = list{i};
    % Check for install directory
    install = findstr(matDirect,str);
    % Check for required toolbox
    if istool ~= 0
        reqtool = findstr(tool,str);
    else
        reqtool = [];
    end
    
    % If not in install directory, then we want it
    if length(install) == 0
        % find / or \ in directory (depending unix or windows)
        slashes = find(str == 47 | str == 92);
        lastslash = length(slashes);
        subfunct = str(slashes(lastslash)+1:end);
        
        % copy the file to the current directory
        copyfile(str,subfunct);
        copy_file{count_copy} = subfunct;
        count_copy = count_copy + 1;
        
        % now check if there are any *.fig files of the same name in order
        % to copy any required graphics files
        strfig = [str(1:end-2), '.fig'];
        if exist(strfig,'file') == 2
            subfig = [subfunct(1:end-2), '.fig'];
            copyfile(strfig,subfig);
            copy_file{count_copy} = subfig;
            count_copy = count_copy + 1;
        end %if
        
    elseif length(install) ~= 0 & length(reqtool) ~= 0
        % find / or \ in directory (depending unix or windows)
        slashes = find(str == 47 | str == 92);
        lastslash = length(slashes);
        subfunct = str(slashes(lastslash)+1:end);
        
        % copy the file to the current directory
        copyfile(str,subfunct);
        copy_file{count_copy} = subfunct;
        count_copy = count_copy + 1;
        
        % now check if there are any *.fig files of the same name in order
        % to copy any required graphics files
        strfig = [str(1:end-2), '.fig'];
        if exist(strfig,'file') == 2
            subfig = [subfunct(1:end-2), '.fig'];
            copyfile(strfig,subfig);
            copy_file{count_copy} = subfig;
            count_copy = count_copy + 1;
        end %if
    end % end copying files
end

% if no quiet option, print out the primary file, and files copied
if verbose == 1
    currpath = [cd, '\', dirnam];
    fprintf('\nCopied files to:   %s\n',currpath);
    for j = 1:count_copy - 1
        str = copy_file{j};
        fprintf('\n%s',str);
    end % for
    fprintf('\n\n');
end % if

% move back up to the previous directory
cd ..