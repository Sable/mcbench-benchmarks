%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The CRC-StructBrowser, is designed to expose the contents of all variables
% of class struct to any depth and plot any of the components.
%
% Syntax:
% StructBrowser
% StructBrowser_gui_g(cell_struct)
%
% The easiest way of starting up the GUI is to type the command:
% "StructBrowser" while the workspace contains some information 
% (the same command can be used in the debug mode).
%
% The GUI can also be launched by typing: StructBrowser_gui_g(cell_struct)
% in the MatLab command. cell_struct is a cell of size (2 X N), 
% where N is the number of structures to browse. The first row of cell_struct
% contains all the structures' names, and the second row contains all the 
% corresponding values. Assuming your workspace contains the 3 structures:
% struct_1, struct_2 and struct_3, cell_struct is described by the following:
%
% cell_struct = ...{'struct_1', 'struct_2', 'struct_3'; ...
%   struct_1, struct_2, struct_3};
%
% In the case of the base workspace, the function "copy_all_struct" is 
% provided to copy all variables of class struct from workspace and store 
% them in a cell array. The syntax of this function is:
%
% cell_struct = copy_all_struct;
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Script for browsing all the structures in the workspace
%  
% H.Lahdili,(hassan.lahdili@crc.ca)
% Communications Research Centre (CRC) | Advanced Audio Systems (AAS)
% www.crc.ca | www.crc.ca/aas
% Ottawa. Canada
%
% CRC Advanced Audio Systems - Ottawa © 2002-2003
% 30/04/2003
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear ws_vars val cell_struct i L

ws_vars = who;

L = length(ws_vars);
cell_struct = {};
for i=1:L
    val = eval(ws_vars{i});
    if isstruct(val)
        cell_struct = [cell_struct, {ws_vars{i}; val}];
    end
end

StructBrowser_gui_g(cell_struct);

clear ws_vars val cell_struct i L