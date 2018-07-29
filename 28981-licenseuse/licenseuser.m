function num = licenseuser(username,verbose)
%LICENSEUSER Displays the names of users who have a license checked out.
% NUM = LICENSEUSER(USERNAME) displays the feature toolboxes that are
%  currently checked out by USERNAME from a shared network license.
%  LICENSEUSER uses the Flexlm (R) license manager utility to get
%  information about the license status.
%
% USERNAME is the username on the host system. Default, if USERNAME is not
%  given, is to try and get the username of the current user from the host.
% VERBOSE (0|1|2) is the level of messages printed on the command line.
%
% NUM returns the total number of licenses checked out by USERNAME.
%
% Example:
%  To see a list of the toolboxes that user wsmith is using, use:
%
%  >> licenseuser('wsmith')
%
%
% Note that the only way to release a license is to exit Matlab.
%
%   See also LICENSEUSE, LICENSE, VER.
%
%
% Matt Hopcroft
%  mhopeng@gmail.com
%

% MH Nov2012
% v2.01 handle Win/Mac/Linux environment username 
% v2.0  update for current Matlab releases (& sync with licenseuse)
% MH Jun2011
% v1.1  return total number of licenses checked out
% MH Apr2011
% v1.0
%

%% Welcome
if nargin < 2
    verbose=1;
end
if verbose >= 1, fprintf(1,'licenseuser v2.01: %s\n',datestr(clock)); end

if nargin < 1 || isempty(username)
    % use this ridiculous logic to handle Win/Mac/Linux (v2.01)
    username=[];
    try %#ok<TRYNC>
        username = getenv('USER');
    end
    if isempty(username)
        try %#ok<TRYNC>
            username = getenv('USERNAME');
        end
    end
end

if isempty(username)
    error('licenseuser: Could not determine username');
end

% get the list of all active licenses ("-a")
fprintf(1,'licenseuser: Finding licenses checked out to "%s"...\n',username);

cdir=cd;


%% Determine path to lmutil
if isunix % v2.11
    lmExe='lmutil';
else
    lmExe='lmutil.exe';
end

lmPath=[matlabroot filesep 'bin' filesep computer('arch') filesep]; % prior to R2010b
if ~exist([lmPath lmExe],'file')
    lmPath=[matlabroot filesep 'etc' filesep computer('arch') filesep]; % R2010b+
    if ~exist([lmPath lmExe],'file')
        fprintf(1,'ERROR: "%s" not found in bin/ or etc/ locations!\n\n',lmExe);
        return
    end
end
if verbose >= 3, fprintf(1,'License manager utilities found at:\n  %s\n',lmPath); end

cd(lmPath);


%% Execute license manager command
[ltstat, lt]=system(['.' filesep 'lmutil lmstat -c "' matlabroot filesep 'licenses' filesep 'network.lic" -a']);

cd(cdir);

if ltstat ~= 0
    fprintf(1,'ERROR: "%s"\n',strtrim(lt));
    if strfind(lt, 'No such file')
        fprintf(1,'On Linux you may need to upgrade the package "lsb"\n  (see %s)\n',...
            'https://www.mathworks.com/support/solutions/en/data/1-GLXUHV/index.html?product=ML&solution=1-GLXUHV');
    end
    error('OS returned error %d when executing lmutil',ltstat);
else
    if verbose >= 2, disp(lt); end % display the license manager status
end

%% Process the list

% tline = 1; tlineMatch={};
% k=0; k2=0;

tlines=textscan(lt,'%s','delimiter','\n'); tlines=tlines{1};
tIndC=strfind(tlines,'Users of');
%length(tIndC)
uIndC=strfind(tlines,username);
% create numeric binary arrays
for i=1:length(tIndC)
    if isempty(tIndC{i})
        tInd(i)=0;                                                              %#ok<*AGROW>
    else
        tInd(i)=1;
    end
    if isempty(uIndC{i})
        uInd(i)=0;
    else
        uInd(i)=1;
    end
end

tlbInd=find(tInd);
usrInd=find(uInd);

if ~isempty(usrInd)
    num = length(usrInd);
    fprintf(1,'User %s has %d licenses checked out:\n',username,num);

    for i=usrInd
        tlbx=tlbInd(tlbInd<i);
        %tlines{tlbx(end)}
        toolbox=textscan(tlines{tlbx(end)},'Users of %s','Delimiter',':'); toolbox=toolbox{1};
        fprintf(1,' %s',toolbox{1});
        hostname=textscan(tlines{i},[username '%s']); hostname=hostname{1};
        fprintf(1,' (on host %s)\n',hostname{1});
    end    
    fprintf(1,'\n');
else
    fprintf(1,'No licenses found for username "%s".\n',username);
    num = 0;
end
