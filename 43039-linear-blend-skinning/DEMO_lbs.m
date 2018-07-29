% Sample of Linear Blend Skinning in Matlab
% This code is non optimized nor necessarily correct.
% Also, it has only been tested on the data in this folder so I dont know
% how it will behave on other data.

% Aaron Wetzler, 2013

%% -------------------------------------------------------------------------
clf
close all
clear all
clc

% Load the faces, vertices and weights
faces = csvread('handfaces.txt');
V0 = csvread('handverts.txt');
V0=V0';
N = size(V0,1);
weights = csvread('handweights.txt');
sk = loadbvh('HandBase.bvh');

% Mapping to correct the ordering of the weights to the bones for the
% HandBase.bvh file
wmap = [1 2 3 4 0 15 16 17 0 5 6 7 0 8 9 10 0 11 12 13 0 14 0];
wzero = wmap==0;

% This will likely crash a machine if there are two many bones and too many
% animation frames
W = sparse(weights(:,1)+1,weights(:,2)+1,weights(:,3));
W = full(W);%W = W./repmat(sum(W,2),[1 size(W,2)]);

W = W(:,wmap+wzero);
W(:,wzero)=0;

% Currently there are some rows in W which have up to 6 nonzero weights.
% The industry accepted number is 4 so should probably zero the smaller
% ones.

% -------------------------------------------------------------------------

%Display the mesh

cla
for displayWeightIndex=find(~wzero)
    h = trisurf(faces+1,V0(1,:),V0(2,:),V0(3,:),W(:,displayWeightIndex));
    axis equal; axis vis3d;
    shading interp;
    set(h,'FaceAlpha',0.5)
    axis([-200 200 -100 100 -100 500]);
    pause(0.2);
end
hold on

%% -------------------------------------------------------------------------
% Display the skinned armature animation

for j=2:258
    
    V=V0*0;
    
    cla
    for i=1:length(sk)
        % -------------------------------------------------------------------------
        % Display the bones
        if sk(i).parent
            s=sk(i).t_xyz(:,j); sp = sk(sk(i).parent).t_xyz(:,j);
            plot3([s(1) sp(1)],[s(2) sp(2)],[s(3) sp(3)],'r','LineWidth',5);
        end
        plot3(sk(i).t_xyz(1,j),sk(i).t_xyz(2,j),sk(i).t_xyz(3,j),'g.','MarkerSize',10);
        if sk(i).Nchannels
            plotax(sk(i).t_xyz(:,j)',sk(i).T(1:3,1:3,j)*sk(i).R0,15)
        end
        % -------------------------------------------------------------------------
        
        if sk(i).Nchannels
            % Takes a local bone coordinate and puts it into the new pose global position
            poseMatrix(:,:,i,j) = [(sk(i).T(1:3,1:3,j)*sk(i).R0) sk(i).t_xyz(:,j);0 0 0 1];
            % Takes a local bone coordinate and puts it into the base pose global position
            restMatrix(:,:,i) = [((sk(i).R0)) sk(i).head0 ;0 0 0 1];
            
            % The matrix T for a bone takes a point from global bind space to its new
            % position also in global space as dictated by that bone
            
            % -------------------------------------------------------------------------------
            % To go from base pose to new pose position we
            % undo the restmatrix and then apply the posematrix i.e.
            % if we have a vertex v from the bind pose then to see where
            % it would be sent by bone i for pose j we would apply
            % vj = M(:,:,j)*[v;1]
            
            
            M(:,:,j) = poseMatrix(:,:,i,j)*inv(restMatrix(:,:,i));
            R = M(1:3,1:3,j);
            t = M(1:3,4,j);
            
            % We add the influence from every bone
            V = V + (R*V0 + repmat(t,1,length(V0))) * spdiags(W(:,i),0,length(V),length(V));
            
            % --------------------------------------------------------------------------------
            
            
        end
    end
    
    % -------------------------------------------------------------------------
    % Display nicely
    h = trisurf(faces+1,V(1,:),V(2,:),V(3,:),W(:,2)*0);
    axis off;
    axis equal
    shading interp;
    light
    lighting phong
    set(h,'FaceAlpha',0.8)
    drawnow
    
end
%%

% Code to extract specific joint angles
% Bone i, animation frame j
i = 20; j=2;
T = poseMatrix(1:3,1:3,i,j); Tp = poseMatrix(1:3,1:3,i-1,j); T_0 = restMatrix(1:3,1:3,i); Tp_0 = restMatrix(1:3,1:3,i-1);
R = (T_0')*(Tp_0)*(Tp')*(T);
[Rx Ry Rz] = dcm2angle(R,'XYZ'); 
Rx = rad2deg(-Rx); Ry = rad2deg(-Ry); Rz = rad2deg(-Rz);

[Rx Ry Rz]

