function [r ElapsedTime] = RunAnsys( AnsysPath,FileName,workspace,database)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%% Default Input Value
if nargin<4
    database=512;
end
if nargin<3
    workspace=1024;
end
%% start timing
tic;
% running ansys
r=dos([AnsysPath ' -m ' num2str(workspace) ' -db ' num2str(database) ' -b -p ANE3FL ' '-i ' FileName '.inp ' '-o fem_temp.out'],'-echo');
% stop timing
ElapsedTime=toc;
end

