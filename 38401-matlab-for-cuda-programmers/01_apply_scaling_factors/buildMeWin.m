%Copyright 2013 The MathWorks, Inc.

% These are the files we want to build.
files = {
    'applyScaleFactors'

    }';


% Check that we are running Windows.
assert ( ispc() )

% Check if we are running 32 or 64 bit MATLAB.
bittedness = 32;
if ( strcmp( computer, 'PCWIN64' ) )
	bittedness = 64;
end

% Hard link to Visual Studion (Express) compiler binaries.
VCpath = '"C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\bin"';

% Link to the MATLAB include files to get the type declarations right.
incpath = [ '"' matlabroot() '/extern/include"' ];

for ii=1:numel(files)
	cmd = sprintf( 'nvcc --machine %d -ptx -Xptxas=-v -arch sm_20 -ccbin %s -I %s %s.cu --output-file %s.%s', bittedness, VCpath, ...
          incpath , ...
          files{ii}, files{ii}, parallel.gpu.ptxext );
    fprintf( 'Compiling %s... ', files{ii} );
    system( cmd );
    fprintf( '%s done.\n', repmat(' ',[1,max(0,20-length(files{ii}))]) );
end
