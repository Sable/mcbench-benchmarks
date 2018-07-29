% VTKSERIES creates a vtk-file containing plots for a series of time
%    which can be called by a vtk-visualization tool.
%
%    VTKSERIES(T, F, FILENAME)
%
%    The argument T contains the time points and F the names of the .vtu
%    data files as cell (cf. example).  FILENAME is the name of the
%    .pvd-file to store the data.  If the string does not end with '.pvd',
%    this extension is attached.
%
% Example
%    [X,Y] = meshgrid(-2:0.25:2,-1:0.2:1);
%    T = 0:0.1:2;
%    F = cell(length(T), 1);
%    for k = 1 : length(T)
%      Z = T(k)*X.* exp(-X.^2 - Y.^2);
%      F{k} = sprintf('data.%d.vtu', k-1); % output will be 'data.0.vtu', data.1.vtu' etc
%      TRI = delaunay(X,Y);
%      vtktrisurf(TRI,X,Y,Z,'pressure',F{k});
%    end
%    vtktimeseries(T, F, 'datatimeseries.pvd');
%    
%    % open `dataseries.pvd' via Paraview or Mayavi2
%
% See also trisurf, vtkquiver
%
% Copyright see license.txt
%
% Author:     Florian Frank
% eMail:      snflfran@gmx.net
% Version:    1.00
% Date:       Jun 16th, 2010

function vtkseries(t, f, filename)

assert(nargin == 3)
assert(isa(f, 'cell'))
assert(ischar(filename))
assert(length(t(:)) == length(f(:)))

% OPEN FILE
if ~strcmp(filename(end-3:end), '.pvd') % append file extension if not specified yet
  filename = [filename '.pvd'];
end

file = fopen(filename, 'wt');

fprintf(file, '<?xml version="1.0"?>\n');
fprintf(file, '<VTKFile type="Collection" version="0.1">\n');
fprintf(file, '  <Collection>\n');
for k = 1 : length(t(:))
  fprintf(file, '    <DataSet timestep="%f" group="" part="0" file="%s"/>\n', t(k), f{k});
end
fprintf(file, '  </Collection>\n');
fprintf(file, '</VTKFile>\n');

fclose(file);

return

end
