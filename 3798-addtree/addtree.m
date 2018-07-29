function  cnt = addtree(root_str,option_str)
%ADDTREE  adds the given root-directory 
%   and the complete tree below to the MATLAB-path
%   The number of added directories will be returned.
%
%   Syntax:          cnt = ADDTREE( root_str, option_str )
%
%      cnt           Number of added directories
%      root_str      A string representing the desired tree-root
%      option_str    A string which contains the single options,
%                    separated by whitespaces. Not case sensitive.
%                    (optional, may be empty or omitted)
%
%                    Available options:
%                    - verbose       print each directory name to the command window
%                    - methods       include object method directoties (private, @xxx)
%
%   Examples:        addtree(cd)
%                    addtree(cd , 'verbose option1 option2')
%                    
%
%   See also PATH, ADDPATH

%	Jochen Lenz


% Check right hand arguments:
if  nargin < 2
    option_str = ''; % emtpy string is default
end
verbose_flg = ~isempty(strfind(upper(option_str),'VERBOSE'));
methods_flg = ~isempty(strfind(upper(option_str),'METHODS'));

% Ignore object-method directories, unless forced by 'METHODS' option:
[pathname,foldername] = fileparts(root_str);
if  methods_flg
    ignore_flg = 0;  % forced
else
    if  strcmp(upper(foldername),'PRIVATE')  |  isequal(foldername(1),'@')
        ignore_flg = 1;
    else
        ignore_flg = 0;
    end
end

if  ignore_flg
    cnt = 0;
    return
end

% Add the given root-directory itself:
path(path,root_str);
if  verbose_flg
    disp(root_str);
end

% Counter for the number of added directories:
cnt = 1;

% Call ADDTREE recursively for all sub-dirs:
root_dir = dir(root_str);
for  i = 1 : length(root_dir)
    if  root_dir(i).isdir  &  ~isequal(root_dir(i).name,'.')  &  ~isequal(root_dir(i).name,'..')
        cnt = cnt + addtree( fullfile(root_str, root_dir(i).name) , option_str );
    end
end

return
