function [ result ] = plot_neb_spline( directory  )
%PLOT_NEB_SPLINE Plot the energy along a NEB path.
%   result = PLOT_NEB_SPLINE() plots the energy as a function of
%   hyperdistance using the results of a NEB calculation. Each image
%   directory (01, 02, ... NIMG) must contain an OUTCAR and CONTCAR file.
%   The end points (00 and NIMG+1) must contain an OUTCAR and POSCAR file.
%   The energies are fit with a spline using NEB_SPLINE.
%
%   See also NEB_ENERGIES, NEB_SPLINE, HYPERDISTANCE.

    startDir = pwd();
    if nargin > 0
       cd(directory);
    end
    result = 0;
    
    [ energy0 x0 ] = neb_energies();
    [ energy x ] = neb_spline();
    
    figure
    hold on
    plot(x0, energy0, 'ok')
    plot(x, energy, 'k')
    
    xlabel(['Hyperdistance (' char(197) ')'])
    ylabel('Energy (eV)')
    
    cd(startDir);
end

