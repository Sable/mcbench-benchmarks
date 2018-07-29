% Copyright 2013 The MathWorks, Inc.
cudaMexPath = fullfile( matlabroot, '\toolbox\distcomp\gpu\extern\include' );
argumentList = ['-largeArrayDims -lnpp ' ...
	' -I' cudaMexPath ' computeMeanMEX.cpp computeMean.cpp'];
eval( ['mex ' argumentList] );