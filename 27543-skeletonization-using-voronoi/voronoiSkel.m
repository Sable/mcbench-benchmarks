function [skel v e]=voronoiSkel(BW,varargin)

% voronoiSkel   Skeletonization using Voronoi tesselation.
%   
%   skel = voronoiSkel(BW) returns the skeleton of the logical matrix BW. If
%   BW is not logical, the function returns the skeleton of BW~=0. 
%   
%   voronoiSkel(BW,options) allows the user to set non default options.
%   Details are given below.
%   
%   [v e] = voronoiSkel(...) or,
%   [skel v e] = voronoiSkel(...) returns the edges and vertices of the
%   skeleton. v is a (n x 2) matrix whose rows are the coordinates of the
%   vertices. e is a (m x 2) matrix where each row defines an edge. In each
%   row, there are two row indices (in v) of the edge's endpoints.
%   These vertices may have, and usually do have, sub-pixel resolution, and
%   are not uniformly distributed.
%   
%   voronoiSkel uses only the pixels on the boundary of the objects, and
%   therefore is very efficient for thick objects (effiicency scales with
%   the object's radius, rather than its area). However, it might be 
%   sensitive to small defects, if they are on the boundaries (or small 
%   holes inside the object). It gives bad results for thin objects.
%   If you get funny results, consider smoothing the boundary before 
%   skeletonizng by dilating or removing spur pixels (e.g :
%   bwmorph(BW,'spur') ).
%
%   If the skeleton obtained misses some parts that you think should be
%   included, try setting a lower trim value (see below). It there are too
%   many edges in the skeleton, set a higher trim value (default is pi).
%
%   The function uses qhull (www.qhull.org, and therefore qhull must be
%   executable from the commandline in the current directory.
%
%   example of use:
%   BW = imread('circles.png');
%   %simple:
%   skel = voronoiSkel(BW);
%   % setting trim and fast:
%   [skel v e] = voronoiSkel(BW,'trim',2,'fast',1.23);
%   % boundary input:
%   b = bwboundaries(BW); b = b{1};
%   [v e] = voronoiSkel(b,'boundary','trim',2,'fast',1.23);
%
%   options: 
%
%   'trim'      Sets the threshold for trimming edges (see Algorithm
%               below for details).
%
%   'boundary'  Means that the input is not a BW matrix, but a list of
%               pixel coordinates on the object's boundary. These pixels are
%               the vertices of a polygon, whose interior is the object. The
%               matrix should be a (n x 2) or a (2 x n) matrix. 
%
%   'fast'      Accelerates the calculation by using only a fraction of the
%               object's boundary. fast=2 uses every second point, fast=3
%               uses every third point, and so on. This has, of course, an 
%               effect on the results. fast does not have to be an integer.
%
%   Algorithm:
%   The skeleton of an object is a subgraph of the Voronoi tesselation of
%   the pixels on its boundary. This is because each edge in the Voronoi
%   diagram is equidistant two points (which are called "generators") on 
%   the boundary. 
%
%   If the distance along the boundary between the two generators is much
%   bigger than the actual distance, the edge is kept as a part of the 
%   skeleton. Otherwise, it is deleted. That is, if
%       contourDistance < realDistance * trim
%   the edge is deleted, where trim can be set by the user. The default 
%   value is pi, which corresponds to a circular bump of the boundary. 
%   Low values of trim (around 2 and less) might give funny results.
%
%   Author: Yohai Bar Sinai, yohai.barsinai at mail.huji.ac.il 
%   May 09, 2010


iptcheckinput(BW,{'numeric' 'logical'},{'real' 'nonsparse' '2d'}, ...
              mfilename, 'BW', 1);
trim=0;
factor=-1;
boundary=false;

for i=1:length(varargin)
    switch lower(varargin{i})
        case 'trim'
            trim=varargin{i+1};
        case 'fast'
            factor=varargin{i+1};
        case 'boundary'
            boundary=true;
            if nargout~=2
                error(['If boundary is specified, the function cannot generate'...
                        char(10) 'the BW inage of the skeleton.' char(10)...
                        'Use [v e]=voronoiSkel(...) instead'])
            end
            if size(BW,2)~=2 
                if size(BW,1)~=2
                    error('If you use the ''boundary'' option, the imput must be a 2 x n or n x 2 matrix')
                else
                    BW=BW';
                end
            end
    end
end

if trim<1;  trim=pi;  end
if factor<0; factor=1; end;
if ~islogical(BW) && ~boundary
    BW = (BW ~= 0);
end

   

%construct voronoi
if ~boundary
    b=bwboundaries(BW);
else
    b={BW};
end
if factor>1
    for i=1:length(b)
        inds=round(1:factor:size(b{i},1));
        b{i}=b{i}(inds,:);
    end
end

i=1;
inds=[];
while i<=length(b)
    if size(b{i},1)<4
        b(i)=[];
        continue;
    end
    inds(i)=length(b{i}); %#ok<AGROW>
    i=i+1;
end
inds=[0 cumsum(inds)];
p=cell2mat(b);
[v e]=costumVoronoi(p);

%clear bad vertices (bv) which are outside of the object.
if ~boundary
    rv=round(v);
    M=max(p);
    m=min(p);
    bv=v(:,1)<m(1)|v(:,1)>M(1)|v(:,2)>M(2)|v(:,2)<m(2);
    bv2=find(~bv);
    tmp=sub2ind(size(BW),rv(bv2,1),rv(bv2,2));
    bv2(BW(tmp))=[];
    bv=[find(bv); bv2];
else
    bv=find(~inpolygon(v(:,1),v(:,2),p(:,1),p(:,2)));
end
be=ismember(e(:,3),bv)|ismember(e(:,4),bv);
e=e(~be,:);
clear bv2 m M rv tmp;

% build distance table
D=cell(size(b));
for i=1:length(D);
    tmp=diff(b{i});
    tmp=sqrt(sum(tmp'.^2)');
    D{i}=[0 ;cumsum(tmp)];
end

% trim
be=false(size(e,1),1);
for i=1:size(e,1)
    i1=find(inds>=e(i,1),1,'first')-1;
    i2=find(inds>=e(i,2),1,'first')-1;
    if i1~=i2; continue; end;
    
    offset=inds(i1);
    contourDistance=abs(D{i1}(e(i,1)-offset)-D{i1}(e(i,2)-offset));
    contourDistance=min(contourDistance,D{i1}(end)-contourDistance);
    realDistance=norm(p(e(i,1),:)-p(e(i,2),:));
    if (contourDistance<realDistance*trim)
        be(i)=1;
    end
end
% keep only good edges
e=e(~be,3:4);

outputVertices=(nargout>1);
outputSkel=(nargout~=2);

if (outputSkel) 
    skel=false(size(BW));
    for i=1:size(e);
        v1=v(e(i,1),:);
        v2=v(e(i,2),:);
        t=linspace(0,1,max(ceil(1.3*norm(v2-v1)),4));
        x=v1(:,1).*t+(1-t).*v2(:,1);
        y=v1(:,2).*t+(1-t).*v2(:,2);
        inds=unique(round([x' y']),'rows');
        skel(sub2ind(size(skel),inds(:,1),inds(:,2)))=1;
    end
end

if outputVertices
    tmp=1:length(v);
    tmp=~ismember(tmp,e(:,1:2));
    inds=cumsum(tmp);
    e(:,1)=e(:,1)-inds(e(:,1))';
    e(:,2)=e(:,2)-inds(e(:,2))';
    v=v(~tmp,:);
end

if nargout==2
    skel=v;
    v=e;
end
end

function [v e]=costumVoronoi(V)
% Calculates the voronoi diagram of the vertices in V.
% v should be a n x 2 real matrix.
% qhull (www.qhull.org) MUST be executable from the current directory.
%
% Output: v is the matrix of the Voronoi vertices.
%         e is the matrix of the Voronoi edges. 
%            each row of e represents an edge in the following way: 
%            e(k,[1 2]) are the row indices (in V) of the points which
%            generated the k-th edge. 
%            e(k,[3 4]) are the row indices (in v) of the endpoints of the
%            k-th edge.
%         

% write to temp file
namein=tempname;
fid=fopen(namein,'w');
fprintf(fid,'%d\n%d\n',2,size(V,1));
fprintf(fid,'%d %d\n',V');
fclose(fid);
[a s]=dos(['qhull v p Fv TI ' namein]);
if (a~=0)
    delete(namein);
    error(['qhull returned an error:' char(10) s]);
end
[junk s]=strtok(s);

[Nv s]=strtok(s);
Nv=str2double(Nv);
[v pos]=textscan(s,'%f %f',Nv);
v=cell2mat(v);
s=s(pos:end);
[Ne s]=strtok(s);
e=double(cell2mat(textscan(s,'%d %d %d %d %d',Ne)));
e=e(:,2:5);
e(:,1:2)=e(:,1:2)+1;
e(e(:,3)==0,:)=[];
e(e(:,4)==0,:)=[];
%clean up
delete(namein);
end
