
function [hLight]=Surf3D(LayerN,R,Z,Xn,Yn)
% Plot 2 surfaces (of same colour but different topography) and closes them using the patch command.
% the patched boundary faces are coloured using the colour of the
% corresponding upper/lower face.
% 2010 Kenni Petersen/James Ramm
%==========================================================================
%INPUTS: LayerN: The number of the layer to be plotted
%        R: a m*n*k matrix of colour/resistivity data for each layer where 
%           m*n is the size
%           of the grid and k is the layer number
%        Z: a m*n*k+1 matrix of elevation data for each layer. Therefore 
%           Z(:,:,1) gives the topography of the land, Z(:,:,2) would be the 
%           topography of the interface between layer 1 and layer 2.
%           Z(:,:,k+1) gives the topography of the base of the last layer. 
%        Xn, Yn: m*n matrices of the base grid containing the XY co-ords
%        for each point. 
%
%               NOTE: Each matrix must be surrounded by NaNs. This could be
%               achieved in two ways: 1. Use the NaNMat function 
%                                     2. Plot a pcolor image of the surface
%                                     and use ginput to draw a polygon of
%                                     the desired surface. Then use
%                                     'inpolygon' to replace all those
%                                     values lying outside with NaN. See
%                                     the file ThreedDemo for help.
%
%OUTPUTS: hLight: handle of the light object for manipulating lighting.
%==========================================================================


%plot the two surfaces
scrsz = get(0,'ScreenSize');
figure('Position',[scrsz(3)/4 scrsz(4)/4 scrsz(3)/2 scrsz(4)/2],'Renderer','opengl'); 
surf(Xn,Yn,Z(:,:,LayerN),R(:,:,LayerN)); hold on; surf(Xn,Yn,Z(:,:,LayerN+1),R(:,:,LayerN));
[I,J]=size(Z(:,:,LayerN));





%The following calculates which edges are boundary edges and closes the volume using the
%patch command. 

for i=1:I
    for j=1:J
        if isnan(Z(i,j,LayerN))
        else
            if ~isnan(Z(i+1,j,LayerN))&& (isnan(Z(i+1,j-1,LayerN))||isnan(Z(i,j-1,LayerN)))%west
                xt1=Xn(i,j); xt2=Xn(i+1,j); xb1=Xn(i,j); xb2=Xn(i+1,j);
                yt1=Yn(i,j); yt2=Yn(i+1,j); yb1=Yn(i,j); yb2=Yn(i+1,j);
                zt1=Z(i,j,LayerN); zt2=Z(i+1,j,LayerN); zb1=Z(i,j,LayerN+1); zb2=Z(i+1,j,LayerN+1);
                patch([xt1 xt2 xb2 xb1],[yt1 yt2 yb2 yb1],[zt1 zt2 zb2 zb1],R(i,j,LayerN))
            end
            if ~isnan(Z(i,j+1,LayerN))&& (isnan(Z(i-1,j+1,LayerN))||isnan(Z(i-1,j,LayerN))) %south
                 xt3=Xn(i,j); xt4=Xn(i,j+1); xb3=Xn(i,j); xb4=Xn(i,j+1);
                yt3=Yn(i,j); yt4=Yn(i,j+1); yb3=Yn(i,j); yb4=Yn(i,j+1);
                zt3=Z(i,j,LayerN); zt4=Z(i,j+1,LayerN); zb3=Z(i,j,LayerN); zb4=Z(i,j+1,LayerN);
                patch([xt3 xt4 xb4 xb3],[yt3 yt4 yb4 yb3],[zt3 zt4 zb4 zb3],R(i,j,LayerN))
            end
            if ~isnan(Z(i+1,j,LayerN))&& (isnan(Z(i+1,j+1,LayerN))||isnan(Z(i,j+1,LayerN)))%east
                xt1=Xn(i,j); xt2=Xn(i+1,j); xb1=Xn(i,j); xb2=Xn(i+1,j);
                yt1=Yn(i,j); yt2=Yn(i+1,j); yb1=Yn(i,j); yb2=Yn(i+1,j);
                zt1=Z(i,j,LayerN); zt2=Z(i+1,j,LayerN); zb1=Z(i,j,LayerN+1); zb2=Z(i+1,j,LayerN+1);
                patch([xt1 xt2 xb2 xb1],[yt1 yt2 yb2 yb1],[zt1 zt2 zb2 zb1],R(i,j-1,LayerN))
            end
            if ~isnan(Z(i,j+1,LayerN))&& (isnan(Z(i+1,j+1,LayerN))||isnan(Z(i+1,j,LayerN))) %north
                 xt3=Xn(i,j); xt4=Xn(i,j+1); xb3=Xn(i,j); xb4=Xn(i,j+1);
                yt3=Yn(i,j); yt4=Yn(i,j+1); yb3=Yn(i,j); yb4=Yn(i,j+1);
                zt3=Z(i,j,LayerN); zt4=Z(i,j+1,LayerN); zb3=Z(i,j,LayerN+1); zb4=Z(i,j+1,LayerN+1);
                patch([xt3 xt4 xb4 xb3],[yt3 yt4 yb4 yb3],[zt3 zt4 zb4 zb3],R(i,j,LayerN))
            end
        end
    end
end
set(findobj(gca,'type','surface'),'EdgeColor','none');
set(findobj(gca,'type','patch'),'EdgeColor','none');
view(350,40)
hLight = camlight('left');
end
