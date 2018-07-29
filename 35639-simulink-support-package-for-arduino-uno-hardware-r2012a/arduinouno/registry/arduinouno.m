% NOTE: DO NOT REMOVE THIS LINE XMAKEFILE_TOOL_CHAIN_CONFIGURATION
function toolChainConfiguration = arduinouno()
%ARDUINOUNO Defines a tool chain configuration

% Copyright 2012 The MathWorks, Inc.

try
hSetup = realtime.setup.PackageInfo;
    spPkg = hSetup.getSpPkgInfo('Arduino Uno');
    arduinoRootDir = hSetup.getTpPkgRootDir('ARDUINO', spPkg);
catch me
    toolChainConfiguration = {};
    return;
end

% General
toolChainConfiguration.Configuration = 'Arduinouno';
toolChainConfiguration.Version = '2.0';
toolChainConfiguration.Description = 'MS Visual Studio';
toolChainConfiguration.Operational = true;
toolChainConfiguration.Decorator = 'linkfoundation.xmakefile.decorator.eclipseDecorator';
% Make
toolChainConfiguration.MakePath = @(src) fullfile(arduinoRootDir, 'hardware', 'tools', 'avr', 'utils', 'bin', 'make');
toolChainConfiguration.MakeFlags = '-f "[|||MW_XMK_GENERATED_FILE_NAME[R]|||]" [|||MW_XMK_ACTIVE_BUILD_ACTION_REF|||]';
toolChainConfiguration.MakeInclude = '';
% Compiler
toolChainConfiguration.CompilerPath = @(src) fullfile(arduinoRootDir, 'hardware', 'tools', 'avr', 'bin', 'avr-gcc');
toolChainConfiguration.CompilerFlags = '-c -x none';
toolChainConfiguration.SourceExtensions = '.c,.cpp';
toolChainConfiguration.HeaderExtensions = '.h';
toolChainConfiguration.ObjectExtension = '.o';
% Linker
toolChainConfiguration.LinkerPath = @(src) fullfile(arduinoRootDir, 'hardware', 'tools', 'avr', 'bin', 'avr-gcc');
toolChainConfiguration.LinkerFlags = '-o [|||MW_XMK_GENERATED_TARGET_REF|||]';
toolChainConfiguration.LibraryExtensions = '.lib,.a';
toolChainConfiguration.TargetExtension = '.elf';
toolChainConfiguration.TargetNamePrefix = '';
toolChainConfiguration.TargetNamePostfix = '';
% Archiver
toolChainConfiguration.ArchiverPath = @(src) fullfile(arduinoRootDir, 'hardware', 'tools', 'avr', 'bin', 'avr-ar');
toolChainConfiguration.ArchiverFlags = '-crs $(TARGET_FILE)';
toolChainConfiguration.ArchiveExtension = '.a';
toolChainConfiguration.ArchiveNamePrefix = 'lib';
toolChainConfiguration.ArchiveNamePostfix = '';
% Pre-build
toolChainConfiguration.PrebuildEnable = false;
toolChainConfiguration.PrebuildToolPath = '';
toolChainConfiguration.PrebuildFlags = '';
% Post-build
toolChainConfiguration.PostbuildEnable = true;
toolChainConfiguration.PostbuildToolPath = @(src) fullfile(arduinoRootDir, 'hardware', 'tools', 'avr', 'bin', 'avr-objcopy');
toolChainConfiguration.PostbuildFlags = '-O ihex -R .eeprom $(TARGET)  [|||MW_XMK_MODEL_NAME|||].hex';
% Execute
toolChainConfiguration.ExecuteDefault = false;
toolChainConfiguration.ExecuteToolPath = '';
toolChainConfiguration.ExecuteFlags = '';
% Directories
toolChainConfiguration.DerivedPath = '[|||MW_XMK_SOURCE_PATH_REF|||]';
toolChainConfiguration.OutputPath = '';
% Custom
toolChainConfiguration.Custom1 = '';
toolChainConfiguration.Custom2 = '';
toolChainConfiguration.Custom3 = '';
toolChainConfiguration.Custom4 = '';
toolChainConfiguration.Custom5 = '';
end

% LocalWords:  XMAKEFILE Uno linkfoundation xmakefile avr utils XMK crs ihex
% LocalWords:  eeprom
