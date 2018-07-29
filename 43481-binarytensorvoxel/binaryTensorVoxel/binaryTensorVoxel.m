function ah = binaryTensorVoxel(t,varargin)
% binaryTensorVoxel. Create a voxel image out of the binary tensor 't'. 
%
% A binary tensor is also referred to as a 3D matrix of zeros and nonzeros.
% Each voxel is a cube of side length varargin{1}.
%
%
% NECESSARY INPUT.
% t : binary tensor, in other words, a 3D matrix of zeros and non-zeros.
%
%
% OPTIONAL INPUT.
% varargin{1} : length of the side of each voxel in the range [0, 1]. The
%               default value is 1.
%
% varargin{2} : a colormap to shade each voxel. The default value is bone.
%
%
% EXAMPLES OF USE.
% Example 1.
% t = round(rand(3,3,3));
% binaryTensorVoxel(t);
%
% Example 2.
% t = round(rand(3,3,3));
% binaryTensorVoxel(t,0.5);
%
% Example 3.
% t = round(rand(3,3,3));
% binaryTensorVoxel(t,0.5,pink);
%

% Copyright 2013 The MathWorks, Inc.


ah = gca;
set(ah,...
  'xLim',[-1, size(t,2)],...
  'yLim',[-size(t,1), 1],...
  'zLim',[-size(t,3), 1]);
axis vis3d;
view(3);
for n = 1:numel(t)
  [i,j,k] = ind2sub(size(t),n);
  if (t(n))
    cuboid([i-1,1-j,1-k],varargin{:});
  end
end
end

function c = cuboid(p,varargin)
% cuboid. Draw a cube. 
%
% Draw a cube centered about p = [x,y,z].
%
% NECESSARY INPUT.
% p : 3 vector of Cartesian coordinates [x y z].
%
% OPTIONAL INPUT.
% varargin{1} : length of the side of each voxel in the range [0, 1]. The
%               default value is 1.
%
% varargin{2} : a colormap to shade each voxel. The default value is bone.
%
% EXAMPLES OF USE.
% Example 1.
% cuboid([0 0 0]);
%
% Example 2.
% cuboid([0 0 0], 0.5);
%
% Example 3.
% cuboid([0 0 0], 0.5, pink);
%

% Copyright 2013 The MathWorks, Inc.


% Set color shading of the cube
if     nargin == 1
  a    = 1;
  cMap = bone;
elseif nargin == 2
  a    = varargin{1};
  cMap = bone;
else
  a    = varargin{1};
  cMap = varargin{2};
end
colormap(cMap);
set(gca,'cLim',[0 3]);
cdata = [1 2 3 2 0 1 2 1]';

% Create reference cube
%   6--------7
%  /|       /|
% 4--------3 |
% | |      | | 
% | 5--------8
% |/       |/
% 1--------2
fv.faces = [...
  1 2 3 4; % front
  5 6 7 8; % back
  4 3 7 6; % top
  1 5 8 2; % bottom
  1 4 6 5; % left
  2 8 7 3];% right
fv.vertices = [...
  1 0 0;
  1 1 0;
  1 1 1;
  1 0 1;
  0 0 0;
  0 0 1;
  0 1 1;
  0 1 0];
% Scale and translate reference cube.
fv.vertices = bsxfun(@plus,a.*fv.vertices, p - 0.5.*[1 1 1]);

% Create the cube out of a patch object
c = patch(fv,...
  'faceColor'       ,'interp' ,...
  'faceVertexCData' ,cdata    ,...
  'edgeColor'       ,'k'      ,...
  'lineWidth'       ,1        ,...
  'cDataMapping'    ,'scaled' ,...
  'tag'             ,'cuboid');

end