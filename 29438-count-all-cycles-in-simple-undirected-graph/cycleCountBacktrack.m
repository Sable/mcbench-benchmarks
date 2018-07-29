function [ cycleCount, elapsedTime ] = cycleCountBacktrack( inputFormat, source, varargin )
% cycleCountBacktrack: Count all cycles in input graph up to specified
%   size limit, using backtracking algorithm.  Designed for undirected
%   graphs with no self-loops or multiple edges.
%
% usage: cycleCountBacktrack( inputFormat, source [, limit ] )
%
% input arguments:
%   inputFormat, source - Enter 'help readGraph' for information on
%       supported input formats.
%   limit (optional) - type: integer. Specifies largest cycle size to
%       search for and count.
%
% output arguments:
%   cycleCount - type: vector of integers (as doubles).  Holds counts
%       of cycles for each size cycle from 3 up to limit.
%   elapsedTime - type: double.  Elapsed time for computation of cycle
%       counts, in seconds.
%
% Algorithm is guaranteed to find each cycle exactly once.  It
%   is essentially equivalent to Johnson (SIAM J. Comput. (1975),
%   4, 77), but for undirected graphs, and without the look-ahead
%   feature.  The lack of look-ahead is expected to have
%   negligible performance impact on dense random graphs.
%
% Sample source files for each inputFormat are included with
%   this code.
%
% Copyright (c) 2011, J. Jeffry Howbert and Laboratory for 
%   Experimental Combinatorics.  All rights reserved.
% Version 1.1             Aug. 27, 2011
%
    global A limit cycleCount;
    
    if ( nargin < 2 )
        disp( 'usage: cycleCountBacktrack( inputFormat, source, [ optional: limit ] )' );
        return
    end
    A = readGraph( inputFormat, source );
    if ( isempty( A ) )
        return
    end
    nVert = size( A, 1 );

    if ( size( varargin ) >= 1 & isnumeric( varargin{ 1 } ) )
        limit = floor( varargin{ 1 } );
        if ( limit < 3 )
            limit = 3;
        elseif ( limit > size( A, 1 ) )
            limit = size( A, 1 );
        end
    else
        limit = size( A, 1 );
    end
    
    format compact;
    tic;    % start stopwatch timer

    cycleCount = zeros( 1, nVert );

    % Generate all unique triples of connected vertices which have
    %   indices v1 < v2 < v3 and connections v2 - v1 - v3, then 
    %   search for paths which connect v2 to v3
    for ix = 1 : nVert - 2                    % v1
        for jx = ix + 1 : nVert - 1           % v2
            if ( A( ix, jx ) == 1 )
                inclVert = [ zeros( 1, ix ), ones( 1, nVert - ix ) ];
                inclVert( jx ) = 0;
                for kx = jx + 1 : nVert       % v3
                    if ( A( kx, ix ) == 1 )
                        % initial path length = 2; now look for extensions
                        nextVert( inclVert, 2, jx, kx );  
                    end
                end
            end
        end
    end

    elapsedTime = toc;    % halt stopwatch timer and display elapsed time
    fprintf( 1, '\nElapsed time is %8.6f seconds.\n\n', elapsedTime );
    
    disp( 'cycles in graph' );
    disp( 'size     count' );
    for ix = 3 : limit
        fprintf( '%4d  %8d\n', ix, cycleCount( ix ) )
    end
    cycleCount = cycleCount( 3 : limit );   % return counts

end         % function cycleCountBacktrack

% extend current path by one additional vertex
function nextVert( inclVert, len, origin, target )
    % input arguments:
    %   inclVert - type: vector of 0's and 1's.  1's specify
    %       vertices available for extension of current path;
    %       0's indicate vertices blocked because they have
    %       lower index than v1, or are already on current
    %       path.
    %   len - type: integer.  Length of current path.
    %   origin - type: integer.  Vertex at growing terminus
    %       of current path.
    %   target - type: integer.  Vertex at start of path (v3).
    global A limit cycleCount;
    len = len + 1;
    % get candidates for extension
    cand = find( inclVert .* A( origin, : ) );
    for mx = 1 : size( cand, 2 )
        ca = cand( mx );
        if ( ca == target )         % found a cycle
            cycleCount( len ) = cycleCount( len ) + 1;
        elseif ( len < limit )      % extend again
            inclVert1 = inclVert;
            inclVert1( ca ) = 0;    % block vertex just added to path 
            nextVert( inclVert1, len, ca, target );
        end
    end
end     % function nextVert
