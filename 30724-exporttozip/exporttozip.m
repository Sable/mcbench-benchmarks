function zipfilename = exporttozip(funcname,abspath,zipfilename)
%% EXPORTTOZIP - Creates a ZIP file containing dependencies of a function
%
% zipfilename = exporttozip(funcname);
% zipfilename = exporttozip(funcname,abspath);
% zipfilename = exporttozip(funcname,abspath,zipfilename);
%
% Finds and Zips all M-files which are required by the specified function(s) 
% and which are NOT inside MATLAB's "toolbox" directory.
% Note: this does not include functions called by eval() statements
%
% funcname      is one or more function names, as a string or cell array of strings
% abspath       flag for absolute (rather than relative) paths
%               1 = use absolute paths, write the zipfile to the local directory
%               0 = use relative paths, write the zipfile to the commom rootpath
% zipfilename   the zipfile to export the functions to
%
% abspath is useful when you are using networked drives where a common
% rootpath may not exist or be useful
%
% If no zipfilename is specified, the ZIP file is created in the current
% working directory with name X.zip where X is the first function name in
% the supplied list
%
% The file names in the ZIP file are relative to the
% common root directory directory of all the required files.  If no
% common root directory can be established (e.g. if files are on
% different drives) an error is thrown (sometimes).
%

%% Version
% Copyright 2006-2010 The MathWorks, Inc. 
% Original: Malcolm Wood    11 Apr 2006
% Modified: ?               15 Mar 2010     ? on Matlab FileExchange
%           Mark Morehead      Mar 2011     added abspath ability
%                                             relative paths do not work well 
%                                             across multiple network drives
%                                           changed strcmp to strcmpi to 
%                                             avoid problems with mixing cases
%                                             recommend by Mut Ante
%           Mark Morehead   25 Feb 2013     Added nargin<2 test
%                                           recommended by Ioannis Filippidis
%

%% Start

if ~iscell(funcname)
    funcname = {funcname};
end

if isempty(funcname)
    error('No function names specified');
end

if ~iscellstr(funcname)
    error('Function names must be strings');
end

if nargin>1 && ~isnumeric(abspath)
    error('abspath must be a numeric value');
end

if nargin < 2
    abspath = 0; 
end

if nargin<3
    zipfilename = fullfile(pwd,[ funcname{1} '.zip' ]);
end

req = cell(size(funcname));
for i=1:numel(funcname)
    req{i} = mydepfun(funcname{i},1); % recursive
end
req = vertcat(req{:}); % cell arrays of full file names
req = unique(req);

% Use relative rootpath
if ~abspath
    % Find the common root directory
    d = i_root_directory(req);
    % Calculate relative paths for all required files.
    n = numel(d);
    for i=1:numel(req)
        % This is the bit that can't be vectorised
        req{i} = req{i}(n+1:end); % step over last character (which is the separator)
    end
    zip(zipfilename,req,d);
else
    zip(zipfilename,req);
end

fprintf(1,'Created %s \n',zipfilename);
fprintf(1,' with %d entries (exludes functions called by eval())\n',numel(req));

%%%%%%%%%%%%%%%%%%%%%
% Identifies the common root directory of all files in cell array "req"
function d = i_root_directory(req)

d = i_parent(req{1});
for i=1:numel(req)
    t = i_parent(req{i});
    if strncmpi(t,d,numel(d))
        % req{i} is in directory d.  Next file.
        continue;
    end
    % req{i} is not in directory d.  Up one directory.
    count = 1;
    while true
        % Remove trailing separator before calling fileparts.  Add it
        % again afterwards.
        tempd = i_parent(d(1:end-1));
        if strcmp(d,tempd)
            % fileparts didn't find us a higher directory
            error('Failed to find common root directory for %s and %s',req{1},req{i});
        end
        d = tempd;
        if strncmpi(t,d,numel(d))
            % req{i} is in directory d.  Next file.
            break;
        end
        % Safety measure for untested platform.
        count = count+1;
        if count>1000
            error('Bug in i_root_directory.');
        end
    end
end

%%%%%%%%%%%%%%%%%%%
function d = i_parent(d)
% Identifies the parent directory, including a trailing separator

% Include trailing separator in all comparisons so we don't assume that
% file C:\tempX\file.txt is in directory C:\temp
d = fileparts(d);
if d(end)~=filesep
    d = [d filesep];
end











