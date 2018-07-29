function xface=blockPlot(mask, offset, varargin)
%function xface=blockPlot(mask, offset, varargin)
%draw a 3D lego-like plot from a bitmask
%inputs:
%mask -     a 3D logical array or a 3D binary mask. The function will draw
%           boxes around all points (1's) in the mask which border empty 
%           space (0's).
%           Interior points which do not border any empty space will not be
%           drawn.
%           If no input is given, draws an example (wavy cone)
%offset -   3-component vector added to the coordinate of all patches drawn 
%           (default=[0 0 0])
%           Useful if the user wants to pass only part of the figure to be
%           drawn, but have the coordinates correct to match another plot
%varagin -  pair of plot style properties to pass to the patch command.
%           ex: (...,'color','r'), (...,'facealpha',.5),
%           (...,'edgecolor','none'), etc
%outputs:
%xface - returns patch object that was drawn
%
%examples:
%   p=blockPlot();
%   p=blockPlot(ones([10 10 10]));
%   p=blockPlot(ones([10 10 10]), [0 0 0], 'facecolor','r', 'facealpha',.5)
%
%  Tripp Jones, June 2011

%set offset to zero if none given
if nargin < 2
    offset=[0 0 0];
end

%draw wavy cone if no input is given
if nargin < 1
    s=101;
    mask=zeros([s 100 s]);
    k=0;
    z_r=[sqrt(9.5^2-(10.5-(1:20)).^2)/9.5*s/4 ((21:100)/100).^(1.2)*s/2.*(sin(linspace(0+k/100*8*pi(), 8*pi()+k/100*8*pi(), 80))/15+1).*linspace(.9,1.1, 80) ];
    xpos=cumsum(ones(s),1)-(s-1)/2-1;
    ypos=cumsum(ones(s),2)-(s-1)/2-1;
    rpos=sqrt(xpos.^2+ypos.^2);
    for k=1:100
        a=zeros(s);
        a(rpos<z_r(k))=1;
        mask(:,k,:)=reshape(a, [s 1 s]);
    end
end

%pad array with zeros to find 1's along border
mask=padarray(mask, [1 1 1]);

verts=[]; %will contain all vertices of the resulting figure

%trim mask to non-zero values
[xlims ylims zlims]=find_limits(mask, 1);
mask=mask(xlims,ylims,zlims);
mask_size=[numel(xlims) numel(ylims) numel(zlims)];

%set 3D offset used for plotting
xmin=min(ylims)+offset(1,2)-2.5;
ymin=min(xlims)+offset(1,1)-2.5;
zmin=min(zlims)+offset(1,3)-3.5;

%arrays to shift each component of the vertices
s1=[0;0;1;1];
s2=[0;1;1;0];
s3=[.5;.5;.5;.5];


%create convolution kernels
n1=zeros([1 1 3]);
n2=n1;
n3=n1;
n1(1,1,1)=-1;
n1(1,1,3)=1;
n2(1,1,1)=1;
n2(1,1,3)=-1;
n3(1,1,1)=-1;
n3(1,1,3)=-1;
n3(1,1,2)=1;

%find edges in +/- x/y/z direction
xmask1=convn(mask, [-1 0 1], 'same');
xmask2=convn(mask, [1 0 -1], 'same');
ymask1=convn(mask, [-1;0;1], 'same');
ymask2=convn(mask, [1;0;-1], 'same');
zmask1=convn(mask, n1,      'same');
zmask2=convn(mask, n2,      'same');

%find points with empty edges on both sides
xmask3=convn(mask, [-1 1 -1], 'same');
ymask3=convn(mask, [-1;1;-1], 'same');
zmask3=convn(mask, n3,      'same');


%find coordinates of -x edges
[p(:,1) p(:,2) p(:,3)]=ind2sub(mask_size,find((mask & xmask2==1) | xmask3==1));
b=size(p,1);
%repeat each point 4 times (to make 4 points for square face)
p=p(sort(repmat((1:b)', [4 1])),:);
%apply shifts to find corners of patch face
shifts=[s2+ymin -s3+xmin+.5 s1+zmin];
p=p+repmat(shifts,[b 1]);
verts=[verts;p];
clear p

%find coordinates of +x edges
[p(:,1) p(:,2) p(:,3)]=ind2sub(mask_size,find((mask & xmask1==1) | xmask3==1));
b=size(p,1);
p=p(sort(repmat((1:b)', [4 1])),:);
shifts=[s2+ymin s3+xmin+.5 s1+zmin];
p=p+repmat(shifts,[b 1]);
verts=[verts;p];
clear p

% -y
[p(:,1) p(:,2) p(:,3)]=ind2sub(mask_size,find((mask & ymask2==1)| ymask3==1));
b=size(p,1);
p=p(sort(repmat((1:b)', [4 1])),:);
shifts=[-s3+ymin+.5 s2+xmin s1+zmin];
p=p+repmat(shifts,[b 1]);
verts=[verts;p];
clear p

% +y
[p(:,1) p(:,2) p(:,3)]=ind2sub(mask_size,find((mask & ymask1==1) | ymask3==1));
b=size(p,1);
p=p(sort(repmat((1:b)', [4 1])),:);
shifts=[s3+ymin+.5 s2+xmin s1+zmin];
p=p+repmat(shifts,[b 1]);
verts=[verts;p];
clear p


%-z
[p(:,1) p(:,2) p(:,3)]=ind2sub(mask_size,find((mask & zmask2==1) | zmask3==1));
b=size(p,1);
p=p(sort(repmat((1:b)', [4 1])),:);
shifts=[s1+ymin s2+xmin -s3+zmin+.5];
p=p+repmat(shifts,[b 1]);
verts=[verts;p];
clear p


% +z
[p(:,1) p(:,2) p(:,3)]=ind2sub(mask_size,find((mask & zmask1==1) | zmask3==1));
b=size(p,1);
p=p(sort(repmat((1:b)', [4 1])),:);
shifts=[s1+ymin s2+xmin s3+zmin+.5];
p=p+repmat(shifts,[b 1]);
verts=[verts;p];
clear p



%draw the patch
xface=patch(verts(:,1),verts(:,2),verts(:,3),[.5 .5 .5],varargin{:});
%re-order the vertices into 4-corner polygons (squares)
set(xface,'faces',reshape(get(xface,'faces'),4,[])');
set(gca, 'cameraPosition',[-661.6507 -588.5909 -312.2231])


return

function [xlims ylims zlims]=find_limits(mask, padding)

xlims=find(squeeze(sum(sum(mask,2),3)));
ylims=find(squeeze(sum(sum(mask,1),3)));
zlims=find(squeeze(sum(sum(mask,2),1)));

xlims=(min(xlims)-padding):(max(xlims)+padding);
ylims=(min(ylims)-padding):(max(ylims)+padding);
zlims=(min(zlims)-padding):(max(zlims)+padding);

return

