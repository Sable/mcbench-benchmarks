function ed(varargin)
%   ED: MODIFIED (SHORTCUT) VERSION of TMW's "Edit" function.
%
%   In this version, "unique partial matches" IN THE CURRENT DIRECTORY 
%   are treated as successes.
% 
%   For example, if the current directory contains files called testformat.m,
%   cssm.m, and workinprog.m, typing 'ed tes cs work' will suffice to launch
%   testformat, cssm, and workinprog in the editor as long as the partial matches
%   are locally non-ambiguous. (If another file called 'tesselations.m' also
%   exists in the current directory, no action will be taken for the first input
%   argument.)
%   
%   BASED ON function edit:
%   Copyright 1984-2003 The MathWorks, Inc.
%   $Revision: 5.10.4.2 $  $Date: 2004/07/16 18:32:13 $
%   Built-in function.
%
%   Modification by Brett Shoelson, PhD.
%   shoelson@helix.nih.gov
%   1/4/05.


rel = ver; rel=rel(find(ismember({rel.Name},'MATLAB'))).Release;rel = str2num(rel(3:4));
a = which('edit','-all');

if rel <= 13
	beep;
	disp('Function does not yet work for R13 and earlier.');
	return
else
	[pn,fname] = fileparts(a{find(~cellfun('isempty',strfind(a,'\codetools')))});
	fn{1} = str2func(fullfile(pn,fname));

	%Parse varargin into exist/not exist
	usetmw = {}; usebds = {}; tmwcnt = 0; bdscnt = 0;
	for ii = 1:nargin
		if exist(varargin{ii})
			tmwcnt = tmwcnt+1;
			usetmw{tmwcnt} = varargin{ii};
		else
			bdscnt = bdscnt+1;
			usebds{bdscnt} = varargin{ii};
		end
	end

	if ~isempty(usetmw)
		feval(fn{1},usetmw{:});
	end

	if ~isempty(usebds)
		a = dir;
		for ii = 1:length(usebds)
			lnum = strmatch(lower(usebds{ii}),lower(strvcat(a(:).name)));
			if length(lnum) == 1
				feval(fn{1},a(lnum).name);
				fprintf('Editing file: %s\n',a(lnum).name);
			else
				fprintf('Ignoring ambiguous argument with non-unique partial matches for input: %s\n',usebds{ii});
			end
		end
	end
end

