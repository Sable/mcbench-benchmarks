function scan_data = dk2rd(ufilename,plotmode,verbose)
%DK2RD - read Dektak IIA surface profilometer data file
%
% SCAN_DATA = DK2RD(UFILENAME,PLOTMODE,VERBOSE)
%
%DK2RD reads the data from file UFILENAME.txt, and returns a 2-column
% array SCAN_DATA:
%  (:,1) is the horizontal position data in microns
%  (:,2) is the vertical profile data in microns
%     Note that the data saved in the file is in units of Angstroms, but it
%      is returned as microns (um).
%
% Options:
% If VERBOSE == 0, no messages will be displayed.
% If VERBOSE == 1, the data summary will be displayed. (default)
% If VERBOSE == 2, the file header and data summary will be displayed.
% If PLOTMODE == 0, the data will not be displayed.
% if PLOTMODE == 1, the data will be displayed in a new figure. (default)
%
% NOTE: DK2RD only reads the first section of a Dektak IIA data file; so if
%  the data on the screen has been zoomed before saving, DK2RD will only
%  return the zoomed data.
%
% NOTE: The function can only read ASCII text data files, not binary data
%  files. If you supply a filename without an extension, the extension
%  ".txt" is appended.
%
% Examples:
%
%  If the data is stored in a text file called "mydata.txt", then:
%
%      dk2rd mydata;
%
%  will load the file, plot the data, and print a summary. You can also use:
%
%      dk2rd;
%
%  and you will be prompted for the file name. The command:
%
%      profile_data=dk2rd('mydata',0,1);
%
%  will open the file mydata.txt, plot the data,
%   and save the data to the variable profile_data in the workspace
%   without printing anything in the command window. 
%
% Note: For information about downloading data from the serial ports of
% various profilometers, see:
%   http://micromachine.stanford.edu/~hopcroft/Shared/profilometer.html#serial
%
%
% M.A. Hopcroft
%  mhopeng at gmail dot com
%
% The license governing use of this code is in the accompanying file
%  "license.txt".
%
versionstr='dk2rd 1.3';

% MH Jul2013
% v1.3  add uifileget
% MH Sep2012
% v1.2  updates for modern matlab
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
        fprintf(1, '\n\n  %s\n  %s\n\n', versionstr, 'Load Dektak IIA data files');
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
% the header is 11 lines, but only the first 8 need to be printed
%  to the command window in verbose mode
% (ver 0.98) change header processing, because some data files may have
% some blank lines missing (possibly different data acquisition method?)

if verbose == 2
    fprintf(1,'\n\n %s\n %s %s\n\n %s\n\n', versionstr, 'Filename:', fname, 'File header:');
end

while 1
    % read header lines, until we get to the LEFT line
    linein=fgetl(userfile);
    % handle spurious carriage returns
    if isempty(linein), linein=fgetl(userfile); end
    
    if length(linein) >= 4 % if it is not a blank line
        if strcmp(linein(1:4),'DATE')
            scan_date=sscanf(linein,'%s %s',2);
            scan_date=scan_date(5:end);
        elseif strcmp(linein(1:4),'TIME')
            scan_time=sscanf(linein,'%s %s',2);
            scan_time=scan_time(5:end);
        elseif strcmp(linein(1:5),'SPEED')
            scan_speed=sscanf(linein,'%s %s',2);
            scan_speed=scan_speed(6:end);
        elseif strcmp(linein(1:4),'LEFT')
			left=sscanf(linein, '%*s %*s %g'); % ignore the label "LEFT ="
			%left=left(6); % isolate the value of LEFT
            break; % done reading header
        end
    end
    
    % print the line to the command window if verbose mode 2 is set
    if verbose == 2
        fprintf(1,'%s\n',linein);
    end
end



%%%%
% get data
% The data begins with the label LEFT=X, where X is the starting horizontal
%  position for the display data. X should generally be zero for most applications,
%  but it will be something else if the user zoomed the data before sending.
% Note that ONLY the first data section encountered will be processed; if the
%  user zoomed the view on the Dektak before sending data, only the zoomed
%  portion will be processed by DK2RD.


% get data
% data is just a list of vertical measurement values in Angstroms.
scan_data(:,2)=fscanf(userfile,'%f',inf); % continue until end

% fscanf(inf) will continue reading data points until an inappropriate
%  value is found. This value will be the label RIGHT=Y, where Y is the
%  final horizontal position value.

% get the end number of points
%linein=fscanf(userfile, '%s',2); % ignore the label RIGHT =
right=fscanf(userfile, '%*s %*s %g');

%%%%
% process data for output

% rescale deflection data to um from Angstroms
scan_data(:,2)=scan_data(:,2).*1e-4;

% set the horizontal postion data to fit scan length
% scan_data(:,1) will have position values in um
%  The dektak reports the positions LEFT and RIGHT as indexes to an array,
%   not as an actual position. Therefore, there is no data at position LEFT.
%   Data starts at LEFT+STEPSIZE, is taken every STEPSIZE, and ends at
%   RIGHT=STEPSIZE*STEPS
%

% determine the step size
stepsize=(right-left)/length(scan_data);
% create the x data
scan_data(:,1)=[left+stepsize:stepsize:right]'; 

if verbose == 2
    fprintf(1,'%s %g\n%s %g\n%s %g\n', 'LEFT:', left, 'RIGHT:', right, 'STEPSIZE:', stepsize);
end

% close the file
fclose(userfile);


%%%%
% plot
if plotmode == 1
    
    figure;
    plot(scan_data(:,1),scan_data(:,2),'.-');
    title(['dk2rd: ' fname],'Interpreter','none','FontSize',16,'FontWeight','bold');
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
    fprintf(1,' %s %s %s\n','Scan Date:', scan_date, scan_time);
    
    fprintf(1,'\n');
    
    fprintf(1,' %s %s\n', 'Scan Speed:', scan_speed);
    fprintf(1,' %s %g\n', 'Number of data points read:', size(scan_data,1));
    fprintf(1,' %s %g %s\n', 'Scan Length:', right-left, 'um');
    fprintf(1,' %s %g %s\n', 'Step Size:', stepsize, 'um');
    fprintf(1,'\n');
    
end

