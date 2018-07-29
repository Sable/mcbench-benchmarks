function [ chg mag geometry ] = import_chgcar( filename )
%IMPORT_CHGCAR Import a VASP CHGCAR file. 
%   [chg,mag,geometry] = import_chgcar(filename)
%   Import a VASP CHGCAR file. If no filename is specified, data is read 
%   from CHGCAR. chg and mag are three dimensional arrays containing the 
%   charge magnetization densities in Bohr magneton per cubic Angstrom. 
%   Note that these are not the same units as the CHGCAR file. geometry is 
%   a struct describing the cell geometry; see IMPORT_POSCAR for a detailed
%   description.
%
%   See also IMPORT_POSCAR, IMPORT_LOCPOT.

% todo:
% check compatibility with non-spin-polarized files
% extract chemical symbols
% what about AECAR and ELFCAR files?

  if nargin == 0
      filename='CHGCAR';
  end

  fid = fopen(filename);
  if fid==-1
    error(['File ' filename ' not found']); 
  end
 
    geometry = import_poscar(fid);
  
    vol = abs(dot(geometry.lattice(1,:),cross(geometry.lattice(2,:),geometry.lattice(3,:))));
    natoms = sum(geometry.atomcount);
    

    fgetl(fid); % blank line
    
    gridsize = fscanf(fid, '%d %d %d', [3 1])';
    
    chg = fscanf(fid, '%f', [prod(gridsize,2) 1])';
    chg = reshape(chg,gridsize);
    chg = chg/vol;
    
    fgetl(fid); % empty string (or padding)
    
    pos = ftell(fid);
    line = fgetl(fid);
    fseek(fid,pos,'bof');
    if line(1)=='a' 
        for i = 1:natoms
            line = fgetl(fid);
            nentries = sscanf(line,['augmentation occupancies ' num2str(i)...
                ' %d']); % number of occupancy entries
            fscanf(fid, '%f', [nentries 1]);
            fgetl(fid); % empty string      
        end
        fscanf(fid, '%f', [natoms 1]); % don't know what these are
        fgetl(fid); % empty string     
    end
    
    pos = ftell(fid);
    fgetl(fid);
    if ~feof(fid)     
        fseek(fid,pos,'bof');
        gridsize = fscanf(fid, '%d %d %d', [3 1])';

        mag = fscanf(fid, '%f', [prod(gridsize,2) 1])';
        mag = reshape(mag,gridsize);
        mag = mag/vol;
    else
        mag = [];
    end
    
    fclose(fid);

end

