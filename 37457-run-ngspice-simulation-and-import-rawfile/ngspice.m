function [ data ] = ngspice(netlistfilename)
%NGSPICE Simulate a circuit in ngspice
%   ngspice is an open-source electronic circuit simulator based on the
%   Simulation Program with Integrated Circuit Emphasis (SPICE). This
%   function provides a wrapper to get the simulation output data into
%   MATLAB.
%
%   The function takes a 'netlist' as its input. It then runs 'ngspice'
%   (which must be installed). 'ngspice' performs the simulation and saves
%   data in a temporary 'rawfile'. The data are typically voltages or
%   currents at various nodes of circuit. This function reads the rawfile
%   into a MATLAB structure array, then deletes it. The field names of the
%   structure array correspond to the variable names in the rawfile. As the
%   variable names used by ngspice are generally not valid as MATLAB
%   structure array field names this function attempts to convert them to
%   valid field names.
%
%   To use this function the application 'ngspice' must be available in the
%   system path.
%
%   Parts of this function were based on Madison McGaffin's 'Read ngspice'
%   function, available from MATLAB Central.
%
%   This function has been tested on rawfiles produced by ngspice
%   revision 23.
%
%   Requires: ngspice
%   Author: Iain Robinson, School of Geosciences, University of Edinburgh
%   Last updated: 2012-07-11

% Check that the netlist file name provided actually exists.
if ~exist(netlistfilename, 'file')
    error('Could not find the netlist file:\n\t%s', netlistfilename);
end

% Get a temporary filename to use for the raw file.
rawfilename = tempname;

% Prepare the system command.
command = sprintf('ngspice --batch --rawfile="%s" "%s"', rawfilename, netlistfilename);

% Run the simulation. The '-echo' option shows outout in the MATLAB command
% window. This can be useful for debugging.
system(command, '-echo');

% Open the RAW file
[fid, message] = fopen(rawfilename, 'r');
if fid == -1
	error('Could not open rawfile:\n\t%s\n%s\n\nThis may indicate that the simulation failed.', rawfilename, message);
end

% rawfiles contain a text header, followed by binary data. The text part
% of the file ends with the line
%   Binary:
% to indicate that the rest of the file contains binary data.
header = '';
line = fgets(fid); % fgets reads a line but keeps newline characters.
while isempty(strfind(line, 'Binary:'))
    line = fgets(fid);
    header = [header, line];
end

% Parse the header.
datetext = char(regexp(header, '^Date:\s*(\w.*?\w)\s*$', 'tokens', 'once', 'lineanchors'));
data.date = datestr(datenum(datetext, 'ddd mmm dd HH:MM:SS  yyyy')); % Converts the date to a MATLAB date.
data.plotname = char(regexp(header, '^Plotname:\s*(\w.*?\w)\s*$', 'tokens', 'once', 'lineanchors'));
data.flags = char(regexp(header, '^Flags:\s*(\w.*?\w)\s*$', 'tokens', 'once', 'lineanchors'));
numVariables = str2num(char(regexp(header, '^No\. Variables:\s*(\d+)\s*$', 'tokens', 'once', 'lineanchors')));
numPoints = str2num(char(regexp(header, '^No\. Points:\s*(\d+)\s*$', 'tokens', 'once', 'lineanchors')));
vartext = char(regexp(header, '^Variables:\s*$(.*)^Binary:', 'tokens', 'once', 'lineanchors'));
variables = regexp(vartext, '^\s*(?<num>\d+)\s+(?<name>\S+)\s+(?<type>.*?)\s*$', 'names', 'lineanchors');

% Check for errors.
if numVariables < 1
    fclose(fid);
    error('The RAW file:\n\t%s\ncontains no variables.', rawfilename);
end
if numVariables ~= numel(variables)
    fclose(fid);
    error('Was expecting %d variables, but found %d in RAW file:\n\t%s', numVariables, numel(variables));
end
if numPoints < 1
    fclose(fid);
    error('The RAW file:\n\t%s\ncontains no points.', rawfilename);
end

% Get the list of variable names. These are probably invavlid as MATLAB
% variable names.
invalid_variable_names = {variables.name};

% Turn the variable names into valid MATLAB variable names by removing
% or substituting dodge characters.
s = invalid_variable_names;
s = regexprep(s, '(', ''); % Strip opening brackets.
s = regexprep(s, ')', ''); % Strip closing brackets.
s = regexprep(s, '-', ''); % Strip dashes.
s = regexprep(s, '#', 'hash'); % Replace hash symbol with word.
s = regexprep(s, '\.', 'dot'); % Replace dot symbol with word.
s = regexprep(s, '\+', 'plus'); % Replace plus symbol with word.
s = regexprep(s, ':', ''); % Remove colons.
valid_variable_names = s;

% Check that the variable names are all valid MATLAB variable names.
for n=1:numel(valid_variable_names)
    if ~isvarname( valid_variable_names{n} )
        warning('One of the variable names, %s, could not be converted to a valid MATLAB variable name.', invalid_variable_names{n});
        valid_variable_names{n} = sprintf('variableNumber%d', n-1);
    end
end

% Read the binary part of the file.
data_matrix = zeros(numVariables, numPoints);
for col=1:numPoints
	for var=1:numVariables
        if feof(fid)
            fclose(fid);
            error('The end of the RAW file:\n\t%s\nwas reached before all the expected data had been read.', rawfilename);
        end
        % Read one value from the binary part of the file.
        [value, count] = fread(fid, 1, 'double');
        % Check that the value was read okay.
        if count == 0
            warning('No data found for variable %d column %d.', var, col);
        else
            % Copy the value into the data matrix.
        	data_matrix(var,col) = value;
        end
	end
end

% Check that there is no 'leftover' data.
while ~feof(fid)
    byte = fread(fid, 1, 'uint8');
    if ~isempty(byte)
        error('All expected data have been read, but there still appears to be some data remaining in the file:\n\t%s', rawfilename);
    end
end
    
% Close and delete (!) the RAW file
fclose(fid);
delete(rawfilename);

% Copy data into a structure.
for n = 1:numVariables
    data = setfield(data, valid_variable_names{n}, data_matrix(n,:));
end
end

