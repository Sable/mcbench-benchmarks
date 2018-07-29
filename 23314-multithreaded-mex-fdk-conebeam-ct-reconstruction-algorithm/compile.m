% This is a script that can be used to compile the mex file from the matlab
% prompt
%
% Author: Rene Willemink (Signals and Systems Group, University of Twente)
% Date: 23-10-2008

% This variable should point to the mexSupport directory which contains the
% mexSupport header files
MexSupportDir = 'mexSupport';

if ~exist(MexSupportDir, 'dir')
    error('The variable MexSupportDir should point to the directory containing the mexSupport header files');
end

mex('-largeArrayDims', ['-I' MexSupportDir], 'mex_iconebeam_fdk.cpp');