function mexcwithf(sfunstr)

% usage : makemexcwith('sfunction.c') where 'sfunction.c' is the name of
% the level-2 c s-function, creates a mex file from the c s-function and
% supporting fortran code.  This function must be called in the same folder
% as the s-function and supporting fortran code and you need to have g77
% installed if it is for a Linux operating system.  If you are using
% Windows, you must have the g77 executable residing in the folder.  If you
% need the G77 compiler for windows, it is freely available at www.mingw.org.  % % Follow the standard
% installation directions on the website and then copy the g77.exe file 
% (located in the \MinGW\bin folder) to the folder where the supporting 
% fortran code exists.

if ~exist(sfunstr,'file'), disp('The Level-2 C S-function does not exist');return, end

if ~exist('g77.exe','file') && ~strcmp(mexext,'mexglx'), disp('The g77 executable is not in the working directory');return,end

eval('! g77 -c *.f');
mex(sfunstr,'*.o')