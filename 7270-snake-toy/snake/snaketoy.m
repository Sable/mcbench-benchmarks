function [h r] = snaketoy(in, conf, style)
% Create a snake, return the handle-vector of the group
% objects that make up the snake.
%
% [H R] = SNAKETOY - Create a new snake H with rotation vector R
%
% H = SNAKETOY(FIG) - Create a snake in figure FIG.  Return
%                       handle list R.
%
% SNAKETOY(H, CONFIG) - Configure the snake vector H with CONFIG.
%   CONFIG is a vector of angles for how far each block is twisted,
%   or it can be a string representing a named pre-defined shape.
%
% SNAKETOY(H, CONFIG, STYLE) - Configure snake vector H with
%   CONFIG using animation style STYLE.
% 
% S = SNAKETOY('shape') - Return a cell array S of named shapes
% S = SNAKETOY('xformstyle') - Return a cell array S of named
%   transformation styles.
% 
% setappdata(gcf,'noorbit',true);
% to disable orbiting while reconfiguring.

% Copyright (C) 2005-2011 The MathWorks Inc.
  
  shapes = { 'ball' 'symbol' 'fluer' 'bowl' 'spring' ...  3D shapes
             'wave' 'dna' 'coil' 'spiral' ...  Linear
             'box' 'filledbox' 'cross' 'heart' ... Flat Shapes
             'dog' 'chicken' 'swan' 'duck' 'cobra' 'robot' ...  Animals
             'mikesnake' 'fatboa' ... More animals
             'line' };
  
  xformstyles = { 'snap' 'forward' 'backward' 'rand' 'once' };
  
  if nargin==1 && nargout==1
    if ishandle(in)
    
      h = create(in);
      
    elseif ischar(in)
      
      switch (in)
       case 'shapes'
        h = shapes;
       case 'xformstyle'
        h = xformstyles;
       otherwise
        disp('Unknown request.');
      end
    end
  
  elseif nargin==0 && nargout==0  || nargin==1 && nargout==0 && ishandle(in)
  
    if nargin==1
        fig = in;
    else
        fig = gcf;
    end
        
    v = create(fig);
    float;
    styles = { 'rand' 'once' 'forward' 'once' 'backward'};
    
    ax1=gca;

    ax2=axes('units','pix',...
             'pos',[5 5 5 5],'vis','off');
    t = text('parent',ax2,'pos',[0 0],...
             'color','k',...
             'fontsize',18,...
             'horizontalalign','left',...
             'verticalalign','bottom');
    
    axes(ax1);
    
    oldstr='line';
    
    while true

      foldvec = randperm(length(shapes));
      
      for i=1:length(foldvec)
      
        str = shapes{foldvec(i)};

        stylestr = styles{ceil(rand(1,1)*length(styles))};
      
        set(t,'string',[oldstr '->' stylestr '->' str]);
        snaketoy(v,str,stylestr);
      
        set(t,'string',str);
        oldstr=str;
        float
        
      end
      
    end
    
  elseif nargin == 0
    
   h = create;
   r = h*0;
    
  else

    if isempty(in)
      in = create;
    end
    
    if ischar(conf)
      
      rv = zeros(24,1);
      n=pi/2;
  
      % For shape ideas see:
      %
      % http://home.t-online.de/home/thlet.wolter/
      
      switch conf
       case 'ball'
        rv = [ 0 n -n -n n -n n n -n n -n -n ...
               n -n n n -n n -n -n n -n n n];
       case 'wave'
        rv = [ 0 0 pi 0 pi 0 pi 0 pi 0 pi 0 ...
               pi 0 pi 0 pi 0 pi 0 pi 0 pi 0];
       case 'dna'
        rv = [ n n n n n n n n n n n n ...
               n n n n n n n n n n n n];
       case 'spiral'
        rv = [ 0 n 0 n 0 n 0 n 0 n 0 n ...
               0 n 0 n 0 n 0 n 0 n 0 n];
       case 'coil'
        rv = [ 0 n pi n pi n pi n pi n pi n ...
               pi n pi n pi n pi n pi n pi n];
       case 'box'
        rv = [ 0 0 0 0 0 0 pi 0 0 0 0 ...
               pi 0 0 0 0 0 0 pi 0 0 0 0 pi];
       case 'filledbox'
        rv = [ 0 pi 0 0 0 pi pi 0 0 0 0 pi ...
               0 0 pi 0 0 0 0 pi pi 0 0 0];
       case 'cross'
        rv = [ 0 0 0 pi pi 0 0 0 pi 0 pi pi ...
               0 pi 0 pi pi 0 pi 0 pi pi 0 pi];
       case 'heart'
        rv = [ 0 0 pi 0 0 n 0 n 0 0 0 0 ...
               pi 0 0 0 0 -n 0 -n 0 0 pi 0];
       case 'dog'
        rv = [ 0 pi 0 0 0 pi pi 0 pi 0 0 ...
               pi 0 pi pi 0 0 0 pi 0 pi pi 0 pi ];
       case 'chicken'
        rv = [ 0 pi 0 0 0 0 0 pi pi 0 ...
               n 0 pi pi 0 pi pi 0 -n ...
               0 pi pi 0 0];
       case 'swan'
        rv = [ 0 pi pi 0 0 0 0 0 pi -n -n -n ...
               n -n n n -n n -n -n -n pi 0 pi];
       case 'fatboa'
        rv = [ 0 0 pi 0 pi 0 0 -n -n -n ...
               n -n n n -n n -n -n -n 0 0 pi 0 pi];
       case 'duck'
        rv = [ 0 pi pi 0 0 0 n 0 n 0 0 -n ...
               pi n 0 0 n pi -n 0 0 n 0 n];
       case 'robot'
        rv = [ 0 0 n 0 -n n n n -n -n -n -n ...
               pi n n n n -n -n -n n 0 -n 0];
       case 'symbol'
        rv = [ 0 pi 0 pi n n -n n -n -n pi 0 ...
               pi pi 0 pi n n -n n -n -n pi 0];        
       case 'fluer'
        rv = [ 0 0 n -n n 0 pi 0 -n n -n 0 ...
               pi 0 n -n n 0 pi 0 -n n -n 0];
       case 'bowl'
        rv = [ 0 0 pi pi 0 n -n pi n n -n -n ...
               pi n n -n -n pi n n -n -n pi n];
       case 'spring'
        rv = [ 0 -n n 0 n -n n 0 n -n n 0 ...
               n -n n 0 n -n n 0 n -n n 0];
       case 'cobra'
        rv = [ 0 pi -n 0 0 0 pi n n 0 pi 0 0 ...
               0 n 0 pi pi 0 pi pi 0 n 0];
       case 'mikesnake'
        rv = [ 0 0 pi 0 0 0 pi 0 0 pi 0 0 ...
               0 pi 0 0 pi 0 0 0 pi 0 0 0];
       case 'line'
        rv = [ 0 0 0 0 0 0 0 0 0 0 0 0 ...
               0 0 0 0 0 0 0 0 0 0 0 0];
       case 'reset'
        rv = [ 0 0 0 0 0 0 0 0 0 0 0 0 ...
               0 0 0 0 0 0 0 0 0 0 0 0];
      end
    else
      rv = conf;
    end

    if nargin < 3
      style = getappdata(gcf,'transitionstyle');
      if isempty(style)
        style = 'rand';
      end
    end
    
    set(gcf,'currentaxes',ancestor(in(1),'axes'));
    
    config(in, rv, style);
    
    if nargout >= 1
      h = in;
    end
    
    if nargout == 2
      r = rv;
    end
    
  end

function xform(block, rotation)
% Apply a transform to BLOCK.
% ROTATION is the amount of rotation off the default for that blcck.

  set(block,'matrix',...
            makehgtform(...
                'axisrotate',[0 1 0],rotation,...
                'zrotate',pi/2,'yrotate',pi,...
                'translate',[2 0 0]));
  
function docam
% Rotate the camera just a little bit

  orb = getappdata(gcf,'noorbit');
  showstats = getappdata(gcf,'orbitstats');
set(gca,'xlim',[-1 1]); set(gca,'xlimmode','auto');

  if isempty(orb)
    orb = false;
  end
  
  if ~orb
    camorbit(5,3);
  end
  tic
    drawnow;
  h=toc;
  
  delta = .1-h;
  
  if delta > 0
    pause(delta);
  end
  
  if showstats
      disp(sprintf('Frame Time: %f', h));
  end
  
function float
% Float the snake for a little bit.
  
  for i=1:50
    docam;
  end
  
function config(in, conf, style)

  switch style
   case 'snap'
    for i=1:length(in)
      xform(in(i),conf(i));
      setappdata(in(i),'rotation',conf(i));
    end
    
   case 'once'
    oncestepsize = getappdata(gcf,'oncestepsize');
    if isempty(oncestepsize)
      oncestepsize=30;
    end

    callback=getappdata(gcf,'snakeconfigcallback');
    
    % Collect the step data
    for i=1:length(in)
      old(i) = getappdata(in(i),'rotation');
      steps(i) = (conf(i)-old(i))/oncestepsize;
    end
    
    for j=1:oncestepsize
      
      for i=1:length(in)
        xform(in(i),old(i)+(steps(i)*j));
      end
      if ~isempty(callback)
        feval(callback,in,j,oncestepsize);
      end
      docam;
    end
    
    for i=1:length(in)
      xform(in(i),conf(i));
      setappdata(in(i),'rotation',conf(i));
      if ~isempty(callback)
        feval(callback,in,oncestepsize,oncestepsize);
      end
    end
    docam;
    
   otherwise

    switch style
     case 'rand'
      foldvec = randperm(length(conf));
     case 'backward'
      foldvec = length(conf):-1:1;
     otherwise
      foldvec = 1:length(conf);
    end

    for fv=foldvec
      
      old = getappdata(in(fv),'rotation');

      step = (conf(fv)-old)/10;
      
      if step ~= 0
        for j = 1:10
          
          xform(in(fv),old+(step*j));
          docam;
          
        end
      end

      xform(in(fv),conf(fv));
      setappdata(in(fv),'rotation',conf(fv));
      drawnow;
      
    end
  end
  
function p = portapatch(varargin)
    
        p = patch(varargin{:});
    
function h = create(fig)
  
  if nargin==0
    figure('renderer','open');
    title('Snake Toy');
    xlabel X
    ylabel Y
    zlabel Z
    view(3)
    set(gca,'position',[0 0 1 1]);
  end
  %axis vis3d
  daspect([1 1 1]);
  set(gca,'climmode','auto','alimmode','auto');
  set(gca,'Visible','off','Clipping','off');
  light

  h(1) = oneblock(false, gca);

  v2 = [ -1 .6 -.6 ;
         -1 .6 .6 ;
         -1 -.6 -.6 ;
         -1 -.6 .6 ];
  f2 = [ 1 2 4 3 ];
  
  portapatch('Parent',h(1), ...
             'Vertices', v2, ...
             'Faces', f2, ...
             'FaceColor','none', ...
             'EdgeColor','n',...
             'MarkerEdgeColor','k',...
             'Marker','.');

  for i = 2:24
    
    h(i) = oneblock(~mod(i,2),h(i-1));
    
  end

  v3 = [ -.6 -1 -.6
         .6 -1 -.6
         .6 -1 .6
         -.6 -1 .6 ];
         
  f3 = [ 1 2 3 4 ];
  
  portapatch('Parent',h(i), ...
             'Vertices', v3, ...
             'Faces', f3, ...
             'FaceColor','none', ...
             'EdgeColor','n',...
             'MarkerEdgeColor','k',...
             'Marker','.');

  %h(2) = oneblock(true, h(1));
  %h(3) = oneblock(false, h(2));
  
function b = oneblock(dark, parent)
% Create one snake block.
% DARK is boolean - is this a dark block.
% PARENT is the object that is the parent of the new block.
  
  % The transform object.
  b = hgtransform('parent',parent);
  
  % Create the patches
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

  vp = [ v(A,:) ; v(B,:) ; v(C,:) ;
         v(E,:) ; v(F,:) ; v(D,:) ; 
         v(A,:) ; v(B,:) ; v(F,:) ; v(E,:) ;
         v(A,:) ; v(E,:) ; v(D,:) ; v(C,:) ;
         v(C,:) ; v(D,:) ; v(F,:) ; v(B,:) ];
  
  f = [ 1 2 3 nan
        4 5 6 nan
        7 8 9 10
        11 12 13 14
        15 16 17 18
      ];
  
  if dark
    fc = [ .4 .4 .2 ];
  else
    fc = [ 1 1 .9 ];
  end
  
  p = portapatch('parent',b, ...
                 'vertices', vp, ...
                 'faces', f, ...
                 'facecolor',fc, ...
                 'edgecolor','k',...
                 'Clipping','off',...
                 'facelighting','g',...
                 'ambientstrength',.8);

  % Make the vertex normals look pretty
%  norm = get(p,'vertexnormals');
%  
%  normtip = -1;
%  
%  for fi = 1:size(f,1)
%    
%    if isnan(f(fi,4))
%      centroid = sum(vp(f(fi,1:3),:))/3;
%      for fj = 1:3
%        n = norm(f(fi,fj),:) + normtip * (vp(f(fi,fj),:)-centroid);
%        norm(f(fi,fj),:) = n/sqrt(dot(n,n));
%      end
%    else
%      centroid = sum(vp(f(fi,1:4),:))/4;
%      for fj = 1:4
%        n = norm(f(fi,fj),:) + normtip * (vp(f(fi,fj),:)-centroid);
%        norm(f(fi,fj),:) = n/sqrt(dot(n,n));
%      end
%    end
%    
%  end
%  
%  set(p,'vertexnormals',norm);
  
  
  v = [ .8 -.8 -.8 ; % Inner decorations
        .8 -.8 .8 ;
        -.8 .8 -.8 ;
        -.8 .8 .8 ];
  aa = 1;
  bb = 2;
  cc = 3;
  dd = 4;
  f = [ aa bb dd cc ];
  
  portapatch('Parent',b, ...
             'Vertices', v, ...
             'Faces', f, ...
             'faceColor','none', ...
             'Clipping','off',...
             'EdgeColor','k');
    
  xform(b,0);
  setappdata(b,'rotation',0);

  
