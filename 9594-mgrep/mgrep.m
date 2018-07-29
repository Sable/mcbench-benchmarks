function mfilelist = mgrep(searchstring,startpath,varargin)
% mgrep: searches (recursively or not) files on a path for a given searchstring
% usage: mfilelist = mgrep(searchstring)
% usage: mfilelist = mgrep(searchstring,startpath)
% usage: mfilelist = mgrep(searchstring,startpath,prop1,val1,...)
% usage: mgrep searchstring
% usage: mgrep searchstring startpath
% usage: mgrep searchstring startpath prop1 val1 ...
%
%
% arguments: (input)
%  searchstring - string - search string (no wildcards)
%
%  startpath - (OPTIONAL) string - contains top level directory to search
%        The search will not be recursive by default.
%
%        If left empty or not supplied, then startpath will be the
%        current directory.
%
%  Additional arguments are in the form of property/value pairs.
%  Properties may be in any order, and may be shortened as long
%  as that shotening is unambiguous, down to a single letter.
%  Capitalization is ignored.
%
%  Valid properties: 'recurse', 'wholewords', 'casesens', 'showline')
%
%  The only legal values for each of these properties are 'on' or 'off'
%
%   'recurse' - 'on' --> Recursively search subdirectories on the path
%              'off' --> Restrict search to only the specified directory
%
%              DEFAULT = 'on'
%
%   'wholewords' - 'on' --> Find occurences of searchstring as a whole word
%              'off' --> Allow partial word matches
%
%              DEFAULT = 'off'
%
%   'casesens' - 'on' --> Use case sensitive matches in the search
%              'off' --> Ignore case in the search
%
%              DEFAULT = 'off'
%
%   'showline' - 'on' --> Include the line that contained each match
%              'off' --> Do not display the lines with matches
%
%              DEFAULT = 'on'
%
%
% Arguments: (output)
%  mfilelist - a cell array 
%        
%  If no output argument is provided for, then the results of mgrep
%  will only be displayed in the command window. This is the behavior
%  of mgrep when used in command mode.
%
%
% Example usages:
%
% Recursive search, starting in the current directory for the string 'fmin',
% returning the result as a cell array. Any of these 3 alternatives will work:
%   filelist = mgrep('fmin');
%   filelist = mgrep('fmin',pwd);
%   filelist = mgrep('fmin','.');
%
% Simple search of the directory './mylocaldir' for the string 'fmin',
% display the result in the command window. Do not search subdirectories.
%   mgrep fmin ./mylocaldir recurse off
%
% Case sensitive search for the name "John D'Errico", through all subdirectories
% beginning with the current directory. Display the results in the command window.
%   mgrep 'John D''Errico' . c on
%
%
% Much of this code is thanks to Brett Shoelson, Ph.D.
% My contribution was mainly the interface, plus any errors that may have
% surrepticiously appeared. John D'Errico, woodchips@rochester.rr.com

% defaults for all optional parameters
par.recurse = 'on';
par.wholewords = 'off';
par.casesens = 'off';
par.showline = 'on';

if (nargin<2) || isempty(startpath)
  startpath = pwd;
end

% default startpath
if ~nargin
	error('Requires at least one argument indicating desired searchstring.');
elseif (nargin == 1) || isempty(startpath)
	% Starting path is current directory
  startpath = pwd;
end
% Remove trailing filesep character if one is there
if strcmp(startpath(end),filesep),startpath(end) = [];end

% process property/value pairs into a structure
if (nargin>2)
  par=parse_pv_pairs(par,varargin);
end

% Check for appropriate values
if ~ischar(searchstring)
	error('searchstring must be a character string.');
end
val = {'on' 'off'};
par.recurse = lower(par.recurse);
if ~ismember(par.recurse,val)
	error('recurse must be ''on'' or ''off''.');
end
par.wholewords = lower(par.wholewords);
if ~ismember(par.wholewords,val)
	error('wholewords must be ''on'' or ''off''.');
end
par.casesens = lower(par.casesens);
if ~ismember(par.casesens,val)
	error('casesens must be ''on'' or ''off''.');
end
par.showline = lower(par.showline);
if ~ismember(par.showline,val)
	error('showline must be ''on'' or ''off''.');
end

% convert parameters to booleans
par.recurse = strcmp(par.recurse,'on');
par.wholewords = strcmp(par.wholewords,'on');
par.casesens = strcmp(par.casesens,'on');
par.showline = strcmp(par.showline,'on');

% save for later return to the user's directory
currpath = cd;
% If startpath is not a directory, then cd will provide the
% error message. No need to check with isdir.
cd(startpath);
% get the absolute path, just in case only a relative path was specifid
startpath = pwd;

% Compile filenames (calls subfunction filesearch)
files = filesearch('m', startpath, par.recurse);

if nargout>0
  mfilelist = {};
end

if ~par.casesens
	searchstring = lower(searchstring);
end

if par.wholewords
	alphachars = ('ABCDEFGHIJKLMNOPQRSTUVWXYZ')';
	alphachars = [alphachars; lower(alphachars); ('1234567890')'];
end

% Loop through all mfiles on search path

fprintf('Searching directory(ies)...\n');

for j = 1 : size(files, 1)
	filename = files{j};
	%fprintf('Searching %s....\n', filename);
	% read contents of files{i}

  %   filecontents = textread(filename,'%s','delimiter','\n','whitespace','');
  
  fileflag = 1;
  line_i = 0;
  % Open mfile(i) and read contents line by line
	fid_j = fopen(filename, 'rt');
	while line_i ~= -1
		line_i = fgets(fid_j);
    if line_i ~= -1
      
      %   for i=1:numel(filecontents)
      %    line_i=filecontents{i};
      if ~par.casesens
        lline_i = lower(line_i);
      else
        lline_i = line_i;
      end
      if ~isempty(findstr(lline_i, searchstring))
        % findstr finds the instance of the shorter string in the longer; the following if/then ensures that
        % the function won't return instances of subelements (eg., findstr('y','classify') is non-empty).
        if length(lline_i) >= length(searchstring)
          if par.wholewords
            wholefound = iswhole(searchstring, lline_i, alphachars);
            if wholefound
              if fileflag
                % write the file name
                fileflag = 0;
                if nargout==0
                  disp(' ');
                  disp(filename)
                else
                  mfilelist{end + 1, 1} = filename;
                end
              end
              if par.showline
                if nargout==0
                  disp(line_i)
                else
                  mfilelist{size(mfilelist, 1) + 1, 1} = line_i;
                end
              else
                break
              end
            end % if wholefound
          else
            if fileflag
              % write the file name
              fileflag = 0;
              if nargout==0
                disp(' ');
                disp(filename)
              else
                mfilelist{end + 1, 1} = filename;
              end
            end
            if par.showline
              if nargout==0
                disp(lline_i)
              else
                mfilelist{size(mfilelist, 1) + 1, 1} = line_i;
              end
            else
              break
            end % if par.showline
          end % if wholewords
        end % if length(lline_i) >= length(searchstring)
      end % if ~isempty(findstr(lline_i, searchstring))
      
    end % if line_i ~= -1
  end % while line_i ~= -1
  line = 0;
  % Close mfile(i) and continue
  fclose(fid_j);
end % for j = 1 : size(files, 1)

cd(currpath);


% ======================================================================
%                        begin subfunctions
% ======================================================================
function files = filesearch(extension,startpath,recurse)
%
%  Search a specified path (recursively or non-recursively) for all instances of files with a specified extension.
%  Results are returned in a cell array ('files').
%
%  FILES = FILESEARCH(EXTENSION,STARTPATH,1) searches for all instances of *.extension in the starting directory OR
%          in any subdirectory beneath the starting directory.
%  FILES = FILESEARCH(EXTENSION,STARTPATH,0) searches for all instances of *.extension in the starting directory ONLY,
%          and excludes files in subdirectories.
%  Examples:
% 
%  files = filesearch('txt','C:\WinNT',1)
%  mfiles = filesearch('m','D:\Mfiles',0)

% Copyright Brett Shoelson, Ph.D., 5/29/2001 
% brett.shoelson@joslin.harvard.edu

if recurse
	files = {};
	%Create string of recursive directories/subdirectories
	paths = genpath(startpath);
	%Find instances of the path separator
	seplocs = findstr(paths,pathsep);
	%Parse paths into individual (vertically catenated) directories
	if ~isempty(seplocs)
		directories = paths(1:seplocs(1)-1);
		for i = 1:length(seplocs)-1
			directories = strvcat(directories,paths(seplocs(i)+1:seplocs(i+1)-1));
		end
		%Search each directory for instances of *.extension, appending to current list
		for i = 1:size(directories,1)
			%Compile located files as vertically catenated strings
			tmp = dir([deblank(directories(i,:)) filesep '*.' extension]);
			if ~isempty(tmp),tmp = char(tmp.name);end
			%Update files to reflect newly detected files. (Omit trailing blanks.)
			for j = 1:size(tmp,1)
				files{size(files,1)+1,1} = [deblank(directories(i,:)) filesep deblank(tmp(j,:))];
			end
		end
	end
else %Search non-recursively
	files = {};
	tmp = dir([startpath filesep '*.' extension]);
	if ~isempty(tmp),tmp = char(tmp.name);end
	for j = 1:size(tmp,1)
		files{size(files,1)+1,1} = [startpath filesep deblank(tmp(j,:))];
	end
end



function wholefound = iswhole(searchstring, teststring, alphachars)
charlocs = findstr(searchstring, teststring);
prevlocs = charlocs - 1;
postlocs = charlocs + length(searchstring);
delprevposns = find(prevlocs == 0);
delpostposns = find(postlocs >= length(teststring));
prevlocs(delprevposns) = '';
postlocs(delpostposns) = '';
prevmbrs = ismember(teststring(prevlocs)', alphachars);
postmbrs = ismember(teststring(postlocs)', alphachars);
if ~ isempty(delprevposns), prevmbrs = [0; prevmbrs]; end
if ~ isempty(delpostposns), postmbrs = [postmbrs; 0]; end
wholefound = any(~ or (prevmbrs, postmbrs) );



function params=parse_pv_pairs(params,pv_pairs)
% parse_pv_pairs: parses sets of property value pairs, allows defaults
% usage: params=parse_pv_pairs(default_params,pv_pairs)
%
% arguments: (input)
%  default_params - structure, with one field for every potential
%             property/value pair. Each field will contain the default
%             value for that property. If no default is supplied for a
%             given property, then that field must be empty.
%
%  pv_array - cell array of property/value pairs.
%             Case is ignored when comparing properties to the list
%             of field names. Also, any unambiguous shortening of a
%             field/property name is allowed.
%
% arguments: (output)
%  params   - parameter struct that reflects any updated property/value
%             pairs in the pv_array.
%
% Example usage:
% First, set default values for the parameters. Assume we
% have four parameters that we wish to use optionally in
% the function examplefun.
%
%  - 'viscosity', which will have a default value of 1
%  - 'volume', which will default to 1
%  - 'pie' - which will have default value 3.141592653589793
%  - 'description' - a text field, left empty by default
%
% The first argument to examplefun is one which will always be
% supplied.
%
%   function examplefun(dummyarg1,varargin)
%   params.Viscosity = 1;
%   params.Volume = 1;
%   params.Pie = 3.141592653589793
%
%   params.Description = '';
%   params=parse_pv_pairs(params,varargin);
%   params
%
% Use examplefun, overriding the defaults for 'pie', 'viscosity'
% and 'description'. The 'volume' parameter is left at its default.
%
%   examplefun(rand(10),'vis',10,'pie',3,'Description','Hello world')
%
% params = 
%     Viscosity: 10
%        Volume: 1
%           Pie: 3
%   Description: 'Hello world'
%
% Note that capitalization was ignored, and the property 'viscosity'
% was truncated as supplied. Also note that the order the pairs were
% supplied was arbitrary.

npv = length(pv_pairs);
n = npv/2;

if n~=floor(n)
  error 'Property/value pairs must come in PAIRS.'
end
if n<=0
  % just return the defaults
  return
end

if ~isstruct(params)
  error 'No structure for defaults was supplied'
end

% there was at least one pv pair. process any supplied
propnames = fieldnames(params);
lpropnames = lower(propnames);
for i=1:n
  p_i = lower(pv_pairs{2*i-1});
  v_i = pv_pairs{2*i};
  
  ind = strmatch(p_i,lpropnames,'exact');
  if isempty(ind)
    ind = find(strncmp(p_i,lpropnames,length(p_i)));
    if isempty(ind)
      error(['No matching property found for: ',pv_pairs{2*i-1}])
    elseif length(ind)>1
      error(['Ambiguous property name: ',pv_pairs{2*i-1}])
    end
  end
  p_i = propnames{ind};
  
  % override the corresponding default in params
  params = setfield(params,p_i,v_i);
  
end












