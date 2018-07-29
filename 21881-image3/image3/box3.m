function h = box3(vol, I2X, bbox)
% Cut out a box from volumetric data and display it using texture mapping.
% h = box3(vol, I2X, bbox)
%
% vol, is a volume that is either N x M x K if it consists of scalar values
% or N x M x K x 3 if it is in RGB. The behaviour of the color handling is 
% is similar to image3 and slice3.
% vol is the volume
% I2X is a transformation matrix, see slice3 for an explanation.
% bbox is a vector [i1 i2 j1 j2 k1 k2], where i1 is the lowest index of the
% box in the first dimension and i2 is the highest index of the box in the
% first data dimension, j1 is the lowest in the second data dimension and
% so on.
%
% SEE ALSO: slice3, image3

vol = vol(bbox(1):bbox(2),bbox(3):bbox(4),bbox(5):bbox(6),:);

I2Xp = I2X; I2Xp(:,4) = I2Xp(:,4) + I2X*[bbox(1)-0.5 bbox(3) bbox(5) 1]';
h1 = slice3(vol,I2Xp,1,1);
I2Xp = I2X; I2Xp(:,4) = I2Xp(:,4) + I2X*[bbox(1) bbox(3)-0.5 bbox(5) 1]';
h2 = slice3(vol,I2Xp,2,1);
I2Xp = I2X; I2Xp(:,4) = I2Xp(:,4) + I2X*[bbox(1) bbox(3) bbox(5)-0.5 1]';
h3 = slice3(vol,I2Xp,3,1);
I2Xp = I2X; I2Xp(:,4) = I2Xp(:,4) + I2X*[bbox(1)+0.5 bbox(3) bbox(5) 1]';
he1 = slice3(vol,I2Xp,1,size(vol,1));
I2Xp = I2X; I2Xp(:,4) = I2Xp(:,4) + I2X*[bbox(1) bbox(3)+0.5 bbox(5) 1]';
he2 = slice3(vol,I2Xp,2,size(vol,2));
I2Xp = I2X; I2Xp(:,4) = I2Xp(:,4) + I2X*[bbox(1) bbox(3) bbox(5)+0.5 1]';
he3 = slice3(vol,I2Xp,3,size(vol,3));

h = [h1,h2,h3,he1,he2,he3];
