function outline = snowflake(n, width, height)
% SNOWFLAKE Generate outline of Koch snowflake.
%
% SNOWFLAKE iteratively generates the outline of a Koch snowflake using
% a Lindenmayer system. 
% 
%   OUTLINE = SNOWFLAKE(N, WIDTH, HEIGHT)
%
% N: Generate the Nth iteration. Higher numbers generate a smoother 
%    outline, but complexity increases quickly: the 4th iteration
%    returns 768 vectors and the 6th 12,288.
%
% WIDTH, HEIGHT: Scale the (unit) vectors to fit within a bounding box
%    of the given dimensions.
%
% OUTLINE: A structure with two fields: vectors and bbox.
%
% VECTORS: A list of 2D turtle-graphics vectors that define the outline of 
%    the snowflake. You can draw the snowflake by putting your pen down at
%    0,0 and moving it along the path defined by the vectors. The entries 
%    in VECTORS are NOT X,Y coordinates of points along the outline. Each 
%    entry in VECTORS specifies how far and in what direction to move your
%    pen at each step. 
%
% BBOX: The actual extent of the snowflake. Guaranteed to be smaller than
%    WIDTH x HEIGHT.
%
% All vectors and coordinates returned as integers.
%
% Example:
%
%    outline = snowflake(6,300,300);
%
% Return a vector list and bounding box for the 6th iteration of the
% Koch snowflake, scaled to fit inside a 300 x 300 rectangle.

  % Use a Lindenmayer system to generate the Nth generation of the
  % outline. This returns a long string of F's, plusses and minuses.
  % http://en.wikipedia.org/wiki/L-system
  snowflake = lsystem('F++F++F', containers.Map('F', 'F-F++F-F'), n);
  
  % Generate a list of vectors and a bounding box from the L-system
  % string representation of the fractal.
  [vectors, bbox] = turtle(pi/3, snowflake); % 60 degrees = pi/3
 
  % Determine the X and Y scale factors that will fit the snowflake into
  % the view rectangle.
  xscale = double(width) / bbox(3);
  yscale = double(height) / bbox(4); 
  scale = min(xscale, yscale);

  % Scale snowflake to fit into view rectangle.
  vectors = int32(round(vectors * scale));
  
  % Must recompute bounding box because of roundoff error
  bbox = computeBoundingBox(vectors);
  
  % Pesky roundoff error may produce a snowflake too large for the
  % given window. If so, shrink the snowflake by 5% 'til it fits. 
  shrinkFactor = 0.95;
  while (bbox(3) > width || bbox(4) > height)
      vectors = int32(round(vectors * shrinkFactor));
      bbox = computeBoundingBox(vectors);
      shrinkFactor = shrinkFactor - 0.05;
  end
  outline.vectors = vectors;
  outline.bbox = bbox;
end

function [vectors, bbox] = turtle(angle, path)
% TURTLE Generate a turtle-graphics vector path from a Lindenmayer string.
%
% This very simple turtle-graphics interpreter creates a vector-graphics
% drawing path from a program consisting of three instructions: move
% forwards (F); turn right (-); turn left (+). 
%
% ANGLE: The number of radians to turn (both left and right turns span
%    the same angle).
%
% PATH: A string defining the position-relative path the turtle should 
%    follow.
%
% For example, the PATH 'F--F--F' generates a triangle with ANGLE pi/3 (or
% 60 degrees):
%
%   1. Draw forward one unit.
%   2. Turn right 120 degrees.
%   3. Draw forward one unit.
%   4. Turn right 120 degrees.
%   5. Draw forward one unit.
%
% VECTORS: A series of unit vectors recording the moves made by the turtle.
%
% BBOX: A rectangle tightly enclosing the path. A 4-element vector
%     consisting of the X and Y coordinates of the lower left corner and
%     the width and height of the rectangle: [X, Y, WIDTH, HEIGHT].
%
% http://en.wikipedia.org/wiki/Turtle_graphics

    vectors = zeros(sum(path=='F'), 2);
    bbox = zeros(1,4);
    point = [0 0];
    k = 1;
    direction = 0;
    for action = path
        switch action
            case 'F'
                vectors(k,:) = [cos(direction), sin(direction)];
                point = point + vectors(k,:);
                k = k + 1;
                bbox = trackBoundingBox(bbox, point);
            case '-'
                direction = direction - angle;
            case '+'
                direction = direction + angle;
        end
        
        if (direction > (2*pi))
            direction = direction -(2*pi);
        elseif (direction < 0) 
            direction = direction + (2*pi);
        end
    end
    
    % Convert bounding box to (x, y, width, height)
    bbox(3) = bbox(3) - bbox(1);
    bbox(4) = bbox(4) - bbox(2);
end

function bbox = computeBoundingBox(vectors)
% COMPUTEBOUNDINGBOX Compute a tight-fitting bounding box.
%
% Fit a bounding box tightly around a list of vectors that define a
% path (curve?) through 2-D space. 
%
% Return the X and Y coordinates of the lower left corner and the width
% and height of the bounding box: [X, Y, WIDTH, HEIGHT].

    point = zeros(1,2,class(vectors));
    bbox = zeros(1,4,class(vectors));
    len = size(vectors,1);
    for k=1:len
        point = point + vectors(k,:);
        bbox = trackBoundingBox(bbox, point);
    end
    % Convert bbox to x,y,width,height
    bbox(3) = bbox(3) - bbox(1);
    bbox(4) = bbox(4) - bbox(2);
end

function bbox = trackBoundingBox(bbox, point)
% TRACKBOUNDINGBOX Expand the bounding box to include the given point
%
% [lower left X, lower left Y, upper right X, upper right Y]

  if point(1) < bbox(1), bbox(1) = point(1); end
  if point(2) < bbox(2), bbox(2) = point(2); end
  
  if point(1) > bbox(3), bbox(3) = point(1); end
  if point(2) > bbox(4), bbox(4) = point(2); end
end

function sentence = lsystem(axiom, rules, n)
% LSYSTEM Generate the Nth iteration of a context-free Lindenmayer system.
%
% AXIOM: Starting state.
%
% RULES: Hash table mapping individual symbols to their replacement 
%    strings.
%
% N: Iteration number. Apply the rules this many times. 
%
% http://en.wikipedia.org/wiki/L-system

  sentence = axiom;

  for k=1:n
      rkeys = cell2mat(keys(rules));
      for r = rkeys
          sentence = strrep(sentence,r,rules(r));
      end
  end
end
