function [ locpot geometry ] = import_locpot( filename )
%IMPORT_LOCPOT Import a VASP LOCPOT file. 
%   [locpot,geometry] = import_locpot(filename) imports a VASP LOCPOT file.
%   If no filename is specified, data is read from LOCPOT. locpot is a
%   three dimensional array containing the local potential in eV. geometry
%   is a geometry structure; see IMPORT_POSCAR for a detailed description.
%
%   See also IMPORT_POSCAR, IMPORT_CHGCAR.

% todo:
% check compatibility with non-spin-polarized files
% extract chemical symbols
% update comments
% perhaps combine with import_chgcar.m

  if nargin == 0
      filename='LOCPOT';
  end

  fid = fopen(filename);
  if fid==-1
    error(['File ' filename ' not found']); 
  end
 
    geometry = import_poscar(fid);
    
    %fgetl(fid); % empty string
    fgetl(fid); % blank line?
    
    gridsize = fscanf(fid, '%d %d %d', [3 1])';
    
    chg = fscanf(fid, '%f', [prod(gridsize,2) 1])';
    chg = reshape(chg,gridsize);
    %chg = chg/vol;
    
    locpot = chg;
    
    fclose(fid);

end