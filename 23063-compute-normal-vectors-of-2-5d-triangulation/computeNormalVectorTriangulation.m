function [NormalVx NormalVy NormalVz PosVx PosVy PosVz]=computeNormalVectorTriangulation(XYZ,TRI,strPosition)
%
% This function takes as input a 2D unrestricted triangulation and computes
% the normal vector of the surface.
%
% Input :
%           "XYZ" is the coordinate of the vertex of the triangulation (nx3 matrix).
%           "TRI" is the list of triangles which contain indexes of XYZ (mx3 matrix).
%           "strPosition" is the position where the normal is computed. It
%           could be 'center-cells' for a computation on the center of each
%           triangle or could be 'vertices' and the vectors are computed at
%           vertices with respect to the neighbour cells (string).
%
% Output :
%           "NormalVx", "NormalVy" and "NormalVz" are the component of
%           normal vectors (normalized to 1).
%           "PosVx", "PosVy" and "PosVz" is the positions of each vector.
% 
% Note : 
%           if strPosition == 'center-cells', then the dimension of each
%           output are mx1.
%           if strPosition == 'vertices', then the dimension of each
%           output are nx1. 
%
%           All cells have to be enumerated clockwise or counter-clock.
%
% Example :
%
% [X,Y,Z]=peaks(25);
% X=reshape(X,[],1);
% Y=reshape(Y,[],1);
% Z=0.4*reshape(Z,[],1);
% TRI = delaunay(X,Y);
% [NormalVx NormalVy NormalVz PosVx PosVy PosVz]=computeNormalVectorTriangulation([X Y Z],TRI,'vertices');
%
% quiver3(PosVx,PosVy, PosVz, NormalVx, NormalVy, NormalVz), axis equal
% hold on
% trimesh(TRI,X,Y,Z)
%
% David Gingras, February 2009

NormalTri=cross(XYZ(TRI(:,3),:)-XYZ(TRI(:,2),:),XYZ(TRI(:,2),:)-XYZ(TRI(:,1),:));
NormalTri=-1*NormalTri./repmat((sqrt(NormalTri(:,1).^2+NormalTri(:,2).^2+NormalTri(:,3).^2)),1,3);

if  strcmpi(strPosition,'center-cells')
    [NormalVx NormalVy NormalVz]=deal(NormalTri(:,1),NormalTri(:,2),NormalTri(:,3));
    [PosVx PosVy PosVz]=centerTri3D(XYZ(:,1),XYZ(:,2),XYZ(:,3),TRI);
elseif strcmpi(strPosition,'vertices')
    invTRI=buildInverseTriangulation(TRI);
    NormalVx=zeros(length(XYZ),1);
    NormalVy=zeros(length(XYZ),1);
    NormalVz=zeros(length(XYZ),1);
    for j=1:length(XYZ)
        NormalVx(j)=mean(NormalTri(removeD0(invTRI(j,:)),1));
        NormalVy(j)=mean(NormalTri(removeD0(invTRI(j,:)),2));
        NormalVz(j)=mean(NormalTri(removeD0(invTRI(j,:)),3));
    end
    [PosVx PosVy PosVz]=deal(XYZ(:,1),XYZ(:,2),XYZ(:,3));
else
    error('The third argument input is not correct. Use the strings ''center-cells'' or ''vertices'' to define where the normal vectors are computed.');
end

end

function invTRI=buildInverseTriangulation(TRI)
% Building the inverse triangulation, i.e. a link from node indexes to
% triangle indexes.
nbTri=length(TRI);
nbNode=max(reshape(TRI,[],1));
comp=zeros(nbNode,1);
invTRI=zeros(nbNode,8);

for i=1:nbTri
   for j=1:3
       index=TRI(i,j);
       comp(index)=comp(index)+1;
       invTRI(index,comp(index))=i;
   end
end
end

function [Xc Yc Zc]=centerTri3D(X,Y,Z,tri1)
% This function return the position of the center of a cells
Xc=mean([X(tri1(:,1)) X(tri1(:,2)) X(tri1(:,3))],2);
Yc=mean([Y(tri1(:,1)) Y(tri1(:,2)) Y(tri1(:,3))],2);
Zc=mean([Z(tri1(:,1)) Z(tri1(:,2)) Z(tri1(:,3))],2);
end

function out=removeD0(x)
% Removing duplicate and null values
s=sort(x);
s1=[0,s];
s2=[s,s(length(s))];
ds=(s1-s2);
out=s(logical(ds~=0));
end