function compile
% COMPILE: Compilation file of the MATLAB CDI MEX files.
% It should produce 5 MEX files: cdi_varlist, cdi_readmeta, cdi_readfield, cdi_readfull, cdi_readall.
%   $Revision: 1.2 $WCREV$ $  $Date: 2008/02/27 13:28:58 $WCDATE$ $

str = computer;
% add the -DDOUBLE flag to return double value for field data returned by cdi_readall, cdi_readfield, cdi_readfull
% add the -DDEBUG flag to display debug info

if ~ispc

% COMPILATION WITH 64 BITS SYTEM
if isequal(str(end-1:end), '64')
	disp('COMPILING cdi_varlist...')
	mex cdi_varlist.c cdi_mx.c -Iinclude -Llib64 -lcdi -lnetcdf
	disp('COMPILING cdi_readfull...')
	mex cdi_read1var.c cdi_mx.c -Iinclude -Llib64 -lcdi -lnetcdf -output cdi_readfull -DREADFULL
	disp('COMPILING cdi_readmeta...')
	mex cdi_read1var.c cdi_mx.c -Iinclude -Llib64 -lcdi -lnetcdf -output cdi_readmeta -DREADMETA %-DDEBUG
	disp('COMPILING cdi_readfield...')
	mex cdi_read1var.c cdi_mx.c -Iinclude -Llib64 -lcdi -lnetcdf -output cdi_readfield -DREADFIELD
	disp('COMPILING cdi_readall...') 
	mex cdi_readall.c cdi_varlist.c cdi_read1var.c cdi_mx.c -Iinclude -Llib64 -lcdi -lnetcdf -output cdi_readall -DREADALL -DREADFIELD
else
% COMPILATION WITH 32 BITS SYTEM
	disp('COMPILING cdi_varlist...')
	mex cdi_varlist.c cdi_mx.c -Iinclude -Llib32 -lcdi -lnetcdf
	disp('COMPILING cdi_readfull...')
	mex cdi_read1var.c cdi_mx.c -Iinclude -Llib32 -lcdi -lnetcdf -output cdi_readfull -DREADFULL
	disp('COMPILING cdi_readmeta...')
	mex cdi_read1var.c cdi_mx.c -Iinclude -Llib32 -lcdi -lnetcdf -output cdi_readmeta -DREADMETA %-DDEBUG
	disp('COMPILING cdi_readfield...')
	mex cdi_read1var.c cdi_mx.c -Iinclude -Llib32 -lcdi -lnetcdf -output cdi_readfield -DREADFIELD
	disp('COMPILING cdi_readall...') 
	mex cdi_readall.c cdi_varlist.c cdi_read1var.c cdi_mx.c -Iinclude -Llib32 -lcdi -lnetcdf -output cdi_readall -DREADALL -DREADFIELD
end

else
% COMPILATION ON WIN PC
	disp('COMPILING cdi_varlist...')
	mex -f lib-mingw/mexopts.bat cdi_varlist.c cdi_mx.c -Iinclude -Llib-mingw -lcdi -lnetcdf
	disp('COMPILING cdi_readfull...')
	mex -f lib-mingw/mexopts.bat cdi_read1var.c cdi_mx.c -Iinclude -Llib-mingw -lcdi -lnetcdf -output cdi_readfull -DREADFULL
	disp('COMPILING cdi_readmeta...')
	mex -f lib-mingw/mexopts.bat cdi_read1var.c cdi_mx.c -Iinclude -Llib-mingw -lcdi -lnetcdf -output cdi_readmeta -DREADMETA %-DDEBUG
	disp('COMPILING cdi_readfield...')
	mex -f lib-mingw/mexopts.bat cdi_read1var.c cdi_mx.c -Iinclude -Llib-mingw -lcdi -lnetcdf -output cdi_readfield -DREADFIELD
	disp('COMPILING cdi_readall...') 
	mex -f lib-mingw/mexopts.bat cdi_readall.c cdi_varlist.c cdi_read1var.c cdi_mx.c -Iinclude -Llib-mingw -lcdi -lnetcdf -output cdi_readall -DREADALL -DREADFIELD
end
