function scan_data = p10rd(ufilename,plotmode,verbose)
%P10RD Read Tencor P-10 surface profilometer data file
%
% SCAN_DATA = P10RD(UFILENAME,PLOTMODE,VERBOSE)
%
%P10RD reads the data from file UFILENAME.txt, and returns a 5-column
% array SCAN_DATA:
%  (:,1) is the horizontal position data in microns
%  (:,2) is the raw vertical profile data in microns
%  (:,3) is the levelled vertical profile data in microns
%  (:,4) is the Wav/A data (unscaled)
%  (:,5) is the Rough/A data (unscaled)
%
% Options:
% If VERBOSE == 0, no messages will be displayed.
% If VERBOSE == 1, the data summary will be displayed. (default)
% If VERBOSE == 2, the file header and data summary will be displayed.
% If PLOTMODE == 0, the data will not be displayed.
% if PLOTMODE == 1, the levelled data will be displayed in a new figure. (default)
% If PLOTMODE == 2, a second data plot with the raw data will be shown.
%
% If no input parameters are specified, the program is interactive, and the
% user will be prompted to enter a filename.
%
% NOTE: The function can only read ASCII text data files, not binary data files.
%  The name of the data file must have the extension ".txt", but you do not
%  need include the extension when specifying the file name.
%
% Examples:
%
%  If the data is stored in a text file called "mydata.txt", then:
%
%      p10rd mydata;
%
%  will load the file, plot the data, and print a summary. You can also use:
%
%      p10rd;
%
%  and you will be prompted for the file name. The command:
%
%      profile_data=p10rd('mydata',0,1);
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
versionstr='p10rd 1.3';

% MH Jul2013
% v1.3  add uifileget
% MH Sep2012
% v1.2  updates for modern matlab
% MH MAY2007
% v1.1  re-order input (verbose last)
%       filename w/ or w/o .txt
% MH OCT2006
% v1.0 out of beta
%
%#ok<*NBRAK>

% handle input arguments - set defaults
% default to verbose mode 1 (summary only)
if nargin < 3
    verbose = 1;
end

% default to plot mode 1 (levelled data only)
if nargin < 2
    plotmode = 1;
end

% get interactive if not being called by another program
if (nargout == 0)
    if (verbose >= 1 && nargin == 0)
        clc;
        fprintf(1, '\n\n  %s\n  %s\n\n', versionstr, 'Read in Tencor P-10 data files');
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
    [ufilename, ufilepath]=uigetfile('.txt','Select the Tencor P-10 data file');
    if isequal(ufilename,0)
        scan_data=[];
        return
    end
    userfilename=fullfile(ufilepath,ufilename);
    %userfilename=input(' Enter the name of the Dektak XT .csv file: ','s');
end

% open the file
userfile=fopen(userfilename);
[fpath, fname, fext]=fileparts(userfilename);


%%%%
% process the file header
% the first 5 lines are header information
% read them in and get some data: scan length, number of points, etc.
if verbose == 2
    fprintf(1,'\n\n %s\n %s %s\n\n %s\n\n', versionstr, 'Filename:', fname, 'File header:');
end

% additional linein statements should handle unix/DOS ASCII/ANSI problem
%  [note: investigate this further]

% line 1: filename and date
linein=fgetl(userfile);
if isempty(linein), linein=fgetl(userfile); end % spurious carriage returns?
if verbose == 2
    fprintf(1,' %s\n', linein);
end
scan_date=sscanf(linein,'* %*s %s',1);

% line 2: number of data points
linein=fgetl(userfile); 
if isempty(linein), linein=fgetl(userfile); end % spurious carriage returns?
if verbose == 2
    fprintf(1,' %s\n', linein);
end
% %  because the bastards use tabs instead of spaces, we have to 
% %   parse the line to isolate the number at the start of it
% lspace=0; % initialize
% for i=1:8
%     if isspace(linein(i))
%         lspace=i;
%         break
%     end
% end
% num_points=str2num(linein(1:lspace-1));
num_points=sscanf(linein,'%d',1);

% line 3: length of scan (um)
linein=fgetl(userfile); % line 3: length of scan (um)
if isempty(linein), linein=fgetl(userfile); end % spurious carriage returns?
if verbose == 2
    fprintf(1,' %s\n', linein);
end
scan_length=sscanf(linein,'%d',1);

%line 4: "A per Y count"
% (I believe this represents the minimum vertical resolution for the scan)
linein=fgetl(userfile); 
if isempty(linein), linein=fgetl(userfile); end %spurious carriage returns?
if verbose == 2
    fprintf(1,' %s\n', linein);
end

%line 5: column headers
linein=fgetl(userfile);
if isempty(linein), linein=fgetl(userfile); end
if verbose == 2
    fprintf(1,' %s\n', linein);
end

%the position of the data points is now known
% the P-10 appears to add spurious data points, i.e. 700um scan, 702 data points
%  ignore step
% stepsize=scan_length/num_points;
%rstep=round(stepsize);
%if rstep-stepsize <= 0.005
%    stepsize=rstep; %the scan length is effectively lengthed slightly
%end



%%%%
% get data from file
%  data is formatted in 5 columns
%  column 1 is horizontal position in um
%  column 2 is the "raw data" in Angstroms
%  column 3 is the levelled data in Angstroms
%  column 4 is "Wav/A" ??
%  column 5 is "Rough/A" ?? surface roughness?

d=textscan(userfile,'%f %f %f %f %f',inf);
scan_data(:,1)=d{1};
scan_data(:,2)=d{2};
scan_data(:,3)=d{3};
scan_data(:,4)=d{4};
scan_data(:,5)=d{5};
count=size(scan_data,1);
sd=diff(scan_data(:,1));
if all(sd==sd(1))
    stepsize=sd(1);
else
    stepsize=scan_length/num_points;
end

% close the file
fclose(userfile);


%adjust data point number to be position
%scan_data(:,1)=scan_data(:,1).*stepsize;
%scale data to um from Angstroms
scan_data(:,2:5)=scan_data(:,2:5)./10000;

% plot
% plot the raw data
if plotmode >= 1
    
    figure;
    plot(scan_data(:,1),scan_data(:,2),'.-b');
    title(['p10rd: ' fname],'Interpreter','none','FontSize',16,'FontWeight','bold');
    xlabel('Scan Length (\mum)','FontSize',14);
    ylabel('Profile (\mum)','FontSize',14);
    grid on;
    
end

% plot the levelled data
if plotmode == 2
    
    hold on
    plot(scan_data(:,1),scan_data(:,3),'.-g');
    legend('Raw Data','Levelled Data');
    
end


%print summary data
if verbose >= 1
    
    fprintf(1,'\n');
    fprintf(1,' %s\n', 'Data Summary:');
    fprintf(1,'\n');
    fprintf(1,' %s %s\n', 'File name:', [fname fext]);
    if ~isempty(scan_date)
        fprintf(1,' %s %s\n','Scan Date:',scan_date);
    end
    
    fprintf(1,'\n');
    
    fprintf(1,' %s %i\n', 'Number of data points read:', count);
    fprintf(1,' %s %g %s\n', 'Scan Length:', scan_length, 'um');
    fprintf(1,' %s %d %s\n %s %d %s\n %s %g %s\n',...
        'Scan Start:', scan_data(1,1), 'um', 'Scan End:',...
        scan_data(end,1), 'um', 'Scan Step:', stepsize, 'um');
    
    fprintf(1,'\n');
    
end


