%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function copy_all_struct copies all variables of class struct from
% workspace and store them in a cell array. The first row of the cell
% will contain all the structures'name, where the second row will contain
% the corresponding values. The output cell array from this function is
% passed to the struct_browser GUI to browse all its contents.
%
% Syntax : cell_struct = copy_all_struct;
%
% CRC Advanced Audio Systems - Ottawa © 2002-2003
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% H.Lahdili,(hassan.lahdili@crc.ca)
% Communications Research Centre (CRC) | Advanced Audio Systems (AAS)
% www.crc.ca | www.crc.ca/aas
%
% Ottawa. Canada
% 29/04/2003
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cell_struct = copy_all_struct

ws_vars = evalin('base', 'who');
L = length(ws_vars);
cell_struct = {};
for i=1:L
    val = evalin('base',ws_vars{i});
    if isstruct(val)
        cell_struct = [cell_struct, {ws_vars{i}; val}];
    end
end

