% GIF_ADD_FRAME: adds a current figure snapshot to a gif animation
%
% SYNTAX
%   gif_add_frame(h,filename,fps,...)
% 
% INPUT:
%   - h:        handle to the axis that you want to take the snapshot from (use gca)
%   - filename: filename of gif to create or append frames to
%   - fps:      the number of frame per seconds the gif is gonna be displayed at (OPTIONAL)
%   - ...:      any other GIF arguement you might require to have
%               (NOT ONE OF: 'delaytime', 'loopcount' or 'writemode')
% 
% OUTPUT:
% If a file with name 'filename' exist, a frame from the axis 'h' is taken 
% and added to the movie, otherwise, a new gif-movie is created.
% 
% EXAMPLE:
% The following script creates some 3D surface data and rotates view 
% recording every rotation in a GIF frame in the file. The file can 
% be opened with any web-browser for inspection.
%  
% >> clc, clear, close all;
% >> % create data
% >> k = 5;
% >> n = 2^k-1;
% >> [x,y,z] = sphere(n);
% >> c = hadamard(2^k);
% >> h=surf(x,y,z,c);
% >> colormap([1  1  0; 0  1  1])
% >> axis equal
% >> % change view angle and record
% >> for i=1:50
% >>    rotate(h,[0 0 1],1);
% >>    gif_add_frame(gca,'video.gif');
% >> end
%
% See also:
% IMWRITE
%

% Copyright (c) 2008 Andrea Tagliasacchi
% All Rights Reserved
% email: ata2@cs.sfu.ca 
% $Revision: 1.0$  Created on: 2008/09/11
function gif_add_frame(h,filename,fps,varargin)

% default argument - fps
if ~exist('fps','var') || isempty(fps)
    fps = 25;
end

% retrieve the frame
A = getframe(h);
% convert it in a colormap
[IND, map] = rgb2ind(A.cdata(:,:,:),256);

% crete if needed or just append if exist already
if ~exist(filename,'file')
    imwrite(IND,map,filename,'gif','WriteMode','overwrite','delaytime',1/fps,'LoopCount',inf, varargin{:});
else
    imwrite(IND,map,filename,'gif','WriteMode','append','delaytime',1/fps,varargin{:});    
end
