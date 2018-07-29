function [mlepars, output]= paxmle(pars, negloglike, varargin)

% USAGE: 
% [mlepars, output]= paxmle(pars, negloglike)
% [mlepars, output]= paxmle(pars, negloglike, lBounds)
% [mlepars, output]= paxmle(pars, negloglike, lBounds, uBounds)
% [mlepars, output]= paxmle(..., options)
% 
% Calculate the best parameter fit given the negative log-likelihood. 
% 
% The parameter(s) is/are estimated thru MLE, using Matlab optimization fminsearch (fmincon, 
%  if the Optimization Toolbox is available). 
% 
% NOTE: No confidence interval yet, I got to find the math for it first...
% 
% ARGUMENTS:
% - pars (non empty vector) The initial parameter, the starting value. 
% - negloglike is a function of the type [negL, negDL, negDDL]= negloglike(p), where
%   negL, negDL, and negDDL are the value, first derivate (Jacobian), and second derivate 
%   (Hessian) respectively for the (log-)likelihood function at p. If you don't want to
%   calculate the Jacobian and/or the Hessian, return NaN for these instead. They are only 
%   used when the Optimisation Toolbox is available. 
% - lBounds (default is -Inf), the lower bounds for mlepars.
% - uBounds (default is Inf), the upper bounds for mlepars.
% - options (string) Information ('info') or detailed information ('info2')
%   about execution. Generates a nice figure too!
% - mlepars is the maximum likelihood estimated parameter values, or NaNs if none was found. 
% - output (structure) is the 'output' structure of the optimization call with two additions:
%     .exitflag is the exitflag value returned by the optimization call. 
%     .call is the name of the called function, see its reference for the other fields.
% 
% EXAMPLE:
% [v, res]= paxmle([mean(x) std(x)], myfunhandle, 'info2');
% 
% Copyright (C) Peder Axensten <peder at axensten dot se>
% 
% HISTORY:
% Version 1.0, 2006-08-03.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	% Default values.
	options=	optimset( ...
					'Display', 		'off', ...
					'MaxIter', 		2000, ...
					'TolX', 		eps, ...
					'TolFun', 		0 ...
				);
	
	
	% Check the arguments
	argok=	all(all(isreal(pars))) && ~isempty(pars) && strcmp(class(negloglike), 'function_handle');
	pLen=	length(pars);							% Number of parameters.
	
	if((nargin > 2) && ischar(varargin{end}))		% Display execution information?
		dbg= 	true;
		switch(varargin{end})
			case 'info',	options= optimset(options, 'Display', 'final');
			case 'info2',	options= optimset(options, 'Display', 'iter');
			case '',		dbg=     false;
			otherwise,		argok=   false;
		end
		varargin=	{varargin{1:end-1}};
	else	dbg= false;
	end
	
	if(length(varargin) >= 1)						% Lower bounds?
		lBounds=	varargin{1};
		argok=		argok && all(all(isreal(lBounds))) && all(all(size(lBounds) == size(pars)));
	else
		lBounds=	repmat(-Inf, [1 pLen]);
	end
	if(length(varargin) >= 2)						% Upper bounds?
		uBounds=	varargin{2};
		argok=		argok && all(all(isreal(uBounds))) && all(all(size(uBounds) == size(pars)));
	else
		uBounds=	repmat( Inf, [1 pLen]);
	end
	if(~argok || (length(varargin) > 2))			% Argument error?
		error('Incorrect arguments, check ''help paxmle''.');
	end
	
	
	% Do we have the Jacobian ? The Hessian?. 
	[L, dL, ddL]=	negloglike(pars);
	if(~isnan(dL))
		options=	optimset(options, 'LargeScale', 'on', 'GradObj', 'on');
		if(~isnan(ddL))
			options=	optimset(options, 'Hessian', 'on');
		end
	end
	
	
	% Find parameters. 
	divzero=	warning('query', 'MATLAB:divideByZero');
	warning('off', 'MATLAB:divideByZero');
	if(exist('fmincon', 'file') == 2)	% Optimization Toolbox is available. 
		[mlepars,fval,exitflag,output]= fmincon(negloglike, pars, ...
						[], [], [], [], lBounds, uBounds, [], options);
		output.call=	'fmincon';
	else								% Standard Matlab. 
		[mlepars,fval,exitflag,output]= fminsearch(negloglike, pars, options);
		output.call=	'fminsearch';
	end
	warning(divzero.state, 'MATLAB:divideByZero');
	output.exitflag=	exitflag;
	
	
	% Diverged?
	if(exitflag <= 0),	mlepars= repmat(NaN, [1 pLen]);	end		% We did not find a solution...
	
	
	% Debug info.
	if(dbg)
		% Textual information. 
		value('ALGORITHM:', output.algorithm);
		value('Iterations:', 		output.iterations);
		value('Function calls:', 	output.funcCount);
		disp(' ');
		value('', '-loglike', '-Jacobian', 'parameter(s)');
		[l, dl]=	negloglike(pars);
		value('Initial value(s):', 	[l, sqrt(sum(dl.^2)), pars]);
		[l, dl]=	negloglike(mlepars);
		value('Best fit:',  		[l, sqrt(sum(dl.^2)), mlepars]);
		
		% Prepare for figure.
		st=		0.05;
		pmin=	max([lBounds; min([mlepars; pars; uBounds]) - 0.5 - st*3]);
		pmax=	min([uBounds; max([mlepars; pars; lBounds]) + 0.5 + st*3]);
		if(pLen == 1)		% Draw 2-d figure.
			mark=	{'MarkerFaceColor', 'r', 'MarkerSize', 8};
			xx=		linspace(pmin(1), pmax(1), 50);
			LL=		zeros(1, length(xx));
			for nx= 1:length(xx)
				LL(nx)=		negloglike(xx(nx));
			end
			plot(xx,      LL);
			hold on;
			plot(pars,    negloglike(pars),  	'^r', mark{:});
			plot(mlepars, negloglike(mlepars),	'vr', mark{:});
			xlabel('Parameter');	ylabel('negative log-likelihood');
		else				% Draw 3-d figure. 
			mark=	{'MarkerFaceColor', 'k', 'MarkerSize', 12};
			aa=		linspace(pmin(1), pmax(1), 50);
			bb=		linspace(pmin(2), pmax(2), 50);
			LL=		zeros(length(bb), length(aa));
			for na= 1:length(aa)
				for nb= 1:length(bb)
					LL(nb, na)=	negloglike([aa(na), bb(nb)]);
				end
			end
			[aa, bb]=	meshgrid(aa, bb);

			plot3(pars(1),    pars(2),    negloglike(pars),    '^k', mark{:});
			hold on
			plot3(mlepars(1), mlepars(2), negloglike(mlepars), 'vk', mark{:});
			meshz(aa, bb, LL);
			contour3(aa, bb, LL, 'LineSpec', 'k');
			shading interp;		colormap hsv;
			xlabel('Parameter 1');	ylabel('Parameter 2');	zlabel('negative log-likelihood');
		end
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
