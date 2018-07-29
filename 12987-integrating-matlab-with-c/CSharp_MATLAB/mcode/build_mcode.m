%%  Build Script
% This script will build the mcode for the CSharp_MATLAB demo.
%
% This demo shows the integration of MATLAB with C# in three
% distinct fashions.  See the included readme.doc for more
% information.
%
% The bulk of the demo is written in C# and referenced in the 
% Visual Studio project.  The example MATLAB code used,
% "math_on_numbers.m," is a user submitted code snippet that
% motivated the demo.
%
% Copyright 2006,2010 The MathWorks, Inc.


%% Determine path names
workdir = pwd();

basedir = fileparts(workdir);
outdir = fullfile(basedir, 'Output');

clibdir = fullfile(workdir, 'CShared');
dnetdir = fullfile(workdir, 'dotnet');

%% Determine file names
mfile = fullfile(workdir, 'math_on_numbers.m');

dnetdll = fullfile(dnetdir, 'dotnet.dll');

clibdll = fullfile(clibdir, 'cshared.dll');

%% Verify m file can be found
if (exist(mfile, 'file') ~= 2)
    error('Unable to fine mfile math_on_numbers.m');
end

%% Create directories if needed
if (exist(outdir, 'dir') ~= 7)
    mkdir(outdir);
end

if (exist(clibdir, 'dir') ~= 7 )
    mkdir(clibdir);
end

if (exist(dnetdir, 'dir') ~= 7)
    mkdir(dnetdir);
end

%% Build .NET Assembly
disp('Compiling .NET Assembly...');

eval(['mcc -N -d ' dnetdir ' -W ''dotnet:dotnet,' ...
        'dotnetclass,0.0,private'' -T link:lib ' mfile]);

% verify assembly was created
if (exist(dnetdll, 'file') ~= 2) 
    error('Failed to successfully compile .NET assembly.');
else
    fprintf('\tDone\n');
end

%% Build C Shared library
disp('Compiling C Shared Library...');

eval(['mcc -N -W lib:cshared -d ' clibdir ' -T link:lib ' mfile]);

% verify library was created
if (exist(clibdll, 'file') ~= 2)
    error('Failed to successfully compile C Shared Library.');
else
    fprintf('\tDone\n');
end

%% Copy .NET Assembly to Output
Copy1 = copyfile(dnetdll, fullfile(outdir, 'dotnet.dll'));

if (Copy1 ~= 1) 
    error('Unable to copy .NET Assembly to output directory.');
end

%% Copy C Shared library to Output
Copy1 = copyfile(clibdll, fullfile(outdir, 'CShared.dll'));

if (Copy1 ~= 1)
    error('Unable to copy .NET Assembly to output directory.');
end

%% Clean up temp variables
clear Copy1 basedir clibdir clibdll dnetdir dnetdll mfile ...
      outdir workdir;