function [ s ] = kpath_length( k, A, mode )
%KPATH_LENGTH Find the distance along a path in k-space. 
%   [ s ] = kpath_length( k, A, mode ) calculates the legnth along a series
%   of N points in k-space whose fractional coordinates are given by the 
%   3xN array k. This is useful for creating band structure plots. The 3x3 
%   matrix A gives the lattice vectors (mode = 'direct') or the reciprocal 
%   lattice vectors (mode = 'reciprocal'). If mode is not specified, the 
%   default is reciprocal.

    if nargin ==3 
        switch mode
            case 'direct'
                B = reciprocal_lattice(A);
            case 'reciprocal'
                B = A;
        end
    end
    
    k = k*B; % convert to Cartesian coordinates
    
    s = zeros(1,size(k,1));
    
    for i = 1:size(k,1)-1
        d = sqrt(sum((k(i,:)-k(i+1,:)).^2));
        s(i+1) = s(i) + d;
    end


end

