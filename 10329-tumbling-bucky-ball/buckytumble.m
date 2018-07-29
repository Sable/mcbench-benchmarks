%BUCKYTUMBLE shows tumbling Bucky Ball
%   BUCKYTUMBLE -- display the Bucky Ball, slowly tumbling in space
%   Needs perms.m

%   Bill McKeeman

function buckytumble
  gr = (1+sqrt(5))/2;                  % golden ration
  d = @(a,b) a + b*gr;                 % vertex function

  bb = perms(...                       % Bucky Ball vertices
    [d(0,0), d(0,3), d(1,0)            % truncated icosahedron
     d(1,0), d(0,2), d(2,1)
     d(2,0), d(0,1), d(1,2)]/2, 'cycles', 'signs', 'unique');
  [s,f] = edges(bb);                   % start,finish
  
  mx = max(abs(bb(:)))*1.2;            % frame the picture
  mz = max(abs(bb(3,:)));              % z scale
  clip = @(vec) min(max(vec,0),1);     % black and white
  axis([-mx mx -mx mx]);               % fix the axes
  axis equal
  axis off
  bg = .8*[1 1 1];                     % background grey
  set(gcf, 'color', bg);

  hold on
  tumble;                              % plot it
  hold off

  return;
  
  % compute the edges of a polyhedron
  function [s,f] = edges(p)
    m = size(p,1);
    d = inf(m);                        % distance matrix
    for i=1:m
      for j=i+1:m
        seg = p(i,:)-p(j,:);           % vertex pairs
        d(i,j) = sqrt(seg*seg');       % distance between
      end
    end  
    es = min(d(:));                    % nearest neighbors
    TOL = es/10000;
    [s,f] = find(abs(d-es)<TOL);       % compensate for roundoff
  end

  % tumble until stopped with ^C
  function tumble
    nd = size(bb,2);
    a = rand(nd)/25;                   % about 1 degree
    p = bb;                            % rotatable vertex set
    for reps = 1:intmax
      dr = ndrotate(a);
      for i=1:100                      % 100, then change direction
        cla;                           % clear previous
        fromInfinity(p);               % new edges
        drawnow;
        p = p*dr;                      % new position
        pause(0.03);                   % leave some cycles 
      end
      a = a + (rand-0.5)/100;          % change direction
    end
  end

  % plot 2-D shadow of edges
  function fromInfinity(p) 
    for k = 1:numel(s)                 % all edges
      e1 = [p(s(k),1)  p(f(k),1)];     % x end
      e2 = [p(s(k),2)  p(f(k),2)];     % y end
      z = p(s(k),3) + p(f(k),3);       % 2*mx : -2*mx
      h = ((z+2*mz)/mz)/4;             %    1 : 0 
      h = 1-h;                         %    0 : 1
      c = clip([h h h]);               % black is nearest
      w = 2-h;
      plot(e1, e2, 'color', c, 'linewidth', w);
    end
  end

  % turn angles into orthogonal matrix
  function res = ndrotate(angles)
    [m,n] = size(angles);
    res = eye(n);
    for i=1:m
      for j=1:n
        if i ~= j && angles(i,j) ~= 0
          tmp = eye(n);
          tmp(i,i) = cos(angles(i,j));
          tmp(j,j) = tmp(i,i);
          tmp(i,j) = -sin(angles(i,j));
          tmp(j,i) = -tmp(i,j);
          res = res*tmp;
        end
      end
    end
  end
end
