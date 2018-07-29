function [srf]=nrbloft(X,Y,Z,dir,mode)
% NRBLOFT  Loft Univariate NURBS curves into a NURBS surface
%
%  NRBLOFT constructs a surface by lofting NURBS curves.  This is performed
%  by an interpolation of the new control points from the ones specified in
%  each curve.
%
%  NRBLOFT(CURVES) where CURVES is either a cell array or structure array 
%  of NURBS representation structures created from NRBMAK in the NURBS
%  toolbox.  NRBLOFT performs the lofting procedure in the order which the
%  elements are specified in CURVES.
%
%  NRBLOFT(X,Y,Z) lofts a NURBS surface based on the data in the rows of
%  each element of the 2D arrays specified in X,Y,Z. 
%
%  NRBLOFT(X,Y,Z,dir) allows the user to switch from row-wise interpolation
%  to columnwise (dir = 1 or 2, respectively).  NRBLOFT forces the degree 
%  of the specified direction (dir) to be 4th order (cubic).
%
%  NRBLOFT(...,mode) specifies an interpolation mode used in generating
%  a control point mesh for the surface.  The default for mode is 2, but
%  the user can also specify mode = 1.  This is not recommended, and often
%  causes computation time to increase exponentially.  However, it may be
%  useful to try this mode in certain instances.
%
%  NRBLOFT requires the NURBS toolbox found at:
%  http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId
%  =312&objectType=file
%  
%
%  %Example 1:
%  [X,Y,Z]=peaks(15);
%  nrb = nrbloft(X,Y,Z);
%  figure; nrbplot(nrb,[50,50]);
%
%  %Example 2:
%  pnts = [ 0.0  3.0  4.5  6.5 8.0 10.0; 0.0  0.0  0.0  0.0 0.0  0.0;... 
%             2.0  2.0  7.0  4.0 7.0  9.0];   
%  testcrv = nrbmak(pnts, [0 0 0 1/3 0.5 2/3 1 1 1]);
%  crv{1} = testcrv; crv{2} = testcrv;  crv{3} = testcrv;
%  crv{2}.coefs(2,:) = 5;  crv{3}.coefs(2,:) = 10;
%  crv{2}.coefs(3,:) = 2*crv{2}.coefs(3,:);
%  crv{3}.coefs(3,:) = -crv{3}.coefs(3,:)+10;
%  nrb = nrbloft(crv);
%  figure; hold on; for i=1:3, nrbplot(crv{i},50); end
%  axis equal; axis tight
%  view(135,45); pause(2);  nrbplot(nrb,[50,50]);
%
%  See Also:  NRBMAK

if nargin == 1,
    mode = 2;
end

if ~isstruct(X) && ~iscell(X)
    switch nargin
        case 3
            dir = 1;
            mode = 2;
        case 4
            mode = 2;
        case 5
        otherwise
            error('At least 3 inputs required for array inputs');
    end
    switch dir
        case 1
            for i=1:size(X,1)
                u(i) = nrbinterp(X(i,:),Y(i,:), Z(i,:),1);
            end
        case 2
            for i=1:size(X,2)
                u(i) = nrbinterp(X(:,i), Y(:,i), Z(:,i),1);
            end
        otherwise
            error('4th argument must either be 1 or 2')
    end
else
    u = X;
    if nargin == 2
        mode = Y;
    end
    if iscell(u)
       for i=1:length(u)
          uu(i) = u{i}; 
       end
       u = uu;
    end
end

if isstruct(u(1)) && isfield(u(1),'form')
    field = getfield(u(1),'form');
    if ~strcmp(field(1:2),'B-')
        error('Curves must be in B-NURBS form');
    end
else
    error('Each element of a single input must be a NURBS structure array');
end

nn = length(u);

% ensure all curves have a common degree in u-direction
u = commonDegree(u);
% merge the knot vectors, to obtain a common knot vector in u-direction
u = mergeKnots(u);

for i=1:nn
    coefs(:,:,i) = u(i).coefs;
end

% all u direction curves have the same knot vector so we only need one
uknots = u(1).knots;

% extract x,y,z coefficient data
x = squeeze(coefs(1,:,:));
y = squeeze(coefs(2,:,:));
z = squeeze(coefs(3,:,:));

% Interpolate through control points
for i=1:size(x,1)
    v(i) = nrbinterp(x(i,:),y(i,:),z(i,:),mode);
end
% ensure all curves have a common degree in v-direction
v = commonDegree(v);
% merge the knot vectors, to obtain a common knot vector in v-direction
v = mergeKnots(v);
% all v direction curves have the same knot vector so we only need one
vknots = v(1).knots;
% assemble new surface coefficient array from each curve 
for i=1:length(v)
    c(:,:,i) = v(i).coefs;
end

srf = nrbmak(c,{vknots uknots});
srf = nrbtransp(srf);


return





function crv = commonDegree(crv)
nn = length(crv);
% d = max(cell2vec({crv.order}));
for i=1:nn
    d(i) = crv(i).order;
end
d = max(d);
for i=1:nn,
    degree_raised = d - crv(i).order;
    if degree_raised < 0
       disp('NRBLOFT: Problem may have occured during degree elevation');
    end
    if degree_raised > 0
        crv(i) = nrbdegelev(crv(i), degree_raised);
    end
end


function crv = mergeKnots(crv)
nn = length(crv);
k = ({crv.knots});
ku = unique(cell2vec(k));
n = length(ku);
ka = cell(1,nn);
for i = 1:n
    for j=1:nn
        ii(j) = length(find(k{j} == ku(i)));
    end
    m = max(ii);
    for j=1:nn
        ka{j} = [ka{j} ku(i)*ones(1,m-ii(j))];
    end
end

% Do knot insertion where necessary in each curve
for i=1:nn
    crv(i) = nrbkntins(crv(i), ka{i});
end



function v = cell2vec(c)
n = numel(c);
v = [];
for i=1:n
    t = c{i};
    t = t(:);
    v = [v; t];
end


function nrb = nrbinterp(x,y,z,mode)

ctrlpts = [x(:)'; y(:)'; z(:)'];

switch mode
    case 1
        sp = cscvn(ctrlpts);
    case 2
        sp = nintrp1(ctrlpts);
    otherwise
        error('Invalid mode type');
end

% Convert piecewise polynomial to nurbs
nrb = pp2nrb(sp);


function sp = nintrp1(ctrlpts)
n = size(ctrlpts,2);
x = linspace(0,1,n);
sp = csapi(x,ctrlpts);


function nrb = pp2nrb(pp)
b = pp2sp(pp);
nrb = nrbmak(b.coefs,b.knots);
