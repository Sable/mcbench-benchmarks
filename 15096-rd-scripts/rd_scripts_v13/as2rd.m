function scan_data = as2rd(ufilename,plotmode,verbose)
%AS2RD - read AlphaStep 200 surface profilometer data file
%
%SCAN_DATA = AS2RD(UFILENAME,PLOTMODE,VERBOSE)
%
%AS2RD reads the data from file UFILENAME.txt, and returns a 2-column
% array SCAN_DATA:
%  (:,1) is the horizontal position data in microns
%  (:,2) is the vertical profile data in microns
%     Note that the AlphaStep 200 can save data in either microns (um) or
%      kiloAngstroms (kA). The scale is read from the file header, and if
%      the data is in KA, it is converted to um.
%
% Options:
% If VERBOSE == 0, no messages will be displayed.
% If VERBOSE == 1, the data summary will be displayed. (default)
% If VERBOSE == 2, the file header and data summary will be displayed.
% If PLOTMODE == 0, the data will not be displayed.
% if PLOTMODE == 1, the data will be displayed in a new figure. (default)
%
% NOTE: Assumes no zooming of the data on the AlphaStep before it is saved
%  to a file.
%
% NOTE: The function can only read ASCII text data files, not binary data
%  files. If you supply a filename without an extension, the extension
%  ".txt" is appended.
%
% Examples:
%
%  If the data is stored in a text file called "mydata.txt", then:
%
%      as2rd mydata;
%
%  will load the file, plot the data, and print a summary. You can also use:
%
%      as2rd;
%
%  and you will be prompted for the file name. The command:
%
%      profile_data=as2rd('mydata',0,1);
%
%  will open the file mydata.txt, plot the data,
%   and save the data to the variable profile_data in the workspace without
%   displaying a plot of the data.
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
versionstr='as2rd 1.3';

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

% handle input arguments
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
        fprintf(1, '\n\n  %s\n  %s\n\n', versionstr, 'Load AlphaStep 200 data files');
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
    [ufilename, ufilepath]=uigetfile('.txt','Select the AlphaStep 200 data file');
    if isequal(ufilename,0)
        scan_data=[];
        return
    end
    userfilename=fullfile(ufilepath,ufilename);
    %userfilename=input(' Enter the name of the AlphaStep 200 .txt file: ','s');
end

% open the file
userfile=fopen(userfilename);
[fpath, fname, fext]=fileparts(userfilename);


%%%%
% process the file header

% the first 13 lines are header information
% read and process them
if verbose == 2
    fprintf(1,'\n\n %s\n %s %s\n\n %s\n\n', versionstr, 'Filename:',...
        fname, 'File header:');
end

% the first line is the date and time
linein=fgetl(userfile);
% handle spurious carriage returns
if isempty(linein), linein=fgetl(userfile); end
% save the date and time
scan_date=sscanf(linein,'%s',1);
scan_time=sscanf(linein,'%*s %s',1);

if verbose == 2, fprintf(1,'%s\n',linein); end

% the next line is the Vertical scale. We read it to determine whether the
%  data is in microns ("um") or Angstroms ("KA")
linein=fgetl(userfile); % format is "VERT.*xxx"
% handle spurious carriage returns
if isempty(linein), linein=fgetl(userfile); end
if strfind(linein,'um')
    scaleFactor=0;
elseif strfind(linein,'KA')
    scaleFactor=10;
else
    scaleFactor=0;
    fprintf(1,'WARNING: The vertical data scale (um or KA) was not scanned from the data file.');
end

if verbose == 2
    fprintf(1,'%s\n',linein); % print the line we just evaluated
end

% skip the next 9 lines
for i=1:9
    linein=fgetl(userfile);
    if verbose == 2
        fprintf(1,'%s\n',linein);
    end
end

% line 12 has the stylus force
linein=fgetl(userfile); % format is " [text] STYLUS xmg"
% handle spurious carriage returns
if isempty(linein), linein=fgetl(userfile); end

t=textscan(linein,'%*s STYLUS %dmg');
stylus_force=t{1};

if verbose == 2
    fprintf(1,'%s\n',linein); % print the line we just evaluated
end

% skip line 13
linein=fgetl(userfile);
if verbose == 2
    fprintf(1,'%s\n',linein);
end

%%%%
% get data
%  data is formatted in 11 columns
%  the first column is the horizontal position for the first data point in the row
%  the remaining ten columns are vertical measurement data


ind=1;
pointsPerRow=10; % always true, afaik
while ~feof(userfile)
    if ind==1 % for the first line only, save the horizontal position
        h=fscanf(userfile,'%fum:',1); % get horizontal start position
        scan_data(ind,1)=h;                                                %#ok<AGROW>
    else
        hlast=h;
        h=fscanf(userfile,'%fum:',1); % get horizontal position
        delta=h-hlast; % measure the s/um
    end
    [datain,count]=fscanf(userfile,'%f',pointsPerRow); % get the ten data points
    scan_data(ind:ind+count-1,2)=datain;
    ind=ind+count; % ten points per row
    if count ~= pointsPerRow, break, end

end

ind=ind-1; % reset ind to be a correct count of the number of points
stepsize=delta/pointsPerRow;
scan_data(ind,1)=h; % save last horizontal position in the data array
scan_data(1:ind,1)=[scan_data(1,1):stepsize:scan_data(ind,1)].'; % horizontal position
scan_data=scan_data(1:ind,:); % discard the extra zeros

% scale data to um if necessary
if scaleFactor>0
    scan_data(:,2)=scan_data(:,2)./scaleFactor;
end


% close the file
fclose(userfile);



% plot
if plotmode >= 1
    
    figure;
    plot(scan_data(:,1),scan_data(:,2),'.-');
    title(['as2rd: ' fname],'Interpreter','none','FontSize',16,'FontWeight','bold');
    xlabel('Scan Length (\mum)','FontSize',14);
    ylabel('Profile (\mum)','FontSize',14);
    grid on;
    
end


% print some data to the console
if verbose >= 1
    
    fprintf(1,'\n');
    fprintf(1,' %s\n', 'Data Summary:');
    fprintf(1,'\n');
    fprintf(1,' %s %s\n', 'File name:', [fname fext]);
    fprintf(1,' %s %s %s\n','Scan Date:',scan_date,scan_time);
    
    fprintf(1,'\n');
    
    fprintf(1,' %s %d\n', 'Number of data points read:', ind);
    fprintf(1,' %s %d %s\n', 'Scan Length:', scan_data(ind,1)-scan_data(1,1), 'um');

    fprintf(1,' %s %.2f %s\n', 'Scan Step:', stepsize, 'um');
    fprintf(1,' %s %d mg\n','Nominal stylus force:',stylus_force);
    
    fprintf(1,'\n');
    
end



