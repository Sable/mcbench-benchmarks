%STRPAT		EXACT pattern search and replacement
%
%		STRPAT searches for EXACTLY matching patterns
%		in a character or numeric string and replaces
%		the occurrences with another pattern.
%
%		see also findstr, strfind, strrep, regexp, regexprep
%
%SYNTAX
%-------------------------------------------------------------------------------
%		 S       = STRPAT(VEC,PAT)
%				to find indices of PAT in VEC
%
%		[NVEC,S] = STRPAT(VEC,PAT,REP)
%				to replace PAT with REP
%
%INPUT
%-------------------------------------------------------------------------------
% VEC	:	a STRING or NUMERIC array
% PAT	:	a pattern of the same type as VEC including NaNs
% REP	:	a pattern of the same type as VEC
%
% OUTPUT
%-------------------------------------------------------------------------------
% NVEC	:	VEC with PATs replaced by REPs
% S	:	output struc with (selected) fields
%		  .n:	nr of occurrences of PAT
%		.iob:	start     indices of PAT
%		.ioe:	end       indices of PAT
%		.irb:	start     indices of REP
%		.ire:	end       indices of REP
%
%
% EXAMPLES
%-------------------------------------------------------------------------------
%		strrep('aa_a_aaa_aa','a','XXX')		% <- STRREP
% %			XXXXXX_XXX_XXXXXXXXX_XXXXXX
%		strpat('aa_a_aaa_aa','a','XXX')		% <- STRPAT
% %			aa_XXX_aaa_aa
%		strpat('aa_a_aaa_aa','aa','X') 
% %			X_a_aaa_X
%		strpat('aa_a_aaa_aa','a','XXX')
% %			aa_XXX_aaa_aa
%		strpat([1:3,pi,5:7],pi,nan)
% %			1 2 3 NaN 5 6 7
%		strpat(pi*(1:6),pi*(4:5),[])
% %			3.1416 6.2832 9.4248 18.85
%		strpat(pi*(1:6),pi*(4:5),[nan inf -inf nan])
% %			3.1416 6.2832 9.4248 NaN Inf -Inf NaN 18.85
%		strpat(pi*(1:6),pi*(4:5),1:3)
% %			3.1416 6.2832 9.4248 1 2 3 18.85
%		strpat([-10,nan,1,-10,nan,nan,1,nan,1,-10],[nan,1],inf)
% %			-10 Inf -10 NaN Inf Inf -10

% created:
%	us	20-Mar-2002
% modified:
%	us	21-Mar-2002		/ CSSM
%	us	15-Feb-2003		/ CSSM (R13)
%	us	05-Jul-2006		/ FEX  (R14.SP3)
%	us	22-Apr-2010 09:57:37	/ FEX  (R2010a)
%
% localid:	us@USZ|ws-nos-36362|x86|Windows XP|7.10.0.499.R2010a

%--------------------------------------------------------------------------------
function	[nvec,sout]=strpat(str,pat,npat)

	if	nargin < 2
		help strpat;
		return;
	end

		snan='';
		hasnan=0;

	if	isnumeric(pat)
		snan=cast(nan,class(pat));
		onan=snan;
		opat=pat;

		in=isnan(pat);
	if	any(in)
		hasnan=1;
		snan=cast(sum(rand(1,5)),class(pat));
	while	any(pat==snan)				||...
		any(str==snan)
		hasnan=hasnan+1;
		snan=cast(sum(rand(1,5)),class(pat));
	end
		pat(in)=snan;
		str(isnan(str))=snan;
	end
	end

		sout.pat=pat;
		sout.npat=[];
		sout.hasnan=hasnan;
		sout.snan=snan;
		sout.n=0;
		sout.iob=[];
		sout.ioe=[];
		sout.irb=[];
		sout.ire=[];

		[nr,nc]=size(str);
	if	nr > 1		&&...
		nc > 1
		sout.dim=size(str);
		disp('strpat> input must be a vector');
	if	nargout
		nvec=sout;
	end
		return;
	end
		str=str(:)';
		pat=pat(:)';
		nvec=str;
		sout.iob=[];
		sout.ioe=[];
		z=strfind(str,pat);
	if	~isempty(z)
		zd=(diff(z)-1)~=0;
		ld=[1 zd] & [zd 1];
	if	any(ld)
		sout.iob=z(ld);
		sout.ioe=sout.iob+numel(pat)-1;
		[sout.iob,sout.iob,sout.ioe]=STRPAT_prune(sout.iob,sout.ioe,false);
		sout.n=numel(sout.iob);
	end
	end

	if	sout.hasnan
		sout.pat=opat;
		sout.snan=onan;
	end

	if	~sout.n
	if	sout.hasnan
		nvec(nvec==snan)=onan;
	end
		disp('strpat> EXACT pattern not found');
		return;
	end

	switch	nargin
	case	2
		nvec=sout;
		return;
	otherwise
		sout.npat=npat;
		[nvec,sout]=STRPAT_repstr(str,pat,npat,sout);

	if	sout.hasnan
		nvec(nvec==snan)=onan;
	end
	end

end
%--------------------------------------------------------------------------------
function	[nvec,sout]=STRPAT_repstr(str,pat,npat,sout)

% ENGINE	01-Dec-2005
% -------------------------
		pp=~STRPAT_fmep(str,sout.iob,sout.ioe);
	if	~numel(npat)
	if	any(pp)
		nvec=str(pp);
	else
		nvec=[];
	end
	else
		dlen=numel(npat)-numel(pat);
		nlen=numel(str)+numel(sout.iob)*(numel(npat)-numel(pat));
		nvec=cast(zeros(1,nlen),class(str));
		sout.irb=sout.iob+dlen*(0:sout.n-1);
		sout.ire=sout.irb+numel(npat)-1;
		gg=STRPAT_fmep(nvec,sout.irb,sout.ire);
		nvec(~gg)=str(pp);
		nvec(gg)=STRPAT_repmat(npat,sout.n);
	end
end
%--------------------------------------------------------------------------------
%--------------------------------------------------------------------------------
% UTILITIES
% 	- FMEP		fast MEP
%				generates logical epochs based on indices
%				ixbeg(1:end):ixend(1:end)
%	- FREPMAT	fast REPMAT
%--------------------------------------------------------------------------------
%--------------------------------------------------------------------------------

% created:
%	us	02-Oct-2002		/	MEP
% modified:
%	us	03-Oct-2002		/	MEP	FEX
%	us	05-Jul-2006		/	FMEP	strpat

%--------------------------------------------------------------------------------
function	vix=STRPAT_fmep(v,ixb,ixe)

% prune input ...
		ixs=STRPAT_prune(ixb,ixe,true);

% ... and create logical array
		vix=STRPAT_mepoch(v,ixs);
end
%--------------------------------------------------------------------------------
% prune input list to remove adjacent blocks
function	[ixs,ixb,ixe]=STRPAT_prune(ixb,ixe,oflg)

% + overlap
	if	oflg
		ixs=ixb(2:end)-1>ixe(1:end-1);
		ixs=[ixb([true,ixs]);ixe([ixs,true])];
		ixs=ixs(:).';

% - overlap
	else
		rx=[false,ixb(2:end)<=ixe(1:end-1)];
	if	any(rx)
		rx=find(rx);
		rx=[rx-1,rx];
		ixb(rx)=[];
		ixe(rx)=[];
	end
		ixs=[ixb;ixe];
		ixs=ixs(:).';
	end
end
%--------------------------------------------------------------------------------
function	vix=STRPAT_mepoch(v,ixs)

		vlen=numel(v);
		tix=zeros(1,vlen+1);
		tix(ixs(2:2:end)+1)=-1;
		tix(ixs(1:2:end-1))=1;
		vix=cumsum(tix);
		vix=vix~=0;
		vix(vlen+1:end)=[];
end
%--------------------------------------------------------------------------------
% fast REPMAT
function	r=STRPAT_repmat(r,nrep)

		ix=(1:numel(r)).';
		r=r(:,ix(:,ones(1,nrep)));
end
%--------------------------------------------------------------------------------