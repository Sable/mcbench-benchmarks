function varargout = curvvec(X,Y,U,V,varargin)
% CURVVEC - create curved arrows from 2D vector data
%   CURVVEC(X,Y,U,V) creates curved vectors for vector components U,V.
%   The arrays X,Y define the coordinates for U and V. If X and 
%   Y are not regularly spaced (as produced by MESHGRID), CURVVEC 
%   will re-sample the data to create evenly spaced matrices. Curvature
%   of the vectors is based on ML Built-in function, STREAM2. The
%   length of the vectors are scaled to the vector magnitude.  The 
%   color of the vectors may or may not be scaled according to 
%   the vector magnitude depending on optional input parameters (see
%   below).
%
%   OPTIONAL INPUT ARGUMENTS - optional input arguments can be provided
%   using property/value pairs.
%       'maxmag'    - maximum magnitude used for vector length scaling and
%                     color.
%       'minmag'    - minimum magnitude used for vector length scaling and
%                     color.
%       'numpoints' - maximum vector length (number of points).
%       'thin'      - vector thinning parameter. No thinning (value=1) 
%                     by default. Larger integers decrease number of 
%                     vectors shown.
%       'color'     - Controls colors of the vectors.  If this is a single
%                     value (eg. 'k' or [1 1 1]), all vector will be the 
%                     same color.  If this value is a standard colormap, 
%                     (eg. jet), the color of each vector will be scaled
%                     according to the vector magnitude.  Custom colormaps
%                     (eg. m x 3 matrix) are also accepted.
%       'linewidth' - line width (default=1)
%
%   OPTIONAL OUTPUT ARGUMENT
%       H=CURVVEC(...) - returns handles to the curved vector and 
%                        arrow heads line elements
%
%   EXAMPLE 
%       %generate data
%       load wind
%       mu=mean(u,3); mv=mean(v,3); mx=mean(x,3); my=mean(y,3);
%
%       figure
%       curvvec(mx,my,mu,mv,'color',jet,'minmag',5,...
%           'maxmag',50,'thin',3) 
%       set(gca,'color','k')
%
% NOTE- This code was originally based on Betrand Dano's STREAKARROW, 
% available on the ML File Exchange (ID=22269).
%
% SEE ALSO STREAM2 STREAMLINE QUIVER

% Andrew Stevens, 8/17/2009
% astevens@usgs.gov

%check number of inputs
error(nargchk(4,inf,nargin,'struct'));

%check size of inputs
if ndims(X) > 2 || ndims(X) > 2 || ndims(U) > 2 || ndims(V) > 2
    error('ASTEVENS:curv_vec:HigherDimArray',...
          'X,Y and U,V cannot be arrays of dimension greater than two.');
end

%default values for optional params
color='k'; %user-specified color flag
maxspd=[]; %maximum speed for vector scaling
minspd=[]; %minimum speed for vector scaling
np=50; %max number points in vector
thin=1; %reduces number of vectors
lw=1; %linewidth

%process optional input args
if nargin>0
    [m,n]=size(varargin);
    opts={'maxmag','minmag','numpoints','thin','color',...
        'linewidth'};
    
    for i=1:n;
        if ischar(varargin{i})
            ind1=strncmpi(varargin{i},opts,3);
            ind=find(ind1==1);
            if ~isempty(ind)
                switch ind
                    case 1
                        maxspd=varargin{i+1};
                    case 2
                        minspd=varargin{i+1};
                    case 3
                        np=round(varargin{i+1});
                    case 4
                        thin=round(varargin{i+1});
                    case 5
                        color=varargin{i+1};
                        
                        if isa(color,'function_handle')
                            color= func2str(color);
                        end
                        %check size of numeric colormap input
                        if isa(color,'numeric')
                            [m,n]=size(color);
                            if n~=3
                                error('ASTEVENS:curv_vec:badColormap',...
                                    'Custom Colormap must have 3 columns.')
                            end
                        end
                    case 6
                        lw=varargin{i+1};
                        
                end
            else
            end
        end
    end
end


%prepare data for stream2 function
%first check for uniform grid 
dx=abs(diff(X(1,:)));
dy=abs(diff(Y(:,1)));
maxDiff=0.01;

%if grid is not regular (like my curvilinear model output),
%reshape into regular grid using grid-cell averaging
if any(diff(dx)>maxDiff) || any(diff(dy)>maxDiff) || ...
        any(isnan(dx)) || any(isnan(dy))
    fprintf(['Non-uniform grid detected, re-binning data ',...
        'onto square grid...\n'])
    
    [m,n]=size(X);
    minx=min(X(:));
    maxx=max(X(:));
    miny=min(Y(:));
    maxy=max(Y(:));
    
    %decrease the resolution of the grid by 2
    xi=linspace(minx,maxx,round(n/2));
    yi=linspace(miny,maxy,round(m/2));
    [Xm,Ym]=meshgrid(xi,yi);
    
    Um=bin2mat(X(:),Y(:),U(:),Xm,Ym);
    Um(isnan(Um))=0;
    Vm=bin2mat(X(:),Y(:),V(:),Xm,Ym);
    Vm(isnan(Vm))=0;
else
    [Um,Vm,Xm,Ym]=deal(U,V,X,Y);
end

%replace non-finite velocity with zero
Um(~isfinite(Um))=0;
Vm(~isfinite(Vm))=0;

%create streamlines
XY=stream2(Xm,Ym,Um,Vm,Xm,Ym);

%calculate vector magnitude
[direc,spd]=cart2pol(Vm,Um);
if isempty(maxspd)
    maxspd=max(spd(:));
end
if isempty(minspd)
    minspd=0;
end

%scale length of vectors to vector magnitude
len=cellfun(@(x)(size(x,1)),XY);
nline=ceil(interp1(linspace(minspd,maxspd,np),(1:np),spd(:)));
nline(spd>maxspd)=np;
nline(spd<minspd)=0;

F0=cell(length(XY),1);
F0(len>nline') = cellfun(@(x,y)(x(1:y,:)),...
    XY(len>nline')',num2cell(nline(len>nline')),'uni',0);
len2=cellfun(@(x)(size(x,1)),F0);
F0=F0(len2>1);

%calculate the arrowhead position
F1=cellfun(@(x,y)(x(end-1:end,:)),F0,'uni',0);
x1=cellfun(@(x)(x(1,1)),F1);
y1=cellfun(@(x)(x(1,2)),F1);
x2=cellfun(@(x)(x(2,1)),F1);
y2=cellfun(@(x)(x(2,2)),F1);
u=-(x1-x2); v=-(y1-y2);

alpha = 10;  % Size of arrow head relative to the length of the vector
beta = .35; % Width of the base of the arrow head relative to the length

%scale the arrow size relative to velocity mag.
ialpha=interp1(linspace(minspd,maxspd,alpha),(1:alpha),spd(len2>1));
ialpha(spd(len2>1)>maxspd)=alpha;
ialpha(spd(len2>1)<minspd)=1;

ibeta=interp1(linspace(minspd,maxspd,10),(0:beta/9:beta),spd(len2>1));
ibeta(spd(len2>1)>maxspd)=beta;
ibeta(spd(len2>1)<minspd)=0;

%calculate the x,y position of the arrowheads
xa1=x2+u-ialpha.*(u+ibeta.*(v+eps));
xa2=x2+u-ialpha.*(u-ibeta.*(v+eps));
ya1=y2+v-ialpha.*(v-ibeta.*(u+eps));
ya2=y2+v-ialpha.*(v+ibeta.*(u+eps));

%do we want to color the arrows according 
%scaled to the vector mag?
if (isa(color,'numeric') && size(color,1)>1) || ...
        (isa(color,'char') && numel(color)>1);
    
    if isa(color,'char');
        color=feval(color);
    end
    
    edges=[-inf,linspace(minspd,maxspd,size(color,1)-2),inf];
    [n,bin]=histc(spd(len2>1),edges);
    
    
    colors=num2cell(color(bin,:),2);
else
    colors=cellstr(repmat(color,length(F0),1));
end
    
%get the current axes, next plot property (so we can set it back)
nextp=get(gca,'nextplot');

%draw the streamlines
h=streamline(F0(1:thin:end));
cellfun(@(x,y)(set(x,'color',y,'linewidth',lw)),...
    num2cell(h),colors(1:thin:end));
hold on

%draw the arrowheads
xhead=num2cell([xa1 x2 xa2],2);
yhead=num2cell([ya1 y2 ya2],2);
h2=cellfun(@(x,y,z)(plot(x,y,'color',z,'linewidth',lw)),...
    xhead(1:thin:end),yhead(1:thin:end),colors(1:thin:end));

%clean up
set(gca,'nextplot',nextp);

%optional output arg
if nargout>0
    varargout{1}=[h;h2];
end

%%%%-subfunction-----------------------------------------------------------
function ZG = bin2mat(x,y,z,XI,YI,varargin)
% BIN2MAT - create a matrix from scattered data without interpolation
% 
%   ZG = BIN2MAT(X,Y,Z,XI,YI) - creates a grid from the data 
%   in the (usually) nonuniformily-spaced vectors (x,y,z) 
%   using grid-cell averaging (no interpolation). The grid 
%   dimensions are specified by the uniformily spaced vectors
%   XI and YI (as produced by meshgrid). 
%
%   ZG = BIN2MAT(...,@FUN) - evaluates the function FUN for each
%   cell in the specified grid (rather than using the default
%   function, mean). If the function FUN returns non-scalar output, 
%   the output ZG will be a cell array.
%
%   ZG = BIN2MAT(...,@FUN,ARG1,ARG2,...) provides aditional
%   arguments which are passed to the function FUN. 
%
%   EXAMPLE
%    
%   %generate some scattered data
%    [x,y,z]=peaks(150);
%    ind=(rand(size(x))>0.9);
%    xs=x(ind); ys=y(ind); zs=z(ind);
%
%   %create a grid, use lower resolution if 
%   %no gaps are desired
%    xi=min(xs):0.25:max(xs);
%    yi=min(ys):0.25:max(ys);
%    [XI,YI]=meshgrid(xi,yi);
%
%   %calculate the mean and standard deviation
%   %for each grid-cell using bin2mat
%    Zm=bin2mat(xs,ys,zs,XI,YI); %mean 
%    Zs=bin2mat(xs,ys,zs,XI,YI,@std); %std
%  
%   %plot the results 
%    figure 
%    subplot(1,3,1);
%    scatter(xs,ys,10,zs,'filled')
%    axis image
%    title('Scatter Data')    
%
%    subplot(1,3,2);
%    pcolor(XI,YI,Zm)
%    shading flat
%    axis image
%    title('Grid-cell Average')
%
%    subplot(1,3,3);
%    pcolor(XI,YI,Zs)
%    shading flat
%    axis image
%    title('Grid-cell Std. Dev.')   
%   
% SEE also RESHAPE ACCUMARRAY FEVAL   

% A. Stevens 3/10/2009
% astevens@usgs.gov

%check inputs
error(nargchk(5,inf,nargin,'struct'));

%make sure the vectors are column vectors
x = x(:);
y = y(:);
z = z(:);

if all(any(diff(cellfun(@length,{x,y,z}))));
    error('Inputs x, y, and z must be the same size');
end

%process optional input
fun=@mean;
test=1;
if ~isempty(varargin)
    fun=varargin{1};
    if ~isa(fun,'function_handle');
        fun=str2func(fun);
    end
    
    %test the function for non-scalar output
    test = feval(fun,rand(5,1),varargin{2:end});
    
end

%grid nodes
xi=XI(1,:);
yi=YI(:,1);
[m,n]=size(XI);

%limit values to those within the specified grid
xmin=min(xi);
xmax=max(xi);
ymin=min(yi);
ymax=max(yi);

gind =(x>=xmin & x<=xmax & ...
    y>=ymin & y<=ymax);

%find the indices for each x and y in the grid
[junk,xind] = histc(x(gind),xi);
[junk,yind] = histc(y(gind),yi);

%break the data into a cell for each grid node
blc_ind=accumarray([yind xind],z(gind),[m n],@(x){x},{NaN});

%evaluate the data in each grid using FUN
if numel(test)>1
    ZG=cellfun(@(x)(feval(fun,x,varargin{2:end})),blc_ind,'uni',0);
else
    ZG=cellfun(@(x)(feval(fun,x,varargin{2:end})),blc_ind);
end

