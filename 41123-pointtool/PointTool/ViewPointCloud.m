%Develop by Renoald
%Email:Renoald@live.com
%11/2/2013
%This function can used to view 3D point clouds
%Format of 3D point clouds
%Xi Yi Zi Ri Gi Bi 
function ViewPointCloud(file)
%read File
p=dlmread(file);
[i,j]=size(p);
dist=ones(i,1);
if j==6
    %scatter3(p(:,1),p(:,2),p(:,3),'Marker','o')
    
else
    for i=1 : i
    dist(i,1)=Dist3D(0,0,0,p(i,1),p(i,2),p(i,3));
end
    figure(1);
    %Plot point clouds
    fname=strcat('Number of points:',num2str(i));
    scatter3(p(:,1),p(:,2),p(:,3),1,dist(:,1)) 
    title(fname);
    xlabel('x axis');
    ylabel('y axis');
    zlabel('z axis');
end
