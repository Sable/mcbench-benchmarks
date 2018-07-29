function [fmat]=bbmplot(pt_conf, make_mov)
% BBMPLOT Make an animation of the dynamics of the particle
%   configuration in the branching Brownian motion in the plain. 
%
% [fmat] = bbmplot(pt_conf [, make_mov])
%
% Inputs:
%   pt_conf - cell array describing the system dynamics. The k-th
%     element is a N_k x 2 matrix with the coordinates of the
%     particles at a certain time point
%   make_mov - optional. If non-zero, make the movie in the MATLAB 
%     format. Default value 0.
%
% Outputs:
%   fmat - the MATLAB movie matrix if make_mov is non-zero
%

% Authors: R.Gaigalas, I.Kaj
% v1.6 Created 07-Nov-01
%      Modified 24-Nov-05 Changed variable names and comments
%      Modified 10-Jan-06 

 if (nargin==1)
   make_mov = 0;
 end

 nframes = size(pt_conf, 2)

 % find the extreme coordinates between all particles
 % if the last frame is empty, skip it
 nact = nframes-isempty(pt_conf{nframes});
 max_coor = pt_conf{1}(1, :);
 min_coor = pt_conf{1}(1, :);
 for i=1:nact
   max_coor = max([pt_conf{i}; max_coor]);
   min_coor = min([pt_conf{i}; min_coor]);   
 end
 
 clf;
 % set a double buffer to avoid flickering
 set(gcf,'DoubleBuffer','on');
 % plot the extremes white on white - to get axes right
 plot([min_coor(1) max_coor(1)], [min_coor(2) max_coor(2)], 'w.');
 
 % set some properties to the current axes
 set(gca, 'NextPlot', 'add', 'Drawmode','fast');

 % get the object with the shown points
 point_obj = get(gca, 'Children');
 % redraw only points, not the background - to avoid flickering
% set(point_obj, 'EraseMode', 'xor', ...
%                'Color', [0 0 1]); % draw in blue
 set(point_obj, 'EraseMode', 'normal', ...
                'Color', [0 0 1]); % draw in blue
 axis manual % keep the original axes

 if (make_mov) % make a MATLAB movie

   fmat = moviein(nframes);
   for i=1:nframes
     set(point_obj,'XData', pt_conf{i}(:, 1), 'YData', pt_conf{i}(:, 2));
     fmat(:, i)=getframe;
   end

   movie(fmat);
 
 else % depict the frames only

   fmat = [];
   for i=1:nframes
     set(point_obj,'XData', pt_conf{i}(:, 1), 'YData', pt_conf{i}(:, 2));
     pause2(0.1);
   end   
 end




