%% Run this cell for Release version
AddiIncPath = ['-I','..\..\src'];
OutFile = 'mx_add';
mex('mex_main.cpp',AddiIncPath,'-output',OutFile);
clear AddiIncPath OutFile
%% Run this cell for Debug version
AddiIncPath = ['-I','..\..\src'];
OutFile = 'mx_add';
mex('mex_main.cpp',AddiIncPath,'-output',OutFile, '-g');
clear AddiIncPath OutFile