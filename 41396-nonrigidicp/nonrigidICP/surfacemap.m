function [distancemap]=surfacemap(Vertices,faces,Index)

%this function defines how many vertices each vertex is away from the
%specifc vertex with index "Index3". 

%the first collumn gives the vertex indices, the second the number of
%vertices each vertex is distant from the Index vertix
%the third collumn gives the "weigth" for each, meaning the number of
%vertices of the same generation devided by the total number of vertices

faces(:,4)=1:length(faces);
distancemap(:,1)=1:length(Vertices(:,1));
distancemap(Index,2)=1;
distancemap(Index,3)=1-length(double(find(distancemap(:,2))))/length(Vertices(:,1));


a=2;
facestemp1(1,1)=Index;

while isempty(faces)==0 

    indicesconnectedfaces=vertcat(find(double(ismember(faces(:,1),facestemp1))),find(double(ismember(faces(:,2),facestemp1))),find(double(ismember(faces(:,3),facestemp1))));
    connectedfaces=faces(indicesconnectedfaces,:);
    indicesvertices=unique(reshape(connectedfaces(:,1:3),3*length(connectedfaces(:,1)),1));
    distancemap(indicesvertices,2)=a;
    faces(indicesconnectedfaces,:)=[];
    
    indicesoldvertces=find(double(ismember(indicesvertices,facestemp1)));
    distancemap(indicesvertices(indicesoldvertces,:),2)=a-1;
    indicesvertices(indicesoldvertces,:)=[];
    facestemp1=indicesvertices;
    distancemap(indicesvertices,3)=1-length(double(find(distancemap(:,2))))/length(Vertices(:,1));
    a=a+1;
end











