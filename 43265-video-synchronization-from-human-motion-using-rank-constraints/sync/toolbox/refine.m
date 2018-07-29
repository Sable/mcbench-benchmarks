function [a_opt,dt_opt] = refine(params,ref,tgt,varargin)
% function [anew,dtnew] = refine(params,ref,tgt,{cons,projmodel})
%
% Optimize initial estimates (from Hough accumulator) using non-linear
% minimization.
% 
% For a variable alpha: params = [dt0,alpha0].
% For a fixed alpha: params = [dt0] and cons = [alpha].
	
% read in variable arguments
cons	= [];
	if (length(varargin)>0), cons = varargin{1}; end
projmodel	= 'affine';
	if (length(varargin)>1), projmodel = varargin{2}; end
	
% parameters+constraints must equal 2
if (size(params,2)+size(cons,2) ~= 2)
	error('Incorrect number of parameters/constraints');
end

% extract alpha and dt from params/cons
dt = params(:,1);
if isempty(cons),	a = params(:,2);
else,							a = cons(:,1);
end

% perform non-linear optimization of initial estimates using sub-frame cost
% function
cmax = inf;
for hyp	= 1:length(a)
	fprintf('  (a=%0.3f,dt=%0.3f) -> ',a(hyp),dt(hyp));
	if isempty(cons)
		[pmin,c]	=	fminsearch(@subframecost,[dt(hyp),a(hyp)],[],ref,tgt,[],projmodel);
		dtnew	= pmin(1);	
		anew	= pmin(2);
	else
		[pmin,c]	=	fminsearch(@subframecost,[dt(hyp)],[],ref,tgt,[a(hyp)],projmodel);
		dtnew	= pmin(1);	
		anew	= a(hyp);
	end
	fprintf('(a=%0.3f,dt=%0.3f)\n',anew,dtnew);
	
	if (c < cmax)
		cmax		= c;
		dt_opt	= dtnew;
		a_opt		= anew;
	end
end

