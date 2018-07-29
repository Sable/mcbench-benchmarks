function R= allstats(A,varargin)
%R= ALLSTATS(A) returns a structure R with several statistics of vector A.
%	Groups within the data can be defined in optional vector G using a 
%	numeric value for each group: R= ALLSTATS(A,G), see examples below. 
%	In case a groups vector is provided all the statistics will be
%	calculated independently for each group. Each statistics is returned 
%	as a field of structure R. Requires Statistics toolbox.
% 
% The stats calculated are:
% R.min= minimum 
% R.max= maximum 
% R.mean= mean
% R.std= standard deviation
% R.mode= mode (of freq. distribution produced by HIST)
% R.q2p5= 2.5 percentile
% R.q5=   5 percentile
% R.q25=	25 percentile
% R.q50=	50 percentile (median)
% R.q75=	75 percentile
% R.q95= 95 percentile
% R.q97p5= 97.5 percentile
% R.kurt= Kurtosis
% R.skew= Skewness
%
% Example without groups
%  x= rand(10,1);
%  R= allstats(x)
% 
% Example with 2 groups (coded as 1 and 2 in vector G)
%  G= [1;1;1;1;1;2;2;2;2;2];
%  R= allstats(x,G)

A= shiftdim(A);

% Some error checking
if ~isnumeric(A) error('First argument must be numeric'); end
if ~isempty(varargin)
	factors= shiftdim(varargin{1});
	if ~isnumeric(factors) error('Second argument must be numeric'); end
	if length(A) ~= length(factors)
		error('Length of first and second arguments must be the same'); 
	end
end

% We have groups
if ~isempty(varargin)

	% Extract unique values for groups
	fval= unique(factors);
	s= length(fval);

	% Create the structure
	R= struct('min',zeros(s,1),'max',zeros(s,1),'mean',zeros(s,1),...
		'std',zeros(s,1),'q2p5',zeros(s,1),'q5',zeros(s,1),'q25',zeros(s,1),'q50',zeros(s,1),...
		'q75',zeros(s,1),'q95',zeros(s,1),'q97p5',zeros(s,1),'kurt',zeros(s,1),...
		'skew',zeros(s,1));

	% Do calculations for each value of the groups
	for k= 1:s
		rows= find(factors == fval(k)); % Elements of group 'k'
		R(k).min=	nanmin(A(rows,:));
		R(k).max=	nanmax(A(rows,:));
		R(k).mean=	nanmean(A(rows,:));
		R(k).std=	nanstd(A(rows,:));
		[f,n]= hist(A(rows,:),30);
		R(k).mode=  n(find(f==max(f)));
		R(k).q2p5=	prctile(A(rows,:),2.5);
		R(k).q5=		prctile(A(rows,:),5);
		R(k).q25=	prctile(A(rows,:),25);
		R(k).q50=	prctile(A(rows,:),50);
		R(k).q75=	prctile(A(rows,:),75);
		R(k).q95=	prctile(A(rows,:),95);
		R(k).q97p5=	prctile(A(rows,:),97.5);
		R(k).kurt=	kurtosis(A(rows,:));
		R(k).skew=	skewness(A(rows,:));
	end
else % No groups
	R.min=	nanmin(A);
	R.max=	nanmax(A);
	R.mean=	nanmean(A);
	R.std=	nanstd(A);
	[f,n]= hist(A,30);
	R.mode=  n(find(f==max(f)));
	R.q2p5=	prctile(A,2.5);
	R.q5=		prctile(A,5);
	R.q25=	prctile(A,25);
	R.q50=	prctile(A,50);
	R.q75=	prctile(A,75);
	R.q95=	prctile(A,95);
	R.q97p5=	prctile(A,97.5);
	R.kurt=	kurtosis(A);
	R.skew=	skewness(A);
end
