function findfirst_install
% function findfirst_install
% Installation by building the C-mex files for findfirst package
%
% Author Bruno Luong <brunoluong@yahoo.com>
% Last update: 05-Jul-2009

arch=computer('arch');
mexopts = {'-v' '-O' ['-' arch]};
% 64-bit platform
if ~isempty(strfind(computer(),'64'))
    mexopts(end+1) = {'-largeArrayDims'};
end

% invoke MEX compilation tool
mex(mexopts{:},'find1dmex.c');