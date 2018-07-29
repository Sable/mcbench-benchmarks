function p = epip_quadrant(e,dim)

%% The algorithm divides the cartesian space into 9 parts
%   find which quadrant the epipole is in
%   e  -  epipole
%   dim = [width,height] - dimensions of the image
%
%   p(1),p(2) are image plane coordinates of pixels that define K

x = e(1);
y = e(2);
im_corners = [0 0 1;dim(1) 0 1;0 dim(2) 1; dim(1) dim(2) 1]';

%%
if x<=0 && y<=0
%     q = 1
    ii_c = [2 3];
end

if x>=0 && x<=dim(1) && y<=0
%     q = 2
    ii_c = [1 2];
end

if x>=dim(1) && y <= 0
%     q = 3
    ii_c = [1 4];
end

%%
if x<=0 && y>=0 && y<=dim(2)
%     q = 4
    ii_c = [1 3];
end

if x>=0 && x<=dim(1) && y>=0 && y<=dim(2)
    % epipole is in the image
    %     q = 5
    ii_c = [];
end

if x>=dim(1) && y>=0 && y<=dim(2)
%     q = 6
    ii_c = [2 4];
end

if x<=0 && y>=0 && y>=dim(2)
%     q = 7
    ii_c = [1 4];
end

if x>=0 && x<=dim(1) && y>=0 && y>=dim(2)
%     q = 8
    ii_c = [3 4];
end

if x>=dim(1) && y>=0 && y>=dim(2)
%     q = 9
    ii_c = [2 3];
end

p(:,1) = im_corners(:,ii_c(1));
p(:,2) = im_corners(:,ii_c(2));
