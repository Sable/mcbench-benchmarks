function [ C , coord , MN ] = rcv ( A , N )
% Generates reciprocal lattice sites, Calculates connecting vectors from point to
% point, Finds the number of nearest neighbors of each atomic site. 
%
% function [ C , coord , MN ] = rcv ( A , N )
%
% arguments: ( input )
%
%  A - ( class - double ) a ( 3 * 3 ) matrix that each row is a vector that
%  shows primary generator vectors of a lattice in three dimensions.
%
%  N - ( class - double ) a matrix with three possitive integers that shows
%  the number of atoms in each dimensions.
%
% arguments: ( output )
%
%  CV - ( class - double ) A ( N ( 1 ) * N ( 2 ) * N ( 3 ) ) * ( N ( 1 ) * 
%  N ( 2 ) * N ( 3 ) ) * 3 matrix connecting vector between each two
%  reciprocal atomic sites
%
%  coord - ( class - double ) Coordination number (Number of nearest 
%  neighbors) of each reciprocal of atomic site
%
%  MN - ( class - double ) Mean distance between the nearest neighbor of
%  each reciprocal of atomic site
%
% Example:
%  A = [ 2 3 3 ; 6 5 3 ; 2 5 3 ] ;
%  N = [ 4 3 5 ] ;
%  [ CV , COORD , MN ] = rcv ( A , N )
%
% See also cv.
%
% Copyright 2009
%
% Release Date: 2009-09-21

% check for simple errors

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

Aold = A ;
A ( 1 , : ) = ( 2 * pi / V ) * cross ( Aold ( 2 , : ) , Aold ( 3 , : ) ) ; % Creates Reciprocal Lattice Vector
A ( 2 , : ) = ( 2 * pi / V ) * cross ( Aold ( 3 , : ) , Aold ( 1 , : ) ) ; % Creates Reciprocal Lattice Vector
A ( 3 , : ) = ( 2 * pi / V ) * cross ( Aold ( 1 , : ) , Aold ( 2 , : ) ) ; % Creates Reciprocal Lattice Vector

n = ( N ( 1 ) * N ( 2 ) )* N ( 3 ) ; % calculates the total number of atomic sites

xy = [ ] ; % Preallocating

for i = 0 : N ( 1 ) - 1 % i is the numerator of for loop
    for j = 0 : N ( 2 ) - 1 % j is the numerator of for loop
        for k = 0 : N ( 3 ) - 1 % k is the numerator of for loop
            xy ( ( ( N ( 1 ) * j ) + ( i + 1 ) ) + ( N ( 1 ) * N ( 2 ) ) * k , : ) = A ( 1 , : ) * i + A ( 2 , : ) * j + A( 3 , : ) * k ;
        end % end of for loop
    end % end of for loop
end % end of for loop

C = zeros ( n , n , 3 ) ; % Preallocating
D = zeros ( n , n , 3 ) ; % Preallocating
E = zeros ( n , 3 ) ; % Preallocating
coord = zeros ( 1 , n ) ; % Preallocating
MIN = zeros ( n-1 , n ); % Preallocating
k = 1 ; % Preallocating

for P = 1 : n % P is the numerator of for loop
    for j = 1 : 3 % j is the numerator of for loop
        C ( P , 1 : n , j ) = xy ( 1 : n , j ) - xy ( P , j ) ; % Connecting vector elements between to lattice atomic sites
        D ( P , 1 : n , j ) = ( xy ( 1 : n , j ) - xy ( P , j ) ) .^ 2 ;
    end % end of for loop
    E ( P , 1 : n ) = sqrt ( D ( P , 1 : n , 1 ) + D ( P , 1 : n , 2 ) + D ( P , 1 : n , 3 ) ) ;
end % end of for loop

for P = 1 : n % P is the numerator of for loop
    for i = 1 : n % i is the numerator of for loop
        if E ( P , i ) ~= 0
            MIN ( k ) = E ( P , i ) ; % Eliminates zero value elements
            k = k + 1 ;
        end % end of if loop
    end % end of for loop
end % end of for loop

MN = min ( MIN ) ; % Nearest neighbors distance

for P = 1 : n % P is the numerator of for loop
    t = 0 ; % Preallocating
    for i = 1 : n % i is the numerator of for loop
        if E ( P , i ) == MN ( P )
            t = t + 1 ; % Counts number of nearest neighbors
        end % end of if loop
    end % end of for loop
    coord ( P ) = t ;
end % end of for loop

% With special thanks to John D'Errico
% By Ali Mohammad Razeghi
% My Email ( am_razeghi@yahoo.com ) is also ready to get full detailed 
% commentation.