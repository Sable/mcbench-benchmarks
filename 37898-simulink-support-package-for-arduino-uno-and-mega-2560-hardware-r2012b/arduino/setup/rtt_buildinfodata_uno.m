function info = rtt_buildinfodata_uno()
%RTT_BUILDINFODATA_UNO Defines build info data

% Copyright 2011 The MathWorks, Inc.


info.SourceFiles            = i_getSorceFiles;
info.SourceFilesToSkip      = {'main.cpp'};
info.IncludePaths           = i_getIncludePaths;
info.CompileFlags           = '-mmcu=atmega328p -std=gnu99 -Wall -Wstrict-prototypes -gstabs -Os';
info.Defines                = 'F_CPU=16000000';
info.LinkFlags              = '-lm -mmcu=atmega328p -gstabs';
end

% -------------------------------------------------------------------------
function files = i_getSorceFiles()
files = {};

% Get ARDUINO 0022 installation folder
hSetup = hwconnectinstaller.SetupInfo;
spPkg  = hSetup.getSpPkgInfo('Arduino');
arduinoRootDir = hSetup.getTpPkgRootDir('ARDUINO 0022', spPkg);

% Set paths
filesPath = fullfile(arduinoRootDir, 'hardware', 'arduino', 'cores', 'arduino');
cfiles = dir(fullfile(filesPath, '*.c'));
for i=1:length(cfiles)
    files{end+1}.Name = cfiles(i).name; %#ok<*AGROW>
    files{end}.Path = filesPath;
end
cfiles = dir(fullfile(filesPath, '*.cpp'));
for i=1:length(cfiles)
    files{end+1}.Name = cfiles(i).name;
    files{end}.Path = filesPath;
end
files{end+1}.Name = 'io_wrappers.cpp';
files{end}.Path = fullfile(spPkg.RootDir, 'src');
end

% -------------------------------------------------------------------------
function paths = i_getIncludePaths()
paths = {};

% Get ARDUINO 0022 installation folder
hSetup = hwconnectinstaller.SetupInfo;
spPkg  = hSetup.getSpPkgInfo('Arduino');
arduinoRootDir = hSetup.getTpPkgRootDir('ARDUINO 0022', spPkg);

% Set paths
paths{end+1} = fullfile(arduinoRootDir, 'hardware', 'arduino', 'cores', 'arduino');
paths{end+1} = fullfile(spPkg.RootDir, 'include');
end
