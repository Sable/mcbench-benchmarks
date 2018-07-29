function latexcmd_example(varargin)

% Usage: latexcmd_example(outfilename)
%
% Run this command and then look at this file and the resulting LaTeX file 
% (latexcmd_example_out.tex) to better understand how latexcmd can be used.
% 
% If you find any errors, please let me know! (peder at axensten dot se) 
%
% Example: 
% latexcmd_example('testout.tex')
%
% Copyright (C) Peder Axensten (peder at axensten dot se), 2006.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
	
	outfile=	'latexcmd_example_out';		% Default file name
	if(nargin > 0)
		if((nargin == 1) && ischar(varargin{1}))
			% File name is given.
			outfile= varargin{1};
	
		% Run multiple times, for timing purposes. 
		elseif((nargin == 1) && isnumeric(varargin{1}))
			iterations=	varargin{1};
			outfile=	tempname();
			tic;
			for n= 1:iterations
				latexcmd_example(outfile);
				fprintf(1, 'Iteration %d (of %d)\r', n, iterations);
			end
			fprintf(1, 'Finished %d iterations in  %f seconds.\n', iterations, toc);
			delete(outfile);
		else
			error('Usage: latexcmd_example(outfilename)');
		end
	end
	
	latexcmd(outfile);
	outfile=	['>' outfile];
	
	
	
	
	% Symbolic Toolbox.
	% Exporting symbolic variables works in the same way as numeric variables. 
	if(exist('sym', 'file') == 2)
		% Create 3 symbolic variables.
		x=			sym('x');
		y=			sym('y');
		z=			sym('z');
		% Calculate the Hessian, a 3x3 symbolic array.
		symbolic=	jacobian(jacobian(x^4 + y^3*x + z^2*x^2));
		% Get a symbolic scalar, for later purposes. 
		symitem=	symbolic(1, 1);
	else
		symbolic=	'No symbolic toolbox...';
		symitem=	'No symb.';
	end
	latexcmd(outfile, symbolic);
	
	
	% Name an expression. 
		latexcmd(outfile, '\mypi', 3.1415+0.000092);
	
	
	% Check various container forms (array, cell array, character string, structure).
		% Zero sized (this is for testing purposes).
		stringzero=				'';
		arrayzero=				[];
		cellzero=				{};
		structzero.first=		[];
		latexcmd(outfile, stringzero, arrayzero, cellzero, structzero);
		
		% One item sized (this is for testing purposes).
		stringone=				'A';
		arrayone=				 1.1;
		cellone=				{1.1};
		structone.first=		1.1;		% Numeric.
		structone.second=		'a.b';		% String.
		structone.third=		symitem;	% Symbolic.
		latexcmd(outfile, stringone, arrayone, cellone, structone);
		
		% Three items sized.
		stringnorm=				'Normal sized string';
		arraynorm=				[1.1  1.2      1.3];
		cellnorm=				{1.1 '1.2' symitem};	% Numeric, string, and symbolic items.
		structnorm(1).first=	1.1;		% Numeric.
		structnorm(1).second=	1.2;		% Numeric.
		structnorm(1).third=	1.3;		% Numeric.
		structnorm(2).first=	2.1;		% Numeric.
		structnorm(2).second=	'b.b';		% String.
		structnorm(2).third=	symitem;	% Symbolic.
		latexcmd(outfile, stringnorm, arraynorm, cellnorm, structnorm);
	
	
	% Check different formats.
		% Create array of values. 
		nums=		    [-0, -9.8765e-113, -1.234e-7, -0.5-0.125i, -23.4, -1.234e7, -9.8765e113, -Inf];
		nums=			[nums(end:-1:1), NaN, 1+ NaN*i];
		nums=			[nums, +0,  9.8765e-113,  1.234e-7,  0.5+0.125i,  23.4,  1.234e7,  9.8765e113,  Inf];
		% Various output formats, look at the definition of '\numforms' to see what happens!
		numformsformat=	'%g & %3s & %3S & %r & %R & %12.1E & %12.2e & %d';
		numformsarr=	eval(['{''' regexprep(numformsformat, '\s*&\s*', ''',''') '''}']);
		numforms=		transpose([nums; nums; nums; nums; nums; nums; nums; nums; nums]);
	
		% First 'numformstr' is exported as a string, the second decides the numerical format of 'numforms'.
		latexcmd(outfile, '\numformstr', numformsarr, numformsformat, numforms, '%g');
	
	
	% Check "special" numbers. 
		% Complex
		numscomplex=	transpose([-1-i, -i, i, 1+i; ...
						 	-Inf-Inf*i, 1-Inf*i, 1+Inf*i, Inf+Inf*i; ...	% Matlab makes real part a NaN!??
						  	Inf+i, -Inf-i, NaN, ...
											  	NaN*i ...					% Matlab makes real part a NaN!??
						]);
	
		% Polynomial (actually a vector of six polynomials).
		polynomialA=	[ 	 0,  1, -1+i,  2, -2; ...
					 		-2,  0,  1-i, -1,  2; ...
					  		 2, -2,  0+i,  1, -1; ...
					 		-1,  2,   -2,  0,  1-i; ...
					  		 1, -1,    2, -2,  0; ...
					  		 0,  0,    0,  0,  0];
		polynomialB=	polynomialA;
		
		latexcmd(outfile, numscomplex, '%poly:\alpha', polynomialA, ...
					'%3S & %.2e & %.1f & %d & %R', '%poly:t', polynomialB);
	
	
	% Statistics AND using the prefix option. 
		arraydd=				[1.1, 1.2,     1.3; 2.1, 2.2, 2.3; 3.1,  3.2,  3.3];
		latexcmd(outfile, arraydd, '@prefix', '%stat', arraydd);
	
end
