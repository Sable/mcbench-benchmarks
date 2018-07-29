function install(dir, libpython)
	% INSTALL(toolboxdir, libpython)
	%
	% Compile and install pymex.
	%
	% toolboxdir is Matlab's toolbox directory. It defaults to 
	% '/opt/matlab/toolbox/'.
	%
	% libpython is the location of the Python shared library. It
	% defaults to '/usr/lib/libpython2.6.so'.

	if ~exist('libpython', 'var')
		libpython = '/usr/lib/libpython2.6.so';
	end
	
	if ~exist('dir', 'var')
		toolboxdir = '/opt/matlab/toolbox/';
	else
		if dir(1) ~= '/'
			error('The toolbox directory must be given as an absolute path.');
		else
			toolboxdir = dir;
		end
	end
	installdir = [toolboxdir, '/pymex/'];
	
	mex_command = ['mex pymex.cpp -g -lpython2.6 -ldl -DLIBPYTHON=', libpython];
	
	disp(' ');
	disp(' ');
	disp('Now installing pymex. It will be installed here:');
	disp(' ');
	disp(['    ', installdir]);
	disp(' ');
	disp('When building, mex needs to be able to link against');
	disp('libpython2.6 and libdl. You may need to adjust the mex');
	disp('command to get everything working. Pymex also needs to ');
	disp('load libpython2.6 during runtime, it will look here: ');
	disp(' ');
	disp(['    ', libpython]);
	disp(' ');
	disp('...or else fail. The location of the library can be ');
	disp('adjusted by changing the ''libpython'' argument. Type');
	disp('''help install.m'' to see usage.');
	disp(' ');
	disp(' ');
	disp(' < Press a key to continue >');
	disp(' ');
	disp(' ');
	pause;

	disp('Now checking for the toolbox directory...');
	disp(['(Looking for ', toolboxdir, ')']);
	if ~exist(toolboxdir, 'dir')
		error('Cannot find the toolbox directory.');
	end
	disp('Now checking for libpython2.6...');
	if ~exist(libpython, 'file')
		error([libpython, ' does not exist.']);
	end
	disp('Now compiling pymex.cpp with command:');
	disp(' ');
	disp(['     ', mex_command]);
	disp(' ');
	eval(mex_command);
	disp('Now installing pymex...');
	if ~movefile('./pymex.mex*', installdir, 'f')
		error('Cannot install pymex files. Do you need to be root?');
	end
	disp('Now updating the path...');
	path(path, installdir);
	if savepath ~= 0
		error('Cannot update path.');
	end
end
