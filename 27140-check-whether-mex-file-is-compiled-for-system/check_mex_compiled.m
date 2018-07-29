function check_mex_compiled(varargin)
% Check if mex file is compiled for system
% 
%   check_mex_compiled(source_file)
%   check_mex_compiled(options,source_file)
% 
%   check_mex_compiled(source_file) checks whether a mex
%   source file source_file is compiled for the current
%   operating system OR whether the source file has been
%   modified since it was compiled. It is compiled if it
%   does not pass these tests (to the same directory as the
%   source file). source_file must be a string that is the
%   name of a source file on the MATLAB search path.
% 
%   check_mex_compiled(options,source_file) passes the
%   script switches in options to the mex compiler, one
%   argument per switch.
% 
%   Example
% 
%       % check function compiled, with debugging info, and
%       % with large-array-handling API
%       check_mex_compiled('-g','-largeArrayDims','myfun.c')
% 
% See also MEX.

% !---
% ==========================================================
% Last changed:     $Date: 2012-01-17 15:15:36 +0000 (Tue, 17 Jan 2012) $
% Last committed:   $Revision: 100 $
% Last changed by:  $Author: mu31ch $
% ==========================================================
% !---

source_file = varargin{end};

% Check input filename
if ~ischar(source_file)
    error('source_file: must be a string')
end

% Check extension is specified
if isempty(strfind(source_file,'.'))
    error('source_file: no file extension specified')
end

% Locate source file
[pathstr,name,ext] = fileparts(which(source_file));

filename = [pathstr filesep name ext]; % Create filename
mexfilename = [pathstr filesep name '.' mexext]; % Deduce mex file name based on current platform

if strcmp(pathstr,'') % source file not found
    error([source_file ': not found'])
elseif exist(mexfilename,'file')~=3 || get_mod_date(mexfilename)<get_mod_date(filename)
     % if source file does not exist or it was modified after the mex file
    disp(['Compiling "' name ext '".'])
    d = cd;
    cd(pathstr)
    % compile, with options if appropriate
    if length(varargin)>1
        options = varargin{1:end-1};
        mex(options,source_file)
    else
        mex(source_file)
    end
    disp('Done.')
    cd(d)
end

% end of check_mex_compiled()

% ----------------------------------------------------------
% Local functions:
% ----------------------------------------------------------

% ----------------------------------------------------------
% get_mod_date: get file modified date
% ----------------------------------------------------------
function datenum = get_mod_date(file)

d = dir(file);
datenum = d.datenum;

% [EOF]
