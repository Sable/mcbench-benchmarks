function scan_data = dk3rd(ufilename,plotmode,verbose)
%DK3RD - load Dektak 3ST surface profilometer data file
%
% SCAN_DATA = DK3RD(UFILENAME,PLOTMODE,VERBOSE)
%
%DK3RD reads the data from file UFILENAME.txt, and returns a 2-column
% array SCAN_DATA:
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
% NOTE: The function can only read ASCII text data files, not binary data
%  files. If you supply a filename without an extension, the extension
%  ".txt" is appended.
%
% Examples:
%
%  If the data is stored in a text file called "mydata.txt", then:
%
%      dk3rd mydata;
%
%  will load the file, plot the data, and print a summary. You can also use:
%
%      dk3rd;
%
%  and you will be prompted for the file name. The command:
%
%      profile_data=dk3rd('mydata',0,1);
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
versionstr='dk3rd 1.3';

% MH Jul2013
% v1.3  add uifileget
% MH Sep2012
% v1.2  updates for modern matlab
%
% MH MAY2007
% v1.1  re-order input (verbose last)
%       filename w/ or w/o .txt
%
% MH OCT2006
% v1.0 out of beta
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
        fprintf(1, '\n\n  %s\n  %s\n\n', versionstr, 'Load Dektak 3ST data files');
    end
end


%%%%
% open user's file
if nargin >= 1 % if the user already specified a file, use it
    userfilename=ufilename;
    
    % check to see if file exists
    cfid=fopen(userfilename);
    if cfid== -1
        % try with ".txt"
        userfilename=strcat(userfilename,'.txt');
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
    [ufilename, ufilepath]=uigetfile('.txt','Select the Dektak 3 data file');
    if isequal(ufilename,0)
        scan_data=[];
        return
    end
    userfilename=fullfile(ufilepath,ufilename);
    %userfilename=input(' Enter the name of the Dektak 3 .txt file: ','s');
end

% open the file
userfile=fopen(userfilename);
[fpath, fname, fext]=fileparts(userfilename);


%%%%
% process the file header
% the first 44 lines are header information
%  read them in and get some data: scan length, number of points, etc.
% display the header for plotmode 2 only
if verbose == 2
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
    % figure out where the ":" is so we can divide the line
    id_pos=find(linein==':');
    % some lines may be malformed or empty, especially in Dektak 8 data
    %  files
    if ~isempty(id_pos)
        id_pos=id_pos(1); % some lines have additional :'s
        % line_id is the identifier
        line_id=linein(1:id_pos);
        % line_data is everything following the identifier
        if length(linein)>id_pos(1) && strcmp(linein(id_pos+1),':')
            line_data=linein(id_pos+2:end);
        else
            line_data=linein(id_pos+1:end);
        end
    else
        % line_id is the identifier
        line_id=linein;
    end
    
    % check to see if the line identifier is interesting, if so, scan
    % the data from line_data. exit when SCALED DATA is reached
    
    if strcmp(line_id,'Sclen:')==1
        scan_length=sscanf(line_data,'%g',1);
    elseif strcmp(line_id,'Units:')==1
        headerUnits=sscanf(line_data,'%s',1); % check for unusual "units" value
        if ~strcmpi(headerUnits,'SCI')
            fprintf(1,'dk3rd: WARNING: Header Units value is "%s".\n  Data is assumed to have units of Angstroms. You should verify this.\n',headerUnits);
        end
    elseif strcmp(line_id,'NumPts:')==1
        num_points=sscanf(line_data,'%g',1);
    elseif strcmp(line_id,'Hsf:')==1
        stepsize=sscanf(line_data,'%g',1);
    elseif strcmp(line_id,'Force:')==1
        stylus_force=sscanf(line_data,'%e',1);
    elseif strcmp(line_id,'Date:')==1
        scan_date=sscanf(line_data,'%s',1);
        scan_time=sscanf(line_data,'%*s %s',1);
    elseif strcmp(line_id,'Speed:')==1
        scan_speed=sscanf(line_data,'%s',1);
    elseif strcmp(line_id,'Data Res:')==1
        data_res=sscanf(line_data,'%s',1);
    elseif strcmp(line_id,'SCALED DATA:')==1
        break % exit loop
    end
    

    
    % print the line to the command window if verbose mode 2 is set
    if verbose == 2
        % avoid printing empty lines
        if ~isempty(linein)
            fprintf(1,'%s\n',linein);
        end
    end
    
    
    % error if no : found; maybe this is not a dk3 file?
    if linein == -1
        error('dk3rd: ERROR: file appears to be corrupted or not a Dektak 3 data file.');
    end
    
end



%%%%
% get data from file
%  data is a simple list of vertical position in Angstroms
%   (formatted in 5 columns of text)

% create the x axis
scan_data(:,1)=[stepsize:stepsize:scan_length]';

% read the data points
[scan_data(:,2),count]=fscanf(userfile,'%f',inf);
if count~=num_points
    fprintf(1,'dk3rd: WARNING: The number of data points (%g) does not equal the value in the file header (%g).\n  The file may be corrupted.',...
        count,num_points);
end
% scale data to um from Angstroms
scan_data(:,2)=scan_data(:,2)./10000;


% close the file
fclose(userfile);


% plot
if plotmode == 1
    
    figure;
    plot(scan_data(:,1),scan_data(:,2));
    title(['dk3rd: ' fname],'Interpreter','none','FontSize',16,'FontWeight','bold');
    xlabel('Scan Length (\mum)','FontSize',14);
    ylabel('Profile (\mum)','FontSize',14);
    grid on;
    
end


% print summary data for the user
if verbose >= 1
    
    fprintf(1,'\n');
    fprintf(1,' %s\n', 'Data Summary:');
    fprintf(1,'\n');
    fprintf(1,' %s %s\n', 'File name:', [fname fext]);
    fprintf(1,' %s %s %s\n','Scan Date:',scan_date,scan_time);
    
    fprintf(1,'\n');
    
    fprintf(1,' %s %s%s %s\n', 'Data Res.:', data_res, '; Scan Speed:', scan_speed);
    fprintf(1,' %s %d\n', 'Number of data points read:', count);
    fprintf(1,' %s %d %s\n', 'Scan Length:', scan_length, 'um');
    fprintf(1,' %s %g %s\n', 'Scan Step:', stepsize, 'um');
    fprintf(1,' %s %g %s\n', 'Nominal Stylus Force:', stylus_force, 'mg'); 
    
    fprintf(1,'\n');
    
end


