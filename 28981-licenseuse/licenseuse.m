function [userCount, licenseCount] = licenseuse(toolbox,verbose)
%LICENSEUSE Counts licenses currently checked out from a license server.
% [USERCOUNT, LICENSECOUNT] = LICENSEUSE(TOOLBOX,VERBOSE)
%  Returns the number of current users of the feature TOOLBOX for a Matlab
%   installation that uses a shared network license. LICENSEUSE can also
%   display the usernames and computer names of the users who have the
%   licenses checked out. LICENSEUSE uses the Flexlm(R) license manager
%   utility to get information about the network license status.
%
% TOOLBOX is the Flexlm license manager's name for each Matlab toolbox.
%   Leave empty to count all available toolboxes plus Matlab base licenses.
%   The license manager's name for a toolbox can be found by inspecting the
%   output from
%     >> licenseuse([],2);
%   Correct capitalization is required.
% VERBOSE (0|1|2) is the level of messages printed on the command line.
%   Use VERBOSE=2 to see a list of current users for each toolbox, or to
%   see a list of all available toolboxes if TOOLBOX=[].
%
% USERCOUNT     The total number of MATLAB licenses in use.
% LICENSECOUNT  The total number of licenses available to you. If TOOLBOX
%   is not included in your license, LICENSECOUNT=-1.
%  (Note: The number of licenses remaining that can be checked out for
%      TOOLBOX is equal to LICENSECOUNT - USERCOUNT)
%
% Examples:
%  To display a list of the current users of the Instrument Control Toolbox,
%   use:
%
%  >> licenseuse('Instr_Control_Toolbox',2);
%
%  To return a count of the number of current users of MATLAB on your
%   license, use
%
%  >> [usersMatlab, licensesMatlab] = licenseuse('MATLAB');
%
%
% Note that the only way to release a license is to exit Matlab.
%
%   See also LICENSEUSER, LICENSE, VER.
%
%
% Matt Hopcroft
%  mhopeng@gmail.com
%

% MH Nov 2012
% v2.11 find file for Windows or *nix
% v2.1  update for new location of lm utilities (R2010b+)
% MH Apr2012
% v2.0  counts user/licenses and returns results
%       changed "all" behaviour- counts MATLAB + toolboxes
%       added VERBOSE parameter, improved results reporting
%       fixed help file/comments
% MH Apr2011
% v1.1  added error message
% MH Oct2010
% v1.0
%

% Note: See the an updated MATLAB help page for FlexLM utilities at:
%  http://www.mathworks.fr/support/tech-notes/1300/1303.html


%% Welcome
if nargin < 2
    if nargin < 1 || isempty(toolbox) || strcmp(toolbox,'MATLAB')
        verbose=2;
    else
        verbose=1;
    end
end
if verbose >= 1, fprintf(1,'licenseuse v2.11: %s\n',datestr(clock)); end

if nargin < 1 || isempty(toolbox)
    if verbose >= 1, fprintf(1,'licenseuse: Checking for users of all MATLAB products on your license...\n'); end
    toolboxStr = '-a';
else
    if verbose >= 1, fprintf(1,'licenseuse: Checking for current users of MATLAB "%s"...\n',toolbox); end
    toolboxStr = ['-f ' toolbox];
end

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
[ltstat, lt]=system(['.' filesep 'lmutil lmstat -c "' matlabroot filesep 'licenses' filesep 'network.lic" ' toolboxStr]);
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


%% Count number of users
tlines=textscan(lt,'%s','delimiter','\n'); tlines=tlines{1};
tIndC=strfind(tlines,'Total of');
licenseCount=0; % number of licenses available to you ("issued")
userCount=0;    % number of users that have checked out a license ("in use")
toolboxFound=0;
for i = 1:length(tIndC)
    if ~isempty(tIndC{i})
        if strcmp(toolboxStr,'-a') % if -a, count users of matlab and all users
            if ~isempty(strfind(tlines{i},'Users of MATLAB:'))
                mCount=textscan(tlines{i},'Users of MATLAB:  (Total of %d %*s issued; Total of %d %*s in use)',1);
                userCountMatlab=mCount{2};
                licenseCountMatlab=mCount{1};
            else
                uCount=textscan(tlines{i},'Users of %*s (Total of %d %*s issued; Total of %d %*s in use)',1);
                userCount=userCount+uCount{2};
                licenseCount=licenseCount+uCount{1};
            end
        else % else, look for only the requested toolbox
            if ~isempty(strfind(tlines{i},toolbox))
                toolboxFound=1;
                uCount=textscan(tlines{i},['Users of ' toolbox ': (Total of %d %*s issued; Total of %d %*s in use)'],1);
                userCount=uCount{2};
                licenseCount=uCount{1};
            end
        end
    end
end


%% Report results
if verbose >= 1
    if verbose >= 2, fprintf(1,'licenseuse: Results:\n'); end
    if strcmp(toolboxStr,'-a')
        fprintf(1,'  There are %d MATLAB licenses in use out of %d available to you,\n',userCountMatlab,licenseCountMatlab);
        fprintf(1,'   and %d additional toolbox licenses in use out of %d available to you.\n\n',userCount,licenseCount);
        userCount=userCount+userCountMatlab;
        licenseCount=licenseCount+licenseCountMatlab;
    else
        if toolboxFound==0
            fprintf(1,'  There do not appear to be any licenses for "%s" available to you.\n',toolbox);
            fprintf(1,'  Check for typos in the toolbox name, and/or try using the ''ver'' command,\n');
            fprintf(1,'   and/or verify that the license server is up (use VERBOSE=2).\n\n');
            licenseCount=-1;
        else
            fprintf(1,'  There are %d %s licenses in use out of %d available to you.\n\n',userCount,toolbox,licenseCount);
        end        
    end        
end
