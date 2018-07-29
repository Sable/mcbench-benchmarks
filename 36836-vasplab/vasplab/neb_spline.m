function [ energy hyperdistance ] = neb_spline( directory, N  )
%NEB_SPLINE Fit energies and forces of a NEB calculation using a spline.
%   [energy,x] = neb_spline(directory,N) interpolates the energies from
%   an NEB calculation using piecewise cubic Hermite polynomial
%   interpolation. Optional argument directory specifies the directory
%   containing the subdirectories 00, 01, etc. Optional argument N
%   specifies the number of points to interpolate; the default is 1000.
%   Both the energies and forces are used to perform the interpolation.
%   The vector energy contains the energy, and the vector x contains the
%   hyperdistance along the path.
%
%   See also NEB_ENERGIES, PLOT_NEB_SPLINE, HYPERDISTANCE.

  startDir = pwd();
  if nargin > 0
      cd(directory);
  end
    
  if nargin < 2
      N=1000; % number of points to interpolate
  end
    nimg = num_images();
    
    slope = zeros(1,nimg);
    slope(1) = 0;
    slope(nimg+2) = 0;
    
    [ energy0 hyperdistance0 ] = neb_energies(); % energies/distance of images
    
        % read images
    for i = 2:nimg+1
       forces = import_outcar([sprintf('%02d',i-1) '/OUTCAR'],'forces');
       tangent = import_outcar([sprintf('%02d',i-1) '/OUTCAR'],'tangent');
       tangent = tangent/sqrt(sum(sum(tangent.^2)));
       slope(i) = -sum(sum(forces.*tangent));    
    end
    
    hyperdistance = 0:hyperdistance0(end)/(N-1):hyperdistance0(end);
    
    energy = pchipd(hyperdistance0,energy0,slope,hyperdistance);

    cd(startDir);
end

