function varargout = drawMesh(vertex, face, varargin)
% Plot polygonal 2D or 3D mesh.
%
% Usage:    drawMesh(vertex, face)
%           drawMesh(vertex, face, 'wire')
%           hMesh = drawMesh(vertex, face, color, 'surf', alpha)
%
% INPUT:
% vertex        - nv-by-2 matrix of [x y] or 
%                 nv-by-3 matrix of [x y z] vertex coordinates
% face          - nf-by-? faces matrix
% (optional)
% 'wire' or      
% 'surf'        - plot wire mesh or surface (default) mesh;
% color         - string, defining the face color (only in 'surf' mode);
%                 default: 'g' (green color);
% alpha         - a scalar between 0 and 1, defining transparency:
%                 0 - transparent, 1 - opaque (default).
%
% OUTPUT:
% (optional)
% hMesh         - handle to the patch object.
%
% Examples:
% 3D:
%  load('queen.mat'); figure(1); clf; drawMesh(vertex, face);
%  load('queen.mat'); figure(1); clf; drawMesh(vertex, face, 'wire');
%  load('queen.mat'); figure(1); clf; drawMesh(vertex, face, 'r', .5);
% 2D:
%  load('home.mat');  figure(1); clf; drawMesh(vertex, face, 'wire');
%
% See also: drawVector, drawPlane, drawSpan, drawLine.

% Copyright (c) 2009, Dr. Vladimir Bondarenko <http://sites.google.com/site/bondsite>

% Check input:
error(nargchk(2,4,nargin));
[mv,nv] = size(vertex);
[mf,nf] = size(face);
if (nv~=3)&&(nv~=2) , error('Wrong dimensions of the vertex matrix.'); end;

% Defaults:
alfa     = 1;
meshType = 'surf';
fcolor = 'g';

% Parse input:
if nargin > 2
    for ii=1:nargin-2
        if ischar(varargin{ii})
           if strcmpi(varargin{ii}, 'surf')||strcmpi(varargin{ii}, 'wire')
               meshType = varargin{ii}; 
           else
                 fcolor = varargin{ii}; 
           end;
        elseif isnumeric(varargin{ii}) 
            alfa = varargin{ii}; 
        end
    end
end
if (alfa > 1)||(alfa < 0), error('The alpha parameter must be in [0, 1].');end;
            
% Plot the mesh
switch meshType
    case 'surf'
        hMesh = patch('vertices', vertex,'faces', face,...
                      'facecolor', fcolor, 'FaceAlpha', alfa);
        camlight('headlight');
    case 'wire'
        hMesh = patch('vertices', vertex,'faces', face,...
                      'facecolor', 'none');
end
%axis equal tight off
if nargout==1, varargout{1} = hMesh; end