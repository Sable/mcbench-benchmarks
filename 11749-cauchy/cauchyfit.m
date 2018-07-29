function [mlepars, output]= cauchyfit(varargin)

% USAGE:
% [mlepars, res]= cauchyfit(x)           Fit parameters to data x. 
% [mlepars, res]= cauchyfit(x, xpars)    Fit parameters to data x, with one known parameter. 
% [mlepars, res]= cauchyfit(n, npars)    Debugging: generate a n-size sample and fit it...
% [mlepars, res]= cauchyfit(..., i)      Info about execution.
% 
% Parameter estimates (one or both parameters) for Cauchy distributed data. 
% 
% Parameters are estimated thru MLE, using Matlab optimization fminsearch (fmincon, 
%  if the Optimization Toolbox is available). 
% 
% NOTE: No confidence interval yet, I got to find the math for it first...
% 
% ARGUMENTS:
% - x (vector of length 2 or more) The data to fit.
% - xpars: [a NaN], [NaN b], or [NaN NaN] (b>0) NaN-parameters are calculated, others are given.
% - n (scalar) Generate a n-sized random sample and fit. 
% - npars, [a b] (b>0) The parameters to use for the random generation.
% - i (string) Information ('info') or detailed information ('info2')
%   about execution. Generates a nice figure too!
% - mlepars, the mle parameter estimation. 
% - res (structure) is the 'output' structure of the optimization call with two additions:
%   .exitflag is the exitflag value returned by the optimization call. 
%   .call is the name of the called function, see its reference for the other fields.
% 
% EXAMPLE:
% x=           cauchyrnd(1, 0.3, [1 100]);
% params1=     cauchyfit(x, [1 NaN], 'info2');	% Fits b, given that a equals 1.
% params2=     cauchyfit(x, 'info2');           % Fits a and b. 
% 
% SEE ALSO:    cauchycdf, cauchyinv, cauchypdf, cauchyrnd, cauchystat.
% 
% Copyright (C) Peder Axensten <peder at axensten dot se>
% 
% HISTORY:
% Version 1.1, 2006-07-26.
% - Added cauchyfit to the cauchy package. 
% Version 1.2, 2006-08-06:
% - Can now estimate one parameter when the other is given. 
% - The arrangement of arguments now follows the ways of Statistics Toolbox. 
% - Put the actual mle in a separate file. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	% Check the arguments
	argok=		true;
	dbg=		0;			% No execution information displayed. 
	dbgstr=		'';

	if((nargin > 1) && ischar(varargin{end}))
		% Display execution information. 
		switch(varargin{end})
			case 'info',	dbg= 	1;
			case 'info2',	dbg= 	2;
			otherwise,		argok=	false;
		end
		dbgstr=		varargin{end};
		varargin=	{varargin{1:end-1}};
	end

	if((length(varargin) == 2) && all(cellfun('isreal', varargin)) && ...
		~isempty(varargin{1}) && (length(varargin{2}) == 2) ...
	)	
		tpars=		varargin{2};
		if(~any(isnan(varargin{2})) && (length(varargin{1}) == 1))
			% All parameters given: generate random numbers to fit. 
			x=			cauchyrnd(tpars(1), tpars(2), [1 varargin{1}]);
		elseif(any(isnan(varargin{2})) && (length(varargin{1}) >= 2))
			x=			varargin{1};
		else
			argok=		false;
		end
	elseif((length(varargin) == 1) && all(all(isreal(varargin{1}))))
		% This is a "real" run. 
		tpars=		[NaN, NaN];
		x=			varargin{1};
	else
		argok=		false;
	end

	if(~argok)
		error('Incorrect arguments, check ''help cauchyfit''.');
	end


	% Initial parameter values and stuff. 
	ipars=				[	median(x), ...					% Initial a.
							max([std(x)/10 0.2]) ...		% initial b. 
						];
	lBounds=			[-Inf, 1e-20];
	n=					length(x);
	negloglikeshort=	@(pp)negloglike(pp(1), pp(2), x, n, 3);
	if(isnan(tpars(1)) && ~isnan(tpars(2)))
		ipars=				ipars(1);
		lBounds=			lBounds(1);
		negloglikeshort=	@(a)negloglike(a, tpars(2), x, n, 1);
	elseif(~isnan(tpars(1)) && isnan(tpars(2)))
		ipars=				ipars(2);
		lBounds=			lBounds(2);
		negloglikeshort=	@(b)negloglike(tpars(1), b(1), x, n, 2);
	end
	
	
	
	% Info on the data.
	if(dbg)
		value(' ', 'size', 'mean', 'median', 'std');
		value('Data:', numel(x), mean(x), median(x), std(x));
		disp(' ');
	end


	% Find parameters. 
	[mlepars, output]=	paxmle(ipars, negloglikeshort, lBounds, dbgstr);
	
	
	% Result info.
	if(dbg)
		if(isnan(tpars(1)) && ~isnan(tpars(2))),	[l, dl]= negloglikeshort(tpars(2));
		else										[l, dl]= negloglikeshort(tpars);
		end
		value('True params:',    [l, sqrt(sum(dl.^2)), tpars]);
		disp(' ');

		% Add to figure.
		legend('Initial point', 'Best fit', 'Location', 'ne');
		hold off;
	end
end


function value(gs, varargin)
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% For debugging purposes. 
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	fprintf(1, '\n%-20s', gs);
	for i= 1:length(varargin)
		if(ischar(varargin{i})),	fprintf(1, '%15s',   varargin{i});	
		else						fprintf(1, '%15.6f', varargin{i});
		end
	end
end


function [L, dL, ddL]= negloglike(a, b, x, n, whatab)
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Calculate the log-likelihood and, if need be, the derivates and second derivates. 
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	k1=		(x-a)/b;
	kL=		1 + k1.*k1;
	L=		n*log(pi*b) + sum(log(kL));	% The log-likelihood
	if(nargout >= 2)
		k2=		1./kL;
		k3=		k1.*k2;
		if(whatab == 1)			% Only fitting a.
			dL=		-2*sum(k3)/b;
			if(nargout >= 3),		ddL= 2*sum(k2)/(b*b);					end
		elseif(whatab == 2)		% Only fitting b.
			k4=		k1.*k3;
			dL=		(n-2*sum(k4))/b;
			if(nargout >= 3)		ddL= (-n+sum(k4.*(6-4*k4)))/(b*b);		end
		else					% Fitting a and b.
			k4=		k1.*k3;
			dL=		[-2*sum(k3), n-2*sum(k4)]/b;
			if(nargout >= 3)
				k5=		4*sum(k3.*(1-k4));
				ddL=	[2*sum(k2), k5; k5, -n+sum(k4.*(6-4*k4))]/(b*b);
			end
		end
	end
end
