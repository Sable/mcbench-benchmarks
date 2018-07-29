
function mask = voronoi2mask(x,y,szImg)
%
% voronoi2mask Convert Voronoi cells to region mask
%
%   mask = voronoi2mask(x,y,szImg) computes a mask of the Voronoi cells
%   given points,'x' and 'y' and a 2d-image size 'szImg', which
%   the points are extracted from. The voronoi diagram is created
%   using Matlab's voronoi function.
%  
%     Example
%     -------
%
%         % get image from steve's blog at mathworks.com
%         if ~exist('nuclei.png','file')
%            img = imread('http://blogs.mathworks.com/images/steve/60/nuclei.png');
%            imwrite(img,'nuclei.png');
%         else
%            img = imread('/nuclei.png');  
%         end
%         img = double(img);
% 
%         % crop image
%         img = img(1:300,1:350);
% 
%         % "blur" image with imopen
%         se = strel('disk', 15);
%         imgo = imopen(img, se);
% 
%         % find regional max
%         imgPros = imregionalmax(imgo,4);
% 
%         % get centroids of regional max
%         objects = regionprops(imgPros,{'Centroid', 'BoundingBox','Image'});
% 
%         % save centroids to array
%         centroids = nan([numel(objects),2]);
%         for i = 1:numel(objects)
%             centroids(i,:) = objects(i).Centroid;
%         end
% 
%         % based on the centroids, create the voronoi diagram
%         % and transform the Voronoi cells to an image.
%         mask = voronoi2mask(centroids(:,1),centroids(:,2),size(img));
%         mask = label2rgb(mask, 'jet', 'c', 'shuffle');
%
%         % show results
%         subplot(2,1,1)
%         imagesc(img);colormap('gray');
%         hold on;
%         h = voronoi(centroids(:,1),centroids(:,2));
%         set(h(:),'Color',[0 1 0]);
%         axis image;
%         title('original image with voronoi diagram');
% 
%         subplot(2,1,2)
%         imshow(mask);
%         hold on;
%         h = voronoi(centroids(:,1),centroids(:,2));
%         set(h(:),'Color',[0 0 0]);
%         axis image;
%         title('output image with voronoi diagram');
%  
%     See also poly2mask, roipoly.
%
%
% $Created: 1.0 $ $Date: 2013/08/11 20:00$ $Author: Pangyu Teng $
%

if nargin < 3
    display('requires 3 inputs. (voronoi2mask.m)');
    return;
end

% format x, y to be column wise
if size(x,1) < size(x,2)
    x = x';
end

if size(x,1) < size(x,2)
    y = y';
end

% create voronoi diagram and get its finite vertices
[vx, vy] = voronoi(x,y);

% create a mask to draw the vertices
border = logical(false(szImg));
mask = zeros(szImg);

% draw vertices on mask
for i = 1:size(vx,2)
    
    % create line function between 2 points
    f = makelinefun(vy(1,i),vx(1,i),vy(2,i),vx(2,i),2);
    
    % get distance between 2 points
    dist = round(1.5*sqrt(diff(vx(:,i)).^2+diff(vy(:,i)).^2));
    
    % create 'dist' points on the line
    [vxLine, vyLine] = f(dist);  
    
    % round the line
    vxLine = round(vxLine);
    vyLine = round(vyLine);
    
    % contrain line to be within the image
    validInd = vxLine >= 1 & vxLine <= szImg(1) & vyLine >= 1 & vyLine <= szImg(2);
    vxLine = vxLine(validInd);
    vyLine = vyLine(validInd);
    
    % draw the line to an image
    newInd = sub2ind(szImg,vxLine,vyLine);
    border(newInd) = true;
end

% round xs and yx
x = round(x);
y = round(y);

% number each region based on the index of the centroids
% (xs and ys are "flipped" ...)
for i = 1:numel(x)    
    
    bw = imfill(border,sub2ind(szImg,y(i),x(i)));
    mask(bw(:)==1) = i;        
end
