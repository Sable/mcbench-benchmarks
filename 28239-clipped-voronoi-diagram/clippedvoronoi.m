function [vxx,vy] = clippedvoronoi(varargin)
%
% function [vxx,vy] = clippedvoronoi(varargin)
%                                   
% Clipped Voronoi Diagram - Version 1.0
%
%   clippedvoronoi(X,Y) plots the real Voronoi diagram for the points X,Y.
%
%   clippedvoronoi(X,Y,TRI) plots the real Voronoi diagram for the points
%   X,Y using the triangulation TRI from DelaunayTri function
%
% Code -> Modification using Voronoi function from MatLab
%
% Example:
%   coor = rand(50,2);
%   tri = DelaunayTri(coor(:,1),coor(:,2));
%   clippedvoronoi(coor(:,1),coor(:,2),tri.Triangulation);
%
%                                                               July 2010
%                       David Gonzalez
%
% (GEMM) Group of Estructural Mechanics and Material Modelling
% (I3A) Aragon Institute of Engineering Research
%
%                                          Universidad de Zaragoza (Spain)

fprintf(1,'Computing Voronoi Diagram...');
[cax,args,nargs] = axescheck(varargin{:});
error(nargchk(2,4,nargs));

x = args{1};
y = args{2};
if ~isequal(size(x),size(y))
    error('MATLAB:voronoi:InputSizeMismatch',...
          'X and Y must be the same size.');
end
if ndims(x) > 2 || ndims(y) > 2
    error('MATLAB:voronoi:HigherDimArray',...
          'X,Y cannot be arrays of dimension greater than two.');
end
x = x(:);
y = y(:);
if nargs == 2,
    tri = DelaunayTri(x,y); tri = tri.Triangulation;
    ls = '';
else 
    arg3 = args{3};
    if nargs == 3,
        ls = '';
    else
        arg4 = args{4};
        ls = arg4;
    end 
    if isempty(arg3),
        tri = DelaunayTri(x,y); tri = tri.Triangulation;
    elseif ischar(arg3),
        tri = DelaunayTri(x,y); tri = tri.Triangulation; 
        ls = arg3;
    elseif iscellstr(arg3),
        tri = DelaunayTri(x,y,arg3); tri = tri.Triangulation;
    else
        tri = arg3;
    end
    clear arg3;
end
tri1 = DelaunayTri(x,y); tri2 = tri1;% ConvexHull Triangulation.
[triaux,numtind] = setdiff(tri1.Triangulation,tri,'rows'); tri1 = tri; 
if numel(numtind)~=size(tri2.Triangulation,1)-size(tri,1)
    [triaux1,numtind1] = setdiff(triaux(:,[3 1 2]),tri,'rows');
    idq = setdiff(1:size(triaux,1),numtind1);
    triaux(idq,:) = []; numtind(idq) = [];
    [triaux1,numtind2] = setdiff(triaux(:,[2 3 1]),tri,'rows');
    idq = setdiff(1:size(triaux,1),numtind2);
    triaux(idq,:) = []; numtind(idq) = [];
    clear triaux1;
end
tri = [tri; triaux];
% re-orient the triangles so that they are all clockwise
xt = x(tri); 
yt = y(tri);
%Because of the way indexing works, the shape of xt is the same as the
%shape of tri, EXCEPT when tri is a single row, in which case xt can be a
%column vector instead of a row vector.
if size(xt,2) == 1 
    xt = xt';
    yt = yt';
end
ot = xt(:,1).*(yt(:,2)-yt(:,3)) + ...
    xt(:,2).*(yt(:,3)-yt(:,1)) + ...
    xt(:,3).*(yt(:,1)-yt(:,2));
bt = find(ot<0);
tri(bt,[1 2]) = tri(bt,[2 1]);

% Compute centers of triangles
c = circle(tri,x,y);

% Create matrix T where i and j are endpoints of edge of triangle T(i,j)
n = numel(x);
tt = repmat((1:size(tri,1))',1,3);
T = sparse(tri,tri(:,[3 1 2]),tt,n,n); 
tt1 = repmat((1:size(tri1,1))',1,3);
T1 = sparse(tri1,tri1(:,[3 1 2]),tt1,n,n); 

% i and j are endpoints of internal edge in triangle E(i,j)
E = (T & T').*T; 
% i and j are endpoints of external edge in triangle F(i,j)
F = xor(T1, T1').*T1; 

% v and vv are triangles that share an edge
[i,j,v] = find(triu(E));
[i,j,vv] = find(triu(E'));

% Internal edges
vx = [c(v,1) c(vv,1)]'; vy = [c(v,2) c(vv,2)]';

%%% Compute lines-to-infinity
% i and j are endpoints of the edges of triangles in z
[i,j,z] = find(F);
% Counter-clockwise components of lines between endpoints
dx = x(j) - x(i); dy = y(j) - y(i);
% Calculate scaling factor for length of line-to-infinity
% Distance across range of data
rx = max(x)-min(x); ry = max(y)-min(y);
% Distance from vertex to center of data
cx = (max(x)+min(x))/2 - c(z,1); cy = (max(y)+min(y))/2 - c(z,2);
% Sum of these two distances
nm = sqrt(rx.*rx + ry.*ry) + sqrt(cx.*cx + cy.*cy);
% Compute scaling factor
scale = nm./sqrt((dx.*dx+dy.*dy));
    
% Lines from voronoi vertex to "infinite" endpoint
% We know it's in correct direction because compononents are CCW
ex = [c(z,1) c(z,1)-dy.*scale]'; ey = [c(z,2) c(z,2)+dx.*scale]';
% Combine with internal edges
vx0 = vx'; vy0 = vy'; % Internal Edges copy.
vx = [vx ex]; vy = [vy ey];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Clipped Voronoi Diagram %%%%%
fprintf(1,'\nComputing Clipped Voronoi Diagram...\n');
% External edges from convexhull can offer a valid intersection point
F1 = xor(T, T').*T; 
[i1,j1,zz] = find(F1); dx1 = x(j1) - x(i1); dy1 = y(j1) - y(i1);
ex1 = [c(zz,1) c(zz,1)-dy1.*max(scale)]';
ey1 = [c(zz,2) c(zz,2)+dx1.*max(scale)]';
vx = [vx ex1]; vy = [vy ey1];

% Triangulation from the real domain for each Voronoi segment
v1 = repmat(v,1,length(i))'; vv1 = repmat(vv,1,length(i))'; 
z1 = repmat(z,1,length(i))';
numtria = [[v1(:) vv1(:)]; [z1(:) z1(:)]]';
tria = [tri(numtria(1,:),1) tri(numtria(1,:),2) tri(numtria(1,:),3)...
    tri(numtria(2,:),1) tri(numtria(2,:),2) tri(numtria(2,:),3)];
% Adding triangulation from the convexhull domain
zz1 = repmat(zz,1,length(i))'; numtria1 = [zz1(:) zz1(:)]';
tria = [tria; [tri(numtria1(1,:),1) tri(numtria1(1,:),2) ...
    tri(numtria1(1,:),3) tri(numtria1(2,:),1) ...
    tri(numtria1(2,:),2) tri(numtria1(2,:),3)]];
% Searching intersection between cells and boundary
% All vertexs of finite cells out the real domain
trid = tri2.pointLocation([vx0(:,1); vx0(:,2)],[vy0(:,1); vy0(:,2)]);
idxd = max(repmat(trid,1,numel(numtind))==repmat(numtind',numel(trid),1),[],2);
trid(idxd>0) = NaN;
Indi = unique(~isfinite(trid).*[1:numel(vx0)]');
if ~Indi(1)
    Indi(1) = [];
end
nx0 = size(vx0,1);
Indi1 = [(Indi<nx0+1).*Indi ((Indi>nx0).*Indi)-nx0];
% Delete these vertex out the domain
Indi2 = unique(Indi1(Indi1>0));
% Checking every cell and the neigthboor nodes 
numlad = length(i); % Number of external edges
numseg = size(vx,2); % Number  of cells sides
S1x = repmat(vx(1,:),numlad,1); S1y = repmat(vy(1,:),numlad,1);
S2x = repmat(vx(2,:),numlad,1); S2y = repmat(vy(2,:),numlad,1);
L1 = repmat([x(i) y(i)],numseg,1); L2 = repmat([x(j) y(j)],numseg,1);
% Function intersection point for a valid Voronoi Diagram
[P,P1,P2] = itcnpt([S1x(:) S1y(:)],[S2x(:) S2y(:)],L1,L2,x,y,tria);
Indf = unique(P1.*(1:size(P,1))');
if ~Indf(1)
    Indf(1) = [];
end
% Intersections with the boundary
Pm = zeros(numlad,numseg); Pm(:) = P2; suma = sum(Pm,1);
Indc = unique((suma>1).*(1:numseg));
if ~Indc(1)
    Indc(1) = [];
end
% Composition of Voronoi Diagram.
Sx = S1x; Sy = S1y;
if ~isempty(Indi1)
    Indi0 = setdiff(Indi1(Indi1(:,1)>0,1),Indi1(Indi1(:,2)>0,2));
    if ~isempty(Indi0)
        Indi3 = (Indi0-1)*numlad;
        Indi4 = repmat(Indi3,1,numlad) + ones(length(Indi3),1)*(1:numlad);
        Sx(Indi4) = S2x(Indi4); Sy(Indi4) = S2y(Indi4);
    end
end
Indi2 = unique([Indi2; Indc(Indc<nx0+1)']);
vx0(Indi2,:) = []; vy0(Indi2,:) = []; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Last Check %%%%%%
% Pxmed1 = (Sx(Indf) + P(Indf,1))/2.0;
% Pymed1 = (Sy(Indf) + P(Indf,2))/2.0;
% ptomed1 = tri2.pointLocation(Pxmed1,Pymed1);
% ptom = max(repmat(ptomed1,1,numel(numtind))==repmat(numtind',numel(ptomed1),1),[],2);
% Indf_ = Indf;
% Indf_(ptom>0) = [];
% vx = [vx0' [Sx(Indf_) P(Indf_,1)]']; vy = [vy0' [Sy(Indf_) P(Indf_,2)]'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Last Check %%%%%%
vx = [vx0' [Sx(Indf) P(Indf,1)]']; vy = [vy0' [Sy(Indf) P(Indf,2)]'];
% Adding the external edges of the triangulation
vx = [vx [x(i) x(j)]']; vy = [vy [y(i) y(j)]']; 
if ~isempty(Indc)
    % If the vertex of the segment are out the domain we  delete the
    % segment, and add the new one.
    Ix1 = (Indc-1)*numlad; Ix2 = Ix1 + numlad + 1;
    Ix3 = (repmat(Ix1',1,length(Indf))<repmat(Indf',length(Ix1),1) & ...
        repmat(Indf',length(Ix1),1)<repmat(Ix2',1,length(Indf)))...
        .*repmat([1:length(Indf)],length(Ix1),1);
    Indff = [1:length(Indf)]'; Ix4 = unique(Ix3(:));
    % The first value of Ix4 allways will be 0
    Indi6 = Indff(Ix4(2:end)) + nx0 - length(Indi2);
    vx(:,Indi6) = []; vy(:,Indi6) = []; % Deleted!
    % Adding the news segments to the Voronoi Diagram    
    Ix1 = (Indc-1)*numlad; Ix2 = Ix1 + numlad + 1;
    Ix3 = (repmat(Ix1',1,length(Indf))<repmat(Indf',length(Ix1),1) & ...
        repmat(Indf',length(Ix1),1)<repmat(Ix2',1,length(Indf)))...
        .*repmat([1:length(Indf)],length(Ix1),1);
    Ix3 = sort(Ix3,2); Ix4 = Ix3(:,end-max(suma)+1:end);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i1=1:numel(Indc) 
        Ix5 = unique(Ix4(i1,:));
        if ~Ix5(1)
            Ix5(1)=[];
        end
        if ~isempty(Ix5)
            Indi7 = Indf(Ix5);
            Pvx = [S1x(Indi7); P(Indi7,1); S2x(Indi7)]; Pvy = [S1y(Indi7); ...
            P(Indi7,2); S2y(Indi7)]; pto = dsearch(x,y,tri1,Pvx(1),Pvy(1));
            ang = atan2(Pvy-repmat(y(pto),numel(Pvy),1),...
                Pvx-repmat(x(pto),numel(Pvx),1))+2.*pi;
            [angs,Inda] = unique([ang Pvx Pvy],'rows'); angs = angs(:,1);
            Inda1 = (ang(Inda)>2*pi).*[1:numel(Inda)]'; 
            angs(Inda1>0) = angs(Inda1>0)-2*pi; [angs,Inda1] = sort(angs);
            
            Inds1 = tri2.pointLocation(S1x(Indi7),S1y(Indi7));
            idx1 = max(repmat(Inds1,1,numel(numtind))==repmat(numtind',numel(Inds1),1),[],2);
            Inds1(idx1>0) = NaN;
            Inds2 = tri2.pointLocation(S2x(Indi7),S2y(Indi7));
            idx2 = max(repmat(Inds2,1,numel(numtind))==repmat(numtind',numel(Inds2),1),[],2);
            Inds2(idx2>0) = NaN;
            Inda2 = [Inds1; ones(numel(Indi7),1); Inds2]; 
            Inda2 = Inda2(Inda(Inda1));
            Pvx2 = [Pvx(Inda(Inda1))'; Pvx(Inda(Inda1(2:end)))'...
                Pvx(Inda(Inda1(1)))];
            Pvy2 = [Pvy(Inda(Inda1))'; Pvy(Inda(Inda1(2:end)))'...
                Pvy(Inda(Inda1(1)))];
            Inda1b = [Inda1(2:end); Inda1(1)]; 
            Inda3 = [Inda2(2:end); Inda2(1)];
            Pxmed = (Pvx(Inda(Inda1)) + Pvx(Inda(Inda1b)))/2.0;
            Pymed = (Pvy(Inda(Inda1)) + Pvy(Inda(Inda1b)))/2.0;
            ptomed = tri2.pointLocation(Pxmed,Pymed);
            pto1 = max(repmat(ptomed,1,numel(numtind))==repmat(numtind',numel(ptomed),1),[],2);
            ptomed(pto1>0) = NaN;
            
            [dist,pto2] = min(((repmat(Pxmed,1,numel(Inda1))-repmat(Pvx2(1,:),numel(Inda1),1)).^2 ...
            + (repmat(Pymed,1,numel(Inda1))-repmat(Pvy2(1,:),numel(Inda1),1)).^2).^0.5,[],2);
            debe = (1:numel(Inda1))'; debe = [debe debe+1]; debe(end) = 1;
            ptomed2 = zeros(numel(Inda1),1);
            ptomed2(sum((repmat(pto2,1,2)==debe),2)<1) = NaN;
            
            Inda4 = isfinite(Inda2.*Inda3.*ptomed.*ptomed2); % To take account
%             fprintf(1,'%d %d %f %f\n\n',i1,Inda4,Pvx2(:),Pvy2(:));
            vx = [vx Pvx2(:,Inda4)]; vy = [vy Pvy2(:,Inda4)];
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
%% 
fprintf(1,'Ploting...\n'); figure(3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Ploting %%%%%%%%%%%
if nargout<2
    % Plot diagram
    if isempty(cax)
        % If no current axes, create one
        cax = gca;
    end
    if isempty(ls)
        % Default linespec
        ls = '-';
    end
    [l,c,mp,msg] = colstyle(ls); error(msg) % Extract from linespec
    if isempty(mp)
        % Default markers at points        
        mp = '.';
    end
    if isempty(l)
        % Default linestyle
        l = get(ancestor(cax,'figure'),'defaultaxeslinestyleorder'); 
    end
    if isempty(c), 
        % Default color        
        co = get(ancestor(cax,'figure'),'defaultaxescolororder');
        c = co(1,:);
    end
    % Plot points
    h1 = plot(x,y,'marker',mp,'color',c,'linestyle','none','parent',cax);
    % Plot voronoi lines
    h2 = line(vx,vy,'color',c,'linestyle',l,'parent',cax,...
        'yliminclude','off','xliminclude','off');
    if nargout==1, vxx = [h1; h2]; end % Return handles
    axis([min(x)-0.05 max(x)+0.05 min(y)-0.05 max(y)+0.05]);
else
    vxx = vx; % Don't plot, just return vertices
end



function c = circle(tri,x,y)
%CIRCLE Return center and radius for circumcircles
%   C = CIRCLE(TRI,X,Y) returns a N-by-2 vector containing [xcenter(:)
%   ycenter(:)] for each triangle in TRI.

% Reference: Watson, p32.
x1 = x(tri(:,1)); x2 = x(tri(:,2)); x3 = x(tri(:,3));
y1 = y(tri(:,1)); y2 = y(tri(:,2)); y3 = y(tri(:,3));

% Set equation for center of each circumcircle: 
%    [a11 a12;a21 a22]*[x;y] = [b1;b2] * 0.5;

a11 = x2-x1; a12 = y2-y1;
a21 = x3-x1; a22 = y3-y1;

% Solve the 2-by-2 equation explicitly
idet = a11.*a22 - a21.*a12;

% Add small random displacement to points that are either the same
% or on a line.
d = find(idet == 0);
if ~isempty(d), % Add small random displacement to points
    delta = sqrt(eps);
    x1(d) = x1(d) + delta*(rand(size(d))-0.5);
    x2(d) = x2(d) + delta*(rand(size(d))-0.5);
    x3(d) = x3(d) + delta*(rand(size(d))-0.5);
    y1(d) = y1(d) + delta*(rand(size(d))-0.5);
    y2(d) = y2(d) + delta*(rand(size(d))-0.5);
    y3(d) = y3(d) + delta*(rand(size(d))-0.5);
    a11 = x2-x1; a12 = y2-y1;
    a21 = x3-x1; a22 = y3-y1;
    idet = a11.*a22 - a21.*a12;
end

b1 = a11 .* (x2+x1) + a12 .* (y2+y1);
b2 = a21 .* (x3+x1) + a22 .* (y3+y1);

idet = 0.5 ./ idet;

xcenter = ( a22.*b1 - a12.*b2) .* idet;
ycenter = (-a21.*b1 + a11.*b2) .* idet;

c = [xcenter ycenter];


function [P,P1,P2] = itcnpt(P1,P2,P3,P4,x,y,tria)
% Compute the point between the segments P1P2 and P3P4
%
% D.Gonzalez(c)2010 - Universidad de Zaragoza (Spain)
P = zeros(size(P1));
deno = (P4(:,2) - P3(:,2)).*(P2(:,1) - P1(:,1)) - (P4(:,1) - P3(:,1)).*(P2(:,2) - P1(:,2));
a = (P4(:,1) - P3(:,1)).*(P1(:,2) - P3(:,2)) - (P4(:,2) - P3(:,2)).*(P1(:,1) - P3(:,1));

TOL = 1.0E-08;
Ind1 = find(abs(deno)>TOL);
Ind2 = setdiff(1:size(P1,1),Ind1);
P(Ind1,1) = P1(Ind1,1) + a(Ind1).*(P2(Ind1,1)-P1(Ind1,1))./deno(Ind1);
P(Ind1,2) = P1(Ind1,2) + a(Ind1).*(P2(Ind1,2)-P1(Ind1,2))./deno(Ind1);

%Ind3 = find(abs((atan2(P1(Ind1,2)-P(Ind1,2),P1(Ind1,1)-P(Ind1,1))-atan2(P2(Ind1,2)-P(Ind1,2),P2(Ind1,1)-P(Ind1,1))).*...
%    (atan2(P3(Ind1,2)-P(Ind1,2),P3(Ind1,1)-P(Ind1,1))-atan2(P4(Ind1,2)-P(Ind1,2),P4(Ind1,1)-P(Ind1,1))))<0.1);
%Ind2 = [Ind2'; Ind1(Ind3)];

alpha1 = atan2(P1(Ind1,2)-P(Ind1,2),P1(Ind1,1)-P(Ind1,1));
alpha2 = atan2(P2(Ind1,2)-P(Ind1,2),P2(Ind1,1)-P(Ind1,1));
alpha3 = atan2(P3(Ind1,2)-P(Ind1,2),P3(Ind1,1)-P(Ind1,1));
alpha4 = atan2(P4(Ind1,2)-P(Ind1,2),P4(Ind1,1)-P(Ind1,1));

alpha1(abs(alpha1+pi)<TOL) = pi;
alpha2(abs(alpha2+pi)<TOL) = pi;
alpha3(abs(alpha3+pi)<TOL) = pi;
alpha4(abs(alpha4+pi)<TOL) = pi;

Ind3 = find(abs((alpha1-alpha2).*(alpha3-alpha4))<0.1);
Ind2 = [Ind2'; Ind1(Ind3)];

P(Ind2,1:2) = Inf;

x1 = repmat(x',size(P,1),1); y1 = repmat(y',size(P,1),1); P1 = repmat(P(:,1),1,length(x)); P2 = repmat(P(:,2),1,length(y));
[dist,pto] = min(((P1-x1).^2 + (P2-y1).^2).^0.5,[],2); 
pto(~isfinite(dist)) = 0; pto = repmat(pto,1,6); Indt = (1:numel(a))';

Ind3 = Indt(sum(tria==pto,2)==0); P2 = isfinite(P(:,1));
P(Ind3,1:2) = Inf; P1 = isfinite(P(:,1));

return


