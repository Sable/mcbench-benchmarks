function [Xout,Yout,Zout]=gplot(A,xyz,lc)
%GPLOT Plot graph, as in "graph theory".
%   GPLOT(A,xyz) plots the graph specified by A and xyz. A graph, G, is
%   a set of nodes numbered from 1 to n, and a set of connections, or
%   edges, between them.  
%
%   In order to plot G, two matrices are needed. The adjacency matrix,
%   A, has a(i,j) nonzero if and only if node i is connected to node
%   j. The coordinates array, xyz, is an n-by-2 or n-by-3 matrix with the
%   position for node i in the i-th row, xyz(i,:) = [x(i) y(i)]
%   or xyz(i,:) = [x(i) y(i) z(i)]. The plot uses the 2-dimensional view.
%   
%   GPLOT(A,xyz,LineSpec) uses line type and color specified in the
%   string LineSpec. See PLOT for possibilities.
%
%   [X,Y] = GPLOT(A,xyz) or [X,Y,Z] = GPLOT(A,xyz) return the 
%   NaN-punctuated vectors X and Y or X, Y and Z without actually 
%   generating a plot. These vectors can be used to generate the plot at a 
%   later time with PLOT or PLOT3 if desired.
%   
%   See also SPY, TREEPLOT.

%   A backward-compatible elaboration of Mathworks's gplot
%   that uses 3D data (if available) when the plot is rotated.
%   Robert Piche, Tampere Univ. of Tech., 2005

[i,j] = find(A);
[ignore, p] = sort(max(i,j));
i = i(p);
j = j(p);

% Create a long, NaN-separated list of line segments,
% rather than individual segments.

if size(xyz,2)<3, xyz(:,3) = 0; end
X = [ xyz(i,1) xyz(j,1) repmat(NaN,size(i))]';
Y = [ xyz(i,2) xyz(j,2) repmat(NaN,size(i))]';
Z = [ xyz(i,3) xyz(j,3) repmat(NaN,size(i))]';
X = X(:);
Y = Y(:);
Z = Z(:);

if nargout==0,
    if nargin<3,
        plot3(X, Y, Z);
    else
        plot3(X, Y, Z, lc);
    end
    view(2), box on
else
    Xout = X;
    Yout = Y;
    Zout = Z;
end
