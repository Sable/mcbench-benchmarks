function sphere = hypersphere( varargin )
%HYPERSPHERE - Generate n-dimensional Ellipsoid or Sphere
%
% Possible Calls:
%
%       a)  S = hypersphere( sz )
%       b)  S = hypersphere( sz, 'fullOrVoid' )
%       c)  S = hypersphere( sz, matSize )
%       d)  S = hypersphere( sz, matSize, 'fullOrVoid' )
%
% S is a logical array of size max( sz, matSize ) where "true" (or 1)
% defines the points of an n-dimensional ellipsoid or sphere,
% with n == length(sz).
%
%
% Examples:
%
%   a)  The input "sz" defines the size of an ellipsoid:
%         
%         sz = 10                   --> a 1D vector equal to [ 1 0 0 0 0 0 0 0 0 1 ]' 
%
%         sz = [101  101 ]          --> circle with diameter 101 points
%
%         sz = [ 39  101 ]          --> ellipse with short axis of 39 points vertical
%                                       and long axis of 101 points horizontal
%
%         sz = [101  101  101]      --> 3D sphere with diameter 101 points
%
%         sz = [ 10   51   16]      --> 3D ellipsoid with arbitrary size of the axes
%
%         sz = [101 101 101 101 ]   --> 4D hypersphere with diameter 101 points
%
%       ==>  sz may have any size and positive integer values
%
%
%   b)  The flag 'fullOrVoid':
%       Use...
%
%       ... 'void' (default) to have an empty object, e.g. only the line of a circle
%       ... 'full' to have a filled object, e.g. a disc
%
%   c) & d) The parameter matSize:
%
%      You may want to embed the object into the centre of a larger array/matrix.
%      You can specify matSize the same way as the sz-input.
%      matSize must have equal length as sz and all( matSize >= sz ).
%
%      With sz = [30 1 30 30] and matSize = [100 100 100 100] you embed
%      a small 3D sphere into a larger 4D array.

% michael.voelker@mr-bavaria.de
% 2012

    % ( ===================================================================
    % Parse Inputs
    %
        switch nargin
            case 1
                matSize = varargin{1}(:).';
                fullOrVoid = 'void';
            case 2
                if ischar( varargin{2} )
                    matSize    = varargin{1}(:).';
                    fullOrVoid = varargin{2};
                else
                    matSize = varargin{2}(:).';
                    fullOrVoid = 'void';
                end
            case 3
                matSize = varargin{2}(:).';
                fullOrVoid = varargin{3};
            otherwise
                error( 'hypersphere:Nargs', 'You must pass 1-3 arguments.')
        end

        sz = varargin{1}(:).';
    % ) ===================================================================

    sz = single( sz );      % Pythagoras will be evaluated with this precision

    if length(sz) == 1
        sz(2) = 1;
    end
    if length(matSize) == 1
        matSize(2) = 1;
    end
    if length(matSize) ~= length(sz) || any( matSize < sz )
        error( 'hypersphere:MatrixSize', 'matSize must be >= spheresize.')
    end

    nDims = length(sz);

    centreSphere = floor( sz./2      ) + 1;
    centreMatrix = floor( matSize./2 ) + 1;

    rSqu = 0;       % squared distance to centre

    % ( ===================================================================
    % Pythagoras for all dimensions:
    %
    % r^2 = x1^2 + x2^2 + x3^2 + x4^2 + ...
        for d = 1:nDims

            X = (1:sz(d)) - centreSphere(d);
            X = reshape( X, [ true(1,d)  sz(d) ] );         % reshape for bsxfun's needs

            rSqu = bsxfun( @plus, rSqu, (X./sz(d)) .^ 2 );  % iteratively calculate the (squared) distance to 0

            idx{d} = centreMatrix(d) + X(:);        % matrix indices of the sphere's position

        end
    % ) ===================================================================


    sphere = false( matSize );
    sphere(idx{:}) = ( rSqu <= 1/4 );


    % ( ===================================================================
    % Generate void object through recursion
    %
    % keep only the edges:
    % LargeFullSphere - SmallFullSphere = EmptySphere  :-)
    %
        clear rSqu
        if strcmpi( fullOrVoid, 'void' )
            sphere = sphere & ~hypersphere( max(sz-2,1), matSize, 'full' );
        end
    % ) ===================================================================


end  % of hypersphere()
