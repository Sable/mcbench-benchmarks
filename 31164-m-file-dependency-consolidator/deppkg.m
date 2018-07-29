% Function to find and consolidate all file dependencies for an m-file
% script/function or all such files in a given directory
% Anything that falls under the matlab root path will be ommitted
% (e.g. toolboxes, and standard functions).
%
% Jit Sarkar
% MPL/SIO
% 2011/04/20
%
%
%	Copy_List	=	deppkg(SRC,DEST)
%
%
% Input Parameters:
%	SRC		{str}(n)			:	Source m-file script/function to parse
%	DEST	{srt}(m)			:	Destination directory to copy
%									dependencies to
%
%
% Output Parameters:
%	Copy_List	{cell}{str}(Nc)	:
%


function	Copy_List	=	deppkg(SRC, DEST, IS_recursive)
%	IS_recursive is only used internally to trigger actual file copying,
%	otherwise the recursion would copy your given SRC file(s) as well.



%%	Input parsing
if	~exist(SRC, 'file')
	error('Input file/folder does not exist');
end

if	~exist('IS_recursive','var')
	IS_recursive	=	false;
end


%%	If SRC is a directory find top level files
%	will NOT process nested directories, because that can get messy if the
%	DEST folder is a subfolder in the SRC, and will take unecessarily long
if	isdir(SRC)
	File_List	=	dir(SRC);
	Copy_List	=	[];
	for	nn	=	1:length(File_List)
		if	~File_List(nn).isdir
			file_name	=	fullfile(SRC,File_List(nn).name);
			Copy_List	=	[Copy_List; deppkg(file_name,DEST, IS_recursive)]; %#ok<AGROW>
		end
	end
	return;
end

	
%%	Otherwise find all top-level dependencies for current file
Dep_List	=	depfun(SRC, '-quiet', '-toponly');

%	Determine which dependencies are matlab bundled functions/toolboxes
IN_matlab	=	strncmp(matlabroot, Dep_List, length(matlabroot));
%	Remove them from the list
Dep_List	=	Dep_List(~IN_matlab);

%	First item is always the current file itself
%	Only copy the file, if this is a recursive step
Copy_List	=	[];
if	IS_recursive
	if	~isdir(DEST);	mkdir(DEST);	end;
	copyfile(Dep_List{1},DEST);
	Copy_List	=	Dep_List(1);
end

%	Loop through reduced dependency list recursively finding all other
%	required files
for		nn	=	2:length(Dep_List)
	Copy_List	=	[Copy_List; deppkg(Dep_List{nn},DEST, true)]; %#ok<AGROW>
end



%%	End of Function
return;


