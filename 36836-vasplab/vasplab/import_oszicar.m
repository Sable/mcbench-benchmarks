function [ energy ] = import_oszicar( filename )
%IMPORT_OSZICAR Import energies from a VASP OSZICAR file.
%   energy = import_oszicar(filename) imports the energies at each
%   optimization step from a VASP OSZICAR file. If no filename is
%   specified, data is read from OSZICAR.


    if nargin == 0
        filename='OSZICAR';
    end
  
    fid = fopen(filename);
    if fid==-1
        error(['File ' filename ' not found']); 
    end
    
    energy = [];
    while ~feof(fid)
       line = fgetl(fid);
       [match tok] = regexp(line, 'E0= ([\.-+E0-9]*)', 'match', 'tokens');
       if numel(match)>0
          energy = [energy str2double(tok{1}{1})];
       end

        
    end

end

