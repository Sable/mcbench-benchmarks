function [ status ] = interpolate_poscar( filename1, filename2, N )
%INTERPOLATE_POSCAR Interpolate a chain of images between two POSCAR files.
%   status = interpolate_poscar(filename1,filename2,N) interpolates a chain
%   of N images between two POSCAR files. The interpolated geometries are
%   placed in 00/POSCAR, 01/POSCAR ... N+1/POSCAR. This is useful for
%   setting up NEB calculations.
%
%   See also PERMUTE_COORDS.

    [ geo1 ] = import_poscar( filename1 );
    [ geo2 ] = import_poscar( filename2 );
    
    if sum(sum(geo1.lattice~=geo2.lattice))~=0
        fprintf('Warning: lattice parameters are not equal.');
    end
    
    if sum(geo1.atomcount)~=sum(geo2.atomcount)
        error('Atom counts not equal.');
    end
    
    shift = geo2.coords - geo1.coords;
    shift = shift + repmat([0.5 0.5 0.5], sum(geo1.atomcount), 1);
    shift = mod(shift,1) - repmat([0.5 0.5 0.5], sum(geo1.atomcount), 1);
    
    geo = geo1;
    
    for i = 0:(N+1)
       w = i/(N+1);
       geo.coords = geo1.coords + w*shift;
       dir = sprintf('%02d',i);
       mkdir(dir);
       status = export_poscar( [dir '/POSCAR'], geo );
    end

end