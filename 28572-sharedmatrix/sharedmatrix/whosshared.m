function S=whosshared(HEXOUTPUT)
%WHOSSHARED List shared memory information.
%   WHOSSHARED lists information on shared memory segments,
%   including key, permissions, owener, size, etc.
%
%   Specifying a return variable for WHOSSHARED, such as, 
%   S = WHOSSHARED(...), returns a structure with the fields:
%         key : unique shared memory access identifier
%       shmid : system shared memory access identifier
%       owner : user that owns the shared memory segment
%       perms : permissions of shared memory segment
%       bytes : size of segment in bytes
%      nattch : number of attached processes
%      status : state of memory, i.e., marked for deletion
%
%   For example, to find the total shared memory in MiB:
%      S=whosshared;sum([S.bytes])*2^-20
%
%   WHOSSHARED(true) converts the key to hex; the default is
%   false.
%
%   See also SHAREDMATRIX.
%   
%  Copyright (c) 2010,2011 Joshua V Dillon
%  All rights reserved. (See file header for details.)

if nargin<1
	HEXOUTPUT=false;
elseif nargin==1 && islogical(HEXOUTPUT)
	% do nothing
else
	error('MATLAB:whosshared:InvalidInput',...
		'Input argument must be logical.');
end
	
[exitflag shmem]=system('which ipcs&>/dev/null && ipcs -m');
if exitflag~=0
	error('MATLAB:whosshared:CommandNotFound',...
		['Unable to provide information on ipc facilities ' ...
		'(command `ipcs` missing).']);
end

% remove leading whitespace
shmem=fliplr(deblank(fliplr(shmem)));

% tokenize
a=textscan(shmem,'%s%n%s%n%n%n%s',...
	'MultipleDelimsAsOne',true,'Headerlines',2);

% set to empty (in a consistent way)
if all(cellfun(@isempty,a)),[a{:}]=deal([]);end

if ~HEXOUTPUT
	h=char(a{1});h=h(:,3:end);a{1}=hex2dec(h);
	I=[1 2 4 5 6]; % indecies of numeric
else
	I=[  2 4 5 6]; % indecies of numeric
end

% convert to cell array of cell arrays
a(I)=cellfun(@num2cell,a(I),'uni',0);

% organize
s=struct(...
	'key'   ,a{1} ,...
	'shmid' ,a{2} ,...
	'owner' ,a{3} ,...
	'perms' ,a{4} ,...
	'bytes' ,a{5} ,...
	'nattch',a{6} ,...
	'status',a{7}  ...
);

% output
if nargout<1
	SIZ=12;

	SIZa=num2str(SIZ);
	SIZb=num2str(SIZ-1);

	% print header
	hdr=fieldnames(s);fprintf([' %- ' SIZa 's'],hdr{:});
	fprintf('\n');

	if ~HEXOUTPUT
		FMTSTR=['%- '  SIZa 'd %- ' SIZa 'd  %- ' SIZb 's %- ' SIZa ...
			'd %- ' SIZa 'd %- ' SIZa 'd  %- ' SIZa 's\n'];
	else
		FMTSTR=[' %- ' SIZb 's %- ' SIZa 'd  %- ' SIZb 's %- ' SIZa ...
			'd %- ' SIZa 'd %- ' SIZa 'd  %- ' SIZa 's\n'];
	end

	for i=1:length(s)
		fprintf(FMTSTR,a{1}{i},a{2}{i},a{3}{i},a{4}{i},a{5}{i},...
			a{6}{i},a{7}{i});
	end
	
else
	S=s;
end

