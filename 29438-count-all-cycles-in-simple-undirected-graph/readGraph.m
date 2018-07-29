function [ adjMat ] = readGraph( inputFormat, source )
% readGraph: Read graph from source in one of four supported input
%   formats, return adjacency matrix of graph.  Returned graph
%   will be undirected and contain no self-loops or multiple edges.
%
% usage: readGraph( inputFormat, source )
%
% input arguments:
%   inputFormat - type: string, with four legal values: 'adjMatrix',
%       'edgeList', 'edgeListFile', 'clqFile'
%   source - legal type determined by value of inputFormat:
%       'adjMatrix' -> square numeric array in current workspace
%       'edgeList' -> two-column numeric array in current
%               workspace
%       'edgeListFile' -> text file with '.txt' filetype and 
%               containing two columns of integers
%       'clqFile' -> text file with '.clq' filetype and data in
%               DIMACS ascii format
%
% output arguments:
%   adjMat - type: square numeric array; array will be symmetric,
%       contain only zeros and ones, and have zeros on diagonal
%
% Sample source files for each inputFormat are included with
%   this code.
%
% Copyright (c) 2010, J. Jeffry Howbert and Laboratory for 
%   Experimental Combinatorics.  All rights reserved.
% Version 1.0             Nov. 17, 2010
%
    adjMat = '';
    if ( nargin < 2 )
        disp( ' ' );
        disp( 'usage: readGraph( inputFormat, inputSource )' );
        return
    end
    if ( strcmp( inputFormat, 'adjMatrix' ) )
        if ( isnumeric( source ) && ( size( source, 1 ) == size( source, 2 ) ) )
            A = source;
            numVert = size( A, 1 );
            % make sure A is undirected graph with no self-loops or multiple edges
            % get rid of self-loops
            for ix = 1 : numVert
                A( ix, ix ) = 0;
            end
            % get rid of multiple edges
            A( A ~= 0 ) = 1;
            % make sure graph is undirected
            for ix = 1 : numVert - 1
                for jx = ix + 1 : numVert
                    if ( A( ix, jx ) ~= A( jx, ix ) )
                        disp( ' ' );
                        disp( 'ERROR: for undirected graph, adjacency matrix must be symmetric' )
                        return
                    end
                end
            end
        else
            disp( ' ' );
            disp( 'ERROR: for ''inputFormat'' == ''adjMatrix'', ''source'' must be' );
            disp( '     square array of numeric elements' );
            return
        end
    elseif ( strcmp( inputFormat, 'edgeList' ) )
        if ( isnumeric( source ) && ( size( source, 1 ) > 2 && size( source, 2 ) == 2 ) ...
                && min( min( source ) ) >= 1 )
            A = edgeListToAdjMatrix( source );
        else
            disp( ' ' );
            disp( 'ERROR: for ''inputFormat'' == ''edgeList'', ''source'' must be');
            disp( '     numeric array containing two columns of integers, with' );
            disp( '     values in range 1 -> number of vertices' );
            return
        end
    elseif ( strcmp( inputFormat, 'edgeListFile' ) )
        if ( ischar( source ) && size( source, 2 ) > 4 && strcmp( source( size( source, 2 ) - 3 : size( source, 2 ) ), '.txt' ) )
            % read in graph from .txt file - expect two columns of integers,
            %   with values in range 1 -> number of vertices
            fid = fopen( source, 'r' );
            readEdge = textscan( fid, '%d %d' );
            inputEdge( :, 1 : 2 ) = [ readEdge{ 1 }( : ), readEdge{ 2 }( : ) ];
            status = fclose( fid );
            if ( status ~= 0 || min( min( inputEdge ) ) < 1 )
                disp( ' ' );
                disp( 'ERROR: file must contain two columns of integers with values' );
                disp( '     in range 1 -> number of vertices' );
                return
            end
            A = edgeListToAdjMatrix( inputEdge );
        else
            disp( ' ' );
                disp( 'ERROR: for ''inputFormat'' == ''edgeListFile'', ''source'' must be');
                disp( '     name of file with type ''.txt'', containing two columns of' );
                disp( '     integers' );
            return
        end
    elseif ( strcmp( inputFormat, 'clqFile' ) )
        if ( ischar( source ) && size( source, 2 ) > 4 && strcmp( source( size( source, 2 ) - 3 : size( source, 2 ) ), '.clq' ) )
            % read in graph from .clq file (DIMACS ascii format)
            fid = fopen( source, 'r' );
            header = textscan( fid, '%*s %*s %d %d', 1 );
            numVert = header{ 1 };
            numEdge = header{ 2 };

            readEdge = textscan( fid, '%*s %d %d' );
            inputEdge( :, 1 : 2 ) = [ readEdge{ 1 }( : ), readEdge{ 2 }( : ) ];
            status = fclose( fid );
            %%&& TODO: confirm number of rows in inputEdge agrees with numEdge 

            inputEdge = inputEdge + 1;          % go from zero-based indexing to one-based
            A = edgeListToAdjMatrix( inputEdge );
        else
            disp( ' ' );
            disp( 'ERROR: for ''inputFormat'' == ''clqFile'', ''source'' must be name of' );
            disp( '     file with type ''.clq'', containing graph specification in DIMACS' );
            disp( '     ascii format' );
            return
        end
    else
        disp( ' ' );
        disp( 'ERROR: ''inputFormat'' must be one of:' );
        disp( '          ''adjMatrix''' );
        disp( '          ''edgeList''');
        disp( '          ''edgeListFile''');
        disp( '          ''clqFile''' );
        return
    end
    adjMat = A;     % return conformant adjacency matrix
end     % function readGraph

% convert edge list to adjacency matrix
function [ adjMat ] = edgeListToAdjMatrix( edgeList )
    numEdge = size( edgeList, 1 );
    numVert = max( max( edgeList ) );
    %%&& TODO: delete vertices with degree < 2
    adjMat = zeros( numVert, numVert );
    for ix = 1 : numEdge
        vert1 = edgeList( ix, 1 );
        vert2 = edgeList( ix, 2 );
        adjMat( vert1, vert2 ) = 1;
        adjMat( vert2, vert1 ) = 1;
    end
    % get rid of self-loops
    for ix = 1 : numVert
        adjMat( ix, ix ) = 0;
    end
end     % function edgeListToAdjMatrix
