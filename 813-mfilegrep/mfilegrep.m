function mfilelist = mfilegrep(searchstring,startpath,recurse,wholewords,casesens,showline)

% MFILELIST = MFILEGREP(SEARCHSTRING, STARTPATH, RECURSE, WHOLEWORDS, CASESENS, SHOWLINE)
% returns in a cell array the names of all m-files within the startpath
% (searching recursively or non-recursively), that contain the text searchstring.
%
% The function calls the embedded subfunction 'filesearch' to locate the files.
%
% Takes from 1 to 6 input arguments; at a minimum, the user must specify the desired searchstring.
% STARTPATH and RECURSE (= 0 or 1) may also be inputs; otherwise, a gui interface will prompt the
%       user for these values.
% WHOLEWORDS and CASESENS (= 0 or 1) may be indicated as well; if not, the default values of 0 and 0,
%       respectively, will be used. Wholewords == 1 specifies that only whole-word matches will be returned;
%       wholewords == 0 will also return partial matches. Casesens == 1 returns case-sensitive matches only;
%       casesens == 0 ignores case.
% The final (optional) input is SHOWLINE (= 0 or 1; default = 0). If showline == 1, the output also
%       shows the text of all lines found in the file(s) containing the search string.
%
% EXAMPLES:
%
% FILELIST = MFILEGREP('domct') prompts the user via uicontrols for starting path and inclusion or 
%             exclusion of subdirectories, then searches all mfiles on the indicated path for 'domct'.
% FILELIST = MFILEGREP('domct', 'C:\Mfiles') searches specified directory for m-files; prompts the user for:
%             inclusion or exclusion of subdirectories.
% FILELIST = MFILEGREP('domct','C:\Mfiles',1) searches specified directory recursively for m-files.
% FILELIST = MFILEGREP('domct','C:\Mfiles',1, 0, 1) searches specified directory recursively for m-files;
%             in this case, the search returns partial word matches (e.g., 'examp' matches 'example'),
%             and the search is case sensitive.
% FILELIST = MFILEGREP('domct','C:\Mfiles',0, 0, 1, 1) searches specified directory non-recursively for m-files;
%             returns partial and case-sensitive word matches, and includes all lines containing the search string
%             in the output cell array.               
%
% Copyright Brett Shoelson, Ph.D.
% Shoelson Consulting
% brett.shoelson@joslin.harvard.edu
% V1: 6/22/01. Based extensively on the new version of collectcode.m.
% V2. 9/30/01. Modified to include "showline" option.
% V3. 10/25/01. Modified to match default behavior to program description.


if ~nargin
	error('Requires at least one argument indicating desired searchstring.');
elseif nargin == 1
	% Get starting path
	[filename,startpath]=uigetfile('*.m','Select any m-file in the desired starting pathname.');
	%Remove trailing '\' character
	if strcmp(startpath(end),'\'),startpath=startpath(1:end-1);end
	% Query for inclusion of subdirectories
	recurse=questdlg('Include subdirectories?','','YES','No','YES');
	if strcmp(recurse,'YES'),recurse=1;else;recurse=0;end
	wholewords = 0; casesens = 0; showline = 0;
elseif nargin == 2
	recurse=questdlg('Include subdirectories?','','YES','No','YES');
	if strcmp(recurse,'YES'),recurse=1;else;recurse=0;end
	wholewords = 0; casesens = 0; showline = 0;
elseif nargin == 3
	wholewords = 0; casesens = 0; showline = 0;
elseif nargin == 4
	casesens = 0; showline = 0;
elseif nargin == 5
    showline = 0;
elseif nargin > 6
	error('Too many input arguments.');
end

% Check for appropriateness of inputs:
if ~ischar(searchstring)
	error('searchstring must be a character string.');
end
if recurse ~= 1 & recurse ~= 0
	error('recurse must be 1 or 0.');
end
if wholewords ~= 1 & wholewords ~= 0
	error('wholewords must be 1 or 0.');
end
if casesens ~= 1 & casesens ~= 0
	error('casesens must be 1 or 0.');
end
if showline ~= 1 & showline ~= 0
	error('showline must be 1 or 0.');
end

currpath = cd;

% Compile filenames (calls subfunction filesearch)
files = filesearch('m', startpath, recurse);

cd(startpath);

line = 0;
mfilelist = {};

if ~ casesens
	searchstring = lower(searchstring);
end

if wholewords
	alphachars = ['A' ; 'B' ; 'C' ; 'D' ; 'E' ; 'F' ; 'G' ; 'H' ; 'I' ; 'J' ; 'K' ; 'L' ; ...
			'M' ; 'N' ; 'O' ; 'P' ; 'Q' ; 'R' ; 'S' ; 'T' ; 'U' ; 'V' ; 'W' ; 'X' ; ...
			'Y' ; 'Z'];
	alphachars = [alphachars; lower(alphachars); '1' ; '2' ; '3' ; '4' ; '5' ; '6' ; '7' ; '8' ; '9' ; '0'];
end

% Loop through all mfiles on search path

fprintf('Searching directory(ies)....\n');

for i = 1 : size(files, 1)
	filename = files{i};
	%fprintf('Searching %s....\n', filename);
	% Open mfile(i) and read contents line by line; write lines to codetext.txt
	fid3 = fopen(filename, 'rt');
	while line ~=-1
		line = fgets(fid3);
		if line ~= -1
			if ~ casesens
				line = lower(line);
			end
			if ~isempty(findstr(line, searchstring))
				% findstr finds the instance of the shorter string in the longer; the following if/then ensures that
				% the function won't return instances of subelements (eg., findstr('y','classify') is non-empty).
				if length(line) >= length(searchstring)
					if wholewords
						wholefound = iswhole(searchstring, line, alphachars);
						if wholefound
							if isempty(intersect(mfilelist,filename))
								mfilelist{size(mfilelist, 1) + 1, 1} = filename;
							end
							if showline
								mfilelist{size(mfilelist, 1) + 1, 1} = line;
							else
								break
							end
						end
					else
						if isempty(intersect(mfilelist,filename))
							mfilelist{size(mfilelist, 1) + 1, 1} = filename;
						end
						if showline
							mfilelist{size(mfilelist, 1) + 1, 1} = line;
						else
							break
						end
					end % if wholewords
				end % if length(line) >= length(searchstring)
			end % if ~isempty(findstr(line, searchstring))
		end % if line ~=- 1
	end % while line ~=- 1
	line = 0;
	% Close mfile(i) and continue
	fclose(fid3);
end % for i = 1 : size(files, 1)

cd(currpath);                   
                    

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
			tmp = dir([deblank(directories(i,:)) '\*.' extension]);
			if ~isempty(tmp),tmp = char(tmp.name);end
			%Update files to reflect newly detected files. (Omit trailing blanks.)
			for j = 1:size(tmp,1)
				files{size(files,1)+1,1} = [deblank(directories(i,:)) '\' deblank(tmp(j,:))];
			end
		end
	end
else %Search non-recursively
	files = {};
	tmp = dir([startpath '\*.' extension]);
	if ~isempty(tmp),tmp = char(tmp.name);end
	for j = 1:size(tmp,1)
		files{size(files,1)+1,1} = [startpath '\' deblank(tmp(j,:))];
	end
end


function wholefound = iswhole(searchstring, teststring, alphachars)
charlocs = findstr(searchstring, teststring);
prevlocs = charlocs - 1;
postlocs = charlocs + length(searchstring);
delprevposns = [find(prevlocs == 0)];
delpostposns = [find(postlocs >= length(teststring))];
prevlocs(delprevposns) = '';
postlocs(delpostposns) = '';
prevmbrs = ismember(teststring(prevlocs)', alphachars);
postmbrs = ismember(teststring(postlocs)', alphachars);
if ~ isempty(delprevposns), prevmbrs = [0; prevmbrs]; end
if ~ isempty(delpostposns), postmbrs = [postmbrs; 0]; end
wholefound = any(~ or (prevmbrs, postmbrs) );
