function [varargout] = dirrec(reper,ext)
%
% Find files recursively in a given folder.
%
%     C=dirrec('c:\windows') returns a cell C with the full pathname of all
%      files in the c:\windows folder and all its sub-folders.
%
%     C=dirrec('c:\windows','.exe') idem but returns only the files with
%      extension .exe.
%
%     C=dirrec('c:\windows','co*') idem but returns only the files starting with
%      the two letters co (comsetup.log, control.ini, ...).
%
%     C=dirrec('c:\windows',{'.exe','.dll') idem but returns files with both
%      .exe and .dll extensions.
%
%     dirrec('c:\windows','.cmd') only displays the list of the .cmd files in
%      the Matlab command window
%
%           c:\windows\system32\login.cmd
%           c:\windows\system32\usrlogon.cmd
%
%     Note that extension should be given in lower case.
%
%     See also DIR.
%
%     Luc Masset (2007)

%  Algorithm:
% The three cases - no extension, one extension and multiple extensions - are separeted to speed up the
% search process. The function fileextDR replaces the fileparts function because we only need the
% extension.

%initialisation
if nargout,
 varargout=[];
end
listF=[];

%input arguments
if ~nargin | nargin > 2,
 error('DIRREC requires 1 or two arguments')
 return
elseif nargin == 1,
 ext=[];
else
 if ~iscell(ext),
  if strcmpi(ext,'.*'),
   ext=[];
  end
 end
end

%list of folders
listD{1,1}=reper;       % a cell containing all the searched folders
indD(1)=1;              % a vector (same size as listD) indicating
                        % that a folder has been searched (1) or not (0)

%cases
if isempty(ext),
 icase=1;
elseif ~iscell(ext),
 ii=strfind(ext,'*');
 if length(ii) == 1 & ii == length(ext);
  icase=2;
 else
  icase=3;
 end
elseif iscell(ext),
 icase=4;
else
 ext=[];
 icase=1;
end

%case 1: no extension given
switch icase
case 1,
 while 1,
  ind=find(indD);
  if isempty(ind),
   break;
  end
  ind=ind(1);
  rep=listD{ind};
  [listdir,listfile]=getdirDR1(rep);
  listF=[listF listfile];
  indD(ind)=0;
  nbd=length(listdir);
  if nbd,
   listD=[listD listdir];
   indD=[indD ones(1,nbd)];
  end
 end

%case 2: start of the name given (--*)
case 2,
 stc=strrep(ext,'*','');
 while 1,
  ind=find(indD);
  if isempty(ind),
   break;
  end
  ind=ind(1);
  rep=listD{ind};
  [listdir,listfile]=getdirDR4(rep,stc);
  listF=[listF listfile];
  indD(ind)=0;
  nbd=length(listdir);
  if nbd,
   listD=[listD listdir];
   indD=[indD ones(1,nbd)];
  end
 end

%case 3: only one extension given
case 3,
 while 1,
  ind=find(indD);
  if isempty(ind),
   break;
  end
  ind=ind(1);
  rep=listD{ind};
  [listdir,listfile]=getdirDR2(rep,ext);
  listF=[listF listfile];
  indD(ind)=0;
  nbd=length(listdir);
  if nbd,
   listD=[listD listdir];
   indD=[indD ones(1,nbd)];
  end
 end

%case 4: several extensions given
case 4,
 while 1,
  ind=find(indD);
  if isempty(ind),
   break;
  end
  ind=ind(1);
  rep=listD{ind};
  [listdir,listfile]=getdirDR3(rep,ext);
  listF=[listF listfile];
  indD(ind)=0;
  nbd=length(listdir);
  if nbd,
   listD=[listD listdir];
   indD=[indD ones(1,nbd)];
  end
 end
end

%display results
if ~nargout,
 for i=1:length(listF),
  fprintf('%s\n',listF{i});
 end
else
 varargout{1}=listF;
end

return

%------------------------------------------------------------------------------
function [listdir,listfile] = getdirDR1(reper)

%dir of folder reper
S=dir(reper);

%separate sub-folders of reper and files
n=size(S,1);
listdir=cell(1,n);      % list of sub-folders
listfile=cell(1,n);     % list of files
for i=1:n,
 name=S(i).name;
 if S(i).isdir,
  if strcmp(name,'.'),  % remove current folder (.)
   continue;
  end
  if strcmp(name,'..'), % remove parent folder (..)
   continue;
  end
  listdir{i}=fullfile(reper,S(i).name);
 else
  listfile{i}=fullfile(reper,S(i).name);
 end
end

%reorder results
ind=find(cellfun('isempty',listdir));
listdir(ind)=[];
ind=find(cellfun('isempty',listfile));
listfile(ind)=[];

return

%------------------------------------------------------------------------------
function [listdir,listfile] = getdirDR2(reper,ext)

%dir of folder reper
S=dir(reper);

%separate sub-folders of reper and files
n=size(S,1);
listdir=cell(1,n);      % list of sub-folders
listfile=cell(1,n);     % list of files
nd=0;
nf=0;
for i=1:n,
 name=S(i).name;
 if S(i).isdir,
  if strcmp(name,'.'),  % remove current folder (.)
   continue;
  end
  if strcmp(name,'..'), % remove parent folder (..)
   continue;
  end
  nd=nd+1;
  listdir{nd}=fullfile(reper,S(i).name);
 else
  exte=fileextDR(name);       % compare extension
  if strcmpi(exte,ext),       % with given extension
   nf=nf+1;
   listfile{nf}=fullfile(reper,S(i).name);
  end
 end
end

%reorder results
listdir(nd+1:end)=[];
listfile(nf+1:end)=[];

return

%------------------------------------------------------------------------------
function [listdir,listfile] = getdirDR3(reper,ext)

%dir of folder reper
S=dir(reper);

%separate sub-folders of reper and files
n=size(S,1);
listdir=cell(1,n);      % list of sub-folders
listfile=cell(1,n);     % list of files
for i=1:n,
 name=S(i).name;
 if S(i).isdir,
  if strcmp(name,'.'),  % remove current folder (.)
   continue;
  end
  if strcmp(name,'..'), % remove parent folder (..)
   continue;
  end
  listdir{i}=fullfile(reper,S(i).name);
 else
  exte=fileextDR(name);       % extension of the file
  if isempty(exte),
   continue;
  end
  if strmatch(lower(exte),ext,'exact'),   % compare extension with given extensions
   listfile{i}=fullfile(reper,S(i).name);
  end
 end
end

%reorder results
ind=find(cellfun('isempty',listdir));
listdir(ind)=[];
ind=find(cellfun('isempty',listfile));
listfile(ind)=[];

return

%------------------------------------------------------------------------------
function [listdir,listfile] = getdirDR4(reper,stc)

%dir of folder reper
S=dir(reper);

%separate sub-folders of reper and files
n=size(S,1);
listdir=cell(1,n);      % list of sub-folders
listfile=cell(1,n);     % list of files
nd=0;
nf=0;
for i=1:n,
 name=S(i).name;
 if S(i).isdir,
  if strcmp(name,'.'),  % remove current folder (.)
   continue;
  end
  if strcmp(name,'..'), % remove parent folder (..)
   continue;
  end
  nd=nd+1;
  listdir{nd}=fullfile(reper,S(i).name);
 else
  ii=strfind(name,stc);
  if isempty(ii) | ii ~= 1,
   continue;
  end
  nf=nf+1;
  listfile{nf}=fullfile(reper,S(i).name);
 end
end

%reorder results
listdir(nd+1:end)=[];
listfile(nf+1:end)=[];

return

%------------------------------------------------------------------------------
function [ext] = fileextDR(fname)

ext=[];
ind=strfind(fname,filesep);
if ~isempty(ind),
 fname=fname(max(ind)+1:end);
end
ind=strfind(fname,'.');
if isempty(ind),
 return
end
ext=fname(max(ind):end);

return
