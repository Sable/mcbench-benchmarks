%% FILESYNC Synchronize data using a USB key. 
%
%   PLEASE MAKE SURE YOU UNDERSTAND THE CODE COMPLETELY BECAUSE IT DOES OVERWRITE DATA!
%
%   This file is designed to synchronize data between two computers using a
%   USB key. It only updates files that have been modified since the last 
%   update. Files with the more recent modified date overwrite existing
%   files. 
%   
%   The first time this function is executed, it initializes the USB key.
%   However, since it doesn't know when the last backup was performed, no
%   data is copied to the USB key. Each time after the initialization, 
%   this function will update the USB key to keep data between the two
%   computer synchronized.
%
%   Variables that need to be set are:
%      <basedir>    - (1 x 2) CELLL ARRAY of STRINGs of full paths to the base directory                      
%                     on each computer to be synchronized.
%      <staticname> - (1 x 2) CELL ARRAY of STRINGs that include the computer name 
%                     of each computer retruned by "getenv('computername')"
%      <USBdir>     - STRING of directory path on the USB key used for synchronization
%      <USBtmp>     - STRING of directory path on the USB key used for temporary 
%                     purposes during synchronization
%
% This function was tested on Windows XP, SP2, running Matlab 2006b (ver 7.3). 
% There is a GETENV function call that expects 'computername' to exist as an
% environmet variable. This will need to be modified for other operating
% systems. 
%
% Please send comments/suggestions to:
%
% Jesse Norris
% jnorris@wfubmc.edu
% http://jesse.musculoskeletaldynamics.com
%
% Last modified: 15 April 2007
%

%% filesync
function filesync

   % Start stopwatch, clear command window and store current directory
   %
   tic; clc; currdir = cd; 
   
%% ~~~~~ USER SPECIFIC VARIABLES ~~~~~
 
   % Set the static computer names and base directories on those computers 
   % that will be synchronized. These static computer names should match those
   % returned by the GETENV function with 'computername' argument. 
   %
   staticname{1} = '3390-99RGXAZ';  % Computer 1 <computername>
   basedir{1}    = 'C:\Documents and Settings\jnorris\My Documents'; % Base directory on Computer 1
   staticname{2} = '1612-8QDLG11';   % Computer 2 <computername>
   basedir{2}    = 'C:\Documents and Settings\jnorris\My Documents'; % Base directory on Computer 2
   
   % Set the directories on the USB key used for synchronization.
   %
   USBdir   = 'E:\File Transfer';                  % Directories for storing updated files
   USBtmp   = 'E:\Temp';                           % Temporary directory 
   
%% ~~~~~ END USER SPECIFIC VARIABLES ~~~~~
      
   % Retrieve current computer name. NOTE: The <getenv> function assumes 
   % 'computername' is an enviroment variable.
   %
   computername  = getenv('computername');
   if isempty(computername); error('''computername'' does not exist in this computer''s environment variables.'); end;
      
   % Set files for keeping track of synchronization times.
   %
   USBfile  = ['\' '0 Files updated.txt'];         % File where updated files are stored.   
   USBts{1} = ['\1 ' staticname{1} ' to USB.txt']; % Files on the USB key that are used solely for time stamps.
   USBts{2} = ['\1 ' staticname{2} ' to USB.txt'];
   
   % Check if directories & file exist. If not, attempt to create. If create fails, return error.
   %
   chkmkdir(USBdir);   
   chkmkfile([USBdir USBfile]);
   chkmkfile([USBdir USBts{1}]);
   chkmkfile([USBdir USBts{2}]);
   
   % Ensure that user is ready to begin synchronization.
   %
   button = questdlg('Begin synchronization?', 'USB Synchronization', 'Yes', 'No', 'No');
   
   if strcmp(button,'Yes'); 
       
       % Determine which computer was most recently synchronized to the USB key
       %
       comp1date = filemodified([USBdir USBts{1}]);
       comp2date = filemodified([USBdir USBts{2}]);           
       if (comp1date > comp2date); USBupdatedfrom = staticname{1}; else USBupdatedfrom = staticname{2}; end;            
       
       % Collapse <basedir> and <USBts> to just STRING variables based on the current computer.
       %
       if strcmp(computername,staticname{1});
           basedir = basedir{1}; 
           USBts   = USBts{1};
       elseif strcmp(computername,staticname{2});
           basedir = basedir{2};  
           USBts   = USBts{2};
       else
           error('filesync:unknowncomp','<computername> ''%s'' does not match either name in the variable <staticname>',computername);
       end;
             
       % If the current computer was the most recent to be synchronized with the USB key, 
       % it is only necessary to update the USB key with any new data.
       %        
       if strcmp(computername,USBupdatedfrom);            
           updateUSB(basedir,USBdir,USBfile,USBts); % Update the USB key                                                                                                                
       
       % Otherwise, it is necessary to 
       % (1) Update any changes that have occured on the current computer to <USBtmp> on the USB key.
       % (2) Then update the current computer with USB data. 
       % (3) Lastly, copy from <USBtmp> to <USBdir> for updates back to the other computer.
       %  
       else
           chkmkdir(USBtmp);                          % Check if <USBtmp> exists. If not, attempt to create. If create fails, return error.
           copyfile([USBdir USBts],[USBtmp USBfile]); % Copy the time stamp file to the update file in the temporary directory
           updateUSB(basedir,USBtmp,USBfile,USBts);   % Update <USBtmp>  with data on computer                                                                
           updatecomputer(basedir,USBdir,USBfile);    % Update computer with data in <USBdir> on USB key,
           movefile([USBtmp '\*'],USBdir);            % Move all files from the <USBtmp> to <USBdir>, and
           rmdir(USBtmp);                             % Remove <USBtmp> from the USB key
       end;  
       
       % Return to original directory
       %
       try 
           cd(currdir);
       catch
           cd(basedir);
           warning('filesync:cderror','Unable to change directory to: %s',currdir);
       end

       toc; % Elapsed time     
       
       fprintf(' ~~~ \n\n');
   else
       fprintf('Synchronization Cancelled.\n\n');
   end;
end

%% chkmkdir
function message = chkmkdir(dirname)
   % Check if <dirname> is a directory. If not, attempt to create. 
   % If create fails return error.
   %   
   if ~exist(dirname,'dir')
       try
           mkdir(dirname); % Create directory
           message = 'Directory created.';
       catch
           error('Could not create path: ''%s''.\n~Check initialization value of variable: <%s>.',dirname,inputname(1));
       end;
   else
       message = 'Directory exists.';
   end;
end

%% chkmkfile
function message = chkmkfile(fname)
   % Check if <fname> is a file. If not, attempt to create. 
   % If create fails return error.
   %
   if ~exist(fname,'file')
       try
           fid = fopen(fname,'w'); fclose(fid); % Create file   
           message = 'File created.';
       catch
           error('Could not create file: ''%s''.\n~Check initialization value of variable: <%s>.',fname,inputname(1));
       end;
   else
       message = 'File exists.';
   end;
end

%% removeemptyfolders
function removeemptyfolders(rmdirname)
   if isdir(rmdirname);
       cd(rmdirname);          % CD to directory
       while length(dir) == 2; % Recurrisvely remove until an unempty folder is encountered 
           rmdirname = cd;     % Current directory
           cd ..;              % CD to parent directory
           rmdir(rmdirname);   % Remove the subdirectory
       end; 
   end;
end

%% filemodified
function modified = filemodified(fullpath)
   if exist(fullpath,'file')
       fileinfo = dir(fullpath);   % Determine last modification time
       modified = datenum(fileinfo.date,'dd-mmm-yyyy HH:MM:SS');             
   else
       modified = [];
   end;
end

%% updatecomputer
function updatecomputer(basedir,USBdir,USBfile)    
   fprintf('\n... Updating the computer with files on USB key ...\n\n'); 
   
   USBfile = [USBdir USBfile];                 % Update to full path
   fid     = fopen(USBfile,'r');                 % Open file that includes full directory paths and file names        
   files   = textscan(fid,'%s','delimiter',';'); % Load all the files to update
   files   = files{1};
   fclose(fid);                                % Close the file             
   
   % Step through each file
   % -> check that file exists on USB key
   % -> check that the date on the USB key is more recent than that on the computer
   % -> copy file from USB key to computer
   for fileind = 1:length(files)
       [subdir name ext] = fileparts(files{fileind});
       fprintf('%s...',[subdir '\' name ext]); % Update workspace
       
       if exist([USBdir subdir '\' name ext],'file')
           USBdate = filemodified([USBdir  subdir '\' name ext]);
           Cdate   = filemodified([basedir subdir '\' name ext]); 
           if ~isempty(Cdate)
               if  USBdate > Cdate
                   movefile([USBdir subdir '\' name ext],[basedir subdir '\' name ext],'f');                        
                   fprintf('%s\n','Updated.');
               else
                   switch questdlg(['Confirm Overwrite of ' name ext],'Overwrite','Yes','No - Delete from USB','No - Leave on USB','No - Leave on USB')
                       case 'Yes'
                           movefile([USBdir subdir '\' name ext],[basedir subdir '\' name ext],'f');
                           fprintf('%s\n','Updated.');
                       case 'No - Delete from USB'
                           delete([USBdir subdir '\' name ext]);    
                           fprintf('%s\n','Not updated - deleted from USB.');
                       otherwise
                           fprintf('%s\n','Not updated - left on USB.');
                   end;
               end;
           else
               if ~isdir([basedir subdir]); mkdir([basedir subdir]); end; % Create new directory
               movefile([USBdir subdir '\' name ext],[basedir subdir '\' name ext],'f');
               fprintf('%s\n','Updated.');
           end;
       else
           fprintf('%s\n','File not found on USB key.');
       end;
       removeemptyfolders([USBdir subdir]); % Recurrisvely remove until an unempty folder is encountered               
   end;         
end

%% updateUSB
function updateUSB(basedir,USBdir,USBfile,USBts)
   fprintf('\n... Updating the USB key with files from the computer ...\n\n');
   
   USBfile = [USBdir USBfile];      % Update to full path
   USBts   = [USBdir USBts];        % Update to full path
   USBdate = filemodified(USBfile); % Check when it was modified
   fid     = fopen(USBfile,'a');    % Open file to append the full path strings to            
   
   % Load all the paths to scan. This expression is based on a line in 
   % Matlab function PARSEDIRS.
   %
   paths = regexp(genpath(basedir), sprintf('[^\\s%s][^%s]*', pathsep, pathsep), 'match')';
   
   % Step through all paths
   % -> examine if files have been modified since <USBdate>
   % -> copy updated files to the USB key
   % -> append <fid> with directory where file was originally from
   %
   for pathind = 1:length(paths)
       cd(paths{pathind}); % Change to directory
       files = dir;        % Load file information 
       
       % Step through all files
       %
       for fileind = 3:length(files) 
           % NOTE: THIS EXPRESSIONS STOPS THIS FUNCTION FROM COPYING OUTLOOK MAILBOX FILES (*.pst)
           % The one on my computer is too large to be copied with just a USB key.
           %
           if ~files(fileind).isdir && (datenum(files(fileind).date,'dd-mmm-yyyy HH:MM:SS') > USBdate) && ~strcmpi(files(fileind).name(end-2:end),'pst')
               if (files(fileind).bytes > 10e6)
                   okay2copy = questdlg(['File ' files(fileind).name ' is ' sprintf('%.0f',files(fileind).bytes/1e6) ' Mb. Copy file to the USB key?'],'Large file.','Yes','No','No');
                   okay2copy = strcmp(okay2copy,'Yes');                           
               else
                   okay2copy = true;
               end;
               if okay2copy
                   try
                       if ~isdir([USBdir paths{pathind}(47:end)]); mkdir([USBdir paths{pathind}(47:end)]); end; % Create directory on USB key
                       copyfile(files(fileind).name,[USBdir paths{pathind}(47:end) '\' files(fileind).name]);   % Copy file to USB key
                       fprintf(fid,'%s\r\n',[paths{pathind}(47:end) '\' files(fileind).name '; ']);             % Update the txt file
                       fprintf(      '%s\n',[paths{pathind}(47:end) '\' files(fileind).name]);                  % Update workspace         
                   catch
                       warning('updateUSB:copyfile','Error caught in function <updateUSB>');
                       handleerror(lasterror);                       
                   end                   
               else
                   fidnoupdate = fopen([USBdir '\0 Files NOT updated'],'a');
                   fprintf(fidnoupdate,'%s\r\n',[paths{pathind}(47:end) '\' files(fileind).name '; ']);     % Update the txt file
                   fclose(fidnoupdate);
               end;
           end;
       end;               
   end;
   fclose(fid); % Close the file  
   
   fid = fopen(USBts,'w'); fclose(fid); % Update successful, replace appropriate time stamp file 
   
   cd(basedir); % Return to base directory   
end

%% genpath
% p = genpath(d)
% OUTPUT arguments
%      <p>: a path string that includes all subdirectories of <d>
%
% INPUT arguments
%      <d>: returns a path string starting in D, plus, recursively, all
%           the subdirectories of D, including empty subdirectories.
%
% This function is based on Matlab's genpath function. It was written because 
% the genpath function skips method directories (i.e. those beginning with @), 
% and 'private' directories. 
%
function p = genpath(d)
  p = '';                % Initialize path string  
  files = dir(d);        % Generate path based on given root directory
  if isempty(files)
      return;
  end;    
  p     = [p d pathsep]; % Add d to the path even if it is empty.    
  isdir = [files.isdir]; % Create logical vector for subdirectory entries in d
  dirs  = files(isdir);  % Select only directory entries from the current list
  
  for i = 1:length(dirs)
      dirname = dirs(i).name;
      if ~strcmp(dirname,'.') && ~strcmp(dirname,'..')
          p = [p genpath(fullfile(d,dirname))]; % recursive calling of this function.
      end;
  end;    
end

%% handleerror
% handleerror(errorin)
% INPUT arguments
%      <errorin>: a structure containing at least the following two fields:
% 
%        message    : the text of the error message 
%        identifier : the message identifier of the error message 
%
%      Additionally, <errorin> may contain field <stack>.
%
function handleerror(errorin)
  try     
      fprintf('Message:    %s\n',errorin.message);
      fprintf('Identifier: %s\n',errorin.identifier);
      fprintf('Stack:\n');
      if(isfield(errorin,'stack'));
          while(length(errorin.stack) >=1)
              %fprintf('      %s\n',errorin.stack(1).file);
              fprintf('       <%s> line: %d\n',errorin.stack(1).name,...
                                               errorin.stack(1).line);
              errorin.stack = errorin.stack(2:end);
          end;
      end;
  catch
      warning('handleerror:errorcaught','Error in function <handleerror>');
  end
end