function tedit(varargin)
% TEDIT create a file using a template.
%   TEDIT(funname) opens the editor and pastes the content
%   of a user-defined template into the file funname.m.
% 
%   Example
%   tedit myfunfun
%   opens the editor and pastes the following 
% 
% 	function output = myfunfun(input)
% 	%MYFUNFUN  One-line description here, please.
% 	%   output = myfunfun(input)
% 	%
% 	%   Example
% 	%   myfunfun
% 	%
% 	%   See also
% 
% 	% Author: Your name
% 	% Created: 2005-09-22
% 	% Copyright 2005 Your company.
% 
%   See also edit, mfiletemplate

% Author: Peter (PB) Bodin
% Created: 2005-09-22
	
	
	% See the variables repstr, repwithstr and tmpl to figure out how
	% to design your own template.
	% Edit tmpl to your liking, if you add more tokens in tmpl, make
	% sure to add them in repstr and repwithstr as well.
	
	% I made this function just for fun to check out some java handles to
	% the editor. It would probably be better to fprintf the template
	% to a new file and then call edit, since he java objects might change
	% names between versions.

	switch nargin
		case 0
			edit
			warning('tedit without argument is the same as edit')
			return;
		case 1
			fname=varargin{:};
			edit(fname);
		otherwise
			error('too many input arguments')
	end

	try
		edhandle=com.mathworks.mlservices.MLEditorServices;
		edhandle.builtinAppendDocumentText(strcat(fname,'.m'),parse(fname));
	catch
		rethrow(lasterr)
	end

	function out = parse(func)

		tmpl={ ...
			'function output = $filename(input)'
			'%$FILENAME  One-line description here, please.'
			'%   output = $filename(input)'
			'%'
			'%   Example'
			'%   $filename'
			'%'
			'%   See also'
			''
			'% Author: $author'
			'% Created: $date'
			'% Copyright $year $company.'};

		repstr={...
			'$filename'
			'$FILENAME'
			'$date'
			'$year'
			'$author'
			'$company'};

		repwithstr={...
			func
			upper(func)
			datestr(now,29)
			datestr(now,10)
			'Your name'
			'Your company'};

		for k = 1:numel(repstr)
			tmpl = strrep(tmpl,repstr{k},repwithstr{k});
		end
		out = sprintf('%s\n',tmpl{:});
	end
end
