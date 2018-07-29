function deldup(dname)
% DELDUP - rapidly delete duplicate files in a directory using an MD5 hash
%
% USAGE:
%
% deldup
% deldup(dirname)
%
% dirname = optional string containing the name of a directory. If no directory
%           is specified, then the current directory is used.
%
% Notes: This function rapidly compares large numbers of files for identical content
%        by computing the MD5 hash of each file and detecting duplicates. The probablility
%        of two non-identical files having the same MD5 hash, even in a hypothetical
%        directory containing as many as a million files, is exceedingly remote. Thus,
%        since hashes rather than file contents are compared, the process of detecting
%        duplicates is greatly accelerated.
%
%        You must have the file md5DLL.dll on your Matlab path to use this function.
%        The function is stored in the Matlab Central File Exchange, file #3784,
%        and was written by Hans-Peter Suter. The URL for the download site is:
%        http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=3784&objectType=file
%
%        This function is intended for MS Windows operating systems. This is because
%        Matlab requires on the order of 0.1 seconds to execute an operating system
%        command to delete each file, but can rapidly create and run an operating
%        system batch file to perform the file deletions much faster. Since I use
%        Matlab on a Windows PC, this function creates a batch file for that platform.
%        Futhermore, the md5DLL.dll file is specific to Windows.
%
% Michael Kleder, 2004

% record time for later elapsed time report
yyy = now;

% preserve current directory name so can return to it when done
dkeep=pwd;

% obtain and display desired directory name
if nargin == 0
   dname = pwd;
else
   cd(dname)
end
disp(['Checking directory ' dname])

% obtain list of files, omitting subdirectories
d = dir;
d=d(~[d.isdir]);

if length(d) < 1
   disp('No files in directory.')
   cd(dkeep)
   return
end

disp([num2str(length(d)) ' files found.'])

disp('Eliminating uniquely sized files from consideration.')
sizes=[d.bytes];
[ss,I]=sort(sizes);
ds= (diff(ss)==0); % logical true for files (in ss) whose size is same as next file
ds = [ ds 0 ] | [0 ds]; % logical true for all (in ss) whose size is not unique
d = d(I(ds)); % keep only non-uniquely sized files
disp([num2str(length(d)) ' files remain.'])

% extract filenames
[mf{1:length(d)}]=deal(d.name);

disp(['Computing hashes for ' num2str(length(mf)) ' files.'])
MD5hash=zeros(length(mf),32); % pre-allocate
for fix = length(mf):-1:1
   MD5hash(fix,:) = md5dll(mf{fix},1);
end

% find identical files:
[B,I,J]=unique(MD5hash,'rows');
killcount=0;
nu = nonunique(J); % hashes in B which have multiple source files in mf
if length(nu) < 1
   disp('No identical files found.')
   cd(dkeep)
   return
else
   disp([num2str(length(nu)) ' sets of identical files found. (More than two of each may exist.)']);
end

% catch the error of batchfile name already in use
if exist('tempkillxxx.bat','file')
   cd(dkeep)
   error(['A batch file named "tempkillxxx.bat" already exists in ' dname])
end

% create batch file for deletions
fid = fopen('tempkillxxx.bat','wt');

for nuix = nu(:)'; % loop through non-uniques
   sources = find(J==nuix); % indices of mf which are sources for this hash
   nix = length(sources);
   fn={};
   for six = 1:nix; % loop through source files
      [null,fn{six},null]=fileparts(mf{sources(six)}); % store filenames
   end
   [fn,I]=sort(fn); % list sources alphabetically
   I=I(:)';
   for six = I(2:end) % delete all except first alphabetically
      % *************
      % The commented line of code uses Matlab to execute the file deletion.
      % delete(mf(sources(six)));
      cmdstr = ['del "' mf{sources(six)} '"'];
      fprintf(fid,'%s\n',cmdstr);
      killcount=killcount+1;
   end
end
fclose all;
if killcount > 0
   evalc('!tempkillxxx.bat');
end

% erase batch file
!del "tempkillxxx.bat"

% report stats
disp([num2str(killcount) ' files deleted.'])
disp([num2str((now-yyy)*86400) ' seconds elapsed.'])

function y = nonunique(x)
x = sort(x);
d = ~diff(x); % 1 if entry is same as next entry
y = unique(x(d));