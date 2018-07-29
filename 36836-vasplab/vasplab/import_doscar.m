function [ energy total_dos efermi pdos ] = import_doscar( filename )
%IMPORT_DOSCAR Import a VASP DOSCAR file.
%   [energy,total_dos,efermi,pdos] = IMPORT_DOSCAR(filename) imports a 
%   VASP DOSCAR file. If no filename is specified, the file DOSCAR is read.
%   energy contains the bin energies in eV, total_dos contains the total 
%   DOS in states per unit cell eV, efermi is the Fermi level in eV, and 
%   pdos contains the site projected DOS in states per unit cell eV.

%todo:
% handle non-spin-polarized data

    if nargin == 0
        filename='DOSCAR';
    end
  
    fid = fopen(filename);
    if fid==-1
        error(['File ' filename ' not found']); 
    end
    
    buffer = fscanf(fid, '%f', 4)'; % various data
    natoms = buffer(1); % should this be 1 or 2?
    fgetl(fid); % empty string   
    fgetl(fid);
    fgetl(fid);
    fgetl(fid);
    fgetl(fid); 
    buffer = fscanf(fid, '%f', 5);
    nedos = buffer(3); % NEDOS
    efermi = buffer(4); % Fermi level
    fgetl(fid); % empty string
    position = ftell(fid);
    buffer = sscanf(fgetl(fid),'%f'); % first line of total DOS
    ispin = 1+(max(size(buffer))==5); % determine spin polarization
    fseek(fid, position, 'bof');
    total_dos = fscanf(fid, '%f', [(1+2*ispin) nedos])'; % total DOS
    energy = total_dos(:,1);
    total_dos = total_dos(:,2:(1+ispin));
    
    fgetl(fid); % empty string
    
    pdos = zeros([nedos 9*ispin natoms]);
    for i=1:natoms
       if fgetl(fid)~=-1
         buffer = fscanf(fid, '%f', [(1+9*ispin) nedos])';
         pdos(:,:,i) = buffer(:,2:end);
         fgetl(fid); % empty string
       end
    end

end

