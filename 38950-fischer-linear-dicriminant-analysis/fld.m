function [V, eigvalueSum] = fld(X, L, n, crit, qrf, r, e, M )
%
%   Finding the discriminative susbspace for samples using fischer
%   linear dicriminant 
% 
%   Syntax [ V, eigvalueSum ] = fld( X, L, n, crit, qrf, r, e, M )
%
%   Input arguments: 
%       X: the s x d samples matrix (s samples x d features each )
%       L: the s x 1 labels matrix
%       n: the dimension the subspace required
%   Optional arguments: 
%    crit: 1 (ratio trace criterion - default)
%          2 (trace ratio criterion)
%          3 (tr criterion for subspace + rt criterion for axis)
%     qrf: preprocess with qr decompsition, for robustness  (default value: false)
%       r: the regularization parameter   (default value: 0)
%       e: epsilon value to end iterations for tr criterion (defaut value: 0.001)
%       M: maximum number of iterations for tr criterion (defaut value: 100)
%
%   Output:
%         V: the optimal fiher ( n x d ) orthonormal matrix 
%     ratio: the sum of generalized eigenvalues or the optimal value of the trace ratio 
%   eigvals: the eigenavalues of the (B - r * W) matrix
%
%   The implementation of the trace ratio criterion is based on:
%  	Lei-Hong Zhang, Li-zhi Liao and Michael K. Ng, "Fast Algorithms for 
%   the generalized foley-sammon discriminant analysis", SIAM Journal on 
%   Matrix Analysis and Applications, vol 31, p.1584, 2010
%
%   authors: Sergios Petridis

% checking the arguments

    error( nargchk(3,8,nargin) )

    if ( nargin < 4 )
        crit = 1;
    end

    % default value for r
    if ( nargin < 5 )
        qrf = false;
    end


    % default value for r
    if ( nargin < 6 )
        r = 0.0;
    end

    % default value for epsilon
    if ( nargin < 7 )
        e=0.01;
    end

    % default value for M
    if ( nargin < 8 )
        M=100;
    end

    if( length( L ) ~= size( X, 1 ) ) 
        error( 'Samples Matrix and Labels Matrix do not match') 
    end

    % check that mu is a small positive number
    if ( ( crit < 0 ) || crit > 3 )
        error( 'crit should be one of: 1, 2 or 3 (see help)') 
    end


    % check that r is a small positive number
    if ( ( r < 0 ) || r > 1 )
        error( 'r should be in the [0, 1] range ') 
    end

    % check that epsilon is a small positive number
    if ( ( e < 0 ) || e > 1 )
        error( 'Epsilon should be in the [0, 1] range ') 
    end

    % check that M is positive
    if ( M < 1 )
        error( 'Maximum number of iterations M should be positive') 
    end

    
% Evaluate Mixed Class Statistics

    [ S, D ] = size( X ) ; % number of dimensions of the original space
    Xm = mean( X ); % mixed class mean
    Xc = X - repmat(Xm, S, 1 ); % centered mixed class samples
    Xs = Xc' * Xc / S ; % mixed class covariance matrix

% Evaluate Within Class Statistics

    Lunique = unique( L );  % unique labels
    Lnum = length( Lunique ); % number of unique labels
    Ws = zeros( D ) ; % initialize within-class covariance matrix

    for i = 1 : Lnum % iterate over all elements of the unique labels 
    	XL = X( L == Lunique( i ), : ) ; % samples for the label
        XLm = mean( XL ); % within-class mean
        XLn = size( XL, 1 );
        XLc = XL - repmat( XLm, XLn, 1 ); % centered within-class samples
        XLs = XLc' * XLc / size( XLc, 1 ) ; % within-class covariance matrix
    	Ws = Ws + XLs ; % update average within-class covariance matrix
    end
    Ws  = Ws / Lnum;

% Evalute between Class Statistics - actually not needed
%    Bs = Xs - Ws;

% Set Nominator - Denominator matrices
    % Nmat = Bs; Dmat = Ws; 
    Nmat = Xs; Dmat = Ws; 
    % Nmat = Bs; Dmat = Xs; % alternative
    
% regularised denominator Matrix
    if ( r > 0 )
        regMat = eye( size( Nmat ) ) * sum( Nmat( : ) ) / size( Nmat, 1 );
        Nmat = ( 1 - r ) * Nmat + r * regMat ;
    end

% Project to the Q subspace of the QR decomposition of X, for robustness
    if ( qrf )
        [ Q, R, E ] = qr( X', 0 );
        [ Nmat, Dmat ] = projectMatrices( Nmat, Dmat, Q' );
    end
    
    % check that the number of dimensions to be extracted is in the valid range
    if ( n < 1 ) 
        error( 'Number of extracted dimensions should be positive') 
    end
    
    if ( n > size( Nmat, 1 ) )
        n = size( Nmat, 1 );
        s = sprintf( 'Warning: Number of extracted dimensions are reduced to %d', n );
        disp( s );
    end
    
    switch ( crit )
        case 1
            [V, eigvalueSum ] = ratio_trace_criterion( Nmat, Dmat, n );
        case 2
            [V, eigvalueSum ] = trace_ratio_criterion( Nmat, Dmat, n, e, M);
        case 3
            [Vsub, eigvalueSum] = trace_ratio_criterion( Nmat, Dmat, n, e, M);
            [ NmatSub, DmatSub ] = projectMatrices( Nmat, Dmat, Vsub );
            [Vaxis, notUsed ] = ratio_trace_criterion( NmatSub, DmatSub, n );
            V = Vsub * Vaxis;
    end

% Project to the original space, if using qr 
    if( qrf )
        V = Q' * V ;
    end

end

function Y = projectSymmetric( X, A )
    Y = A' * X * A;
    Y = ( Y + Y' ) / 2;
end

function [Nmat, Dmat ] = projectMatrices( Nmat, Dmat, A )
    Nmat = projectSymmetric( Nmat, A );
    Dmat = projectSymmetric( Dmat, A );
end

function B = normaliseCols( A )
    B = A;
    for i = 1: size( A, 2 )
        B(:,i) = A(:,i)./ norm( A(:,i) );
    end
end

function [ V, eigvalueSum ] = ratio_trace_criterion( Nmat, Dmat, n )
    OPTS.disp = 0;
    [V, eigvalue] = eigs( Nmat, Dmat, n, 'LM', OPTS );
    eigvalueSum = sum( eigvalue(:) );
    V = normaliseCols( V );
end

function [ V, r ] = trace_ratio_criterion( Nmat, Dmat, n, e, M  )

    r = 0;
    r_p = e + eps;
    V = eye( size( Nmat, 1 ), n );
    i = 0 ;% iteration counter

    OPTS.disp = 0;
    % iterations
    while ( ( abs( r - r_p ) > e ) && ( i < M ) )
        r_p = r ;% save the old ratio value, for the termination criterion
        r = trace( V' * Nmat * V) / trace( V' * Dmat * V ) ; % compute new ratio value
        [ V, notUsed ] = trace_difference_criterion( Nmat, Dmat, r, n )
        i = i + 1;
    end

end

function [ V, eigvalueSum ] = trace_difference_criterion( Nmat, Dmat, beta, n  )

    [ V, eigvalues ] = eigs( Nmat - beta * Dmat, n, 'LA', OPTS );
    eigvalueSum = sum( eigvalues(:) );
end
