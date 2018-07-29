function [slice, sliceInd, subX, subY, subZ] = extractSlice(volume,centerX,centerY,centerZ,normX,normY,normZ,radius)

%%extractSlice extracts an arbitray slice from a volume.
% [slice, sliceInd, subX, subY, subZ] = extractSlice extracts an arbitrary 
% slice given the center and normal of the slice.  The function outputs the 
% intensities, indices and the subscripts of the slice base on the input volume.
% If you are familiar with IDL, this is the equivalent function to EXTRACT_SLICE.
%
% Note that output array 'sliceInd' contains integers and NaNs if the particular
% locations are outside the volume, while output arrays 'subX, subY, subZ' 
% contain floating points and does not contain NaNs when locations are
% outside the volume.
%
% Example:
% %Extracts slices from a mri volume by varying the slice orientation from
% sagittal to transverse while shifting the center of the slice from left to right.
% %(pardon me for demonstrating with an image without orientation labels and out-of-scale pixels.)
%
% load mri;
% D = squeeze(D);
% for i = 0:30;
% pt = [64 i*2 14];
% vec = [0 30-i i];
% [slice, sliceInd,subX,subY,subZ] = extractSlice(D,pt(1),pt(2),pt(3),vec(1),vec(2),vec(3),64);
% surf(subX,subY,subZ,slice,'FaceColor','texturemap','EdgeColor','none');
% axis([1 130 1 130 1 40]);
% drawnow;end;
%
%
% $Revision: 1.0 $ $Date: 2011/07/02 18:00$ $Author: Pangyu Teng $
% $Updated $ $Date: 2011/08/012 07:00$ $Author: Pangyu Teng $


if nargin < 7
   display('requires at least 7 parameters');
   return;
end

if nargin < 8,
    % sets the size for output slice radius*2+1.
    radius = 50;
end

isDebug = 0;
if isDebug,   
    clear all;close all;
    isDebug = 1;
    load mri; D = squeeze(D);
    volume = D;
    pt = [63 63 24];
    vec = [0 0 1];
    radius = 30;
end

pt = [centerX,centerY,centerZ];
vec = [normX,normY,normZ];

%initialize needed parameters
%size of volume.
volSz=size(volume); 
%a very small value.
epsilon = 1e-12; 

%assume the slice is initially at [0,0,0] with a vector [0,0,1] and a silceSize.
hsp = surf(linspace(-radius,radius,2*radius+1),linspace(-radius,radius,2*radius+1),zeros(2*radius+1));
hspInitialVector = [0,0,1];

%normalize vectors;
hspVec = hspInitialVector/norm(hspInitialVector);
hspVec(hspVec ==0) = epsilon;
vec = vec/norm(vec);
vec(vec == 0)=epsilon;

%this does not rotate the surface, but initializes the subscript z in hsp.
rotate(hsp,[0,0,1],0);

if isDebug,
    %get the coordinates
    xdO = get(hsp,'XData');
    ydO = get(hsp,'YData');
    zdO = get(hsp,'ZData');
end

%find how much rotation is needed, below are the references.
%http://www.siggraph.org/education/materials/HyperGraph/modeling/mod_tran/3drota.htm
%http://www.mathworks.com/help/toolbox/sl3d/vrrotvec.html
hspVecXvec = cross(hspVec, vec)/norm(cross(hspVec, vec));
acosineVal = acos(dot(hspVec, vec));

%help prevents errors (i.e. if vec is same as hspVec),
hspVecXvec(isnan(hspVecXvec)) = epsilon;
acosineVal(isnan(acosineVal)) = epsilon;

%rotate to the requested orientation
rotate(hsp,hspVecXvec(:)',180*acosineVal/pi);

%get the coordinates
xd = get(hsp,'XData');
yd = get(hsp,'YData');
zd = get(hsp,'ZData');

%translate;
subX = xd + pt(1);
subY = yd + pt(2);
subZ = zd + pt(3);

%round the subscripts to obtain its corresponding values and indices in the volume.
xd = round(subX);
yd = round(subY);
zd = round(subZ);

%delete the surf
delete(hsp);

%obtain the requested slice intensitis and indices from the input volume.
xdSz=size(xd);
sliceInd=ones(xdSz)*NaN;
slice=ones(xdSz)*NaN;
for i = 1:xdSz(1)
    for j = 1:xdSz(2)
        if xd(i,j) > 0 && xd(i,j)<= volSz(1) &&...
             yd(i,j) > 0 && yd(i,j)<= volSz(2) &&...
             zd(i,j) > 0 && zd(i,j)<= volSz(3),
         sliceInd(i,j) = sub2ind(volSz,xd(i,j),yd(i,j),zd(i,j));
         slice(i,j) = volume(xd(i,j),yd(i,j),zd(i,j));
        end
    end    
end

if isDebug,
    plot3(xdO,ydO,zdO,'b+'); hold on;
    plot3(xd,yd,zd,'m.');
    figure(2);
    imagesc(slice);axis tight;axis equal;
end