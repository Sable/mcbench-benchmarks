function [ geometry ] = import_poscar( filename )
%IMPORT POSCAR Import a VASP POSCAR/CONTCAR file.
%   geometry = import_poscar(filename) imports the given VASP
%   POSCAR/CONTCAR file. The data is contained in a geometry structure with
%   the following fields:
%
%    filename: string containing name of the file.
%    comment: first line of file.
%    lattice: 3x3 matrix whose rows are the lattice vectors.
%    symbols: cell array containing chemical symbols.
%    atomcount: nx1 array containing the number of atoms of each type.
%    selective: boolean indicating whether selective dynamics is enabled.
%    coords: nx3 matrix containing ion positions in fractional coordinates.
%
%   See also EXPORT_POSCAR.

% to do: 
% test
% handle negative scale factors (cell volume)

  if nargin == 0
      filename='POSCAR';
  end
  
  if ~isnumeric(filename)
      geometry.filename = filename;
      fid = fopen(filename);
      if fid==-1
        error(['File ' filename ' not found.']); 
      end
  else
      fid = filename;
      geometry.filename = fopen(fid);
  end
 
    geometry.comment = fgetl(fid); % comment
    scale = fscanf(fid, '%f',1); % scale factor for coordinates
    
    geometry.lattice = fscanf(fid, '%f %f %f', [3 3])'; 
    geometry.lattice = geometry.lattice*scale;
    
    fgetl(fid); % empty string
    line = fgetl(fid); % chemical symbols or atom count
%    has_symbols_line = false;
    if sum(isstrprop(line, 'digit')) == 0
        geometry.symbols = regexp(line, '([^ ]*)', 'match');
        line = fgetl(fid);
%        has_symbols_line = true;
    else
        geometry.symbols = {};
    end
    geometry.atomcount = sscanf(line,'%d');
    natoms = sum(geometry.atomcount);
        
    line = fgetl(fid); % Direct/cart or selective
    geometry.selective = 0;
    if line(1) == 's' || line(1) == 'S'
        geometry.selective = 1;
        line = fgetl(fid);
    end
    cartesian = 0;
    if line(1) =='C' || line(1) == 'c' || line(1) == 'K' || line(1) =='k'
        cartesian = 1;
    end
    
    %if geometry.selective==1
    %    geometry.coords = fscanf(fid, '%f %f %f %*s %*s %*s', [3 natoms])';
    %else
    %    geometry.coords = fscanf(fid, '%f %f %f', [3 natoms])';
    %end
    
    for i = 1:natoms
        line = fgetl(fid);
        
        % read coordinates
        geometry.coords(i,:) = sscanf(line, '%f %f %f');
        
        % check if chemical symbols are included as comments
%        if ~has_symbols_line
%           if numel(strfind(line,'!')==1)
%               str = regexp(line, '[^ ]*', 'match');
%               str = str{end};
%               newelement = false; % is this atom a new element?
%               if numel(geometry.symbols)==0
%                   newelement=true;
%               else
%                   if strcmp(geometry.symbols{end},str)==0
%                       newelement=true;
%                   end
%               end
%               if newelement
%                  geometry.symbols{end+1} = str;
%               end
%              
%           end
%        end      
        
    end
    
    % convert to fractional coordinates
    if cartesian==1
        geometry.coords = geometry.coords*scale;
        geometry.coords = geometry.coords/geometry.lattice;
    end
    
    if ~isnumeric(filename)
        fclose(fid);
    end
end