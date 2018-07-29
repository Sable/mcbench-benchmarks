function scan_data = as5rd(ufilename,plotmode,verbose)
%AS5RD - read AlphaStep 500 surface profilometer data file
%
% SCAN_DATA = AS5RD(UFILENAME,PLOTMODE,VERBOSE)
%
%AS5RD reads the data from file UFILENAME.txt, and returns a 2-column
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
%      as5rd mydata;
%
%  will load the file, plot the data, and print a summary. You can also use:
%
%      as5rd;
%
%  and you will be prompted for the file name. The command:
%
%      profile_data=as5rd('mydata',0,1);
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
versionstr='as5rd 1.3';

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

% default to plot mode
if nargin < 2
    plotmode = 1;
end

% get interactive if not being called by another program
if (nargout == 0)
    if (verbose >= 1 && nargin == 0)
        clc;
        fprintf(1, '\n\n  %s\n  %s\n', versionstr, 'Load AlphaStep 500 data files');
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
    [ufilename, ufilepath]=uigetfile('.txt','Select the AlphaStep 500 data file');
    if isequal(ufilename,0)
        scan_data=[];
        return
    end
    userfilename=fullfile(ufilepath,ufilename);
    %userfilename=input(' Enter the name of the AlphaStep 500 .txt file: ','s');
end

% open the file
userfile=fopen(userfilename);
[fpath, fname, fext]=fileparts(userfilename);


%%%%
% process the file header

% All of the lines in the data file are numbered; the first two lines are A,B.
%  Lines A,B,1-7 are header information
%  A and B are the AS500 database tags - ignore them
%  Lines 1-7 have various file and data specs - get the useful bits

if verbose == 2
    fprintf(1,'\n\n %s\n %s %s\n\n %s\n\n', versionstr, 'Filename:',...
        fname, 'File header:');
end

% ignore lines A, B
%disp('ignore A, B');
linein=fgetl(userfile);
% handle spurious carriage returns
if isempty(linein), linein=fgetl(userfile); end
if verbose == 2, fprintf(1,'%s\n',linein); end
linein=fgetl(userfile);
% handle spurious carriage returns
if isempty(linein), linein=fgetl(userfile); end
if verbose == 2, fprintf(1,'%s\n',linein); end

% line 1
%  record type
%disp('line 1');
linenum=fscanf(userfile,'%g',1); % get line number - must be 1 for valid data file
if linenum ~= 1
    error('This does not appear to be a valid AS500 data file');
end
record_type=fscanf(userfile,'%g',1); % record type
if record_type == 3
    error('as5rd cannot process AlphaStep 500 statistics files (record type 3)');
end
linein=fgetl(userfile); % ignore remainder of the line

% print the line if verbose mode 2
if verbose == 2
        fprintf(1,'  %g %g %s\n',linenum,record_type,linein);
end

% line 2 (recipe data)
% scan length, scan speed, vertical range, stylus force, sample rate
%disp('line 2');
linenum=fgets(userfile,3); % get line number
linein1=fgets(userfile,10); %ignore
scan_length=fscanf(userfile,'%g',1); % scan length in microns
scan_speed_code=fscanf(userfile,'%g',1); % scan speed code
linein2=fgets(userfile,19); %ignore
vertical_range_code=fscanf(userfile,'%g',1); % vertical range code
stylus_force1=fscanf(userfile,'%g',1); % stylus force, in tenths of mg
  stylus_force=stylus_force1/10;
sample_rate_code=fscanf(userfile,'%g',1); % sample rate code
linein3=fgets(userfile,10); %ignore
horizontal_units_code=fscanf(userfile,'%g',1); % horizontal units code

linein=fgetl(userfile); %ignore remainder of line

% print the line if verbose mode 2
if verbose == 2
        fprintf(1,'%s %s %g %g %s %g %g %g %s %g %s\n',linenum,linein1,...
            scan_length,scan_speed_code,linein2,vertical_range_code,...
            stylus_force1,sample_rate_code,linein3,horizontal_units_code,linein);
end

% line 3 (recipe data)
%  no useful info
linein=fgetl(userfile); %ignore remainder of line

% print the line if verbose mode 2
if verbose == 2
        fprintf(1,'%s\n',linein);
end

% line 4 (summary data) NOTE: errors in line 4 table (manual, Appendix C)
% time
%disp('line 4');
linein4=fgets(userfile,20); %ignore
time_int=fscanf(userfile,'%x',1); % time of scan (hex integer)
% convert the unix-style date number to MATLAB-style serial date number
  time_int=time_int/(3600*24); % convert seconds to days
  time_int=time_int+719529; % 719529 is the serial date number for Jan 1, 1970
  time_of_scan=datestr(time_int,0,1970);

linein=fgetl(userfile); %ignore remainder of line

% print the line if verbose mode 2
if verbose == 2
        fprintf(1,'%s %x %s\n',linein4,time_int,linein);
end

% line 5,6,7 (additional summary data)
% parameters, 3D min max - ignore
linein5=fgetl(userfile); %ignore remainder of line
linein6=fgetl(userfile); %ignore remainder of line
linein7=fgetl(userfile); %ignore remainder of line

% print the line if verbose mode 2
if verbose == 2
        fprintf(1,'%s\n%s\n%s\n',linein5,linein6,linein7);
end

% line 8 ("raw data or raw trace")
% some parameters about the data:
%  number of points, ADC gain, horizontal resolution
%disp('line 8');
linein8=fgetl(userfile);
l8data=sscanf(linein8,'%d %g %f %f');
num_points=l8data(2);
adc_gain=l8data(3);
horizontal_res=l8data(4);

% num_points=sscanf(linein8,'%g',1); % number of points in data trace
% adc_gain=fscanf(userfile,'%f',1); % ADC gain
% horizontal_res=fscanf(userfile,'%f',1); % horizontal resolution in microns

% linein=fgetl(userfile); %ignore remainder of line

% print the line if verbose mode 2
if verbose == 2
        fprintf(1,'%s %g %f %f %s\n',linein8,num_points,adc_gain,horizontal_res,linein);
end



%%%%
% get data
%  data starts at line 9, and all lines are numbered
%  data is formatted in 20 columns (+ line number)
%  The data is given in ADC counts - multiply by ADC gain to get result in
%  Angstroms

% set the horizontal position array (um)
scan_data(1:num_points,1)=[0:horizontal_res:horizontal_res*(num_points-1)]';

ind=1;
pointsPerRow=20; % always true, afaik
while ~feof(userfile)
    linenum=fscanf(userfile,'%g',1); %#ok<NASGU> % get line number
    [datain,count]=fscanf(userfile,'%g',pointsPerRow); % get the twenty data points
    scan_data(ind:ind+count-1,2)=datain;
    ind=ind+count; % twenty points per row
    if count ~= pointsPerRow, break, end % we have reached the end of the file    
end

ind=ind-1; % reset ind to be a correct count of the number of points

% raw data is ADC counts - multiply by ADC gain to get Angstroms, div by
%  10000 to get um
scan_data(:,2)=(scan_data(:,2)*adc_gain)/10000;


% close the file
fclose(userfile);

%%%%
% plot
if plotmode == 1
    
    figure;
    plot(scan_data(:,1),scan_data(:,2),'.-');
    title(['as5rd: ' fname],'Interpreter','none','FontSize',16,'FontWeight','bold');
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
    
    fprintf(1,'\n');
    
    fprintf(1,' %s %s\n','Time of scan:', time_of_scan);
    
    fprintf(1,' %s %g\n', 'Number of data points read:', ind);
    if ind~=num_points
        fprintf(1,' %s %g\n', 'NOTE: Specified number of points in the file:', num_points);
    end
    fprintf(1,' %s %g %s\n %s %g %s\n %s %g %s\n', 'Scan Start:', scan_data(1,1), 'um',...
        'Scan End:', scan_data(ind,1), 'um', 'Scan Step:', horizontal_res, 'um');
    fprintf(1,' %s %g %s\n', 'Scan Length:', scan_data(ind,1)-scan_data(1,1), 'um');
    
    fprintf(1,' %s', 'Vertical Scan range:');
    if vertical_range_code == 0
        fprintf(1,' %s\n', '2000 um, 155A resolution');
    elseif vertical_range_code == 1
        fprintf(1,' %s\n', '13 um, 1A resolution');
    elseif vertical_range_code == 2
        fprintf(1,' %s\n', '300 um, 25A resolution');
    end
    
    fprintf(1,' %s', 'Sample Rate:');
    if sample_rate_code == 0
        fprintf(1,' %s\n', '50 Hz');
    elseif sample_rate_code == 1
        fprintf(1,' %s\n', '100 Hz');
    elseif sample_rate_code == 2
        fprintf(1,' %s\n', '200 Hz');
    end

    fprintf(1,' %s', 'Scan Speed:');
    if scan_speed_code == 0
        fprintf(1,' %s\n', '1 um/sec');
    elseif scan_speed_code == 1
        fprintf(1,' %s\n', '2 um/sec');
    elseif scan_speed_code == 2
        fprintf(1,' %s\n', '5 um/sec');
    elseif scan_speed_code == 3
        fprintf(1,' %s\n', '10 um/sec');
    elseif scan_speed_code == 4
        fprintf(1,' %s\n', '20 um/sec');
    elseif scan_speed_code == 5
        fprintf(1,' %s\n', '50 um/sec');
    elseif scan_speed_code == 6
        fprintf(1,' %s\n', '100 um/sec');
    elseif scan_speed_code == 7
        fprintf(1,' %s\n', '200 um/sec');    
    end
    
    fprintf(1,' %s %g %s\n', 'Nominal Stylus Force:', stylus_force, 'mg');
    
    fprintf(1,'\n');
    
end



