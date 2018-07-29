%--------------------------------------------------------------------------------
% RES = fpat(TMPL,OBJ,'OPT',...,'OPT',...)
%	A fuzzy pattern detector...
%       the only pattern detector you will ever need!
%
% TMPL	: template to search for
%	  - a string		vector/matrix
%	  - a numeric		vector/matrix of any ML data type
% OBJ	: object to be searched
%	  - a cell array of	strings
%	  - a matrix of		strings
%	  - a cell array of	numerics of any ML data type
%	  - a matrix of		numerics of any ML data type
% OPT	: options
% -exact: only return results with   .isexact == true
% -match: only return results with   .ismatch == true
% -nolap: only return results with   .isolap  == false
%		note: these flags are mutually exclusive
%   -mrg: merge .rowbeg/.rowend into .row     =  [.rowbeg;.rowend]
%	  merge .colbeg/.colend into .col     =  [.colbeg;.colend]
%    -ix: change index to any valid ML 'data type'.
%		eg: r = fpat(tmpl,obj,'-ix','uint8');
%     -s: suppress collection of matching tokens
%		note: may help in memory-intensive scans of large OBJs
%
% RES	: structure returning fields for
%	  - search parameters/declarations/template
%	  - summary of matching patterns
%           .isexact: logical 1 = EXACT pattern match with
%				  no intervening characters/numbers
%				  no line/cell wrapping
%				  overlaps are possible
%		      logical 0 = inexact (fuzzy) match
%	    .ismatch: logical 1 = exact match with no intervening elements
%		      logical 0 = inexact (fuzzy) match with intervening elements
%	    .iswrap:  logical 1 = match across lines/cells
%		      logical 0 = match on a single line/cell
%	    .isolap:  logical 1 = this match overlaps previous one
%		      logical 0 = this match does not overlap previous one
%	    .patlen:  length  of match
%	  - row/col   indices of matches
%	  - collected matching patterns
%
% NOTE ON SPACES AND MATCHING STRATEGY:
% Pattern matching is performed by first removing all characters/numbers not in
% the template, then comparing the reminder exactly with the template.
% Thus spaces are significant when TMPL includes at least one space; otherwise,
% they are not.
% For instance, if TMPL = 'B RE', an exact match will be returned from
% OBJ_1 = 'xB xRxE', but NOT from OBJ_2 = 'xB xRx E'.
% In both OBJs, 'x' is removed because it is not in TMPL, leaving OBJ_1 = 'B RE'
% and OBJ_2 = 'B R E'.
% But if TMPL = 'BRE' (with no space), spaces are discarded in the search,
% leaving OBJ_1 = 'BRE' and OBJ_2 = 'BRE', both of which return exact matches.
%
% USAGE EXAMPLES:
%
%	x = {	'a good BRETT'
%		'a bad BrrrRETt'
%		'a wide B R E T T'
%		'a shaky B RET  T'
%		'a noisy bbB rRxy EeTTtTt'
%		'a wrapped BR'
%		'ET      '
%		'T'};
%
%	tmpl =		'BRETT'			'B RE'		  'B R E'
%	-----------------------------------------------------------------
%	res=fpat(tmpl,x)
%	OUTPUT:
%	isexact: 	[1 0 0 0 0]		  1		   [1 0]
%	ismatch:	[1 0 0 0 0]		  1		   [1 0]
%	iswrap: 	[0 0 0 0 1]		  0		   [0 0]
%	isolap: 	[0 0 0 0 0]		  0		   [0 0]
%	patlen: 	[5 9 8 11 11]		  4		   [5 8]
%	rowbeg: 	[1 3 4 5 6]		  4		   [3 5]
%	rowend: 	[1 3 4 5 8]		  4		   [3 5]
%	colbeg: 	[8 8 9 11 11]		  9		   [8 11]
%	colend: 	[12 16 16 21 1]		 12		   [12 18]
%
%	x = [1 2 3 4; 3 4 pi 3; 4 3 pi 4; 3 3 pi 4];
%
%	tmpl =		[3 4]			 [3 4 3]	   [3 4 5]
%	------------------------------------------------------------------
%	res=fpat(tmpl,x)
%	OUTPUT:
%	isexact:	[1 1 0 0 0]		 [0 0 0 0]
%	ismatch:	[1 1 1 0 0]		 [1 0 1 0]
%	iswrap:		[0 0 1 0 0]		 [1 0 1 1]
%	isolap: 	[0 0 0 0 0]		 [0 1 1 1]
%	patlen:		[2 2 2 3 3]		 [3 4 3 4]
%	rowbeg:		[1 2 2 3 4]		 [1 2 2 3]
%	rowend:		[1 2 3 3 4]		 [2 2 3 4]
%	colbeg:		[3 1 4 2 2]		 [3 1 4 2]
%	colend:		[4 2 1 4 4]		 [1 4 2 1]

% created:
%	us  urs schwarz		30-Sep-2004	us@neurol.unizh.ch
%	bs  brett shoelson	30-Sep-2004	shoelson@helix.nih.gov
%	sa  steve amphlett	30-Sep-2004	steve.amphlett@ricardo.com
% modified:
%	us			25-Oct-2004 20:49:37

function	p=fpat(varargin)
%--------------------------------------------------------------------------------
% initialize parameter structure
		p=ini_par(varargin{:});
%--------------------------------------------------------------------------------
% arg check
	if	nargin < 2
		help(mfilename);
		return;
	else
		tmpl=varargin{1};
		obj=varargin{2};
	end

%--------------------------------------------------------------------------------
% search for suitable <nan>
		p.runtime=clock;		% start timing
		[tmpl,tnan,ct]=find_nan(tmpl);
		co=class(obj);
		osiz=size(obj);
%--------------------------------------------------------------------------------
% create search string
	switch	co
	case	'cell'
		obj=obj(:);
		l=cellfun('length',obj).';
		ls=mk_int(p,[0 cumsum(l)]);	% R13.x!
%% note
%% in R14 <mk_int> could be replaced nicely by this construct:
%%		ls=p.par.iclass([0 cumsum(l)]);	% R14
		s=tnan(ones(1,ls(end)));
	for	i=1:length(l)
		ix=[ls(i)+1:ls(i+1)];
		s(ix)=obj{i};
	end
	otherwise
		l=repmat(osiz(2),1,osiz(1));
		ls=mk_int(p,[0 cumsum(l)]);
		s=reshape(obj.',1,[]);
	end
		clear l obj;			% save memory
		cs=class(s);
%--------------------------------------------------------------------------------
% find fuzzy pattern
	if	~isempty(tnan)
		sp=tnan(ones(1,ls(end)));
	for	i=tmpl
		sp(s==i)=i;
	end
		nix=sp==tnan;
		sp(nix)='';
	else
		nix=zeros(1,length(s));
		sp=s;
	end
		ip=mk_int(p,strfind(sp,tmpl));
	if	~isempty(ip)
		io=mk_int(p,find(~nix));
		pb=io(ip);
		pe=io(ip+length(tmpl)-1);
		[dum,rb]=histc(double(pb)-.5,ls);
		rb=mk_int(p,rb);
		[dum,re]=histc(double(pe)-.5,ls);
		clear dum;
		re=mk_int(p,re);
		p.runtime=etime(clock,p.runtime);% end timing
%--------------------------------------------------------------------------------
% create output structure
		p.par.template=tmpl;
		p.par.tclass=ct;
		p.par.tlen=length(tmpl);
		p.par.tnan=tnan;
		p.par.oclass=co;
		p.par.osize=osiz;
		p.par.sclass=cs;
		p.par.ssize=size(s);
		p.isexact=[];			% keep this logic!
		p.ismatch=[];
		p.iswrap=rb~=re;
		p.isolap=[false pb(2:end)<=pe(1:end-1)];
		p.patlen=pe-pb+1;
		p.ismatch=p.patlen==length(tmpl);
		p.isexact=logical(p.ismatch.*~p.iswrap);
% user wants a subset
		ix=[];
	if	p.par.exactflg
		ix=p.isexact;
		p.par.matchflg=false;		% keep this logic!
		p.par.nolapflg=false;
		p.mode='ISEXACT patterns only';
	elseif	p.par.matchflg
		ix=p.ismatch;
		p.par.nolapflg=false;
		p.mode='ISMATCH patterns only';
	elseif	p.par.nolapflg
		ix=~p.isolap;
		p.mode='NOT OVERLAPPING patterns only';
	end
	if	~isempty(ix)
		p.isexact=p.isexact(ix);
		p.ismatch=p.ismatch(ix);
		p.iswrap=p.iswrap(ix);
		p.isolap=p.isolap(ix);
		p.patlen=p.patlen(ix);
		rb=rb(ix);
		re=re(ix);
		pb=pb(ix);
		pe=pe(ix);
	end
		p.npat=length(rb);
% user wants to merge row/col vecs
	if	p.par.mrgflg
		p.row=[rb;re];
		p.col=[pb-ls(rb);pe-ls(re)];
	else
		p.rowbeg=rb;
		p.rowend=re;
		p.colbeg=pb-ls(rb);
		p.colend=pe-ls(re);
	end
% user wants matching tokens
		p.matches=[];
	if	~p.par.sflg
	for	i=1:p.npat
		p.matches{i,1}=s(pb(i):pe(i));
	end
	end
	else	% pattern not found
		p.runtime=etime(clock,p.runtime);
	end	% pattern found?
		return;
%--------------------------------------------------------------------------------
function	p=ini_par(varargin)

% declarations/options
		p=[];
		p.magic='FPAT';
		p.ver='25-Oct-2004 20:49:37';
		p.time=datestr(clock);
		p.runtime=0;
		p.par.mos=version;		% ML version
		p.par.rel=sscanf(version('-release'),'%d');
		p.par.exactflg=false;		% opt: only use  .isexact
		p.par.matchflg=false;		% opt: only use  .ismatch
		p.par.nolapflg=false;		% opt: only use ~.isoap
		p.par.mrgflg=false;		% opt: merge inx
		p.par.ixflg=false;		% opt: change def index type
		p.par.sflg=false;		% opt: supress token retrieval
		p.par.iclass=@double;		% def index type cast
	if	p.par.rel >= 14
		p.par.iclass=@double;		% speed
		p.par.iclass=@uint32;		% size
	end
		p.mode='ALL patterns';
		p.npat=0;

% option parser
	for	i=3:nargin
	switch	varargin{i}
	case	'-exact'
		p.par.exactflg=true;
	case	'-match'
		p.par.matchflg=true;
	case	'-nolap'
		p.par.nolapflg=true;
	case	'-mrg'
		p.par.mrgflg=true;
	case	'-s'
		p.par.sflg=true;
	case	'-ix'
		t=varargin{i+1};
	if	p.par.rel >= 14
		p.par.ixflg=true;
		p.par.iclass=str2func(t);
	else
		txt=sprintf('fpat> R%d: cannot typecast index vectors to <%s>',p.par.rel,t);
		txt=str2mat(txt,sprintf('fpat> using default <double>'));
		disp(txt)
	end
	end
	end
		return;
%--------------------------------------------------------------------------------
function	[tmpl,tnan,ct]=find_nan(tmpl)

% we must search for a UNIQUE nan-marker!
% we do not use <nan>s, they are slow

		dtyp={'single','double'};	% double types
		tnan=[];
		tmpl=reshape(tmpl.',1,[]);
	if	islogical(tmpl)			% type logical
		tmpl=uint8(tmpl);
	end
		ct=class(tmpl);
% ... hopefully statistics will beat the odds!
	if	isempty(find(strcmp(ct,dtyp)))	% type ~double
		umax=max(double(tmpl))+1;
		tnan=umax;
	for	i=0:umax
	if	isempty(find(tmpl==i))
		tnan=i;
		break;
	end
	end
% ...check for data type overflow!
	if	tnan == umax && feval(ct,tnan) ~= umax
		tnan=[];
	end
	else					% type double
		tnan=unique(tmpl);		% well
		tnan=tnan(tnan==tnan & ~isinf(tnan));
	if	~isempty(tnan)
	if	length(tnan) > 1
		tnan=mean(tnan(1:2));
	else
		tnan=(tnan==0)+.5*tnan;		% take care of zeros
	end
	end
	end
	if	~isempty(tnan)
		tnan=feval(ct,tnan);		% R13.x!
	end
		return;
%--------------------------------------------------------------------------------
function	b=mk_int(p,b)

% note
% this function is necessary due to fnc-handle incompatibility
% between R13.x / R14
% once everybody has switched to R14, we'll get rid of it

	if	p.par.rel == 14
		b=p.par.iclass(b);
	end
		return;
%--------------------------------------------------------------------------------
