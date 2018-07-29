% Compile sharedmatrix mex file.
%
% Copyright (c) 2010,2011 Joshua V Dillon
% All rights reserved. (See file header for details.)

fprintf('Compiling sharedmatrix mex files...\n');

numbits=computer;numbits=str2num(numbits(end-1:end))

if numbits==64
	% For 64-bit machines:
	mex -largeArrayDims -O -v sharedmatrix.c
else
	% For 32-bit machines:
	mex -O -v sharedmatrix.c
end

fprintf('Done.\n');






% --- Miscellaneous Comments ------------------------------------------------


% Valgrind doesn't seem to work here.
% matlab -nodesktop -nojvm -nosplash -r "x=rand(3,4);sharedmatrix('clone',12345,x);quit" -D"valgrind --error-limit=no --tool=memcheck -v --log-file=valgrind.log --leak-check=full --track-origins=yes"


% mex -largeArrayDims -O -v CFLAGS='$CFLAGS -Wall -Werror -ansi -DDEBUG -D_XOPEN_SOURCE -fPIC' sharedmatrix.c



% --- Possibly useful notes. ------------------------------------------------


% --- Note 1 ---


% If you have trouble compiling in Matlab (GLIB error) try prefixing the matlab
% command with a LD_PRELOAD, ie,
% $ LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6 matlab


% --- Note 2 ---

% http://morganbye.net/blog/2011/05/matlab-ubuntu-1104
% 
% MATLAB with Ubuntu 11.04
% 
% Under the new Ubuntu 11.04 (Natty Narwhal), when you try and run MATLAB
% you'll get the following error
% 
%     /matlab/bin/util/oscheck.sh: 605: /lib64/libc.so.6: not found
% 
% To resolve this problem, go to a terminal window (Alt + F2 from anywhere) and
% type:
% 
% For 64 bit:
%     sudo ln -s /lib64/x86_64-linux-gnu/libc-2.13.so /lib64/libc.so.6
% 
% For 32 bit:
%     sudo ln -s /lib/i386-linux-gnu/libc-2.13.so /lib/libc.so.6
% 
% This should restore the missing library that was uninstalled during the
% Ubuntu update process.
