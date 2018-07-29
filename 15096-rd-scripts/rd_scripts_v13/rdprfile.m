function scan_data = rdprfile(ufilename,plotmode,verbose)
%RDPRFILE Reads data from a profilometer data file
%
% DATA = RDPRFILE(UFILENAME,VERBOSE)
%
% RDPRFILE examines the header in a profilometer data file and attempts to
%  determine the type of data file. If a supported type is found, it then
%  uses the appropriate function to open the file and return the data.
%  Returns SCAN_DATA=[] if unable to determine the file type.
%
% Supported profilometers:
%  Dektak IIA
%  AlphaStep 200
%  Alphastep 500
%  Dektak 3ST
%  Veeco Dektak 8
%  Bruker Dektak XT
%  Tencor P-10
%
% Options:
% If VERBOSE == 0, no messages will be displayed.
% If VERBOSE == 1, the data summary will be displayed. (default)
% If VERBOSE == 2, the file header and data summary will be displayed.
% If PLOTMODE == 0, the data will not be displayed.
% if PLOTMODE == 1, the data will be displayed in a new figure. (default)
%
% See also dk2rd.m, as2rd.m, as5rd.m, dk3rd.m, dk8rd.m, dkXTrd.m, p10rd.m
%
% M.A. Hopcroft
%  mhopeng at gmail dot com
%
% The license governing use of this code is in the accompanying file
%  "license.txt".
%
versionstr='rdprfile 1.1';

%
% MH Jul2013
% v1.1  add Dektak XT
% MH Sep2012
% v1.0  works


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
        fprintf(1, '\n\n  %s\n  %s\n\n', versionstr, 'Load profilometer data files');
    end
end


%%%%
%% open user's file
if nargin >= 1 % if the user already specified a file, use it
    userfilename=ufilename;
    % check to see if file exists
    cfid=fopen(userfilename);
    if cfid== -1
        if cfid== -1
            disp(pwd);
            fprintf(1,'ERROR: data file ["%s"] not found in current directory',userfilename);
            scan_data=[];
            return
        end
        fclose(cfid);
    end
    
else % if user did not specify the file name, ask for one
    [ufilename, ufilepath]=uigetfile({'.txt','.csv'},'Select the Profilometer data file');
    if isequal(ufilename,0)
        scan_data=[];
        return
    end
    userfilename=fullfile(ufilepath,ufilename);    
    %userfilename=input(' Enter the name of the profilometer data file: ','s');
end


% open the file
userfile=fopen(userfilename);


% % %
%% read lines from the header until we have an answer
if (nargout == 0), fprintf(1,'\n '); end % screen formatting for interactive mode

%% read the first line in the file
linein1=fgetl(userfile);
while isempty(linein1), linein1=fgetl(userfile); end % handle spurious carriage returns
if verbose >= 2, fprintf(1,'%s\n',linein1); end

% is this a Dektak II file?
if strfind(linein1,'SLOAN DEKTAK II')
    fprintf(1,'rdprfile: This appears to be a data file from a Dektak IIA\n');
    fclose(userfile);
    scan_data=dk2rd(userfilename,plotmode,verbose);
    return
end

% is this a Dektak XT file?
if strfind(linein1,'Meta Data')
    fprintf(1,'rdprfile: This appears to be a data file from a Dektak XT\n');
    fclose(userfile);
    scan_data=dkXTrd(userfilename,plotmode,verbose);
    return
end


%% read another line
linein2=fgetl(userfile);
while isempty(linein2), linein2=fgetl(userfile); end % handle spurious carriage returns
if verbose >= 2, fprintf(1,'%s\n',linein2); end

% is this a AlphaStep 200 file?
if length(linein2)>=4 && strcmp(linein2(1:4),'VERT')
    fprintf(1,'rdprfile: This appears to be a data file from an AlphaStep 200\n');
    fclose(userfile);
    scan_data=as2rd(userfilename,plotmode,verbose);
    return
end

% is this a AlphaStep 500 file?
dbl1=strtrim(linein1);
dbl2=strtrim(linein2);
if strcmp(dbl1(1),'A') && strcmp(dbl2(1),'B')
    fprintf(1,'rdprfile: This appears to be a data file from an AlphaStep 500\n');
    fclose(userfile);
    scan_data=as5rd(userfilename,plotmode,verbose);
    return
end

% is this a Tencor P-10 file?
if strcmp(linein1(1),'*') && strfind(linein2,'data points')
    fprintf(1,'rdprfile: This appears to be a data file from a Tencor P-10\n');
    fclose(userfile);
    scan_data=p10rd(userfilename,plotmode,verbose);
    return
end

% is this a Dektak 3ST file?
if length(linein1)>=9 && strcmp(linein1(1:9),'DATA FILE') && length(linein2)>=9 && strcmp(linein2(1:9),'AUTO PROG')
    fprintf(1,'rdprfile: This appears to be a data file from a Dektak 3ST\n');
    fclose(userfile);
    scan_data=dk3rd(userfilename,plotmode,verbose);
    return
end

%% read more lines
linein3=fgetl(userfile);
while isempty(linein3), linein3=fgetl(userfile); end
if verbose >= 2, fprintf(1,'%s\n',linein3); end
linein4=fgetl(userfile);
while isempty(linein4), linein4=fgetl(userfile); end
if verbose >= 2, fprintf(1,'%s\n',linein4); end
linein5=fgetl(userfile);
while isempty(linein5), linein5=fgetl(userfile); end
if verbose >= 2, fprintf(1,'%s\n',linein5); end

% is this a Dektak 8 file?
if length(linein4)>=9 && strcmp(linein4(1:9),'DATA FILE') && length(linein5)>=4 && strcmpi(linein5(1:4),'Date')
    fprintf(1,'rdprfile: This appears to be a data file from an Dektak 8\n');
    fclose(userfile);
    scan_data=dk8rd(userfilename,plotmode,verbose);
    return
end

% fail
fprintf(1,'rdprfile: Unable to determine file type!\n');
scan_data=[];
    

