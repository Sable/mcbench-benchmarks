%% Visualization with MATLAB Builder for .NET
% Copyright (c) 2009, The MathWorks, Inc.
%
% This demo / example shows how to implement an C# application that uses
% MATLAB built components as a visualization engine.
% The main window can be resized, and there is a movable slitter between
% the textbox and the picturebox.
% After the functions are called for the first time, visualization 
% should be fast enough to enable a real-time experience when 
% resizing the figure.

% There is a compiled exe and related DLLs in the folder bin\release

%%
% 1. Compile the dll with
mcc  -B 'dotnet:NETSquare,NETSquareclass,2.0,Private,local' makesquare.m ...
    makebitmap.m makefigure.m

% 2. Add generated DLL and MWArray DLL to project references

% 3. Compile and run the project


