function [data, headers]= spice3_import(filename)
% DATA = SPICE3_IMPORT(FILENAME) returns the data from a text file created
% by a SPICE3 transient simulation.
%
% FILENAME    The name of the SPICE3 output file
% 
% DATA        The data is returned as a MxN array: M columns, N data
%              points.
%
% HEADERS     A cell array of strings which are the column headers in the
%              SPICE output file.
% 
% This code will import the results from a SPICE3 .out file that has the
% results of a transient circuit simulation. In the SPICE deck, use the
% commands:
%
% .TRAN
% .OPTIONS NOPAGE
% .PRINT [whatever you want to import]
%
% Run the SPICE simulation and save the result to a file:
%
% [~/]> spice3 -b input.spice > spice.out
%
% Then the file "spice.out" can be read by SPICE3_IMPORT.
%
% Comment out the "disp" commands to suppress the 
%  display of headers from the SPICE3 file during the import.
%
% Example:
%
%  Use the following MATLAB code to generate the SPICE3 deck:
%
%         spicefile = 'circuit1.spice';
%         spcfid = fopen(spicefile,'w');
%         fprintf(spcfid,'* %s\n',datestr(fix(clock)));
%         fprintf(spcfid,'.TRAN 1uS 100mS 0 0.1mS UIC\n');
%         fprintf(spcfid,'.OPTION NOPAGE\n');
%         fprintf(spcfid,'.PRINT TRAN');
%
%         [... code for generating SPICE3 deck ...]
%
%  Run the SPICE3 simulation:
%
%         % run the SPICE model
%         fprintf(1,'Running SPICE Model...\n');
%         eval(['!spice3 -b ' spicefile ' > ' spiceout]);
%
%  Then use the following command to read in the data:
%
%         % get spice results from .out file
%         [rcdata, rcheaders]=spice3_import(spiceout);
%
%
% M.A. Hopcroft
%      hopcroft at mems stanford edu
%
% MH JUL2007
% v1.0
%

%% open the data file
fid=fopen(filename);
if fid ~= -1, %then file exists
    %data=textscan(fid,'%f');
    fclose(fid);
else
    filename=strcat(filename,'.txt');
    fid=fopen(filename);
    if fid ~= -1, %then file exists
        fclose(fid);
    else
        error(['Data File not found in current directory! (' pwd ')']);
    end
end
% open the validated file
fid=fopen(filename);

%% read the file
% process the header
k=0;
while 1 
    % get a line from the file
    linein=fgetl(fid); k=k+1;
    % handle spurious carriage returns
    if isempty(linein), linein=fgetl(fid); k=k+1; end
    if length(linein) > 5
        if strcmp(linein(1:5),'-----')
            % then the next line is the top of the column labels
            linein=fgetl(fid); k=k+1;
            h=textscan(linein,'%s');
            headers=h{1};
            disp('spice_import: data column headers:')
            disp(headers)
            numcols = length(headers);
            % the next line is the bottom "----"
            linein=fgetl(fid); k=k+1;
            if strcmp(linein(1:5),'-----')
                break
            else
                error('spice_import: file header malformed');
            end
        elseif strcmp(linein(1:5),'Error')
            fprintf(1,'spice_import: WARNING: Error in SPICE result. Check .out file\n');
        end
    end
end


%% done with header, now get data
% header rows are repeated periodically
d = fscanf(fid,'%e',[numcols inf]);
data=d';

% there may be multiple sections of data; loop until we get to the end
while 1
    
    % get a line from the file
    linein=fgetl(fid); k=k+1;
    % handle spurious carriage returns
    if isempty(linein), linein=fgetl(fid); k=k+1; end
    if length(linein) > 3
        if strcmp(linein(1:3),'CPU') % then this is end of file
            break
        elseif strcmp(linein(1:3),'---') % new section of data
            linein=fgetl(fid); k=k+1;
            h=textscan(linein,'%s');
            ht=h{1};
            disp(ht(3:end))
            numcols = length(ht);
            % skip the first two columns, as they repeat "Index" and "Time"
            headers=[headers; ht(3:end)];
            % the next line is the bottom "----"
            linein=fgetl(fid); k=k+1;
            % now get this section of data,
            d = fscanf(fid,'%e',[numcols inf]); d=d';
            % the first two columns are repeated in every section
            d=d(:,3:end);
            data=[data d];            
            
        end
    end
end

% close the file
fclose(fid);
return


