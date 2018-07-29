cudaMexPath = fullfile( matlabroot, '\toolbox\distcomp\gpu\extern\include' );
argumentList = ['-largeArrayDims -lnpp' ...
	' -I' cudaMexPath ' whitebalanceMEX.cpp whitebalance.cu'];
eval( ['mex ' argumentList] );