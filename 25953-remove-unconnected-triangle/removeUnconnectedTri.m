function [TRI2 XYZ2]=removeUnconnectedTri(TRI1,XYZ1,triID)
% [TRI2 XYZ2]=removeUnconnectedTri(TRI1,XYZ1,triID)
%
% This function takes a triangulation and remove the unconnected cells. The
% group of cells to keep can be specified with an index of triangle
% contained in this group. If no triangle index is specified, the filter
% will keep the group with the maximum number of cells.
%
% Input : 
%           "XYZ1" is nx3 matrix which are vertices coordinates
%           "TRI1" is mx3 matrix which are the standard indexes of vertices
%           "triID" is a triangle index of "TRI1" contained on the group of
%           cells to keep. (optionnal)
% Output :
%           "XYZ2" is px3 matrix which are vertices coordinates of output
%           "TRI2" is qx3 matrix which are the standard indexes of vertices
%
% Simple example : 
%
% X=[2 1 3 2 5 5 8 6 7 5 8 9 10 12 10 12 13 15 1 0 2 1];
% Y=[2 4 4 6 6 8 8 4 2 2 4 6 8 7 5 5 3 2 7 8 8 9];
% Z=zeros(size(X));
% TRI=[1 2 3;2 4 3;4 3 5;5 6 7;10 8 9;8 9 11;12 13 14;15 16 17;17 16 18;4 6 5;20 19 21;22 21 20];
% [TRI2 XYZ2]=removeUnconnectedTri(TRI,[X' Y' Z']);
% 
% subplot(2,1,1)
% trisurf(TRI,X,Y,Z), title('Before filter')
% axis([min(X) max(X) min(Y) max(Y)]);
% campos([7.5 6 10])
% camtarget([7.5 6 0])
% subplot(2,1,2)
% trisurf(TRI2,XYZ2(:,1),XYZ2(:,2),XYZ2(:,3)), title('After filter')
% axis([min(X) max(X) min(Y) max(Y)]);
% campos([7.5 6 10])
% camtarget([7.5 6 0])
%
% David Gingras, November 2009

nbTri=size(TRI1,1); 

% Assign ID to each triangle based on connectivity
allGroupsID=connectivityTri(TRI1);

if nargin==2
    % The filter will keep the group with the highest number of cells
    compGroup=zeros(max(allGroupsID),1);
    for i=1:nbTri
        compGroup(allGroupsID(i))=compGroup(allGroupsID(i))+1; %counter
    end
    [dummy,groupIDtoKeep]=max(compGroup); %the group with maximum nb of cells
elseif nargin==3
    % The filter will keep the group which support the triangle number
    % "triID"
    groupIDtoKeep=allGroupsID(triID);
else
    error('Wrong number of inputs')
end

testGroup=allGroupsID==repmat(groupIDtoKeep(1),nbTri,1);

% Remove the disconnected triangles and unused nodes
TRI2=TRI1(logical(testGroup),:);
[XY,TRI2,Z] = fixmesh(XYZ1(:,1:2),TRI2,XYZ1(:,3));
XYZ2=[XY Z];

end



function groupID=connectivityTri(TRI)
% groupID=connectivityTri(TRI)
%
% This function takes a triangulation (only the list of triangle, not the
% node coordinates) and assigns an ID to each group of triangles. If some cells
% are connected together, each cell of that group will have the same
% ID. It works like the connectivity-filter of the graphical library VTK.
%
% Input : 
%           "TRI" is mx3 matrix which are the standard indexes of vertices
% Output :
%           "groupID" is mx1 matrix which are the ID-group of each cell
%
% David Gingras, June 2009

if size(TRI,2)~=3
    error('connectivityTri : Error with the input. The size of argument has to be mx3')
end

if nargin~=1
    error('connectivityTri : Error with input. The number of argument has to be one.')
end

nbTri=length(TRI);
% Building the neighbour structure
fring = compute_face_ring(double(TRI));
neighbour=zeros(nbTri,3);
for i=1:nbTri
   if ~isempty(fring{i})
        neighbour(i,1:length(fring{i}))=fring{i}; 
   else
        neighbour(i,:)=[-1 -1 -1];
   end
end

% Assign an ID to each group of cells
groupID=groupTri(TRI,neighbour);

end

function [p,t,pfun] = fixmesh(p,t,pfun)

%  FIXMESH: Ensure that triangular mesh data is consistent.
%
%  [p,t,pfun,tfun] = fixmesh(p,t,pfun,tfun);
%
%  p     : Nx2 array of nodal XY coordinates, [x1,y1; x2,y2; etc]
%  t     : Mx3 array of triangles as indices, [n11,n12,n13; n21,n22,n23;
%          etc]
%  pfun  : (Optional) NxK array of nodal function values. Each column in
%          PFUN corresponds to a dependent function, PFUN(:,1) = F1(P),
%          PFUN(:,2) = F2(P) etc, defined at the nodes.
%  tfun  : (Optional) MxK array of triangle function values. Each column in
%          TFUN corresponds to a dependent function, TFUN(:,1) = F1(T),
%          TFUN(:,2) = F2(T) etc, defined on the triangles.
%
% The following checks are performed:
%
%  1. Nodes not refereneced in T are removed.
%  2. Duplicate nodes are removed.
%  3. Triangles are ordered counter-clockwise.
%  4. Triangles with an area less than 1.0e-10*eps*norm(A,'inf')
%     are removed

% Darren Engwirda - 2007.

if (nargin<4)
   tfun = [];
   if (nargin<3)
      pfun = [];
      if nargin<2
         error('Wrong number of inputs');
      end
   end
elseif (nargin>4)
   error('Wrong number of inputs');
end
if (nargout>4)
   error('Wrong number of outputs');
end
if (numel(p)~=2*size(p,1))
   error('P must be an Nx2 array');
end
if (numel(t)~=3*size(t,1))
   error('T must be an Mx3 array');
end
if (any(t(:))<1) || (max(t(:))>size(p,1))
   error('Invalid T');
end
if ~isempty(pfun)
   if (size(pfun,1)~=size(p,1)) || (ndims(pfun)~=2)
      error('PFUN must be an NxK array');
   end
end
if ~isempty(tfun)
   if (size(tfun,1)~=size(t,1)) || (ndims(tfun)~=2)
      error('TFUN must be an Mxk array');
   end
end

% Remove duplicate nodes
[i,i,j] = unique(p,'rows');
if ~isempty(pfun)
   pfun = pfun(i,:);
end
p = p(i,:);
t = reshape(j(t),size(t));

% Remove un-used nodes
[i,j,j] = unique(t(:));
if ~isempty(pfun)
   pfun = pfun(i,:);
end
p = p(i,:);
t = reshape(j,size(t));

end      % fixmesh()

function group=groupTri(TRI,neighbour)
% group=groupTri(TRI)
% TRI Mx3 : list of triangles
% group Mx1 : id group of each cell
%

M=length(TRI);
group=zeros(M,1);
groupID=1;
index=1;
comp=0;
while any(group==0)
    comp=comp+1;
    index=unique(reshape(index,1,[]));
    rowNnul=unique(reshape(neighbour(index,:),1,[]));
    rowNnul=rowNnul(logical(rowNnul~=0));
    if rowNnul~=-1
        nextNotVisited=find(group(rowNnul)==0);
    else
        nextNotVisited=index;
    end
    if ~isempty(nextNotVisited)
        if rowNnul~=-1
            group(rowNnul(nextNotVisited))=groupID;
            index=rowNnul(nextNotVisited);
        else
            group(index)=groupID;
            groupID=groupID+1;
            nextGroup=find(group==0);
            if ~isempty(nextGroup)
                index=nextGroup(1);
            else
                break
            end
        end
    else
        groupID=groupID+1;
        nextGroup=find(group==0);
        if ~isempty(nextGroup)
            index=nextGroup(1);
        else
            break
        end
    end
end

end

function A = compute_edge_face_ring(face)

% compute_edge_face_ring - compute faces adjacent to each edge
%
%   e2f = compute_edge_face_ring(face);
%
%   e2f(i,j) and e2f(j,i) are the number of the two faces adjacent to
%   edge (i,j).
%
%   Copyright (c) 2007 Gabriel Peyre


[tmp,face] = check_face_vertex([],face);

n = max(face(:));
m = size(face,2);
i = [face(1,:) face(2,:) face(3,:)];
j = [face(2,:) face(3,:) face(1,:)];
s = [1:m 1:m 1:m];

% first without duplicate
[tmp,I] = unique( i+(max(i)+1)*j );
% remaining items
J = setdiff(1:length(s), I);

% flip the duplicates
i1 = [i(I) j(J)];
j1 = [j(I) i(J)];
s = [s(I) s(J)];

% remove doublons
[tmp,I] = unique( i1+(max(i1)+1)*j1 );
i1 = i1(I); j1 = j1(I); s = s(I);

A = sparse(i1,j1,s,n,n);


% add missing points
I = find( A'~=0 );
I = I( A(I)==0 ); 
A( I ) = -1;

end

function fring = compute_face_ring(face)

% compute_face_ring - compute the 1 ring of each face in a triangulation.
%
%   fring = compute_face_ring(face);
%
%   fring{i} is the set of faces that are adjacent
%   to face i.
%
%   Copyright (c) 2004 Gabriel Peyre

% the code assumes that faces is of size (3,nface)
[tmp,face] = check_face_vertex([],face);

nface = size(face,2);

A = compute_edge_face_ring(face);
[i,j,s1] = find(A);     % direct link
[i,j,s2] = find(A');    % reverse link

I = find(i<j);
s1 = s1(I); s2 = s2(I);

fring{nface} = [];
for k=1:length(s1)
    if s1(k)>0 && s2(k)>0
        fring{s1(k)}(end+1) = s2(k);
        fring{s2(k)}(end+1) = s1(k);
    end
end

end

function [vertex,face] = check_face_vertex(vertex,face, options)

% check_face_vertex - check that vertices and faces have the correct size
%
%   [vertex,face] = check_face_vertex(vertex,face);
%
%   Copyright (c) 2007 Gabriel Peyre

vertex = check_size(vertex);
face = check_size(face);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function a = check_size(a)
if isempty(a)
    return;
end
if size(a,1)>size(a,2)
    a = a';
end
if size(a,1)<3 && size(a,2)==3
    a = a';
end
if size(a,1)<=3 && size(a,2)>=3 && sum(abs(a(:,3)))==0
    % for flat triangles
    a = a';
end
if size(a,1)~=3 && size(a,1)~=4
    error('face or vertex is not of correct size');
end

end
