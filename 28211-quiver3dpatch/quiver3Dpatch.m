function [F,V,C]=quiver3Dpatch(x,y,z,ux,uy,uz,c,a)

% function [F,V,C]=quiver3Dpatch(x,y,z,ux,uy,uz,a)
% ------------------------------------------------------------------------
%
% This function allows plotting of colored 3D arrows by generating patch
% data (faces “F”, vertices “V” and color data “C”). The patch data which
% allows plotting of 3D quiver arrows with specified (e.g. colormap driven)
% color. To save memory n arrows are created using only n*6 faces and n*7
% vertices. The vector "a" defines arrow length scaling where a(1) is the
% smallest arrow length and a(2) the largest. Use the PATCH command to plot
% the arrows:  
%
% [F,V,C]=quiver3Dpatch(x,y,z,ux,uy,uz,a)
% patch('Faces',F,'Vertices',V,'CData',C,'FaceColor','flat'); 
%
% Below is a detailed example illustrating color specifications for
% (combined) patch data. 
%
%%% EXAMPLE
% %% Plotting colormap driven arrows combined with RGB driven iso-surface
% a=[0.5 1]; %Arrow length scaling
% L=G>0.8; %Logic indices for arrows
% c=[]; %Default length dependant color will be used
% [F,V,C]=quiver3Dpatch(X(L),Y(L),Z(L),u(L),v(L),w(L),c,a);
% 
% Ci1n=(c_iso1.*ones(numel(Ci1),3))-min(M(:)); Ci1n=Ci1n./max(M(:)-min(M(:)));%Custom isosurface color
% Ci2n=(c_iso2.*ones(numel(Ci2),3))-min(M(:)); Ci2n=Ci2n./max(M(:)-min(M(:)));%Custom isosurface color
% 
% fig=figure; clf(fig); colordef (fig,'black'); set(fig,'Color','k');
% set(fig,'units','normalized','outerposition',[0 0 1 1]); hold on; 
% xlabel('X','FontSize',20);ylabel('Y','FontSize',20);zlabel('Z','FontSize',20);
% title('Colormap driven arrows, RGB isosurfaces','FontSize',15);
% patch('Faces',F,'Vertices',V,'EdgeColor','none', 'CData',C,'FaceColor','flat','FaceAlpha',1); colormap jet; colorbar; caxis([min(C(:)) max(C(:))]);
% patch('Faces',Fi1,'Vertices',Vi1,'FaceColor','flat','FaceVertexCData',Ci1n,'EdgeColor','none','FaceAlpha',0.75); hold on;
% patch('Faces',Fi2,'Vertices',Vi2,'FaceColor','flat','FaceVertexCData',Ci2n,'EdgeColor','none','FaceAlpha',0.75); hold on;
% view(3); grid on; axis vis3d; set(gca,'FontSize',20);
% 
% %% Plotting RGB driven arrows combined with colormap driven iso-surface
% a=[0.5 1]; %Arrow length scaling
% L=G>0.8; %Logic indices for arrows
% %Length dependent custom RGB (here grayscale) color specification
% c=1-(G(L)./max(G(L)))*ones(1,3);
% [F,V,C]=quiver3Dpatch(X(L),Y(L),Z(L),u(L),v(L),w(L),c,a);
% 
% fig=figure; clf(fig); colordef (fig,'white'); set(fig,'Color','w');
% set(fig,'units','normalized','outerposition',[0 0 1 1]); hold on; 
% xlabel('X','FontSize',20);ylabel('Y','FontSize',20);zlabel('Z','FontSize',20);
% title('RGB arrows, colormap driven iso-surfaces','FontSize',15);
% patch('Faces',Fi1,'Vertices',Vi1,'FaceColor','flat','CData',Ci1,'EdgeColor','none','FaceAlpha',0.4); hold on;
% patch('Faces',Fi2,'Vertices',Vi2,'FaceColor','flat','CData',Ci2,'EdgeColor','none','FaceAlpha',0.4); hold on;
% colormap jet; colorbar; caxis([c_iso1 c_iso2]);
% patch('Faces',F,'Vertices',V,'EdgeColor','none', 'FaceVertexCData',C,'FaceColor','flat','FaceAlpha',0.8);
% view(3); grid on; axis vis3d; set(gca,'FontSize',20);
%
%
% Kevin Mattheus Moerman
% kevinmoerman@hotmail.com
% 12/04/2011
%------------------------------------------------------------------------

%% 
%Coordinates
x=x(:); y=y(:); z=z(:);
ux=ux(:); uy=uy(:); uz=uz(:);

%Spherical coordinates
[THETA_vec,PHI_vec,R_vec] = cart2sph(ux,uy,uz);
  
%% Setting arrow size properties

%Arrow length
if  min(R_vec(:))==max(R_vec(:)) %If all radii are equal, or if just 1 vector is used
    arrow_length=a(2)*ones(size(R_vec)); %All arrow lengths become a(2)
else
    %Scale arrow lengths between a(1) and a(2)
    arrow_length=R_vec-min(R_vec(:));
    arrow_length=a(1)+((arrow_length./max(arrow_length(:))).*(a(2)-a(1)));
end

%Other arrow dimensions as functions of arrow length and phi (golden ratio)
phi=(1+sqrt(5))/2;
head_size=arrow_length./(phi);
head_width=head_size./(2.*phi);
stick_width=head_width./(2.*phi);
h=sin((2/3).*pi).*stick_width;
ha=sin((2/3).*pi).*head_width;

%% Creating arrow triangle vertices coordinates

X_tri=[zeros(size(x))  zeros(size(x)) zeros(size(x))...
    head_size.*ones(size(x)) head_size.*ones(size(x)) head_size.*ones(size(x))...
    arrow_length];
Y_tri=[-(0.5.*stick_width).*ones(size(x)) (0.5.*stick_width).*ones(size(x))  zeros(size(x))...
    -(0.5.*head_width).*ones(size(x))  (0.5.*head_width).*ones(size(x))  zeros(size(x))...
    zeros(size(x))];
Z_tri=[-(0.5.*stick_width.*tan(pi/6)).*ones(size(x))...
    -(0.5.*stick_width.*tan(pi/6)).*ones(size(x))...
    (h-(0.5.*stick_width.*tan(pi/6))).*ones(size(x))...
    -(0.5.*head_width.*tan(pi/6)).*ones(size(x))...
    -(0.5.*head_width.*tan(pi/6)).*ones(size(x))...
    (ha-(0.5.*head_width.*tan(pi/6))).*ones(size(x))...
    zeros(size(x))];

% Rotating vertices
[THETA_ar,PHI_ar,R_vec_ar] = cart2sph(X_tri,zeros(size(Y_tri)),Z_tri);
PHI_ar=PHI_ar+PHI_vec*ones(1,size(THETA_ar,2));
[X_arg,Y_arg,Z_arg] = sph2cart(THETA_ar,PHI_ar,R_vec_ar);
Y_arg=Y_arg+Y_tri;
[THETA_ar,PHI_ar,R_vec_ar] = cart2sph(X_arg,Y_arg,Z_arg);
THETA_ar=THETA_ar+THETA_vec*ones(1,size(THETA_ar,2));
[X_arg,Y_arg,Z_arg] = sph2cart(THETA_ar,PHI_ar,R_vec_ar);

X_arg=X_arg+x*ones(1,size(THETA_ar,2)); X_arg=X_arg';
Y_arg=Y_arg+y*ones(1,size(THETA_ar,2)); Y_arg=Y_arg';
Z_arg=Z_arg+z*ones(1,size(THETA_ar,2)); Z_arg=Z_arg';

V=[X_arg(:) Y_arg(:) Z_arg(:)];

%% Creating faces matrix

%Standard vertex order for 6 face arrow style
F_order=[1 2 7; 2 3 7; 3 1 7; 4 5 7; 5 6 7; 6 4 7;];
no_nodes=size(X_tri,2);
b=(no_nodes.*((1:1:numel(x))'-1))*ones(1,3);

%Loops size(F_order,1) times
F=zeros(numel(x)*size(F_order,1),3); %Allocating faces matrix
for f=1:1:size(F_order,1)
    Fi=ones(size(x))*F_order(f,:)+b;
    F(1+(f-1)*numel(x):f*numel(x),:)=Fi;
end

%     %Alternative without for loop, not faster for some tested problems
%     F_order=(ones(numel(x),1)*[1 2 7 2 3 7 3 1 7 4 5 7 5 6 7 6 4 7])';
%     F_order1=ones(numel(x),1)*(1:6);
%     F_order2=ones(numel(x),1)*[2 3 1 5 6 4];
%     F_order=[F_order1(:) F_order2(:)];
%     F_order(:,3)=7;
%     b=repmat(((no_nodes.*(0:1:numel(x)-1)')*ones(1,3)),[6,1]);
%     F=F_order+b;

%% Color specification

if isempty(c); %If empty specify vector magnitudes as color
    C=repmat(R_vec,[size(F_order,1),1]);
else %If user specified color replicate to match # of added faces for arrow
    C=repmat(c,[size(F_order,1),1]);
end    

end

