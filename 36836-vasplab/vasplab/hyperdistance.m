function [ x ] = hyperdistance( geo1, geo2 )
%HYPERDISTANCE Calculate hyperdistance between two geometry structures.
%   x = HYPERDISTANCE(geometry1,geometry2) evaluates the hyperdistance 
%   between two geometries. The hyperdistance is defined as the root mean 
%   square of the displacements of each atom. The returned value is only 
%   meaningful if the two geometries have the same lattice vectors. The 
%   minimum image convention is used to calculate atomic displacements. See
%   IMPORT_POSCAR for a detailed description of the geometry structure.
%
%   See also IMPORT_POSCAR.

       x = sqrt(sum(sum(((mod(abs(geo2.coords-geo1.coords)+0.5,1)-0.5)*geo1.lattice).^2)));

end

