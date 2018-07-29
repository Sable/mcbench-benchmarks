%...!
%/*************************************************************************
% Function Name : wrl2mat
% Author: Alireza Bossaghzadeh

    % This Function Extract Pointcloud from a wrl file and change it to a 2D
    % mesh matrix 
    % In the process of changing to mesh, it will interpolated the hole parts 
    % (Parts without any value)

%/*************************************************************************
    % Example: [ZI pointcloud]=wrl2mat('mywrl.wrl');
%     Input:         fname 	 wrl File Name
%     Outputs:       ZI          	 2D mesh File
%                    pointcloud 	 3xN  pointcloud data   
    % Suggestion:
    % to have a better output you should use crop3dface.m that is available in my
    % files in mathworks file exchange.

% In the case of any problem you can call me by 
% Email:Alibossagh@yahoo.co.uk
% This code is a modified version of the read_vrml.m written by "G. Akroyd"

% Version:    1.00       Published: 2008 June 07

function [ZI pointcloud]=wrl2mat(fname)

disp(['Reading The File  ', fname])
        vrfile=fopen(fname);
        p=1;counter=0;pointcloud=[0 0 0];
 while counter~=-1
    data=fgets(vrfile);
    fpoint=findstr(data,'point');% 2 checkers to find out the begining
    f2point=findstr(data,'[');   %of the x,y,z " point [ "
    while ~isempty(fpoint) & ~isempty(f2point)
      data=fgets(vrfile);
        if isempty(findstr(data,']'));
          t=sscanf(data,'%f %f %f');
          pointcloud(p,:)=t';
          p=p+1;
        else fpoint=[];counter=-1;
        end
    end
 end
 disp(['Convert to 2D Image'])
X=pointcloud(:,1);Y=pointcloud(:,2);Z=pointcloud(:,3);%Load positions to X,Y,Z
X=X-min(X);Y=Y-min(Y);%change X,Y to start from 0
x=[min(X):1:max(X)];y=[min(Y):1:max(Y)];%create image dimentions
[XI,YI] = meshgrid(x,y);%create matrix of positions
YI=max(YI(:))-YI;
Z=Z-min(Z(:));%Change Z data to start from 0 
ZI=griddata(X,Y,Z,XI,YI,'linear'); % calculate Z values from noninteger positions
    figure;imshow(ZI,[]);title('Extracted Image')
