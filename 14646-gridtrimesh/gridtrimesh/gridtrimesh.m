function Z = gridtrimesh(F,V,X,Y)
%GRIDTRIMESH Fitting a square grid onto a triangular mesh.
%
%   Z = GRIDTRIMESH(F,V,X,Y) fits a surface of the form Z = F(X,Y) to the
%   triangular mesh defined by F and V.
%   
%   The triangles of the triangular mesh are defined in the m-by-3 face
%   matrix F. Each row of F defines a single triangular face by indexing
%   into the n-by-3 matrix V that contains X, Y and Z coordinates of the
%   vertices.
%
%   It is assumed that X and Y are produced by [X,Y] = meshgrid(x,y),
%   where x and y are monotonically increasing vectors.
%
%   The function Z = MXGRIDTRIMESH(F,V,X,Y) gives exactly the same result
%   but is coded in C and compiled using MEX resulting in slightly faster
%   execution.
%
%   Example: (assume the file example.mat contains F and V)
%        load example
%        nx = 10; ny = 10;
%        x = linspace(min(V(:,1)),max(V(:,1)),nx);
%        y = linspace(min(V(:,2)),max(V(:,2)),ny);
%        [X,Y] = meshgrid(x,y);
%        Z = gridtrimesh(F,V,X,Y);
%        surf(X,Y,Z)
%
%
%   Author:  Willie Brink  [ w.brink@shu.ac.uk ]
%            April 2007



m = size(F,1);

% size of grid
nx = size(X,2);
ny = size(X,1);

% initialise output
Z = NaN(size(X));

% consider every triangle projected to the x-y plane and determine whether gridpoints lie inside
for i = 1:m,
    v1x = V(F(i,1),1); v1y = V(F(i,1),2); v1z = V(F(i,1),3);
    v2x = V(F(i,2),1); v2y = V(F(i,2),2); v2z = V(F(i,2),3);
    v3x = V(F(i,3),1); v3y = V(F(i,3),2); v3z = V(F(i,3),3);
    % we'll use the projected triangle's bounding box: of the form (minx,maxx) x (miny,maxy)
    minx = min([v1x v2x v3x]);
    maxx = max([v1x v2x v3x]);    
    % find smallest x-grid value > minx, and largest x-grid value < maxx
    east = NaN; west = NaN;
    j = 1; while (j <= nx && X(1,j) < minx), j = j + 1; end; if (j <= nx), west = j; end
    j = nx; while (j >= 1 && X(1,j) > maxx), j = j - 1; end; if (j >= 1), east = j; end
    % if there are gridpoints strictly inside bounds (minx,maxx), continue
    if ~isnan(east) && ~isnan(west) && east - west >= 0,
        miny = min([v1y v2y v3y]);
        maxy = max([v1y v2y v3y]);
        % find smallest y-grid value > miny, and largest y-grid value < maxy
        north = NaN; south = NaN;
        j = 1; while (j <= ny && Y(j,1) < miny), j = j + 1; end; if (j <= ny), north = j; end
        j = ny; while (j >= 1 && Y(j,1) > maxy), j = j - 1; end; if (j >= 0), south = j; end
        % if, further, there are gridpoints strictly inside bounds (miny,maxy), continue
        if ~isnan(north) && ~isnan(south) && south - north >= 0,
            % we now know that there might be gridpoints bounded by (west,east) x (north,south)
            % that lie inside the current triangle, so we'll test each of them
            for j = west:east,
                for k = north:south,
                    % calculate barycentric coordinates of gridpoint w.r.t. current (projected) triangle
                    A = [v1x v2x v3x; v1y v2y v3y; 1 1 1];
                    if rcond(A) > eps, w = A\[X(k,j); Y(k,j); 1]; else w = [1; 1; 1]/3; end
                    if min(w) > 0,
                        % use barycentric coordinates to calculate z-value
                        z = w(1)*v1z + w(2)*v2z + w(3)*v3z;
                        if isnan(Z(k,j)) || z > Z(k,j), Z(k,j) = z; end
                    end
                end
            end
        end
    end
end
