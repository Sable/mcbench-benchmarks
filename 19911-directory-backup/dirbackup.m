function dirbackup(s1, s2, runmode)
% function dirbackup(a, b, mode)
%
% Creates a backup of folder 'a' in folder 'b' or updates the current
% backup in folder 'b'. The function deletes files and folders from
% directory 'b' if they are not present in directory 'a'. It also compares
% each file with the same name by date and if a difference is found, the
% files in folder 'b' are updated, provided the file in folder 'a' is found
% to be newer. However, if the file in folder 'b' is found to be newer than
% the file in folder 'a', the user is asked for confirmation of update.
% Currently, the code is optimised for DOS-based system calls. Matlab calls
% to delete files and directories are significantly slower than DOS calls.
%
% The 'mode' argument can be used to determine the following:
%   -1:     No backup performed. Trial run only with command line
%           information.
%   0:      Minimal user input mode. Only questions when the backup would
%           involve updating a file that is newer in the backup directory.
%           This is the default option.
%   1:      Safe mode. Questions most actions (significant user input
%           required to do a backup), except for copying (without
%           overwriting) files/directories to the backup directory.
%
% Example:
%
% dirbackup('C:\Mywork', 'D:\Backup\Mywork', 0)

if (nargin < 3)
   runmode = 0;
end;

tmp = what(s1);
s1 = tmp.path;
tmp = what(s2);
s2 = tmp.path;

if ~exist(s2, 'dir')
   fprintf('\nBackup folder does not yet exist. ');
   R = input('Do you want to create the folder and copy the source? (y/n) ', 's');
   if strcmpi(R, 'y')
      [status, out] = system(sprintf('xcopy "%s" "%s" /E /I /R /K /H /Y', s1, s2));
      if status
         fprintf('Backup failed.');
      end;
   else
      fprintf('\nBackup process cancelled by user.');
   end;
end;

% Remove the '.' and '..' from the file structure arrays
file1 = dir(s1);
nfiles1 = length(file1);
for i = nfiles1:-1:1
   if (isequal(file1(i).name , '.') || isequal(file1(i).name , '..'))
      file1(i) = [];
   end;
end;
file2 = dir(s2);
nfiles2 = length(file2);
for i = nfiles2:-1:1
   if (isequal(file2(i).name , '.') || isequal(file2(i).name , '..'))
      file2(i) = [];
   end;
end;

% Sort file names in current directory (ignoring case) ...
nfiles1 = length(file1);
[x, i] = sort(lower({file1(:).name}));
file1 = file1(i);
nfiles2 = length(file2);
[x, i] = sort(lower({file2(:).name}));
file2 = file2(i);

% Loop through the files, comparing the 'Date modified' values ...
n1 = 1; n2 = 1;
while (n1 <= nfiles1 && n2 <= nfiles2)
   if strcmpi(file1(n1).name, file2(n2).name)
      % Current files have same name (ignoring case) ...
      if (file1(n1).isdir + file2(n2).isdir == 2)
         % Both files are directories. Call this function (recursive) ...
         dirbackup([s1, '\', file1(n1).name], [s2, '\', file2(n2).name], runmode);
      elseif (file2(n2).isdir + file1(n1).isdir == 1)
         % One file is a directory, while the other is not ...
         error('Target directories contain a file ''%s'' and directory ''%s''', file1(n1).name, file2(n2).name);
      elseif (file1(n1).isdir + file2(n2).isdir == 0)
         % Both are non-directory files ...
         if ~strcmp(file1(n1).date, file2(n2).date)
            % The dates are different and one of the files should be updated ...
            loc_update(s1, file1(n1), s2, file2(n2), runmode);
         end;
      end;
      % Continue to next files in s1 and s2 ...
      n1 = n1 + 1;
      n2 = n2 + 1;
   else
      % Current files in s1 and s2 are different. Sort the files by
      % name, ignoring case ...
      [xx, pos] = sort(lower({file1(n1).name, file2(n2).name}));
      if (pos(1) == 1)
         % The file in s1 is higher up the alphabetic rank. Copy
         % file from s1 to s2 ...
         loc_copy(s1, file1(n1), s2, file1(n1), runmode);
         % Continue to next file in s1 ...
         n1 = n1 + 1;
      else
         % The file in s2 is higher up the alphabetic rank ...
         % Directory s1 is the source, delete file or directory in s2 ....
         if file2(n2).isdir
            loc_deletedir([s2, '\', file2(n2).name], runmode);
         else
            loc_deletefile([s2, '\', file2(n2).name], runmode);
         end;
         % Continue to next file in s2 ...
         n2 = n2 + 1;
      end;
   end;
end;

% One of the directories is exhausted ...
if (n1 > nfiles1)
   % Remaining files in s2 not present in s1. Delete files from s2 ...
   for n2 = n2:nfiles2
      if (file2(n2).isdir)
         loc_deletedir([s2, '\', file2(n2).name], runmode);
      else
         loc_deletefile([s2, '\', file2(n2).name], runmode);
      end;
   end;
   n2 = n2 + 1;
elseif (n2 > nfiles2)
   % Remaining files in s1 not present in s2. Copy the files to s2 ...
   for n1 = n1:nfiles1
      loc_copy(s1, file1(n1), s2, file1(n1), runmode);
   end;
   n1 = n1 + 1;
end;


function loc_update(srcdir, srcfile, tgtdir, tgtfile, runmode)
% Default choice is to continue the backup ...
R = 'y';
source = [srcdir, '\', srcfile.name];
target = [tgtdir, '\.'];
if (datenum(srcfile.date) > datenum(tgtfile.date))
   % Directory s1 has newer file, update file in s2 ...
   if (runmode == 1)
      fprintf('\nThe file ''%s'' (source) is newer than the file ''%s'' (target). ', source, target);
      R = input('\nDo you wish to overwrite the target file? (y/n/q) ', 's');
   end;
else
   fprintf('\nThe file ''%s'' (source) is older than the file ''%s'' (target). ', source, target);
   R = input('\nAre you sure you wish to overwrite the target file? (y/n/q)  ', 's');
end;
ok = getanswer(R);
fprintf('\n''%s'' ... ', [tgtdir, '\', tgtfile.name]);
if ok
   if (runmode >= 0)
      [status, out] = system(sprintf('xcopy "%s" "%s" /K /H /Y /Q', source, target));
   else
      status = 0;
   end;
   if status
      fprintf('An unforeseen error occurred during the backup process.\nThe file ''%s'' could not be copied to ''%s''.\nSystem message: %s', source, target, out);
   else
      fprintf('[UPDATED]');
   end;
else
   fprintf('[SKIPPED]');
end;

% Local copy function ...
function loc_copy(srcdir, srcfile, tgtdir, tgtfile, runmode)
source = [srcdir, '\', srcfile.name];
target = tgtdir;
% Directories are a bit tricky to copy properly without errors occurring
% and/or DOS waiting for user input (without a message in the matlab
% console). The following code has been tested and worked under various
% conditions tested.
if srcfile.isdir
   source = [source, '\*'];
   % Check to see if directory already exists. This shouldn't be necessary,
   % but it is! 
   if ~exist([target, '\', srcfile.name], 'dir')
      mkdir(target, srcfile.name);
   end
   target = [target, '\', srcfile.name, '\.'];
else
   target = [target, '\.'];
end;
fprintf('\n%s ... ', source);
if (runmode >= 0)
   [status, out] = system(sprintf('xcopy "%s" "%s" /E /K /H /Y /Q', source, target));
else
   status = 0;
end;
if status
   fprintf('An unforeseen error occurred during the backup process.\nThe file/directory ''%s'' could not be copied to ''%s''.\nSystem message: %s', source, target, out);
else
   fprintf('[COPIED]');
end;

%Local file delete function ...
function loc_deletefile(target, runmode)
% Default choice is to continue the backup ...
R = 'y';
if (runmode == 1)
   fprintf('\nThe file ''%s'' is no longer in the source directory. ', target);
   R = input('Delete? (y/n/q) ', 's');
end;
% Go through potential user options and retrieve answer ...
ok = getanswer(R);
fprintf('\n''%s'' ... ', target);
if ok
   if (runmode >= 0)
      [status, out] = system(sprintf('del /AH /AR /AS /AA "%s"', target));
   else
      status = 0;
   end;
   if status
      fprintf('An unforeseen error occurred during the backup process.\nThe file ''%s'' could not be deleted.\nSystem message: %s', target, out);
   else
      fprintf('[DELETED]');
   end;
else
   fprintf('[SKIPPED]');
end;

% Local directory delete function ...
function loc_deletedir(target, runmode)
% Default choice is to continue the backup ...
R = 'y';
if (runmode == 1)
   fprintf('\nThe directory ''%s'' is no longer in the source directory. ', target);
   R = input('Delete? (y/n/q) ', 's');
end;
% Go through potential user options and retrieve answer ...
ok = getanswer(R);
fprintf('\n''%s'' ... ', target);
if ok
   if (runmode >= 0)
      [status, out] = system(sprintf('rmdir "%s" /S /Q', target));
   else
      status = 0;
   end;
   if status
      fprintf('An unforeseen error occurred during the backup process.\nThe directory ''%s'' could not be deleted.\nSystem message: %s', target, out);
   else
      fprintf('[DELETED]');
   end;
else
   fprintf('[SKIPPED]');
end;

function ok = getanswer(R)
ok = 0;
if strcmpi(R, 'y')
   ok = 1;
elseif strcmpi(R, 'n')
   ok = 0;
elseif strcmpi(R, 'q')
   error('Backup process stopped by user.');
else
   error('Incorrect choice. Backup process stopped.');
end;
