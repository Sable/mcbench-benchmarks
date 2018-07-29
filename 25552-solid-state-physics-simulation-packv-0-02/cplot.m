function cplot ( A , N , F )
% Generates then plots a crystal consists of lattice sites and bases in
% three dimensions
%
% function clplot ( A , N , F )
%
% arguments: ( input )
%
%  A - ( class - double ) a ( 3 * 3 ) matrix that each row is a vector that
%  shows primary generator vectors of a lattice in three dimensions.
%
%  N - ( class - double ) a matrix with three possitive integers that shows
%  the number of atoms in each dimensions.
%
%  F - ( class - double ) a ( m * 3 ) matrix that show the bases
%  coordinates. ( m is the number of bases )
%
% Example:
%  A = [ 2 3 3 ; 6 5 3 ; 2 5 3 ] ;
%  N = [ 4 3 5 ] ;
%  F = [ 0 0 0 ; 0 0 1 ; 0 -2 0 ] ;
%  cplot ( A , N , F )
%
% See also rlplot.
%
% Copyright 2009
%
% Release Date: 2009-10-12

% check for simple errors

if nargin < 3
    F = [ 0 0 0 ] ;
end % end of if loop

if nargin < 2
    N = [ 3 3 3 ] ;
end % end of if loop

if nargin < 1
    A = [ 1 0 0 ; 0 1 0 ; 0 0 1 ] ;
end % end of if loop

if ( N ( 1 ) <= 0 ) || ( N ( 2 ) <= 0 ) || ( N ( 3 ) <= 0 ) % condition of negative numbers
    error ' Enterd demensions must be positive integers. ' % error message
end % end of if loop

V = dot ( A ( 1 , : ) , cross ( A ( 2 , : ) , A ( 3 , : ) ) ) ; % Primitive Cell Volume

if V == 0 % condition of same plane vectors
    error ' Vectors must not be in same plane. ' % error message
end % end of if loop

% end of error checking

n = ( N ( 1 ) * N ( 2 ) ) * N ( 3 ) ; % calculates the total number of atomic sites

xy = zeros ( n , 3 ) ; % Preallocating

for i = 0 : N ( 1 ) - 1 % i is the numerator of for loop
    for j = 0 : N ( 2 ) - 1 % j is the numerator of for loop
        for k = 0 : N ( 3 ) - 1 % k is the numerator of for loop
            xy ( ( ( N ( 1 ) * j ) + ( i + 1 ) ) + ( N ( 1 ) * N ( 2 ) ) * k , : ) = A ( 1 , : ) * i + A ( 2 , : ) * j + A( 3 , : ) * k ;
        end % end of for loop
    end % end of for loop
end % end of for loop

xyold = xy ;
f = size ( F ) ;

for q = 1 : f ( 1 )
    for p = 1 : 3
        xy ( : , p ) = xyold ( : , p ) + F ( q , p ) ;
    end
    C = zeros ( n , n , 3 ) ; % Preallocating
    B = eye ( n ) ; % Preallocating
    if F ( q , : ) == [ 0 0 0 ]
        for P = 1 : n % P is the numerator of for loop
            for j = 1 : 3 % j is the numerator of for loop
                C ( P , 1 : n , j ) = xy ( 1 : n , j ) - xy ( P , j ) ; % Connecting vector elements between to lattice atomic sites
            end % end of for loop
        end % end of for loop

        for P = 1 : n % P is the numerator of for loop
            for i = 1 : n % i is the numerator of for loop
                CV ( 1 , : ) = C ( P , i , : );
                for j = 1 : 3 % j is the numerator of for loop
                    if CV == A ( j , : )
                        B ( P , i ) = 1 ; % generates adjacency matrix
                    end % end of if loop
                end % end of for loop
            end % end of for loop
        end % end of for loop
    end % end of if loop
    gplot3 ( B , xy , '.-' ) % plots the net
    axis off
    hold on
end % end of for loop

% With special thanks to John D'Errico
% By Ali Mohammad Razeghi
% My Email ( am_razeghi@yahoo.com ) is also ready to get full detailed
% commentation.