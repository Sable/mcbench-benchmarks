function mex_sfun_user_fxp_examples()
%% mex_sfun_user_fxp_examples attempts to mex the examples of
%%    user written S-Functions.
%%
%% The source code for user written fixed-point C S-Functions must 
%% contain two extra #includes.  
%% First, at the beginning of the C file, just after the standard
%%      #include "simstruc.h"
%% also put
%%      #include "fixedpoint.h"
%% Second, at the end of the C file, just after the standard
%%      # include "simulink.c"
%% also put
%%      # include "fixedpoint.c"
%%
%% 
%% For user written fixed-point C S-Functions, an extra argument
%% must be passed to mex command.  On UNIX, the extra requirement is simple.
%% Just give the extra argument '-lfixedpoint'.  For example,
%%
%%      mex('sfun_user_fxp_asr.c','-lfixedpoint')
%%
%% On Windows, the requirements are slightly more involved.  The extra
%% input argument is the appropriate libfixedpoint.lib file.  The
%% appropriate file depends on the compiler specified when 
%% mex('-setup') was run.  Several versions of libfixedpoint.lib
%% are included on the Matlab CD and are installed when Simulink
%% is installed.  Starting from the directory MATLABROOT, the
%% installed files are
%%      extern\lib\win32\borland\bc54\libfixedpoint.lib
%%      extern\lib\win32\borland\bc53\libfixedpoint.lib
%%      extern\lib\win32\borland\bc50\libfixedpoint.lib
%%      extern\lib\win32\lcc\libfixedpoint.lib
%%      extern\lib\win32\microsoft\msvc60\libfixedpoint.lib
%%      extern\lib\win32\microsoft\msvc50\libfixedpoint.lib
%%      extern\lib\win32\microsoft\msvc70\libfixedpoint.lib
%% For example, if msvc60 is the compiler mex is setup to use
%% the the mex command would be
%%
%%      mex('sfun_user_fxp_asr.c',[matlabroot,'\extern\lib\win32\microsoft\msvc60\libfixedpoint.lib'])
%%
%% This file attempts to mex all the provided examples of user
%% written fixed-point sfunctions.  On UNIX, there should be no 
%% difficulties.  On Windows, this file assumes msvc60 is
%% the compiler setup for use with mex.  If mex has been setup to
%% use a different compiler on Windows, then the mex attempt
%% will fail.  In this case, the mex command should be called
%% directly as shown in the example above.

%% Copyright 1994-2003 The MathWorks, Inc.
  
sfun_dir = which('mex_sfun_user_fxp_examples');

sfun_dir = sfun_dir(1:(max(find(sfun_dir==filesep))));

sfuns = dir([sfun_dir,'sfun_user_fxp_*.c']);

if ispc
  extra_arg = [matlabroot,'\extern\lib\win32\microsoft\msvc60\libfixedpoint.lib'];
else
  extra_arg = '-lfixedpoint';
end

disp(' ')
for i=1:length(sfuns)
  
  str1 = sprintf('''%s'',',sfuns(i).name);
  
  estr = sprintf('mex( %-30s ''%s'' );',str1, extra_arg);  
  disp(estr)
  eval(estr)
end  
disp(' ')
