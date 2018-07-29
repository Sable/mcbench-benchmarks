function	vix=mep(v,varargin)

% vix = mep(v,ixb,ixe)
% vix = mep(v,[ixb;ixe])
%		to create epochs
%
%	returns in VIX a <logical> array with epochs set to
%		true:	ixb(1)->ixe(1) ... ixb(N)->ixe(N)
%		false:	otherwise
%	correctly handles epoch overlaps/inclusions/reversals
%
%      v:	vector (to size VIX, is not changed)
%    ixb:	list of indices BEGIN epoch
%    ixe:	list of indices END   epoch
%
%%		examples
%		z=zeros(1,10);
%		vix=mep(z(1,:),[1 5],[3 10]);
%		z(1,vix)=1
%%			1 1 1 0 1 1 1 1 1 1
%		z=zeros(1,10);
%		vix=mep(z(1,:),[2 3 2 6 9],[2 3 4 7 10]);
%		z(1,vix)=1
%%			0 1 1 1 0 1 1 0 1 1
%		z='----------';
%		vix=mep(z,[[1 3 6];[4 4 8]]);
%		z(vix)='+'
%%			++++-+++-- 

% uncomment line marked <TEST> to test the output

% created:
%	us	02-Oct-2002
%		based upon an idea developed for
%		a poster at CSSM by Alex Vorwerk
%		<indexing problem> / 02-Oct-2002
% modified:
%	us	03-Oct-2002 22:57:05	/	TMW

		vix=[];
	if	~nargin
		help(mfilename);
		return;
	end

% get args
		[res,ixb,ixe]=parse(varargin{:});
	if	~res
		return;
	end

% prune input ...
		ixs=prune(ixb,ixe);
% ... and create logical array
		vlen=length(v);
		tix=zeros(1,vlen+1);
		tix(ixs(2:2:end)+1)=-1;
		tix(ixs(1:2:end-1))=1;
		vix=cumsum(tix);
		vix=logical(vix(1:vlen));
% TEST		vix=test_mep(vix,ixb,ixe,ixs);
		return;
%--------------------------------------------------------------------------------
% prune input list to remove overlaps/inclusions
% the slowest part due to <sort>/<find>
function	ixs=prune(ixb,ixe)

		ixl=[ixb;ixe];
		ixs=sort(ixl,2);
		ix=find(ixs(1,2:end)-1<=ixs(2,1:end-1));
		ixs(1,ix+1)=-1;
		ixs(2,ix)=-1;
		ixs(ixs==-1)=[];
		ix=find(ixs(1:end-1)>ixs(2:end));
		ixs([ix ix+1])=[];
		return;
%--------------------------------------------------------------------------------
% parse args
function	[res,ixb,ixe]=parse(varargin)

		res=0;
	if	nargin<2 & size(varargin{1},1)==2
		ixb=varargin{1}(1,:);
		ixe=varargin{1}(2,:);
	else
		ixb=varargin{1}(:).';
		ixe=varargin{2}(:).';
	end

% some of these tests can be deleted if
% speed is an issue and the
% input is well behaved (!)

	if	length(ixb) ~= length(ixe)
		disp('mep: index lists do not match');
		return;
	end
	if	~isempty(find(ixb<=0)) | ...
		~isempty(find(ixe<=0))
		disp('mep: index list hast values <=0');
		return;
	end
		ixr=find(ixb>ixe);
	if	~isempty(ixr)
		disp('mep: correcting reversed indexing');
		ixt=ixb;
		ixb(ixr)=ixe(ixr);
		ixe(ixr)=ixt(ixr);
	end
		res=1;
		return;
%--------------------------------------------------------------------------------
% TEST: compare results with simple for-loop
%--------------------------------------------------------------------------------
function	kix=test_mep(vix,ixb,ixe,ixs)

		kix=zeros(1,length(vix));
	for	i=1:length(ixb)
		kix(ixb(i):ixe(i))=1;
	end
		kix=kix(1:length(vix));

		res=isequal(vix,kix);
	if	~res
		disp('mep: test ERROR');
		kix(logical(kix))=nan;
		[ixb;ixe]
		[ixs(1:2:end-1);ixs(2:2:end)]
		[kix;vix]
		kix=[];
		pause
	else
		disp('mep: test PASSED');
		kix=logical(kix);
	end
		return;
%--------------------------------------------------------------------------------
