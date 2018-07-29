%% IMPORTANCE!!!
% set OpenCV installed directory here!
OpenCVRoot = 'C:\Program Files\OpenCV\';
%% Run this cell for Release version
IncPath1 = ['-I',fullfile(OpenCVRoot,'cxcore','include')];
IncPath2 = ['-I',fullfile(OpenCVRoot,'cv','include')];
% LibPath = ['-L',fullfile(OpenCVRoot,'lib')];
LibPath = fullfile(OpenCVRoot,'lib');
HasOpenCV = '-DHAS_OPENCV';

AddiIncPath = ['-I','..\..\src'];
OutFile = 'mx_resize';

mex('mex_main.cpp','../../src/mc_convert.cpp',...
    fullfile(LibPath,'cxcore.lib'),...
    fullfile(LibPath,'cv.lib'),...
    IncPath1, IncPath2, AddiIncPath,...
    HasOpenCV,...
    '-output',OutFile);
clear IncPath1 IncPath2 LibPath HasOpenCV AddiIncPath OutFile
%% Run this cell for Debug version
IncPath1 = ['-I',fullfile(OpenCVRoot,'cxcore','include')];
IncPath2 = ['-I',fullfile(OpenCVRoot,'cv','include')];
% LibPath = ['-L',fullfile(OpenCVRoot,'lib')];
LibPath = fullfile(OpenCVRoot,'lib');
HasOpenCV = '-DHAS_OPENCV';

AddiIncPath = ['-I','..\..\src'];
OutFile = 'mx_resize';

mex('mex_main.cpp','../../src/mc_convert.cpp',...
    fullfile(LibPath,'cxcore.lib'),...
    fullfile(LibPath,'cv.lib'),...
    IncPath1, IncPath2, AddiIncPath,...
    HasOpenCV,...
    '-output',OutFile, '-g');
clear IncPath1 IncPath2 LibPath HasOpenCV AddiIncPath OutFile
%% Run main.m
% Now change Matlab current directory to simple_mex and run main.m to see 
% the result.
% Type "help mx_resize" for help.