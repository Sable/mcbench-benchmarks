function delete_unconnected_lines( sys )
%DELETE_UNCONNECTED_LINES  Delete unconnected lines from a Simulink system.
%   DELETE_UNCONNECTED_LINES('SYS') deletes all lines which has either no 
%   source or no destination under a system. That is, lines that are not 
%   fully connected to two blocks are removed (red-dotted in the GUI).
%
%   See also DELETE_LINE.

%   Developed by Per-Anders Ekström, 2003-2006 Facilia AB.

if nargin<1
    sys = gcs;
end

% get handles to all lines in system
lines = find_system( sys, ...
    'LookUnderMasks', 'all', ...
    'FindAll', 'on', ...
    'Type', 'line' ) ;

% for each line, call delete_recursive if handle still exist
for i=1:length( lines )
    if ishandle( lines( i ) )
        delete_recursive( lines( i ) )
    end
end


function delete_recursive( line )
%DELETE_RECURSIVE( LINE )  Delete line if:
%   1) do not have any source-block
%   2) do not have any line-children AND no destination-block
%   otherwise go recursively through all eventual line-children

if get( line, 'SrcPortHandle' ) < 0
    delete_line( line ) ;
    return
end
LineChildren = get( line, 'LineChildren' ) ;
if isempty( LineChildren )
    if get( line, 'DstPortHandle' ) < 0
        delete_line( line ) ;
    end
else
    for i=1:length( LineChildren )
        delete_recursive( LineChildren( i ) )
    end
end