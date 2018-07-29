function snakedemo2
% SNAKEDEMO - Example on how to build a Snake Toy, and twist
%             it into predefined shapes.
%

% Copyright (C) 2005-2011 The MathWorks Inc.

%%
  function b = oneblock(dark, parent)
  % Create one snake block.
  % DARK is boolean, true if this is a dark block.
  % PARENT is the object that is the parent of the new block.
  
    % The transform object is going to be our BLOCK representation.
    % The patches in the transform are the visible aspect of that block.
    b = hgtransform('parent',parent);
    
    % Create the patches.  Coordinate map.
    %
    %     SIDE         TOP/BACK
    %
    %  -1     1      -1     1
    % -1X-----X      X------X -1
    %   |    /       |      |
    %   |   /        |      |
    %   |  /         |      |
    %   | /          |      |
    %   |/           |      |
    % 1 X            X------X 1
    %
    %                  B (1 -1 -1)
    %               __+  
    %(-1 -1 -1) __--   --__     
    %  A    __--           --__
    %     +-                 __+  F  (1 -1 1)
    %     |--__          __-- / 
    %     |    --__  __--    /  
    %     |        +-       /   
    %     |        |  E    / 
    %     |        |      /  (-1 -1 1)
    %     |        |     /
    %     |        |    /
    %     |        |   /
    %     +        |  /
    %   C  --__    | /
    %          --__|/
    %(-1 1 -1)     +
    %                D  (-1 1 1)
    
    v = [ -1 -1 -1 ;
          1 -1 -1 ;
          -1 1 -1 ;
          -1 1 1 ;
          -1 -1 1 ;
          1 -1 1 ;
        ];
    
    A = 1;
    B = 2;
    C = 3;
    D = 4;
    E = 5;
    F = 6;
    
    f = [ A B C nan 
          E F D nan 
          A B F E
          A E D C
          C D F B
        ];

    %
    % Specify the face color for each block in the snake
    % as either a cream color, or brown.
    %
    if dark
      fc = [ .4 .4 .2 ];
    else
      fc = [ 1 1 .9 ];
    end
    
    patch('parent',b, ...
          'vertices', v, ...
          'faces', f, ...
          'facecolor',fc, ...
          'edgecolor','k');

    % Transformation function that moves each block
    % into the correct location within the parent.
    xform(b,0);
    
    % Remember the current rotation value for animation.
    setappdata(b,'rotation',0);
  end
  
%%
  function xform(block, rotation)
  % Apply a transform to BLOCK.
  % ROTATION is the amount of rotation off the default for that blcck.

    % Create the compound transform.
    tform = makehgtform('axisrotate',[0 1 0],rotation,...
                        'zrotate',pi/2,'yrotate',pi,...
                        'translate',[2 0 0]);
  
    % Apply the transformation to BLOCK.
    % Remember that BLOCK is an hgtransform object, and not
    % A patch object.  The patch just goes along for the ride.
    set(block,'matrix',tform);
  end
  
  %% 
  % Create the Figure window and Axesin which we are going to create the
  % snake.

  figure('renderer','opengl');
  title('Snake Demo');
  % Force the axes to have sane aspect ratios.
  axis vis3d
  % Make the axes visible.  Allow objects to be drawn outside
  % the axes clip rectangle.
  set(gca,'vis','off','clip','off');
  set(gca,'pos',[0 0 1 1]);
  % Start with an off-angle view.
  view(3)

  % Create the first block.
  snake(1) = oneblock(false, gca);

  % We need 24 blocks to make a traditional snake toy.
  for i = 2:24
    snake(i) = oneblock(~mod(i,2),snake(i-1));
  end

  %%
  % We intend to animate snake transformations.
  % To do this so it is reliable on multiple platforms,
  % running at different speeds, we need to measure the time
  % it takes to draw, and then add a pause so the animation
  % is not too fast.
  function docam

    % Orbit the camera so there is lots of movement.
    % Good orbit values are usuall two numbers, where
    % the second value is slightly smaller than the first.
    camorbit(5,3);

    % Measure how long it takes to draw the snake.
    % We could use drawnow('expose'), but it is nice to
    % let someone use camera toolbar and menu items
    % while the snake is animating.
    tic
      drawnow;
    h=toc;
    
    % Calculate the delta between the desired pause of .04 seconds.
    delta = .04-h;
    
    % Add more delay
    if delta > 0
      pause(delta);
    end
  end
  
  %%
  % To animate the snake, we need a routine to permute the snake
  % to new angles.
  function config(in, conf)

    % Loop over all the blocks in order.
    for k=1:length(in)
      
      % Fetch the old rotation value from the input block.
      old = getappdata(in(k),'rotation');

      % Create an animation step value for 10 total steps.
      step = (conf(k)-old)/10;
        
      % Skip blocks already configured
      if step ~= 0
        
        % Perform the animation.
        for j = 1:10
          % Use the same transform function as we had before.
          xform(in(k),old+(step*j));
          docam;
        end
      end
      
      % Solve any round-off problems in the animation.
      xform(in(k),conf(k));
      % Store the new value into the block
      setappdata(in(k),'rotation',conf(k));
    end
    % Float the camera around a little bit so you can
    % Get the feel for what's going on.
    for k=1:50
      docam;
    end

  end  

  %% 
  % Perform some animations.
  %
  % By defining pre-defined rotation vectors, we can animate
  % the snake through different permutations.

  % Convenient name for 90 degrees.
  n=pi/2;

  %% Ball
  rv = [ 0 n -n -n n -n n n -n n -n -n ...
         n -n n n -n n -n -n n -n n n];
  config(snake, rv);
  %% Wave
  rv = [ 0 0 pi 0 pi 0 pi 0 pi 0 pi 0 ...
         pi 0 pi 0 pi 0 pi 0 pi 0 pi 0];
  config(snake, rv);
  %% Dna
  rv = [ n n n n n n n n n n n n ...
         n n n n n n n n n n n n];
  config(snake, rv);
  %% Spiral
  rv = [ 0 n 0 n 0 n 0 n 0 n 0 n ...
         0 n 0 n 0 n 0 n 0 n 0 n];
  config(snake, rv);
  %% Coil
  rv = [ 0 n pi n pi n pi n pi n pi n ...
         pi n pi n pi n pi n pi n pi n];
  config(snake, rv);
  %% box
  rv = [ 0 0 0 0 0 0 pi 0 0 0 0 ...
         pi 0 0 0 0 0 0 pi 0 0 0 0 pi];
  config(snake, rv);
  %% filledbox
  rv = [ 0 pi 0 0 0 pi pi 0 0 0 0 pi ...
         0 0 pi 0 0 0 0 pi pi 0 0 0];
  config(snake, rv);
  %% cross
  rv = [ 0 0 0 pi pi 0 0 0 pi 0 pi pi ...
         0 pi 0 pi pi 0 pi 0 pi pi 0 pi];
  config(snake, rv);
  %% heart
  rv = [ 0 0 pi 0 0 n 0 n 0 0 0 0 ...
         pi 0 0 0 0 -n 0 -n 0 0 pi 0];
  config(snake, rv);
  %% dog
  rv = [ 0 pi 0 0 0 pi pi 0 pi 0 0 ...
         pi 0 pi pi 0 0 0 pi 0 pi pi 0 pi ];
  config(snake, rv);
  %% chicken
  rv = [ 0 pi 0 0 0 0 0 pi pi 0 ...
         n 0 pi pi 0 pi pi 0 -n ...
         0 pi pi 0 0];
  config(snake, rv);
  %% swan
  rv = [ 0 pi pi 0 0 0 0 0 pi -n -n -n ...
         n -n n n -n n -n -n -n pi 0 pi];
  config(snake, rv);
  %% duck
  rv = [ 0 pi pi 0 0 0 n 0 n 0 0 -n ...
         pi n 0 0 n pi -n 0 0 n 0 n];
  config(snake, rv);
  %% robot
  rv = [ 0 0 n 0 -n n n n -n -n -n -n ...
         pi n n n n -n -n -n n 0 -n 0];
  config(snake, rv);
  %% symbol
  rv = [ 0 pi 0 pi n n -n n -n -n pi 0 ...
         pi pi 0 pi n n -n n -n -n pi 0];        
  config(snake, rv);
  %% fluer
  rv = [ 0 0 n -n n 0 pi 0 -n n -n 0 ...
         pi 0 n -n n 0 pi 0 -n n -n 0];
  config(snake, rv);
  %% bowl
  rv = [ 0 0 pi pi 0 n -n pi n n -n -n ...
         pi n n -n -n pi n n -n -n pi n];
  config(snake, rv);
  %% spring
  rv = [ 0 -n n 0 n -n n 0 n -n n 0 ...
         n -n n 0 n -n n 0 n -n n 0];
  config(snake, rv);
  %% cobra
  rv = [ 0 pi -n 0 0 0 pi n n 0 pi 0 0 ...
         0 n 0 pi pi 0 pi pi 0 n 0];
  config(snake, rv);
  %% line
  rv = [ 0 0 0 0 0 0 0 0 0 0 0 0 ...
         0 0 0 0 0 0 0 0 0 0 0 0];
  config(snake, rv);
  
  
end