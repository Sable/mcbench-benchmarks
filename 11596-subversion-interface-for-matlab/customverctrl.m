function customverctrl(fileNames, arguments)
%CUSTOMVERCTRL Custom version control template.
%   CUSTOMVERCTRL(FILENAMES, ARGUMENTS) is supplied as a function
%   stub for customers who want to integrate a version control
%   system that is not supported by The MathWorks.
%
%   Modified by S. Bryan 6/29/2006
%   
%   This version is for integrating Matlab with the Subversion Source
%   Control System with a repository on the local machine.
%
%   OPTIONS:
%      action - The version control action to be performed.
%         checkin
%         checkout
% 
%  
%      revision - Performs the action on the specified revision.
%
%      NOT IMPLEMENTED (since SVN doesn't use these features) 
%      lock - Locks the file.
%         on
%         off 
%
%      outputfile - Writes file to outputfile.
%
%	  undocheckout

%   This file is open-source under the GNU Public License.
%   $Revision: 1.00 $  $Date: 2006/06/29 03:12:11 $

action           = arguments(find(strcmp(arguments, 'action')), 2);      % Mandatory argument
lock             = arguments(find(strcmp(arguments, 'lock')), 2);        % Assumed as OFF for checkin and ON for checkout
comments         = arguments(find(strcmp(arguments, 'comments')), 2);    % Mandatory if checkin is the action 
revision         = arguments(find(strcmp(arguments, 'revision')), 2);
outputfile       = arguments(find(strcmp(arguments, 'outputfile')), 2);
force            = arguments(find(strcmp(arguments, 'force')), 2);

if (isempty(action))                                                     % Checking for mandatory arguements
	error('No action specified.');
else
	action           = action{1};                                        % De-referencing
end

files            = '';                                                   % Create space delimitted string of file names
for i = 1 : length(fileNames)
    files        = [files ' ' fileNames{i}];
end

command          = '';
switch action
case 'checkin'
	if (isempty(comments))                                               % Checking for mandatory arguments
		error('Comments not specified');
	else
		comments = comments{1};                                          % De-referencing
	end
	commentsFile = tempname;
    cf           = fopen(commentsFile, 'w');                             % Write the comments to a temp file
    fprintf(cf, '%s', comments);
    fclose(cf);
	comments     = cleanupcomment(comments);                             % Remove all new line char
	comments     = ['"' comments '"'];                                   % Quote the comments
	command      = ['/sw/bin/svn ci -m ' comments ' --non-interactive'];         % Building the command string for svn.

    % not implementing lock now
% 	if (isempty(lock))
% 		lock     = 'off';
% 	else
% 		lock     = lock{1};                                              % De-referencing
% 	end
% 	if (strcmp(lock, 'on'))
% 		command  = [command ' -l'];
% 	else
% 		command  = [command ' -u'];
% 	end
	
case 'checkout'
	if (~isempty(outputfile) & length(fileNames) > 1)
		error('Several files cannot be checkout to a one file');
    end
    
    % not implementing lock
% 	if (isempty(lock))
% 		lock     = 'off';
% 	else
% 		lock     = lock{1};                                              % De-referencing
% 	end

	if (isempty(revision))
		revision = '';
	else
		revision = revision{1};                                          % De-referencing
    end
    
    % don't know what this does...
% 	if (isempty(force))
% 		force   = '';
% 	else
% 		force   = force{1};                                              % De-referencing
% 	end

	
	command      = '/sw/bin/svn up --non-interactive';                                              % Building the command string for SVN.
% 	if (strcmp(lock, 'on'))
% 		command  = [command ' -l'];
% 	else
% 		command  = [command ' -u'];
% 	end
	if (isempty(revision))
		command  = command;
	else
		command  = [command ' -r' revision];                              % Add revision number if one is supplied
	end
% 	if (isempty(force))
% 		command  = command;
% 	else
% 		command  = [command ' -f'];
% 	end
% 	if (isempty(outputfile))
% 		command  = command;
% 	else
% 		command  = [command ' -p > ' outputfile{1}];                    % SHOULD BE THE LAST OPTION AS REDIRECTING STD OUTPUT
% 	end
	
% case 'undocheckout'
%	command      = 'rcs -q -u';
end

[status, returnMessage] = dos([command files]);                     % Executing the command

if (strcmp(action, 'checkin'))                                          % Deleting the temp file
	delete(commentsFile);
end

 if (~isempty(returnMessage))                                            % With quiet option RCS does not provide any output.
     disp(returnMessage);                                               % Any output would mean error message.
 end

if (strcmp(action, 'undocheckout'))
	checkout(fileNames, 'lock', 'off', 'force', 'on');
end
