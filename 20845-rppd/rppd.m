function [p] = rppd(varargin)
%RPPD creates a rectangular parallelepiped patch object.
% RPPD(sidelength,centerloc,facecolor,edgecolor,alpha) creates an RPPD
% with the following arguments:
% sidelength is a 1x3 vector of sidelengths.
% centerloc is a 1x3 vector giving the location of the center of the rppd.  
% facecolor is a 1x3 vector of RBG values for the faces.  
% edgecolor is a 1x3 vector of RGB values for the edges.
% alpha is the transparency value on [0 1].  0 is transparent, 1 opaque.
%
% All arguments are optional, and defaults will be provided.  The default
% is a 95% opaque, blue unit cube located at the origin.
% If requested, rppd returns the handle to the patch object.
%
% Examples:
%
%     To see the default settings, use:
%
%       rppd
%       view(3)
%
%     To create an opaque unit cube located at (x,y,z) = (2,1,-3) with red 
%     faces and black edges, use:
%
%       rppd([1 1 1],[2 1 -3],[1 0 0],[0 0 0],1)
%       axis([1 3 0 2 -4 -2])
%
%     To use all the defaults except the edgecolor and obtain the handle to 
%     the patch object, use:
%
%       ph = rppd([],[],[],[1 1 1])
%       view(3)
%
%     To see cubes as data markers for a 3d line, use:
%
%       t = linspace(0,2*pi,30);  x = cos(t);  y = sin(t);
%       plot3(x,y,t)
%       clmp = colormap(jet(30));
%       for ii = 1:30
%           rppd([.1 .1 .1],[x(ii) y(ii) t(ii)],clmp(ii,:),[],.6);
%       end
%       axis([-pi pi -pi pi 0 2*pi]);  view(3);  rotate3d
%
% See also patch, rectangle
%
% Author:  Matt Fig
% Contact:  popkenai@yahoo.com
% Created: 7/24/2008

vars = cell(1,5); % Initialize the input cell.

if ~isempty(varargin) % For ver 6.5, the 'deal' below errors without it.
    [vars{1:length(varargin)}] = deal(varargin{:}); % Get the input args.
end

idx = find(cellfun('isempty',vars));  % Find the empty args.
dflt = {[1 1 1], [0,0,0], [.2 .3 .5], [], .95}; % default values.
vars(idx) = dflt(idx);  % Put the defaults into the empty cells.
flg = false;  % See next if statement.

if length(varargin)<4 || isempty(varargin{4})
    vars{4} = vars{3}; % Edgecolor == facecolor if not input.
    flg = true; % Used below in the edgcolor deciding section.
end

lngth = cellfun('length',vars);  % Make sure args are correct.

if ~all(lngth(1:4) == 3) 
    error('Error using: RPPD.  The first 4 args must be length 3 vectors.')
elseif vars{5} < 0 || vars{5} > 1
    error('Error using: RPPD.  The alpha arg must be on [0 1].')
end

[sdln,cntr,clr,edgclr,alph] = deal(vars{:}); % For clarity below.

% Try to make the edges compliment the face color better than black.
if flg && alph >.3
    [mx,i1] = max(clr);  % Find the largest color value.
    [mn,i3] = min(clr);  % Find the smallest color value.
    if mx-mn < .05 % The color values are nearly the same.
        lt = clr <= .8;  % Find which color values are less than .8
        edgclr(lt) = clr(lt) + .2; % Add .2 to these color values.
        edgclr(~lt) = clr(~lt) - .2; % Subtract .2 from the others.
    else % Here the color values are substantially different.
         % Basically boost the highest two vals, lower or raise the third.
        i2 = setdiff([1 2 3], [i1,i3]); % The middle color value.
        edgclr(i1) = (edgclr(i1)+.2)*(edgclr(i1)<.8)+(edgclr(i1)>=.8); 
        edgclr(i2) = (edgclr(i2)+.2)*(edgclr(i2)<.8)+(edgclr(i2)>=.8);
        edgclr(i3) = .25 + (edgclr(i3)<.5)*.5;
    end
end

x = [cntr(1)+sdln(1)/2 cntr(1)-sdln(1)/2];   % The vertices (verts below).
y = [cntr(2)+sdln(2)/2 cntr(2)-sdln(2)/2];
z = [cntr(3)+sdln(3)/2 cntr(3)-sdln(3)/2];

verts = [x(2) y(2) z(2);  % 1  Label for drawing the faces below.
         x(2) y(1) z(2);  % 2
         x(2) y(1) z(1);  % 3
         x(2) y(2) z(1);  % 4
         x(1) y(2) z(2);  % 5
         x(1) y(2) z(1);  % 6
         x(1) y(1) z(2);  % 7
         x(1) y(1) z(1)]; % 8
        
faces = [1,2,3,4;   % These are the faces.
         1,4,6,5;
         5,6,8,7;
         2,1,5,7;
         7,2,3,8;
         8,6,4,3];

p = patch('vertices',verts,'faces',faces,'facecolor',clr,...
          'facealpha',alph,'edgecolor',edgclr);
      
if nargout == 0
    clear p; % User doesn't want the handle.
end