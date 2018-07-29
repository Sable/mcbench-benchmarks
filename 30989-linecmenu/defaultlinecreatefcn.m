function [] = defaultlinecreatefcn(varargin)
% This is a createfcn for line objects.  To ensure that all lines created
% in the future automatically use LINECMENU, follow these instructions:
%
% 1.  Put this file and LINECMENU on your path.  I.e., put this file and 
%     LINECMENU in one of the folders you see when you type:  path
% 2.  In STARTUP put this line:
%
%                 set(0,'defaultlinecreat',@defaultlinecreatefcn)
% 
%    If you don't already have a STARTUP file, create one and make sure it
%    is on your path.  This is the file which MATLAB runs when it first
%    starts. 
%
% The next time MATLAB is started, all lines will automatically have the 
% LINECMENU options.  To make the changes effective without restarting
% MATLAB, simply execute the above call to SET from the command line.

set(varargin{1},'uicontextmenu',linecmenu);