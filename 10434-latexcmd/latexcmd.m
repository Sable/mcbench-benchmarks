function latexcmd(filename, varargin)
	
% USAGE: latexcmd(filename, var1, var2, ...)
% 
% Creates a LaTeX file with commands named as the corresponding Matlab 
%   variables. Include the resulting LaTeX file into your LaTeX document 
%   (by an \include{filename}) to access the variable values. Works on 
%   scalars, polynomials, numeric arrays, cell arrays, and structures. Also 
%   works with most types: numbers (real and complex), NaN, Inf, strings, 
%   syms (from the Symbolic Toolbox), function handles, and inlines (although 
%   functions look flat without the Symbolic TB). 
% 
% If you find any errors, please let me know (peder at axensten dot se)!
% 
% INSPIRATION: latexcmd has the functionality of the similar m-files latex, 
%   matrix2latex, MAT2TEX, latex_trick, mat2textable, but works on more 
%   variable and number types, and has a more flexible number format, when 
%   required. It can also save as many variables as you want in one file, as 
%   opposed to one file per variable in some older related m-files.
% 
% ARGUMENTS:
% filename must be a string. If prefixed by '>' (i.e. '>filename'), the results 
%   will be appended to previous file contents. If empty, results will be 
%   printed on the display.
% var may be any of the following:
% + Arrays must be max 2-dimensional.
% + Cell arrays may not be nested (contain structures or arrays).
% + Structures generates a header with field names, followed by hline, followed 
%   by actual values.
% + Character strings: 
% - '\myname': The name of the next expression.
% - '@myprefix': The prefix of the following names.
% - '%myformat': Defines a new active number format (e.g. '%12.5E'). Specials:
%       '%r': fractions format of numbers (using rat).
%       '%R': fractions format of numbers (using rat) with integer part.
%       '%ns': power of ten suffix (e.g., k, M, etc.) (n is number of digits).
%       '%nS': 'scientific notation', exponent multiple of 3.
%       '%u & %g & %5.2f%%' formats array columns individually. 
% - '%stat': Statistics of the following array (all of it, not column-wise): 
%       length, min, max, range, mean, median, std, cov, and all of it 
%       collectively (see latexcmd_example.m). If the next expression is 
%       non-numeric, '%stat' will be ignored.
% - '%poly': Outputs the following array as a polynomial of 'x'.
% - '%poly:myvar': Outputs the following array as a polynomial of myvar.
% - Other strings will be output as they are.
% 
% EXAMPLE (See 'help latexcmd_example' for more detailed examples.):
% --- In Matlab m-file ---------------------------------------------------
% result= [1 2 3 4 5 6];
% resultmean= mean(result);
% latexcmd(results, result, resultmean);
% --- In your LaTeX file -------------------------------------------------
% \include{results}
% [and somewhere later]
% The mean of the measurements is \resultmean, with individual results:
% \begin{tabular}{r@{, }r@{, }r@{, }r@{, }r@{, and }r}\result\end{tabular}
% ------------------------------------------------------------------------
% 
% LATEX COMMANDS:
% The following LaTeX commands are defined (you may redefine them for other 
%   formatting): \integer{int}, \float{int}{decimal}, \integerE{int}{exp}, 
%   \floatE{int}{decimal}{exp}, \fraction{nom}{denom}, \numberdelimiter, 
%   \imsymb, \textmu, \NaN, \statAll{}{}{}{}{}{}{}{}.
%
% HISTORY:
% Version 1.0, 2006-03-20.
% Version 1.1, 2006-03-29:
% - Added the '%stat' option to output various statistical info on an array.
% - Added '%poly'/'%poly:name' options to output an array as a polynomial.
% - Individual column formatting didn't actually work (sorry!), now it does.
% - Fixed a crash when filename was an empty string.
% - Removed stuff that mlint complained about.
% Version 1.2, 2006-04-27:
% - Better (?) help text (no code changes).
% Version 1.3, 2006-05-07:
% - Prefix (with \) certain characters in char variables: $&%#_{}~^.
% Version 1.4, 2006-05-23:
% - Fixed a bug appearing when latexcmd was called from a command window.
% Version 1.5, 2006-06-06:
% - Fixed bugs in latexcmd_example.m.
% - Objects of type inline are now treated the same as function_handle objects.
% Version 1.6, 2006-06-07:
% - Additional type of formatting for real scalars using power of ten suffix, 
%   (M is 1e6 etc.). See '%^n', above. 
% - Fixed a pretty rare bug with %-prefixed strings.
% Version 1.7, 2006-06-14:
% - Fixed bug with one-dim. structures (thanks Ted Rosenbaum for reporting it).
% Version 1.8, 2006-07-20:
% - Added support for Fixed-Point Toolbox fi objects (class embedded.fi). 
% - '%r' and '%R': fractions format of numbers, using rat().
% - '%ns': scientific notation (exponent multiple of 3) with suffix. 
% - '%nS': scientific notation (exponent multiple of 3). 
% 
% COPYRIGHT (C) Peder Axensten (peder at axensten dot se), 2006.

% KEYWORDS:     export, latex, tex, prettyprint, table, polynomial, cell array, structure
% 
% INSPIRATION:  matrix2latex (4894), latex (2832), MAT2TEX (8373), latex_trick (9324), 
%               mat2textable (306)
% 
% REQUIREMENTS:
% - Symbolic Toolbox supported but not required.
% - Matlab 6.5.1 (R13SP1) and older don't support tokens in regexprep replacement 
%   strings, so latexcmd will never be compatible with these versions. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	st=		dbstack;
	if(numel(st) < 2)														% Caller: cmd win.
		st(2).file=	'Command Window';
		st(2).line=	NaN;
	end
	if((nargin < 1) || ~ischar(filename)), error('First argument must be a file name!'); end
	if(isempty(filename))													% Output to display.
		fileid=	1;
	elseif(filename(1) == '>')												% Append to file.
		[fileid, errmess]=	fopen([filename(2:end) '.tex'], 'a');
		fprintf(fileid, '\n\n%% Appended by %s, line %u, on %s \n\n', ...
												st(2).file, st(2).line, datestr(now));
	else																	% (Re)create file.
		[fileid, errmess]=	fopen([filename '.tex'], 'w');
		fprintf(fileid, '%% Generated by %s, line %u, on %s \n\n', ...
												st(2).file, st(2).line, datestr(now));
		fprintf(fileid, '%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n\n\n', ...
			'\providecommand{\NaN}{\mbox{\textsc{n}a\textsc{n}}}', ...
			'\providecommand{\imsymb}{\ensuremath{\mathrm{i}}}', ...
			'\providecommand{\textmu}{\ensuremath{\mu}} % Better: \usepackage{textcomp}', ...
			'\providecommand{\numberdelimiter}{.}', ...
			'\providecommand{\integer}[1]{#1}', ...
			'\providecommand{\float}[2]{\integer{#1\numberdelimiter#2}}', ...
			['\providecommand{\integerE}[2]{\integer{#1}', ...
				'\ensuremath{\cdot}\integer{10}\ensuremath{^{#2}}}'], ...
			['\providecommand{\floatE}[3]{\float{#1}{#2}', ...
				'\ensuremath{\cdot}\integer{10}\ensuremath{^{#3}}}'], ...
			'\providecommand{\fraction}[2]{\ensuremath{\frac{#1}{#2}}}', ...
			'\providecommand{\statAll}[8]{#1 & #2 & #3 & #4 & #5 & #6 & #7 & #8}' ...
		);	% Default LaTeX commands
	end
	if(fileid == -1), error(errmess); end	% Error while opening file.

	name=			'';
	prefix=			'';
	special.what=	'';
	f=				'%g';
	for i= 2:nargin
		v=		varargin{i-1};
		res=	'';
		if(isempty(v))
			res=	'\mbox{}';
		elseif(ischar(v))
			switch(v(1))
			case '%'
				if(strcmp(v, '%stat'))									% Statistics tag
					special.what=	'stat';
				elseif(~isempty(findstr(v, '%poly')))						% Polynomials tag
					special.what=	'poly';
					special.arg=	regexprep(v, '^%poly:*(.*)', '$1');
					if(isempty(special.arg)), special.arg= 'x'; end
				else														% New format
					f=		v;
				end
			case '@'														% New prefix
				prefix=	v(2:end);
			case char(92) % = backslash										% Name next expr.
				name=	v(2:end);
			otherwise														% Character data
				res=	do_format(f, v);
			end
		elseif(isa(v, 'struct'))											% Structure
			res= 	do_structure(i, f, v, special);
		elseif(isa(v, 'cell'))												% Cell array
			res= 	do_cell(i, f, v, special);
		elseif(numel(v) == 1)												% Scalar
			res=	do_format(f, v);
		elseif(length(size(v)) > 2)											% To many dimensions
			error('To many dimensions in argument %u! (max 2)', i);
		elseif(strcmp(special.what, 'stat') && ~isa(v, 'sym'))				% Statistics output
			if(isempty(name)), name= inputname(i); end	% Get variable name, if any
			if(isempty(name)), error('No name for argument %u!', i); end
			do_stat(fileid, [prefix name], f, v);
			special.what=	'';
			name=	'';
		else																% 'Normal' array
			res=	do_cell(i, f, num2cell(v), special);
		end
		
		if(~isempty(res))													% Any output?
			if(isempty(name)), name= inputname(i); end	% Get variable name, if any
			if(isempty(name)), error('No name for argument %u!', i); end
			do_output(fileid, prefix, name, res);
			name=			'';
			special.what=	'';
		end
	end
	
	if(fileid > 2), fclose(fileid); end										% Close the file
end


function res= do_structure(i, f, v, special)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Process a structure.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	if(length(find(size(v) > 1)) > 1)	% Only scalars and vectors allowed
		error('Only scalars and vectors of structures are allowed (argument %d).', i);
	end
	fields=	fieldnames(v);	% Get field names for table head
	v1=		struct2cell(v);	% We will process the structure in the do_cell()
	res2=	'';
	if(numel(fields) > 1), res2= sprintf('\n\t&\t\\mbox{%s}', fields{2:end}); end
	res=	sprintf('%%\n\t\t\\mbox{%s}%s\n\t\\\\\t\\hline%s', fields{1}, res2,...
				do_cell(i, f, transpose( reshape(v1, size(v1,1), numel(v))), special ));
end


function res= do_cell(i, f, v, special)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Process a cell array.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	res=	sprintf('%%\n\t\t');
	lenm=	size(v,1);	% Number of rows
	lenn=	size(v,2);	% Number of columns
	f=		eval(['{''' regexprep(f, '\s*&\s*', ''',''') '''}']);
	fill=	repmat({f{end}},[1 (lenn-length(f))]);
	f=		{f{:},fill{:}};
	nopoly=	~strcmp(special.what, 'poly');
	for m= 1:lenm
		leadingzeroes=	true;
		for n= 1:lenn
			if(ischar(v{m, n}) || (length(v{m, n}) <= 1))
				if(nopoly)													% Not a polynomial
					res=	[res do_format(f{n}, v{m, n})];
					if(n < lenn), 	res= sprintf('%s%%\n\t&\t', res);	end
				else														% Polynomial
					if(v{m, n} ~= 0)
						if(((v{m, n} > 0) || ~isreal(v{m, n}) ) && ~leadingzeroes)
							res=	sprintf('%s+', res);
						end
						if(n == lenn)							% Zero term
							res=	sprintf('%s%s', res, do_format(f{n}, v{m, n}));
						else
							if(v{m, n} == -1)
								res=	sprintf('%s\\ensuremath{-}', res);
							elseif(~isreal(v{m, n}) && (real(v{m, n}) ~= 0))
								res=	sprintf('%s(%s)', res, do_format(f{n}, v{m, n}));
							elseif(v{m, n} ~= 1)
								res=	sprintf('%s%s', res, do_format(f{n}, v{m, n}));
							end
							if(n < lenn-1)						% Second or larger term
								res=	sprintf('%s\\ensuremath{%s^{%u}}', ...
																	res, special.arg, lenn-n);
							else								% First term
								res=	sprintf('%s\\ensuremath{%s}', res, special.arg);
							end
						end
						leadingzeroes=	false;
					elseif((n == lenn) && leadingzeroes)		% Polynomial is zero
						res=	sprintf('%s%s', res, do_format(f{n}, 0));
					end
				end
			else
				error('Array inside cell array not allowed. (argument %d{%d,%d})', i, m, n);
			end
		end
		if(m < lenm), 	res= sprintf('%s%%\n\t\\\\\t', res);	end			% End of row
	end
	res=	sprintf('%s%%\n', res);
end


function res= do_format(f, v)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Convert an expression to a string.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	switch(class(v))
	case 'char'																% String
		v=		regexprep(v, '(?<!\\)([$&%#_{}~^])', '\\$1');				% Add escape.
		res=	sprintf('\\mbox{%s}', v);
	case {'logical', 'int8', 'uint8', 'int16', 'uint16', ...
	      'int32', 'uint32', 'int64', 'uint64', 'single', 'double'}			% Numbers
		if(isreal(v))														% Real number
			if(~isempty(regexp(f, '%\d+[Ss]', 'once')) && isfinite(v))		% Use exponent suffix.
				v0=		v;
				d=		str2double(regexprep(f, '.*%(\d+)[Ss].*', '$1'));
				if(v0 == 0),	pp= 0;
				else			pp=	floor(log10(abs(v0))./3);
				end
				v=		v0*10^(-3*pp);
				if(v == 0),		d= max(d - 1, 0);
				else			d= max(d - floor(log10(abs(v))) - 1, 0);
				end
				if(~isempty(regexp(f, '%\d+s', 'once')) ...			% We are doing %s, not %S.
						&& (abs(v0)>=1e-24) && (abs(v0)<1e27) ...	% We are within suffix range. 
						&& (pp ~= 0))								% We have a suffix (exp ~= 0).
					powers=	{'y' 'z' 'a' 'f' 'p' 'n' '\\\\textmu' ...
								'm' '' 'k' 'M' 'G' 'T' 'P' 'E' 'Z' 'Y'};
					f=		regexprep(f, '%\d+s', ...
								['%.' num2str(d) 'f\\\\mbox{~' char(powers(pp + 9)) '}']);
				else
					f=		regexprep(f, '%\d+[sS]', ['%.' num2str(d) 'f']);
					if(pp ~= 0),	f= [f 'e' num2str(pp*3)];	end	% No power of ten if zero.
				end
			elseif(strcmp(f, '%r') || strcmp(f, '%R'))						% Use fraction.
				[n, d]=	rat(v);
				if((d ~= 0) && (d ~= 1))
					if(strcmp(f, '%r') || (abs(n) < d))
						res=	sprintf('\\fraction{%d}{%d}', abs(n), d);
						if(n < 0),	res= ['\ensuremath{-}' res];	end
					else
						res=	sprintf('%d\\fraction{%d}{%d}', fix(n/d), mod(abs(n), d), d);
					end
					return;
				end
			end
			if(~isempty(regexp(f, '%\d*[sSrR]', 'once'))), f= regexprep(f, '%\d*[sSrR]', '%g');	end
			res=	strtrim(sprintf(f, v));									% Plain stuff
		else																% Complex number
			res=	[do_format(f, imag(v)) '\ensuremath{\:}\imsymb'];
			if(real(v) ~= 0)									% Real part
				if((imag(v) > 0) || isnan(imag(v))), res= [do_format(f, real(v)) '+' res];
				else								 res= [do_format(f, real(v)) res];
				end
			end
		end
	case 'sym'																% Symbolic
		res=	sprintf('\\ensuremath{%s}', latex(v));
	case 'embedded.fi'														% Fixed-point
		res=	do_format(f, v.data);
	case {'function_handle', 'inline'}										% Functions
		if(strcmp(class(v),'inline')),	res=	char(v);
		else							res=	regexprep(func2str(v), '^@\([^)]*\)\s*', '');
		end		
		if(exist('sym', 'file') == 2)		% The Symbolic Toolbox is available!
			res=	sprintf('\\ensuremath{%s}', latex(sym(res)));
		else								% No Symbolic Toolbox available...
			res=	sprintf('\\ensuremath{%s}', texlabel(res));
		end
	otherwise																% Other object
		res=	char(v);	% Most objects will use char() for a string representation?
	end
end


function do_output(fileid, name, suff, v)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Improve the typography and output a LaTeX command definition.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	v=	regexprep(v, '(\-?)Inf', '\\ensuremath{$1\\infty}');
	v=	regexprep(v, '(\-?)(\d+)', '\\ensuremath{$1}\\integer{$2}');
	v=	strrep(v, '\ensuremath{}', '');
	v=	regexprep(v, '\\integer{(\d+)}\.\\integer{(\d+)}', '\\float{$1}{$2}');
	v=	regexprep(v, '\\float({\d*}{\d*})[eE](\\ensuremath{-})?\+?\\integer{0*(\d+)}', ...
															'\\floatE$1{$2$3}');
	v=	regexprep(v, '\\integer({\d*})[eE](\\ensuremath{-})?\+?\\integer{0*(\d+)}', ...
															'\\integerE$1{$2$3}');
	v=	strrep(v, 'NaN', '{\NaN}');
	fprintf(fileid, '\\newcommand{\\%s%s}{%s}\n', name, suff, v);
end


function do_stat(fileid, name, f, v)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Generate statistics.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	f=		eval(['{''' regexprep(f, '\s*&\s*', ''',''') '''}']);
	fill=	repmat({f{end}},[1 (9-length(f))]);
	f=		{f{:},fill{:}};
	v=		reshape(v, 1, numel(v));
	vMin=	min(v);
	vMax=	max(v);
	if(vMax < vMin), vMax= -vMax; end	% This can happen with complex numbers
	do_output(fileid, name, 'N',      do_format(f{1}, length(v)));	% Number of elements
	do_output(fileid, name, 'Min',    do_format(f{2}, vMin));		% Minima
	do_output(fileid, name, 'Max',    do_format(f{3}, vMax));		% Maxima
	do_output(fileid, name, 'Range',  do_format(f{4}, vMax-vMin));	% Range
	do_output(fileid, name, 'Mean',   do_format(f{5}, mean(v)));	% Mean
	do_output(fileid, name, 'Median', do_format(f{6}, median(v)));	% Median
	do_output(fileid, name, 'Std',    do_format(f{7}, std(v)));		% Standard (sample) deviation
	do_output(fileid, name, 'Cov',    do_format(f{8}, cov(v)));		% Variance
	do_output(fileid, name, 'All', sprintf( ...
		'\\statAll{\\%sN}{\\%sMin}{\\%sMax}{\\%sRange}{\\%sMean}{\\%sMedian}{\\%sStd}{\\%sCov}', ...
			name, name, name, name, name, name, name, name));		% All together now!
end
