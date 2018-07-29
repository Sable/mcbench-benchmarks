function [r,ElapsedTime] = RunCaisFile(FileName,AnsysPath)
%FileName: File of .cai type, only File Name, No Extension!!!!!
%% 
%if nargin<2
%    AnsysPath='"E:\CloudCache\3E46DDDB3C282A64C62650819BF418D0A3B645F6\0\##PROGRAM_FILES##\ANSYS Inc\v110\ANSYS\bin\intel\ansys110"';
%end
%FileName='test';
%% .cai to .inp
r1=Cai2Ansys(FileName);
%% run .inp
[r2 ElapsedTime]=RunAnsys(AnsysPath,FileName);
%% Return Value
r=r1+r2;