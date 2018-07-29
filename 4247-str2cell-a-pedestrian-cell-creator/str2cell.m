% c = str2cell(v)
% c = str2cell(v,delim[s])
%
%	creates a cell array <c> from input array <v>
%	seperated by delimiter[s] <del>
%
% v	: a string/vector of a ML supported data class
% delim	: array of delimiter[s]				[def: isspace]
%	  v-class	syntax
%	  ----------------------
%	  char		'xyz'
%	  other		[1 2 pi]
%
% note:
%	an input matrix (NxM) will be turned into a
%	1x(N*M) row vector WITHOUT warning!
%
% examples:
%	s='this is a ;;; test case; +-0 ;;;_;;; or; +;+ 1'; 
%	c=str2cell(s,' +-;0_')
%		'this'
%		'is'
%		'a'
%		'test'
%		'case'
%		'or'
%		'1'
%
%	d=[pi pi 1 2 pi 4 5 6 pi];
%	c=str2cell(d,[pi 5])
%		[1x2 double]	% contents: 1 2
%		[         4]
%		[         6]

% created:
%	us	13-Nov-2000
% modified:
%	us	20-Dec-2003		/ TMW
%	us	06-Jun-2005 20:05:27

%--------------------------------------------------------------------------------
function	c=str2cell(s,varargin)

	if	nargin < 1
		help str2cell
		return;
	end

% make sure we have a row vec
		s=s(:).';

% check input
	if	nargin < 2
	if	ischar(s)
		ix=~isspace(s);
	else
		ix=ones(size(s));
	end
	else
		ix=~ismember(s,varargin{1});
	if	~isempty(find(isnan(varargin{1})))
		ix=ix&~isnan(s);
	end
	end

% find indices of delim[s]
		dx=diff(ix);
		k=sort([findstr(dx,-1) findstr(dx,1)+1]);
	if	~isempty(k)
	if	ix(1) == 1
		k=[1 k];
	end
	if	ix(end) == 1
		k=[k length(ix)];
	end
	else
		k=1:length(s);
		k=sort([k k]);
	end
		k=reshape(k,2,[]).';

% create cell[s]
		nk=size(k,1);
		c=cell(nk,1);
	for	i=1:nk
		c{i}=s(k(i,1):k(i,2));
	end
		return;
