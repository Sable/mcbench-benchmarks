function customverctrl(fileNames, arguments)
%CUSTOMVERCTRL Custom version control for ComponentSoftware's RCS.
%
%   CUSTOMVERCTRL(FILENAMES, ARGUMENTS) Performs the requested action 
%   with ARGUMENTS options (name/value pairs) as specified below.
%   FILENAMES must be the full path of the file or a cell array
%   of files.
%
%   OPTIONS:
%      action - The version control action to be performed.
%         checkin
%         checkout
%         undocheckout
%   
%      lock - Locks the file.
%         on
%         off
%
%      revision - Performs the action on the specified revision. 
%
%      outputfile - Writes file to outputfile.
%
%    Get the ComponentSoftware's free personal RCS version from:
%    http://www.componentsoftware.com/
%
%    See also CHECKIN, CHECKOUT, UNDOCHECKOUT, CMOPTS, CUSTOMVERCTRL,
%    SOURCESAFE, CLEARCASE, PVCS, and RCS
%

%   Modified from RCS.M for CSRCS by Sakari.Lukkarinen@comsol.fi, 20-Sep-2001

%   Modify this line to point to CSRCSW
cmdfile = '"C:\Program Files\ComponentSoftware\CS-RCS\System\csrcsw"';

% for quiet mode use '/q', otherwise ' '
isquiet = ' ';

action           = arguments(find(strcmp(arguments, 'action')), 2);     % Mandatory argument
lock             = arguments(find(strcmp(arguments, 'lock')), 2);       % Assumed as OFF for checkin and ON for checkout
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
	command      = ['checkin /m@' commentsFile ' /m' comments];             % Building the command string.
	
	if (isempty(lock))
		lock     = 'off';
	else
		lock     = lock{1};                                              % De-referencing
	end
	if (strcmp(lock, 'on'))
		command  = [command ' /l'];
	else
		command  = [command ' /u'];
	end
case 'checkout'
	if (isempty(lock))
		lock     = 'off';
	else
		lock     = lock{1};                                              % De-referencing
	end
	if (isempty(revision))
		revision = '';
	else
		revision = revision{1};                                          % De-referencing
	end
	if (isempty(force))
		force   = '';
	else
		force   = force{1};                                              % De-referencing
	end
	
	command      = 'checkout';                                              % Building the command string.
	if (strcmp(lock, 'on'))
		command  = [command ' /l'];
	else
		command  = [command ' /u'];
	end
    
	if (isempty(revision))
		command  = command;
	else
		command  = [command ' /n' revision];
	end

	if (isempty(force))
		command  = command;
	else
		command  = [command ' /f'];
	end
case 'undocheckout'
    command = 'update';
end;
command = [cmdfile ' ' command ' ' isquiet ' ' files];

[status, returnMessage] = dos(command);                     % Executing the command
 
if (strcmp(action, 'checkin'))                              % Deleting the temp file
	delete(commentsFile);
end

% These lines seems to give error messages, thus commented out
% if (~isempty(returnMessage))                                            % With quiet option RCS does not provide any output.
%     error(returnMessage);                                               % Any output would mean error message.
% end

if (strcmp(action, 'undocheckout'))
	checkout(fileNames, 'lock', 'off', 'force', 'on');
end