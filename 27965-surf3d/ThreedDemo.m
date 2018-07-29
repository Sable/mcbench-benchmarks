%Demonstration of the Surf3D function. Generates two surfaces of random
%data and then gets a subset. Replaces all values not inside the subset
%with NaN and plots the subset in 3D. boundary faces are created using
%patch and coloured according to the corresponding upper/lower faces

function ThreedDemo()

clear all; close all;
% Example - generate a surface using peaks, and plot it with different
% elevations
[X,Y,Ztop] = peaks(500);
Zbot=Ztop-5;
C=Ztop;
%Have a look to see what we are doing
figure('Name','Image of whole surface'); pcolor(X,Y,Ztop);
shading interp
% Get a subset of the area (originally created with ginput command)
x=[-1.0023   -0.2281    0.8088    1.8594    1.7627    0.6982   -0.7120];
y=[-0.7807   -1.5351   -1.9737   -1.0263    0.7982    1.9386    1.5000];

% replace all values outside the subset with nan
isinpolygon=inpolygon(X,Y,x,y);
newZtop=Ztop; newZtop(find(isinpolygon==0))=nan;
newZbot=Zbot; newZbot(find(isinpolygon==0))=nan;

% take a look at the subset
figure('Name','Image of Subset'); pcolor(X,Y,newZtop);
shading interp
%plot the two surfaces
scrsz = get(0,'ScreenSize');
figure('Position',[scrsz(3)/4 scrsz(4)/4 scrsz(3)/2 scrsz(4)/2],'Renderer','opengl'); surf(X,Y,newZtop,C); hold on; surf(X,Y,newZbot,C);
[I,J]=size(Ztop);





%For a threshold, or selected area within the survey area, the following
%calculates which edges are boundary edges and closes the volume using the
%patch command. 

for i=1:I
    for j=1:J
        if isnan(newZtop(i,j))
        else
            if ~isnan(newZtop(i+1,j))&& (isnan(newZtop(i+1,j-1))||isnan(newZtop(i,j-1)))%west
                xt1=X(i,j); xt2=X(i+1,j); xb1=X(i,j); xb2=X(i+1,j);
                yt1=Y(i,j); yt2=Y(i+1,j); yb1=Y(i,j); yb2=Y(i+1,j);
                zt1=Ztop(i,j); zt2=Ztop(i+1,j); zb1=Zbot(i,j); zb2=Zbot(i+1,j);
                patch([xt1 xt2 xb2 xb1],[yt1 yt2 yb2 yb1],[zt1 zt2 zb2 zb1],C(i,j))
            end
            if ~isnan(newZtop(i,j+1))&& (isnan(newZtop(i-1,j+1))||isnan(newZtop(i-1,j))) %south
                 xt3=X(i,j); xt4=X(i,j+1); xb3=X(i,j); xb4=X(i,j+1);
                yt3=Y(i,j); yt4=Y(i,j+1); yb3=Y(i,j); yb4=Y(i,j+1);
                zt3=Ztop(i,j); zt4=Ztop(i,j+1); zb3=Zbot(i,j); zb4=Zbot(i,j+1);
                patch([xt3 xt4 xb4 xb3],[yt3 yt4 yb4 yb3],[zt3 zt4 zb4 zb3],C(i,j))
            end
            if ~isnan(newZtop(i+1,j))&& (isnan(newZtop(i+1,j+1))||isnan(newZtop(i,j+1)))%east
                xt1=X(i,j); xt2=X(i+1,j); xb1=X(i,j); xb2=X(i+1,j);
                yt1=Y(i,j); yt2=Y(i+1,j); yb1=Y(i,j); yb2=Y(i+1,j);
                zt1=Ztop(i,j); zt2=Ztop(i+1,j); zb1=Zbot(i,j); zb2=Zbot(i+1,j);
                patch([xt1 xt2 xb2 xb1],[yt1 yt2 yb2 yb1],[zt1 zt2 zb2 zb1],C(i,j-1))
            end
            if ~isnan(newZtop(i,j+1))&& (isnan(newZtop(i+1,j+1))||isnan(newZtop(i+1,j))) %north
                 xt3=X(i,j); xt4=X(i,j+1); xb3=X(i,j); xb4=X(i,j+1);
                yt3=Y(i,j); yt4=Y(i,j+1); yb3=Y(i,j); yb4=Y(i,j+1);
                zt3=Ztop(i,j); zt4=Ztop(i,j+1); zb3=Zbot(i,j); zb4=Zbot(i,j+1);
                patch([xt3 xt4 xb4 xb3],[yt3 yt4 yb4 yb3],[zt3 zt4 zb4 zb3],C(i,j))
            end
        end
    end
end

set(findobj(gca,'type','surface'),'EdgeColor','none');
set(findobj(gca,'type','patch'),'EdgeColor','none');
view(350,40)
hLight = camlight('left')
contour3(X,Y,newZtop,20,'-k')
end
