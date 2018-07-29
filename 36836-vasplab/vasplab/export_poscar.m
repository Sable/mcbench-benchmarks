function [ status ] = export_poscar( filename, geometry )
%EXPORT_POSCAR Export a geometry struct as a VASP POSCAR file.
%   status = EXPORT_POSCAR(filename,geometry) exports the geometry as a 
%   VASP POSCAR file. 
%
%   See also IMPORT_POSCAR.

    % write selective dynamics and chemical symbols

    fid = fopen(filename,'w');
    if fid==-1
        error(['Error opening ' filename]); 
    end
    
    fprintf(fid,[geometry.comment '\n']);
    fprintf(fid,'1.0\n'); % scale factor
    fprintf(fid, '%19.16f %19.16f %19.16f\n', geometry.lattice'); % lattice vectors  
    if ~isempty(geometry.symbols)
        cellfun(@(x) fprintf(fid, '%s ', x), geometry.symbols);
        fprintf(fid, '\n');
    end
    fprintf(fid, '%d ', geometry.atomcount); % number of each species
    fprintf(fid, '\nDirect\n');
    fprintf(fid, '%19.16f %19.16f %19.16f\n', geometry.coords');   
    
    fclose(fid);

    status = 0;
    
end

