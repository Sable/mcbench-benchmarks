function [ eigenvalues, kpoints, nelect ] = import_eigenval( filename )
%IMPORT_EIGENVAL Import a VASP EIGENVAL file.
%   [eigenvalues,kpoints,nelect] = IMPORT_EIGENVAL(filename) imports a VASP
%   EIGENVAL file. Optional parameter filename specifies the name of the 
%   file. eigenvalues is a NKPOINTS x NBANDS x ISPIN array of eigenvalues,
%   kpoints is a NKPOINTS x 4 array of k-point coordinates and weights, and
%   nelect is the number of electrons.

% todo:
% check compatibility with non-spin-polarized files

  if nargin == 0
      filename='EIGENVAL';
  end
  
  fid = fopen(filename);
  if fid==-1
    error(['File ' filename ' not found']); 
  end
  
  buffer = fscanf(fid, '%d', 4); % various data
  ispin = buffer(4); % 1 = non-polarized, 2 = polarized
  fgetl(fid); % empty string
  fgetl(fid); % various data
  fgetl(fid); % various data
  fgetl(fid); % various data
  fgetl(fid); % comment
  nelect = fscanf(fid, '%d', 1); % number of electrons
  nkpoints = fscanf(fid, '%d', 1); % number of k-points
  nbands = fscanf(fid, '%d', 1); % number of bands

  fgetl(fid); % empty string
 
  kpoints = zeros(nkpoints,4);
  eigenvalues = zeros(nkpoints, nbands, ispin);
  
  for kpoint = 1:nkpoints
    fgetl(fid); % blank line
    kpoints(kpoint,:) = fscanf(fid, '%f', 4)';
    fgetl(fid); % empty string
    for band = 1:nbands
        buffer = fscanf(fid,'%f',ispin+1);
        eigenvalues(kpoint,band,1:ispin) = buffer(2:(ispin+1));
        fgetl(fid); % empty string
    end
  end
  
  eigenvalues = sort(eigenvalues,2); % sort the bands by energy
  
end