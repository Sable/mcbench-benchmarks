function [ energy x ] = neb_energies( directory )
%NEB_ENERGIES Extract energies and hyperdistance from NEB calculation.
%   [energy,x] = NEB_ENERGIES(directory) extracts the energies and
%   hyperdistance of each image from an NEB calculation. The optional
%   argument directory can be used to specify the directory containing the
%   subdirectories 00, 01, etc. If directory is specified, the current
%   directory is used. If no OUTCAR file is present in subdirectories 00 
%   and N+1, then first and last value of energy of will be NaN.
%
%   See also NEB_SPLINE, PLOT_NEB_SPLINE, HYPERDISTANCE.

% shouldn't change directory

    startDir = pwd();
    if nargin == 1
        cd(directory);
    end
    
    nimg = num_images();
    
    energy = zeros(1,nimg+2);
    x = zeros(1,nimg+2);
    
    % read starting point
    if exist('00/OUTCAR','file')
        %buffer = import_oszicar('00/OSZICAR');
        energy(1) = import_outcar('00/OUTCAR','energy');    
    else
        energy(1) = nan;
    end
    
    geo1 = import_poscar('00/POSCAR');
    x(1) = 0;
         
    % read images
    for i = 2:nimg+1
       %buffer = import_oszicar([sprintf('%02d',i-1) '/OSZICAR']);
       energy(i) = import_outcar([sprintf('%02d',i-1) '/OUTCAR'],'energy');
       geo2 = import_poscar([sprintf('%02d',i-1) '/CONTCAR']);
       x(i) = x(i-1) + hyperdistance(geo1,geo2);
       geo1=geo2;
    end
    
    % read ending point
    if exist([sprintf('%02d',nimg+1) '/OUTCAR'],'file')
        %buffer = import_oszicar([sprintf('%02d',nimg+1) '/OSZICAR']);
        energy(nimg+2) = import_outcar([sprintf('%02d',nimg+1) '/OUTCAR'],'energy');    
    else
        energy(nimg+2) = nan;
    end
    
    geo2 = import_poscar([sprintf('%02d',nimg+1) '/POSCAR']); 
    x(nimg+2) = x(nimg+1) + hyperdistance(geo1,geo2);

    cd(startDir);
    
end

