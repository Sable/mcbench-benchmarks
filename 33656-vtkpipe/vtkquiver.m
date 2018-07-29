% VTKQUIVER creates a vtk-file containing a glyph plot similar to Matlab's
%    quiver3 which can be called by a vtk-visualization tool.
%
%    VTKQUIVER(X,Y,Z,U,V,W,VARNAME,FILENAME) plots vectors as glyphs with
%    components (u,v,w) at the points (x,y,z).  The matrices X,Y,Z,U,V,W 
%    must all be the same size and contain the corresponding position and
%    velocity components.  VARNAME should contain the description of the
%    visualized variable which is required by the vtk file format. FILENAME
%    is the name of the .vtu-file to store the data.  If the string does
%    not end with '.vtu', this extension is attached.
%
%    VTKQUIVER(X,Y,[],U,V,[],VARNAME,FILENAME) can be used to abbreviate
%    VTKQUIVER(X,Y,zeros(size(X)),U,V,zeros(size(X)),VARNAME,FILENAME), ie.
%    for 2d plots (vtk expects 3d data).
%
%    To visualize the glyphs you have to load the created .vtu-file via
%    paraview and hit the big `Glyph'-button.
%
% Example
%    [X,Y] = meshgrid(-2:0.25:2,-1:0.2:1);
%    Z = X.*exp(-X.^2-Y.^2);
%    [U,V,W] = surfnorm(X,Y,Z);
%    vtkquiver(X,Y,Z,U,V,W,'velocity','vtkquiver.vtu');
%    % open `vtkquiver.vtu' via Paraview or Mayavi2 and choose `Glyph'
%
% See also quiver, quiver3, vtktrisurf
%
% Copyright see license.txt
%
% Author:     Florian Frank
% eMail:      snflfran@gmx.net
% Version:    1.00
% Date:       Jun 16th, 2010

function vtkquiver(x, y, z, u, v, w, varname, filename)

% ASSERTIONS
assert(nargin == 8)
assert(ischar(varname) && ischar(filename))
dim = length(x(:));
if isempty(z); z = zeros(size(x)); end
if isempty(w); w = zeros(size(x)); end
assert(dim == length(y(:)) && dim == length(z(:)) && ...
  dim == length(u(:)) && dim == length(v(:)) && dim == length(w(:)))

% OPEN FILE
if ~strcmp(filename(end-3:end), '.vtu') % append file extension if not specified yet
  filename = [filename '.vtu'];
end

file = fopen(filename, 'wt');

% HEADER
fprintf(file, '<?xml version="1.0"?>\n');
fprintf(file, '<VTKFile type="UnstructuredGrid" version="0.1" byte_order="LittleEndian" compressor="vtkZLibDataCompressor">\n');
fprintf(file, '  <UnstructuredGrid>\n');
fprintf(file, '    <Piece NumberOfPoints="%d" NumberOfCells="%d">\n', dim, 0);

% POINTS
fprintf(file, '      <Points>\n');
fprintf(file, '        <DataArray type="Float32" NumberOfComponents="3" format="ascii">\n');
for k = 1 : dim
  fprintf(file, '          %.3e %.3e %.3e\n', x(k), y(k), z(k)); 
end
fprintf(file, '        </DataArray>\n');
fprintf(file, '      </Points>\n');

% CELLS (empty but required for paraview)
fprintf(file, '      <Cells>\n');
fprintf(file, '        <DataArray type="Int32" Name="connectivity" format="ascii">\n');
fprintf(file, '        </DataArray>\n');
fprintf(file, '        <DataArray type="Int32" Name="offsets" format="ascii">\n');
fprintf(file, '        </DataArray>\n');
fprintf(file, '        <DataArray type="UInt8" Name="types" format="ascii">\n');
fprintf(file, '        </DataArray>\n');
fprintf(file, '      </Cells>\n');

% % CELL DATA (empty but required for paraview)
% fprintf(file, '      <CellData>\n');
%   fprintf(file, '        <DataArray type="Float32" Name="void" format="ascii">\n');
%   fprintf(file, '        </DataArray>\n');
% fprintf(file, '      </CellData>\n');

% POINT DATA
fprintf(file, '      <PointData Vectors="%s">\n', varname); % def of std value
fprintf(file, '        <DataArray type="Float32" Name="%s" NumberOfComponents="3" format="ascii">\n', varname);
for k = 1 : dim
  fprintf(file, '          %.3e %.3e %.3e\n', u(k), v(k), w(k));
end
fprintf(file, '        </DataArray>\n');
fprintf(file, '      </PointData>\n');

% FOOTER
fprintf(file, '    </Piece>\n');
fprintf(file, '  </UnstructuredGrid>\n');
fprintf(file, '</VTKFile>\n');

fclose(file);

return

end
