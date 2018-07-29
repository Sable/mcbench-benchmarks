function h=vector3d(X,Y,Z,U,V,W,varargin)
%h=vector3d(X,Y,Z,U,V,W,'Property','Value',...)
%
% Plot 3d vectors (real 3d) from .stl file to specified location and
% direction. 
%
%basically same usage as quiver3. Property/value pairs are passed to patch.
%Some additional property/values are available:
%
%h=vector3d(...,'FileName',file)            : string arry with name of .stl file (for example 'arrow4.stl')
%h=vector3d(...,'Scale',[sx sy sz])         : scales along the x-axis by sx, along the y-axis by sy, and along the z-axis by sz.
%                                             If scalar, Vectors are scaled uniformly.
%h=vector3d(...,'MaxVert',nmax)             : Maximum number of vertices per vector. Lower this value if many vectors have to be plotted. Default is 200.
%h=vector3d(...,'Lighting','gouraud')       : Sets both, edge and face lighting. Default is flat lighting
%h=vector3d(...,'Color',rgb)                : Sets face and edge color to specified color (indexed or true rgb). 
%                                             When omitted the vector
%                                             length and current colormap
%                                             are used
%h=vector3d(...,'ColorMap',cmap)            : sets the colormap to cmap for plotting.
%                                             minimum (but non-zero) and maximum data are mapped to
%                                             the interval [0 1]. 
%
%h=vector3d(...,'LightDirection',[x y z])   : Adds a infinite light to the axes with specified position [x y z]
%
%Example:
%
%[X,Y,Z]=sphere(20);
%[U,V,W] = surfnorm(X,Y,Z);
%surf(X,Y,Z);
%hold on
%h=vector3d(X,Y,Z,U,V,W,'FileName','arrow2.stl','Scale',0.25,'Lighting',...
%'gouraud','ColorMap','jet','LightDirection',[-1 -1 1])

%-----------------default values----------------------------------
filename='arrow2.stl';
scalefactor=1;
color='flat';
lighting='flat';
cmap=[];
lightdir=[];
nmax=200;

%-------------------Parse inputs----------------------------------------
if ~any(size(X)==size(Y) & size(Y)==size(Z))
    error('Input arguments must be of same size');
end

ind=[];
for i=1:2:length(varargin)-1
    prop=varargin{i};
    val=varargin{i+1};
    switch prop
        case 'Lighting'
            lighting=val;
            ind=[ind i i+1];
        case 'ColorMap'
            cmap=val;
            color='flat';
            ind=[ind i i+1]; 
        case 'FileName'
            filename=val;
            ind=[ind i i+1];
        case 'LightDirection'
            lightdir=val;
            ind=[ind i i+1];
        case 'Scale'
            scalefactor=val;
            ind=[ind i i+1];
        case 'Color'
            color=val;
            ind=[ind i i+1];
        case 'MaxVert'
            nmax=val;
            ind=[ind i i+1];
    end
end
ind=ind(ind>0);
varargin(ind)=[];

%------------------read the stl file--------------------------------
fv=stlread(filename); %reads arrow stl file. the 3d object should be of unit length and z-oriented
if size(fv.vertices,1)>nmax
fv=reducepatch(fv,nmax);
end

%linearize
X=X(:);
Y=Y(:);
Z=Z(:);
U=U(:);
V=V(:);
W=W(:);


vec_norm=sqrt(U.^2+V.^2+W.^2); %norm of vectors
ind=(vec_norm==0); %indices where norm is zero
vec_norm(ind)=[];

X(ind)=[];
Y(ind)=[];
Z(ind)=[];
U(ind)=[];
V(ind)=[];
W(ind)=[];

max_norm=max(vec_norm); %maximum norm (used for colormap)
min_norm=min(vec_norm);

N=length(X); %number of vectors to be plotted


n=size(fv.vertices,1); %number of mesh vertices
nf=size(fv.faces,1);% number of mesh faces

fv2.vertices=zeros(n*N,3); %preallocate space for patch object
fv2.faces=zeros(N*size(fv.faces,1),size(fv.faces,2));
fv2.FaceVertexCData=zeros(n,1);


%---------------Main loop---------------------------------------------------

for i=1:N;
    
    ax_rot=cross([U(i); V(i); W(i)],[0;0;1]); %axis perpendicular to 

    if ax_rot(1)==0 && ax_rot(2)==0 && ax_rot(3)==0
        ax_rot=[1 0 0];
    end
     %norm of u,v,w vector
    theta=acos(dot([U(i); V(i); W(i)]/vec_norm(i),[0;0;1])); %angle between oz direction (arrow mesh) and vector to be plotted

    

    M1=makehgtform('scale',vec_norm(i).*scalefactor);
    M2=makehgtform('axisrotate',ax_rot,-theta);
    M3=makehgtform('translate',[X(i) Y(i) Z(i)]);

    pos=(M3*M2*M1*[fv.vertices';ones(1,size(fv.vertices,1))])'; %applying transforms
    pos(:,4)=[]; %last column is always one (affine transform)

    fv2.vertices((i-1)*n+1:i*n,:)=pos;
    fv2.faces((i-1)*nf+1:i*nf,:)=fv.faces+max(max(fv2.faces)); %increase vertex indexes

    fv2.FaceVertexCData((i-1)*n+1:i*n)=(vec_norm(i)-min_norm)/(max_norm-min_norm); %indexed color

    
end

h=patch(fv2,'FaceColor',color,'EdgeColor',color,'FaceLighting',lighting,'EdgeLighting',lighting,varargin{:});

if ~isempty(lightdir)
  if isnumeric(lightdir)
    light('Style','infinite','Position',lightdir);
  else
      camlight(lightdir)
  end
end

if ~isempty(cmap)
    colormap(cmap)
end

set(gcf,'Renderer','OpenGl')
set(gca,'CLim',[min(vec_norm) max(vec_norm)])


