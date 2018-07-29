% SIMPLETRI return simple triangulation for square datasets
%    TRI = SIMPLETRI(N) returns a matrix containing indexes to the
%    vertices of triangles fitted onto a square grid of size NxN.
%
% See also TERNSURF
 

% Method:


% Author Carl Sandrock 20031006
 
% To do
 
% Modifications
 
% Modifiers
% (CS) Carl Sandrock 

function tri = simpletri(N);

% for each square, divide diagonally from top left to bottom right
% The two triangles have their top left and bottom right points in common,
% with the remaining point being either top right or bottom left
%
% tl--tr
%  |\ |
%  | \|
% bl--br
%

% Remember that increasing i goes with increasing x, so from bottom to top

[row, col] = meshgrid(1:N-1);

bl = sub2ind([N, N], row, col);
bl = bl(:);
br = bl + 1;
tl = bl + N;
tr = tl + 1;

tri = [tl bl br; tl tr br];
