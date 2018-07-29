function build_spidxmex
% function build_spidxmex
% Build the Mex file for sparse subacess package

arch=computer('arch');
mexopts = {'-v' '-O' ['-' arch]};
% 64-bit platform
if ~isempty(strfind(computer(),'64'))
    mexopts(end+1) = {'-largeArrayDims'};
end
mex(mexopts{:},'getspvalmex.c');
mex(mexopts{:},'setspvalmex.c');
% Tell them to forget MEXFLAG
clear spsubsasgn;
clear spsubsref;