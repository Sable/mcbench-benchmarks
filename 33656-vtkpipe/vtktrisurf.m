% VTKTRISURF % VTKQUIVER creates a vtk-file containing a plot similar to
%    Matlab's trisurf which can be called by a vtk-visualization tool.
%
%    VTKTRISURF(TRI,X,Y,Z,VALS,VARNAME,FILENAME)
%    See Matlab documentation acc. to TRISURF(TRI,X,Y,Z,C).
%
%    VTKTRISURF(TRI,X,Y,Z,VARNAME,FILENAME)
%    See Matlab documentation acc. to TRISURF(TRI,X,Y,Z).
%
%    The (optional) argument VALS should contain the scalar data, which can
%    be given on the vertices or on the cells/triangles of the triangu-
%    lation.  The type is determined automatically.If VALS is not 
%    specified, Z is used as point data.  The argument VARNAME should 
%    contain the description of the visualized variable which is required
%    by the vtk file format. FILENAME is the name of the .vtu-file to store
%    the data.  If the string does not end with '.vtu', this extension is 
%    attached.
%
% Example
%    [X,Y] = meshgrid(-2:0.25:2,-1:0.2:1);
%    Z = X.* exp(-X.^2 - Y.^2);
%    TRI = delaunay(X,Y);
%    vtktrisurf(TRI,X,Y,Z,'pressure','vtktrisurf.vtu')
%    % open `vtktrisurf.vtu' via Paraview or Mayavi2
%
% See also trisurf, vtkquiver
%
% Copyright see license.txt
%
% Author:     Florian Frank
% eMail:      snflfran@gmx.net
% Version:    1.00
% Date:       Jun 16th, 2010

function vtktrisurf(tri, x, y, z, argin5, argin6, argin7)

% INITIALIZATION
if nargin == 6
  vals     = z;
  varname  = argin5;
  filename = argin6;
elseif nargin == 7
  vals     = argin5;
  varname  = argin6;
  filename = argin7;
else
  error('Wrong number of input arguments.')
end

% ASSERTIONS
assert(ischar(varname) && ischar(filename))
numC = size(tri, 1); % number of cells
numP = length(x(:)); % number of points
assert(numP == length(y(:)) && numP == length(z(:)))

% DETERMINE DATA TYPE
if length(vals(:)) == numP
  datatype = 'pointdata';
elseif length(vals(:)) == numC
  datatype = 'celldata';
else
  error('Input argument VALS has wrong dimensions.')
end

% OPEN FILE
if ~strcmp(filename(end-3:end), '.vtu') % append file extension if not specified yet
  filename = [filename '.vtu'];
end

file = fopen(filename, 'wt');

% HEADER
fprintf(file, '<?xml version="1.0"?>\n');
fprintf(file, '<VTKFile type="UnstructuredGrid" version="0.1" byte_order="LittleEndian" compressor="vtkZLibDataCompressor">\n');
fprintf(file, '  <UnstructuredGrid>\n');
fprintf(file, '    <Piece NumberOfPoints="%d" NumberOfCells="%d">\n', numP, numC);

% POINTS
fprintf(file, '      <Points>\n');
fprintf(file, '        <DataArray type="Float32" NumberOfComponents="3" format="ascii">\n');
for kV = 1 : numP
  fprintf(file, '          %.3e %.3e %.3e\n', x(kV), y(kV), z(kV));
end
fprintf(file, '        </DataArray>\n');
fprintf(file, '      </Points>\n');

% CELLS
fprintf(file, '      <Cells>\n');
fprintf(file, '        <DataArray type="Int32" Name="connectivity" format="ascii">\n');
for kC = 1 : numC
  fprintf(file,'           %d %d %d\n', tri(kC, 1) - 1, tri(kC, 2) - 1, tri(kC, 3) - 1);
end
fprintf(file, '        </DataArray>\n');
fprintf(file, '        <DataArray type="Int32" Name="offsets" format="ascii">\n');
for kC = 1 : numC
  fprintf(file,'           %d\n', 3*kC);
end
fprintf(file, '        </DataArray>\n');
fprintf(file, '        <DataArray type="UInt8" Name="types" format="ascii">\n');
for kC = 1 : numC
  fprintf(file,'           %d\n', 5);
end
fprintf(file, '        </DataArray>\n');
fprintf(file, '      </Cells>\n');

% CELL DATA
if strcmp(datatype, 'celldata')
fprintf(file, '      <CellData Scalars="%s">\n', varname); % def of std value
fprintf(file, '        <DataArray type="Float32" Name="%s" format="ascii">\n', varname);
for kC = 1 : numC
  fprintf(file,'           %.3e\n', vals(kC));
end
fprintf(file, '        </DataArray>\n');
fprintf(file, '      </CellData>\n');
end

% POINT DATA
if strcmp(datatype, 'pointdata')
fprintf(file, '      <PointData Scalars="%s">\n', varname); % def of std value
fprintf(file, '        <DataArray type="Float32" Name="%s" NumberOfComponents="1" format="ascii">\n', varname);
  for kP = 1 : numP
    fprintf(file, '          %.3e\n', vals(kP));
  end
fprintf(file, '        </DataArray>\n');
fprintf(file, '      </PointData>\n');
end

% FOOTER
fprintf(file, '    </Piece>\n');
fprintf(file, '  </UnstructuredGrid>\n');
fprintf(file, '</VTKFile>\n');

fclose(file);

return

end
