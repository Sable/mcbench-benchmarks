%ISODD		true for (odd) integers that are not evenly divisible by 2
%
%		ISODD returns TRUE for members (N) of a numeric array, which
%		- are within the range of ±bitmax
%		- are integers such that N == fix(N)
%		- are integers not evenly divisible by 2
%
%		Unlike the typical computational approach using REM/MOD,
%		ISODD produces a not-valid flag for numbers, which are
%		1) not integers
%		2) smaller/larger than the maximum possible double precision
%		   integer representation (±bitmax)
%		and does never return their parity as being odd
%
%		REM/MOD, on the other hand, do not complain if an input
%		is not a valid candidate for being even or odd at all
%		and, therefore, are NOT reliable parity checkers
%
%		see also: rem, mod, isinteger, isnumeric, bitmax, bitand
%
%SYNTAX
%-------------------------------------------------------------------------------
%		[TFODD,TFVAL] = ISODD(IVEC1,IVEC2,...,IVECn);
%
%INPUT
%-------------------------------------------------------------------------------
% IVECx	:	ND arrays of ±integers of any MATALB class
%		by default, other data types including cell arrays
%		of integers return FALSE
%
%OUTPUT
%-------------------------------------------------------------------------------
% TFODD	:	logical array showing whether an array member is
%		   1: valid AND odd			= TRUE
%		   0: valid AND even - OR(!) - invalid	= FALSE
% TFVAL	:	logical array showing whether an array member is
%		an integer <= abs(+bitmax)
%		   1: valid     member			= TRUE
%		   0: invalid   member			= FALSE
%
%		if any IVECx is not a scalar,
%		TFODD and TFVAL are encapsulated in cells
%
%NOTE
%-------------------------------------------------------------------------------
%		EVEN members must be retrieved by
%			~TFODD & TFVAL
%
%EXAMPLE
%-------------------------------------------------------------------------------
%	% input including bitmax+(-2:8)
%	%   note: bitand(bitmax,1) = TRUE (odd)
%	%	  therefore, for the above numbers REM should return
%	%		odd - even - odd - even - odd - ...
%		vec = [-1:1,pi,bitmax+(-2:8)].';
%		format hex;
%		disp(vec);
%	% - returns
%		% vec =	bff0000000000000	-1		== odd
%		%	0000000000000000	0		== even
%		%	3ff0000000000000	1		== odd
%		%	400921fb54442d18	pi		== invalid !
%		%	433ffffffffffffd	bitmax - 2	== odd
%		%	433ffffffffffffe	bitmax - 1	== even
%		%	433fffffffffffff	bitmax		== odd
%	%   note: the following are NOT valid integers
%		% but valid double precision floats
%		%	4340000000000000	bitmax + 1	== even ?
%		%	4340000000000000	bitmax + 2	== bitmax + 1
%		%	4340000000000001	bitmax + 3	== ?
%		%	4340000000000002	bitmax + 4	== ?
%		%	4340000000000002	bitmax + 5	== bitmax + 4
%		%	4340000000000002	bitmax + 6	== bitmax + 4
%		%	4340000000000003	bitmax + 7	== ?
%		%	4340000000000004	bitmax + 8	== ?
%	% REM
%		res = rem(vec,2)~=0;
%		odd = vec(res);
%		evn = vec(~res);
%	% - returns
%		% res = 1 0 1 1 1 0 1 0 0 0 0 0 0 0 0	(.')
%	%   note: pi is marked as odd
%		% odd = bff0000000000000	-1		== odd
%		%	3ff0000000000000	1		== odd
%		%	400921fb54442d18	pi		== odd !
%		%	433ffffffffffffd	bitmax - 2	== odd
%		%	433fffffffffffff	bitmax		== odd
%	%   note: no complaints about nonsense results
%		% evn = 0000000000000000	0		== even
%		%	433ffffffffffffe	bitmax - 1	== even
%		%	4340000000000000	bitmax + 1	== even ?
%		%	4340000000000000	bitmax + 2	== even ?
%		%	4340000000000001	bitmax + 3	== even ?
%		%	4340000000000002	bitmax + 4	== even ?
%		%	4340000000000002	bitmax + 5	== even ?
%		%	4340000000000002	bitmax + 6	== even ?
%		%	4340000000000003	bitmax + 7	== even ?
%		%	4340000000000004	bitmax + 8	== even ?
%	% ISODD
%		[tfo,tfv] = isodd(vec);
%	% - returns
%		% tfo = 1 0 1 0 1 0 1 0 0 0 0 0 0 0 0
%		% tfv = 1 1 1 0 1 1 1 0 0 0 0 0 0 0 0
%		% odd/even numbers
%		odd = vec(tfo);
%		evn = vec(~tfo&tfv);
%	% - returns
%		% odd = bff0000000000000	-1
%		%	3ff0000000000000	1
%		%	433ffffffffffffd	bitmax-2
%		%	433fffffffffffff	bitmax
%		% evn = 0000000000000000	0
%		%	433ffffffffffffe	bitmax-1

% created:
%	us	10-Dec-2006 us@neurol.unizh.ch
% modified:
%	us	14-Aug-2009 20:35:23
%
% localid:	us@USZ|ws-nos-36362|x86|Windows XP|7.8.0.347.R2009a

%-------------------------------------------------------------------------------
function	[atfo,atfv]=isodd(varargin)

		atfo=cell(1,nargin);
		atfv=cell(1,nargin);
		asiz=false(1,nargin);

	for	i=1:nargin

% prepare data
		n=varargin{i};
		asiz(1,i)=isscalar(n);

	if	isnumeric(n)

		na=abs(n);
		nx=fix(n)==n & na<=bitmax;

% is odd
		tfo=false(size(n));
		tfo(nx)=bitand(double(na(nx)),1);

% - is valid
		tfv=false(size(n));
		tfv(nx)=true;

% -- is valid odd
		tfv=tfo&tfv;

% collect results
		atfo{1,i}=tfo;
		atfv{1,i}=tfv;

	else
% invalid input
		vsiz=false(size(varargin{i}));
		atfo{1,i}=vsiz;
		atfv{1,i}=vsiz;
	end

	end

	if	nargin == 1				||...
		all(asiz==1)
		atfo=[atfo{1,:}];
		atfv=[atfv{1,:}];
	end
end
%-------------------------------------------------------------------------------