function [F,V,C]=ind2patch(IND,M,ptype)

% function [F,V,C]=ind2patch(IND,M,ptype)
% ------------------------------------------------------------------------
% 
% This function generates patch data (faces “F”, vertices “V” and color
% data “C”) for 3D images. The patches are only generated for the voxels
% specified by the linear indices in “IND”. The variable “ptype” indicates
% the type of patch:
% 
% ‘v’               Voxel (box)
% ‘sx’, ‘sy’, ‘sz’    Mid-voxel slice for x, y and z direction respectively
%%% EXAMPLE
% clear all; close all; clc;
% 
% %% Simulating 3D image
% [X,Y,Z]=meshgrid(linspace(-4.77,4.77,75));
% phi=(1+sqrt(5))/2;
% M=2 - (cos(X + phi*Y) + cos(X - phi*Y) + cos(Y + phi*Z) + cos(Y - phi*Z) + cos(Z - phi*X) + cos(Z + phi*X));
% M=M./max(M(:)); %Normalise, not required
% 
% figure;fig=gcf; clf(fig); colordef (fig, 'white'); units=get(fig,'units'); set(fig,'units','normalized','outerposition',[0 0 1 1]); set(fig,'units',units); set(fig,'Color',[1 1 1]);
% hold on; xlabel('X-J','FontSize',20);ylabel('Y-I','FontSize',20);zlabel('Z-K','FontSize',20);
% 
% %% Creating and plotting patch data
% 
% %Setting up indices for slices to plot
% S=round(size(M,2)./2);
% L_slices=false(size(M));
% L_slices(:,S,:)=1;
% IND_slices=find(L_slices);
% [Fs,Vs,C_slice]=ind2patch(IND_slices,M,'sx'); %Creating patch data for x mid-voxel slices
% hs=patch('Faces',Fs,'Vertices',Vs,'EdgeColor','none', 'CData',C_slice,'FaceColor','flat','FaceAlpha',0.75);
% 
% %Setting up indices for slices to plot
% S=round(size(M,1)./2);
% L_slices=false(size(M));
% L_slices(S,:,:)=1;
% IND_slices=find(L_slices);
% [Fs,Vs,C_slice]=ind2patch(IND_slices,M,'sy'); %Creating patch data for y mid-voxel slices
% hs=patch('Faces',Fs,'Vertices',Vs,'EdgeColor','none', 'CData',C_slice,'FaceColor','flat','FaceAlpha',0.75);
% 
% %Setting up indices for slices to plot
% S=round(size(M,3)./2);
% L_slices=false(size(M));
% L_slices(:,:,S)=1;
% IND_slices=find(L_slices);
% [Fs,Vs,C_slice]=ind2patch(IND_slices,M,'sz'); %Creating patch data for z mid-voxel slices
% hs=patch('Faces',Fs,'Vertices',Vs,'EdgeColor','none', 'CData',C_slice,'FaceColor','flat','FaceAlpha',0.75);
% 
% %Setting up indices for voxels to plot
% IND=find(M>-0.2 & M<=0);
% [Fs,Vs,C_slice]=ind2patch(IND,M,'v'); %Creating patch data for selection of low voxels
% hs=patch('Faces',Fs,'Vertices',Vs,'EdgeColor','k', 'CData',C_slice,'FaceColor','flat','FaceAlpha',1);
% 
% %Setting up indices for voxels to plot
% IND=find(M>0.9);
% [Fs,Vs,C_slice]=ind2patch(IND,M,'v'); %Creating patch data for selection of high voxels
% hs=patch('Faces',Fs,'Vertices',Vs,'EdgeColor','k', 'CData',C_slice,'FaceColor','flat','FaceAlpha',1);
% 
% axis equal; view(3); axis tight; colormap jet; colorbar; caxis([0 1]); grid on;
% set(gca,'FontSize',20);
%
% Kevin Mattheus Moerman
% kevinmoerman@hotmail.com
% 15/07/2010
%------------------------------------------------------------------------

%% 

IND=IND(:);

[I,J,K] = ind2sub(size(M),IND);

switch ptype
    case 'sx' %X midvoxel slice
        i_shift=ones(size(I))*[-0.5  0.5  0.5 -0.5 ];
        j_shift=ones(size(I))*[ 0    0    0    0   ];
        k_shift=ones(size(I))*[-0.5 -0.5  0.5  0.5 ];
        F_order=[1 2 3 4];
        n=1;
        no_nodes=4;
    case 'sy' %Y mmidvoxel slice
        i_shift=ones(size(I))*[ 0    0    0    0   ];
        j_shift=ones(size(I))*[-0.5 -0.5  0.5  0.5 ];
        k_shift=ones(size(I))*[-0.5  0.5  0.5 -0.5 ];
        F_order=[1 2 3 4];
        n=1;
        no_nodes=4;
    case 'sz' %Z midvoxel slice
        i_shift=ones(size(I))*[-0.5  0.5  0.5 -0.5 ];
        j_shift=ones(size(I))*[-0.5 -0.5  0.5  0.5 ];
        k_shift=ones(size(I))*[ 0    0    0    0   ];
        F_order=[1 2 3 4];
        n=1;
        no_nodes=4;
    case 'v' %Voxels
        i_shift=ones(size(I))*[-0.5  0.5  0.5 -0.5   -0.5  0.5  0.5 -0.5];
        j_shift=ones(size(I))*[-0.5 -0.5  0.5  0.5   -0.5 -0.5  0.5  0.5];
        k_shift=ones(size(I))*[ 0.5  0.5  0.5  0.5   -0.5 -0.5 -0.5 -0.5];
        F_order=[1 2 3 4;...    %Top
            5 6 7 8;...    %Bottom
            1 2 6 5; ...   %Left face
            3 4 8 7; ...   %Right face
            1 4 8 5; ...   %Back
            2 3 7 6];      %Front
        n=6;
        no_nodes=8;
    otherwise
        warning('wrong input for argument ptype, valid inputs are s for surfaces patches and v for voxel patches');
end

VI=I*ones(1,no_nodes);
VJ=J*ones(1,no_nodes);
VK=K*ones(1,no_nodes);

VI=VI+i_shift; VI=VI'; VI=VI(:);
VJ=VJ+j_shift; VJ=VJ'; VJ=VJ(:);
VK=VK+k_shift; VK=VK'; VK=VK(:);

V=zeros(length(VI),3);
V=[VJ VI VK];

F=[ ];
Fi=ones(length(IND),4);
b=(no_nodes.*((1:1:numel(IND))'-1))*ones(1,4);

for i=1:1:n
    Fi=ones(size(IND))*F_order(i,:)+b;
    F=[F; Fi];
end

C=M(IND);
if strcmp(class(C),'double')==0; %If the image is not a double
    C=double(C); %Then convert
end

if n==6;
    C=repmat(M(IND),[6,1]);
end

