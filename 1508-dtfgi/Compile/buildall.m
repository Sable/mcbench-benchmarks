%
%M-file for compiling and linking the FGI source files
%
%Date: 01-06-2000                    
%Copyright (c) 2000 R.Heil, C. L. Wauters
%SYNTAX buildall;               
%
%
%DESCRIPTION File for easily compiling and linking the FGI source files.
%
%INPUT The user is asked to input the source directory and output directory
%
%EXAMPLE:
%buildall;
%


INC = '-Iy:\software\dt\fgsdk32\include';
INC52='-Iy:\software\dt\fgsdk32\include\dt3152';
INC57='-Iy:\software\dt\fgsdk32\include\dt3157';
INCCO='-Iy:\software\dt\fgsdk32\include\colorsdk';
LIB = 'y:\software\dt\fgsdk32\lib\olimg32.lib y:\software\dt\fgsdk32\lib\olfg32.lib';

disp(' ');
%SOURCE = input('Enter the source directory (example: g:\\sourcedir ) -> ','s');
SOURCE = '..\Src';
%OUTDIR = input('Enter the output directory (example: g:\\matlab ) -> ','s');
OUTDIR = '..\Bin';
SOURCE = strcat(SOURCE,'\\');

disp(' ');
disp('Building FGI source files');
disp(' ');

disp('Compiling setfg');
com = strcat(SOURCE,'setfg.c');
mex(com,'-O',INC,INC52,INC57,INCCO,LIB,'-outdir',OUTDIR)

disp('Compiling getfg');
com = strcat(SOURCE,'getfg.c');
mex(com,'-O',INC,INC52,INC57,INCCO,LIB,'-outdir',OUTDIR)

disp('Compiling loadfg');
com = strcat(SOURCE,'loadfg.c');
mex(com,'-O',INC,INC52,INC57,INCCO,LIB,'-outdir',OUTDIR)

disp('Compiling resetfg');
com = strcat(SOURCE,'resetfg.c');
mex(com,'-O',INC,INC52,INC57,INCCO,LIB,'-outdir',OUTDIR)

disp('Compiling grabfg');
com = strcat(SOURCE,'grabfg.c');
mex(com,'-O',INC,INC52,INC57,INCCO,LIB,'-outdir',OUTDIR)

disp('Compiling isopenfg');
com = strcat(SOURCE,'isopenfg.c');
mex(com,'-O',INC,INC52,INC57,INCCO,'-outdir',OUTDIR)

disp('Compiling gethandlefg');
com = strcat(SOURCE,'gethandlefg.c');
mex(com,'-O',INC,INC52,INC57,INCCO,'-outdir',OUTDIR)

disp('Compiling openfg');
com = strcat(SOURCE,'openfg.c');
mex(com,'-O',INC,INC52,INC57,INCCO,LIB,'-outdir',OUTDIR)

disp('Compiling closefg');
com = strcat(SOURCE,'closefg.c');
mex(com,'-O',INC,INC52,INC57,INCCO,LIB,'-outdir',OUTDIR)

disp('Compiling mainfg');
com = strcat(SOURCE,'mainfg.c');
mex(com,'-O',INC,INC52,INC57,INCCO,'-outdir',OUTDIR)

