function SharedMemory_install
% function SharedMemory_install
% Installation by building the C-mex files for SharedMemory_install package
%
% Copied of Bruno Luong InplaceArray FEX submission
% Last update: 28-Jun-2009 built inplace functions

arch=computer('arch');
mexopts = sprintf('mex -v  -O -%s', arch);
% 64-bit platform
if ~isempty(strfind(computer(),'64'))
    mexopts = sprintf('%s -largeArrayDims ', mexopts);
end


%include boost
if ~isempty(strfind(computer(),'win'))
	BOOST_dir = 'C:\Program Files\Boost\boost_1_45_0';
else
	% on Ubuntu: sudo aptitude install libboost-all-dev libboost-doc
	BOOST_dir = '/usr/include/';
end

if ~exist(fullfile(BOOST_dir,'boost','interprocess','windows_shared_memory.hpp'), 'file')
	error('%s\n%s\n', ...
		'Could not find the BOOST library. Please edit this file to include the BOOST location', ...
		'<BOOST_dir>\boost\interprocess\windows_shared_memory.hpp must exist');
end
mexopts = sprintf('%s -I''%s'' ', mexopts, BOOST_dir);

eval([mexopts, 'SharedMemory.cpp']);

