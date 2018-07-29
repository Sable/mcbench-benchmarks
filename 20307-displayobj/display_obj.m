function display_obj(obj,texture)
%
% function display_obj(obj,texture)
%
% displays an obj structure with texture
%
% INPUTS:  obj:     object data
%                   - obj.v:    vertices
%                   - obj.vt:   texture coordinates
%                   - obj.f.v:  face definition vertices
%                   - obj.f.vt: face definition texture
%
%       : texture -  texture image full path
%
% Author: Bernard Abayowa
% University of Dayton
% 6/16/08

texture = imread(texture);
texture_img = flipdim(texture,1);
[sy sx sz] = size(texture_img);
texture_img =  reshape(texture_img,sy*sx,sz);

% make image 3D if grayscale
if sz == 1
    texture_img = repmat(texture_img,1,3);
end

% select what texture correspond to each vertex according to face
% definition
[vertex_idx fv_idx] = unique(obj.f.v);
texture_idx = obj.f.vt(fv_idx);

x = abs(round(obj.vt(:,1)*(sx-1)))+1;
y = abs(round(obj.vt(:,2)*(sy-1)))+1;
xy = sub2ind([sy sx],y,x);
texture_pts = xy(texture_idx);
tval = double(texture_img(texture_pts,:))/255;



% display object
figure; patch('vertices',obj.v,'faces',obj.f.v,'FaceVertexCData', tval);
shading interp
colormap gray(256);
lighting phong;
camproj('perspective');
axis square; 
axis off;
axis equal
axis tight;
cameramenu