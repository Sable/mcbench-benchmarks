function scan_data = dkXTrd(ufilename,plotmode,verbose)
%DK8RD - load Dektak XT surface profilometer data file
%
% SCAN_DATA = DKXTRD(UFILENAME,PLOTMODE,VERBOSE)
%
%DKXTRD reads the data from file UFILENAME.txt, and and returns a 2-column
% array SCAN_dATA:
%  (:,1) is the horizontal position data in microns
%  (:,2) is the vertical profile data in microns
%
% Options:
% If VERBOSE == 0, no messages will be displayed.
% If VERBOSE == 1, the data summary will be displayed. (default)
% If VERBOSE == 2, the file header and data summary will be displayed.
% If PLOTMODE == 0, the data will not be displayed.
% if PLOTMODE == 1, the data will be displayed in a new figure. (default)
%
% NOTE: This function can only read ASCII text data files, not binary data
%  files. The Dektak XT saves comma-separated value files ("CSV"). If you
%  supply a filename without an extension, the extension ".csv" is
%  appended.
%
% Examples:
%
%  If the data is stored in a text file called "mydata.csv", then:
%
%      dkXTrd mydata;
%
%  will load the file, plot the data, and print a summary. You can also use:
%
%      dkXTrd;
%
%  and you will be prompted for the file name. The command:
%
%      profile_data=dkXTrd('mydata',0,1);
%
%  will open the file mydata.txt, plot the data,
%   and save the data to the variable profile_data in the workspace
%   without printing anything in the command window.
%
%
% M.A. Hopcroft
%  mhopeng at gmail dot com
%
% The license governing use of this code is in the accompanying file
%  "license.txt".
%
versionstr='dkXTrd 1.0';

%
% MH Sep2012
% v1.0  first release
%

%#ok<*NBRAK>

% handle input arguments - set defaults
% default to verbose mode 1 (summary only)
if nargin < 3
    verbose = 1;
end

% default to plot mode 1
if nargin < 2
    plotmode = 1;
end

% get interactive if not being called by another program
if (nargout == 0)
    if (verbose >= 1 && nargin == 0)
        clc;
        fprintf(1, '\n\n  %s\n  %s\n\n', versionstr, 'Load Dektak XT data files');
    end
end


%%%%
% open user's file
if nargin >= 1 % if the user already specified a file, use it
    userfilename=ufilename;
    
    % check to see if file exists
    cfid=fopen(userfilename);
    if cfid== -1
        % try with ".csv"
        userfilename=strcat(userfilename,'.csv');
        cfid=fopen(userfilename);
        if cfid== -1
            disp(pwd);
            fprintf(1,'ERROR: data file ["%s"] not found in current directory',userfilename);
            scan_data=[];
            return
        end
        fclose(cfid);
    end
    
else % if user did not specify the file name, ask for one
    [ufilename, ufilepath]=uigetfile('.csv','Select the Dektak XT data file');
    if isequal(ufilename,0)
        scan_data=[];
        return
    end
    userfilename=fullfile(ufilepath,ufilename);
    %userfilename=input(' Enter the name of the Dektak XT .csv file: ','s');
end


% open the file
userfile=fopen(userfilename);
[fpath, fname, fext]=fileparts(userfilename);               %#ok<NASGU>


%%%%
% Process the file header
% The first 20 or so lines are header information
%  In the test files that we have, the header is useless, so ignore it
% The data begins after the line with the word "Data" by itself
if verbose >= 2
    fprintf(1,'\n\n %s\n %s %s\n\n %s\n\n', versionstr, 'Filename:', fname, 'File header:');
end

% read header lines, if they are useful, save the info
while 1
    % get the first word on each line and check to see if it is important
    % the line identifier is followed by a ":", so break the line into
    %  two parts based on the :
    %  if the data is useful, scan it from the second part of the line
    
    % get a line from the file
    linein=fgetl(userfile);
    % handle spurious carriage returns
    if isempty(linein), linein=fgetl(userfile); end
    
    % data starts here
    if strcmp(linein,'Data')==1
        % the next line has the labels for the data
        % get a line from the file
        linein=fgetl(userfile);
        % handle spurious carriage returns
        if isempty(linein), linein=fgetl(userfile); end        
        labels=textscan(linein,'%s','Delimiter',','); labels=strtrim(labels{1});
        
        break % exit loop
    end
    
    
    % print the line to the command window if verbose mode 2 is set
    if verbose == 2
        % avoid printing empty lines
        if ~isempty(linein)
            fprintf(1,'%s\n',linein);
        end
    end
end


%%%%
% get data from file
%  data is a csv file
if verbose >= 2, fprintf(1,' File Data:\n\n'); end
    
% how many columns?
for k=1:length(labels)
    if ~isempty(labels{k})
        nCols=k;
        if verbose >1, fprintf(1,'Column %d: %s, ',k,labels{k}); end
    end
end
if verbose >1, fprintf(1,'\n'); end

data=textscan(userfile,'%f','Delimiter',','); data=data{1};
data=reshape(data,length(labels),[]);
data=data';

% detect and convert units
for k=1:nCols
    if strfind(labels{k},'mm')
        units{k}='mm';
        unitMult(k)=1000;
    elseif strfind(labels{k},'Ã')
        units{k}='A';
        unitMult(k)=0.1;
    elseif strfind(labels{k},'um')
        units{k}='um';
        unitMult(k)=1;
    end;
    if verbose >2, fprintf(1,'Column %d: %s,',k,units{k}); end
    % convert to um
    scan_data(:,k)=data(:,k).*unitMult(k);
end


% close the file
fclose(userfile);


% plot
if plotmode == 1
    
    figure;
    plot(scan_data(:,1),scan_data(:,2),'.-');
    title(['dkXTrd: ' fname],'Interpreter','none','FontSize',16,'FontWeight','bold');
    xlabel('Scan Length (\mum)','FontSize',14);
    ylabel('Profile (\mum)','FontSize',14);
    grid on;
    
end


% The Dektak XT does not appear to include any useful data in the header :(
% % print summary data for the user
% if verbose >= 1
%     
%     fprintf(1,'\n');
%     fprintf(1,' %s\n', 'Data Summary:');
%     fprintf(1,'\n');
%     fprintf(1,' %s %s\n', 'File name:', [fname fext]);
%     fprintf(1,' %s %s %s\n','Scan Date:',scan_date,scan_time);
%     
%     fprintf(1,'\n');
%     
%     fprintf(1,' %s %s\n', 'Scan Speed:', scan_speed);
%     fprintf(1,' %s %d\n', 'Number of data points read:', count);
%     fprintf(1,' %s %d %s\n', 'Scan Length:', scan_length, 'um');
%     fprintf(1,' %s %g %s\n', 'Scan Step:', stepsize, 'um');
%     fprintf(1,' %s %g %s\n', 'Nominal Stylus Force:', stylus_force, 'mg');
%     fprintf(1,'   %s\n', '[Note: stylus force is incorrectly reported by beta versions of Dektak 8 software]'); 
%     
%     fprintf(1,'\n');
%     
% end

%#ok<*AGROW>
