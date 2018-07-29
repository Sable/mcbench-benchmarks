function stlwrite(filename, varargin)
%STLWRITE   Write STL file from patch or surface data.
%
%   STLWRITE(FILE,fv) writes a stereolithography (STL) file to FILE for a triangulated
%   patch defined by FV (a structure with fields 'vertices' and 'faces').
%
%   STLWRITE(FILE,FACES,VERTICES) takes faces and vertices separately, rather than in an FV struct
%
%   STLWRITE(FILE,X,Y,Z) creates an STL file from surface data in X, Y, and Z. STLWRITE triangulates
%   this gridded data into a triangulated surface using triangulations options specified below. X, Y
%   and Z can be two-dimensional arrays with the same size. If X and Y are vectors with length equal
%   to SIZE(Z,2) and SIZE(Z,1), respectively, they are passed through MESHGRID to create gridded
%   data. If X or Y are scalar values, they are used to specify the X and Y spacing between grid
%   points.
%
%   STLWRITE(...,'PropertyName',VALUE,'PropertyName',VALUE,...) writes an STL file using the
%   following property values:
%
%   MODE          - File is written using 'binary' (default) or 'ascii'.
%
%   TITLE         - Header text (max 80 characters) written to the STL file.
%
%   TRIANGULATION - When used with gridded data, TRIANGULATION is either:
%                       'delaunay'  - (default) Delaunay triangulation of X, Y
%                       'f'         - Forward slash division of grid quadrilaterals
%                       'b'         - Back slash division of quadrilaterals
%                       'x'         - Cross division of quadrilaterals
%                   Note that 'f', 'b', or 't' triangulations require FEX entry 28327, "mesh2tri".
%
%   FACECOLOR     - [nx3]           -  [red_1, green_1, blue_1;
%                                       red_2, green_2, blue_2; 
%                                       ...;
%                                       red_n, green_n, blue_n]
%                                       
%                                   -   N is the number of faces.
%                                   -   range for colors is 5 bits (0:31).
%                                   -   Only works in binary files.
%                       
%
%   Example 1:
%       % Write binary STL from face/vertex data
%       tmpvol = zeros(20,20,20);       % Empty voxel volume
%       tmpvol(8:12,8:12,5:15) = 1;     % Turn some voxels on
%       fv = isosurface(tmpvol, 0.99);  % Create the patch object
%       stlwrite('test.stl',fv)         % Save to binary .stl
%
%   Example 2:
%       % Write ascii STL from gridded data
%       [X,Y] = deal(1:40);             % Create grid reference
%       Z = peaks(40);                  % Create grid height
%       stlwrite('test.stl',X,Y,Z,'mode','ascii')

% =========================================================================
%
%   V1.1
%   Improvement of the V1.0 by Sven Holcombe to add Facecolor capability to
%   BINARY stl files
%
%   Author: William Grant Lohsen, 05-18-12
%
% =========================================================================
%
%   V1.0
%   Original idea adapted from surf2stl by Bill McDonald. Huge speed
%   improvements implemented by Oliver Woodford. Non-Delaunay triangulation
%   of quadrilateral surface input requires mesh2tri by Kevin Moerman.
%
%   Author: Sven Holcombe, 11-24-11
% =========================================================================

% % Check valid filename path
% narginchk(2, inf)
path = fileparts(filename);
if ~isempty(path) && ~exist(path,'dir')
    error('Directory "%s" does not exist.',path);
end

% Get faces, vertices, and user-defined options for writing
[faces, vertices, options] = parseInputs(varargin{:});
asciiMode = strcmp( options.mode ,'ascii');

% Create the facets
facets = single(vertices');
facets = reshape(facets(:,faces'), 3, 3, []);

% Compute their normals
V1 = squeeze(facets(:,2,:) - facets(:,1,:));
V2 = squeeze(facets(:,3,:) - facets(:,1,:));
normals = V1([2 3 1],:) .* V2([3 1 2],:) - V2([2 3 1],:) .* V1([3 1 2],:);
clear V1 V2
normals = bsxfun(@times, normals, 1 ./ sqrt(sum(normals .* normals, 1)));
facets = cat(2, reshape(normals, 3, 1, []), facets);
clear normals

% Open the file for writing
permissions = {'w','wb+'};
fid = fopen(filename, permissions{asciiMode+1});
if (fid == -1)
    error('stlwrite:cannotWriteFile', 'Unable to write to %s', filename);
end

% Write the file contents
if asciiMode
    % Write HEADER
    fprintf(fid,'solid %s\r\n',options.title);
    % Write DATA
    fprintf(fid,[...
        'facet normal %.7E %.7E %.7E\r\n' ...
        'outer loop\r\n' ...
        'vertex %.7E %.7E %.7E\r\n' ...
        'vertex %.7E %.7E %.7E\r\n' ...
        'vertex %.7E %.7E %.7E\r\n' ...
        'endloop\r\n' ...
        'endfacet\r\n'], facets);
    % Write FOOTER
    fprintf(fid,'endsolid %s\r\n',options.title);
    
else % BINARY
    % Write HEADER
    fprintf(fid, '%-80s', options.title);             % Title
    fwrite(fid, size(facets, 3), 'uint32');           % Number of facets
    % Write DATA
    % Add one uint16(0 or color) to the end of each facet using a typecasting trick
    facets = reshape(typecast(facets(:), 'uint16'), 12*2, []);
    
    
    %WGL Modification: Allows color in binary stl files
    if isfield(options, 'facecolor')
        facecolor = uint16(options.facecolor);
        %Set the Valid Color bit (bit 15)
        c0 = bitshift(ones(size(faces,1),1,'uint16'),15);
        %Red color (10:15)
        c0 = bitor(bitshift(bitand(2^6-1, facecolor(:,1)),10),c0);
        %Blue color (5:9)
        c0 = bitor(bitshift(bitand(2^11-1, facecolor(:,2)),5),c0);
        %Green color (0:4)
        c0 = bitor(bitand(2^6-1, facecolor(:,3)),c0);
        
        facets(end+1,:) = c0;
    else
        facets(end+1,:) = 0;
    end
    %End WGL Modification
    fwrite(fid, facets, 'uint16');
end

% Close the file
fclose(fid);
fprintf('Wrote %d facets\n',size(facets, 3));

% Input handling subfunctions
function [faces, vertices, options] = parseInputs(varargin)
% Determine input type
if isstruct(varargin{1}) % stlwrite('file', FVstruct, ...)
    if ~all(isfield(varargin{1},{'vertices','faces'}))
        error( 'Variable p must be a faces/vertices structure' );
    end
    faces = varargin{1}.faces;
    vertices = varargin{1}.vertices;
    options = parseOptions(varargin{2:end});
    
elseif isnumeric(varargin{1})
    firstNumInput = cellfun(@isnumeric,varargin);
    firstNumInput(find(~firstNumInput,1):end) = 0; % Only consider numerical input PRIOR to the first non-numeric
    numericInputCnt = nnz(firstNumInput);
    
    options = parseOptions(varargin{numericInputCnt+1:end});
    switch numericInputCnt
        case 3 % stlwrite('file', X, Y, Z, ...)
            % Extract the matrix Z
            Z = varargin{3};
            
            % Convert scalar XY to vectors
            ZsizeXY = fliplr(size(Z));
            for i = 1:2
                if isscalar(varargin{i})
                    varargin{i} = (0:ZsizeXY(i)-1) * varargin{i};
                end                    
            end
            
            % Extract X and Y
            if isequal(size(Z), size(varargin{1}), size(varargin{2}))
                % X,Y,Z were all provided as matrices
                [X,Y] = varargin{1:2};
            elseif numel(varargin{1})==ZsizeXY(1) && numel(varargin{2})==ZsizeXY(2)
                % Convert vector XY to meshgrid
                [X,Y] = meshgrid(varargin{1}, varargin{2});
            else
                error('stlwrite:badinput', 'Unable to resolve X and Y variables');
            end
            
            % Convert to faces/vertices
            if strcmp(options.triangulation,'delaunay')
                faces = delaunay(X,Y);
                vertices = [X(:) Y(:) Z(:)];
            else
                if ~exist('mesh2tri','file')
                    error('stlwrite:missing', '"mesh2tri" is required to convert X,Y,Z matrices to STL. It can be downloaded from:\n%s\n',...
                        'http://www.mathworks.com/matlabcentral/fileexchange/28327')
                end
                [faces, vertices] = mesh2tri(X, Y, Z, options.triangulation);
            end
            
        case 2 % stlwrite('file', FACES, VERTICES, ...)
            faces = varargin{1};
            vertices = varargin{2};
            
        otherwise
            error('stlwrite:badinput', 'Unable to resolve input types.');
    end
    
end

function options = parseOptions(varargin)
IP = inputParser;
IP.addParamValue('mode', 'binary', @ischar)
IP.addParamValue('title', sprintf('Created by stlwrite.m %s',datestr(now)), @ischar);
IP.addParamValue('triangulation', 'delaunay', @ischar);
IP.addParamValue('facecolor',[], @isnumeric)
IP.parse(varargin{:});
options = IP.Results;