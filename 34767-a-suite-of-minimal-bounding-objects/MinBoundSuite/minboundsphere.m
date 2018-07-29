function [center,radius] = minboundsphere(xyz)
% minboundsphere: Compute the minimum radius enclosing sphere of a set of (x,y,z) triplets
% usage: [center,radius] = minboundsphere(xyz)
%
% arguments: (input)
%  xyz - nx3 array of (x,y,z) triples, describing points in R^3
%        as rows of this array.
%
%
% arguments: (output)
%  center - 1x3 vector, contains the (x,y,z) coordinates of
%        the center of the minimum radius enclosing sphere
%
%  radius - scalar - denotes the radius of the minimum
%        enclosing sphere
%
%
% Example usage:
% Sample uniformly from the interior of a unit sphere. 
% As the sample size increases, the enclosing sphere
% should asymptotically approach center = [0 0 0], and
% radius = 1.
%
%   xyz = rand(10000,3)*2-1;
%   r = sqrt(sum(xyz.^2,2));
%   xyz(r>1,:) = [];          % 5156 points retained
%   tic,[center,radius] = minboundsphere(xyz);toc
%   
%   Elapsed time is 0.199467 seconds.
%
%   center = [0.00017275   8.5006e-05   0.00012015]
%
%   radius = 0.9999
%
% Example usage:
% Sample from the surface of a unit sphere. Within eps
% or so, the result should be center = [0 0 0], and radius = 1.
%
%   xyz = randn(10000,3);
%   xyz = xyz./repmat(sqrt(sum(xyz.^2,2)),1,3);
%   tic,[center,radius] = minboundsphere(xyz);toc
%
%   Elapsed time is 0.614762 seconds.
%
%   center =
%      4.6127e-17  -2.5584e-17   7.2711e-17
%
%   radius =
%       1
%
%
% See also: minboundrect, minboundcircle
%
%
% Author: John D'Errico
% E-mail: woodchips@rochester.rr.com
% Release: 1.0
% Release date: 1/23/07

% not many error checks to worry about
sxyz = size(xyz);
if (length(sxyz)~=2) || (sxyz(2)~=3)
  error 'xyz must be an nx3 array of points'
end
n = sxyz(1);

% start out with the convex hull of the points to
% reduce the problem dramatically. Note that any
% points in the interior of the convex hull are
% never needed.
if n>4
  tri = convhulln(xyz,{'QJ' 'Pp'});

  % list of the unique points on the convex hull itself
  hlist = unique(tri(:));

  % exclude those points inside the hull as not relevant
  xyz = xyz(hlist,:);
    
end

% now we must find the enclosing sphere of those that
% remain.
n = size(xyz,1);

% special case small numbers of points. If we trip any
% of these cases, then we are done, so return.
switch n
  case 0
    % empty begets empty
    center = [];
    radius = [];
    return
  case 1
    % with one point, the center has radius zero
    center = xyz;
    radius = 0;
    return
  case 2
    % only two points. center is at the midpoint
    center = mean(xyz,1);
    radius = norm(xyz(1,:) - center);
    return
  case 3
    % exactly 3 points. For this odd case, just use enc4,
    % appending a new point at the centroid. This is simpler
    % than other solutions that would have reduced the
    % problem to 2-d. enc4 will do that anyway.
    [center,radius] = enc4([xyz;mean(xyz,1)]);
    return
  case 4
    % exactly 4 points
    [center,radius] = enc4(xyz);
    return
end

% pick a tolerance
tol = 10*eps*max(max(abs(xyz),[],1) - min(abs(xyz),[],1));

% more than 4 points. for no more than 15 points in the hull,
% just do an exhaustive search.
if n <= 15
  % for 15 points, there are only nchoosek(15,4) = 1365
  % sets to look through. this is only about a second.
  asets = nchoosek(1:n,4);
  
  center = inf(1,3);
  radius = inf;
  for i = 1:size(asets,1)
    aset = asets(i,:);
    iset = setdiff(1:n,aset);
    
    % get the enclosing sphere for the current set
    [centeri,radiusi] = enc4(xyz(aset,:));
    
    % are all the inactive set points inside the circle?
    ri = sqrt(sum((xyz(iset,:) - repmat(centeri,n-4,1)).^2,2));
    
    [rmax,k] = max(ri);
    if ((rmax - radiusi) <= tol) && (radiusi < radius) 
      center = centeri;
      radius = radiusi;
    end
  end
  
else
  % Use an active set strategy, on many different
  % random starting sets.
  center = inf(1,3);
  radius = inf;
  
  for i = 1:250
    aset = randperm(n); % a random start, but quite adequate
    iset = aset(5:n);
    aset = aset(1:4);
    
    flag = true;
    iter = 0;
    centeri = inf(1,3);
    radiusi = inf;
    while flag && (iter < 12)
      iter = iter + 1;
      
      % get the enclosing sphere for the current set
      [centeri,radiusi] = enc4(xyz(aset,:));
      
      % are all the inactive set points inside the circle?
      ri = sqrt(sum((xyz(iset,:) - repmat(centeri,n-4,1)).^2,2));
      
      [rmax,k] = max(ri);
      if (rmax - radiusi) <= tol
        % the active set enclosing sphere also enclosed
        % all of the inactive points. We are done.
        flag = false;
      else
        % it must be true that we can replace one member of aset
        % with iset(k). That k'th element was farthest out, so
        % it seems best (a greedy algorithm) to swap it in. The
        % problem with the greedy algorithm, is it gets trapped
        % in a cycle at times. but since we are restarting the
        % algorithm multiple times, this will work.
        s1 = [aset([2 3 4]),iset(k)];
        [c1,r1] = enc4(xyz(s1,:));
        if (norm(c1 - xyz(aset(1),:)) <= r1)
          centeri = c1;
          radiusi = r1;
          
          % update the active/inactive sets
          swap = aset(1);
          aset = [iset(k),aset([2 3 4])];
          iset(k) = swap;
          
          % bounce out to the while loop
          continue
        end
        s1 = [aset([1 3 4]),iset(k)];
        [c1,r1] = enc4(xyz(s1,:));
        if (norm(c1 - xyz(aset(2),:)) <= r1)
          centeri = c1;
          radiusi = r1;
          
          % update the active/inactive sets
          swap = aset(2);
          aset = [iset(k),aset([1 3 4])];
          iset(k) = swap;
        
          % bounce out to the while loop
          continue
        end
        s1 = [aset([1 2 4]),iset(k)];
        [c1,r1] = enc4(xyz(s1,:));
        if (norm(c1 - xyz(aset(3),:)) <= r1)
          centeri = c1;
          radiusi = r1;
          
          % update the active/inactive sets
          swap = aset(3);
          aset = [iset(k),aset([1 2 4])];
          iset(k) = swap;
          
          % bounce out to the while loop
          continue
        end
        s1 = [aset([1 2 3]),iset(k)];
        [c1,r1] = enc4(xyz(s1,:));
        if (norm(c1 - xyz(aset(4),:)) <= r1)
          centeri = c1;
          radiusi = r1;
          
          % update the active/inactive sets
          swap = aset(4);
          aset = [iset(k),aset([1 2 3])];
          iset(k) = swap;
          
          % bounce out to the while loop
          continue
        end
        
        % if we get through to this point, then something went wrong.
        % Active set problem. Increase tol, then try again.
        tol = 2*tol;
        
      end
    end
    
    % have we improved over the best set so far?
    if radiusi < radius
      center = centeri;
      radius = radiusi;
    end
  end
end

% =======================================
%  begin subfunctions
% =======================================
function [center,radius] = enc4(xyz)
% minimum radius enclosing sphere for exactly 4 points in R^3
%
% xyz is a 4x3 array
%
% Note that enc4 will attempt to pass a sphere through all
% 4 of the supplied points. When the set of points proves to 
% be degenerate, perhaps because of collinearity of 3 or
% more of the points, or because the 4 points are coplanar,
% then the sphere would nominally have infinite radius. Since
% there must be a finite radius sphere to enclose any set of
% finite valued points, enc4 will provide that sphere instead.
%
% In addition, there are some non-degenerate sets of points
% for which the circum-sphere is not minimal. enc4 will always
% try to find the minimum radius enclosing sphere.

% interpoint distance matrix D
% dfun = @(A) (A(:,[1 1 1 1]) - A(:,[1 1 1 1])').^2;
dfun = inline('(A(:,[1 1 1 1]) - A(:,[1 1 1 1])'').^2','A');
D = sqrt(dfun(xyz(:,1)) + dfun(xyz(:,2)) + dfun(xyz(:,3)));

% Find the most distant pair. Test if their circum-sphere
% also encloses the other points. If it does, then we are
% done.
[dij,ij] = max(D(:));
[i,j] = ind2sub([4 4],ij);
others = setdiff(1:4,[i,j]);
radius = dij/2;
center = (xyz(i,:) + xyz(j,:))/2;
if (norm(center - xyz(others(1),:))<=radius) && ...
   (norm(center - xyz(others(2),:))<=radius)
  % we can stop here.
  return
end

% next, we need to test each triplet of points, finding their
% enclosing sphere. If the 4th point is also inside, then we
% are done.
ind = 1:3;
[center,radius,isin] = enc3_4(xyz(ind,:),xyz(4,:),D(ind,ind));
if isin
  % the 4th point was inside this enclosing sphere.
  return
end

ind = [1 2 4];
[center,radius,isin] = enc3_4(xyz(ind,:),xyz(3,:),D(ind,ind));
if isin
  % the 3rd point was inside this enclosing sphere.
  return
end

ind = [1 3 4];
[center,radius,isin] = enc3_4(xyz(ind,:),xyz(2,:),D(ind,ind));
if isin
  % the second point was inside this enclosing sphere.
  return
end

ind = [2 3 4];
[center,radius,isin] = enc3_4(xyz(ind,:),xyz(1,:),D(ind,ind));
if isin
  % the first point was inside this enclosing sphere.
  return
end

% find the circum-sphere that passes through all 4 points
% since we have passed all the other tests, we need not
% worry here about singularities in the system of
% equations.
A = 2*(xyz(2:4,:)-repmat(xyz(1,:),3,1));
rhs = sum(xyz(2:4,:).^2 - repmat(xyz(1,:).^2,3,1),2);
center = (A\rhs)';
radius = norm(center - xyz(1,:));


% =======================================
function [center,radius,isin] = enc3_4(xyz,xyztest,Di)
% minimum radius enclosing sphere for exactly 3 points in R^3
%
% xyz - a 3x3 array, with each row as a point in R^3
%
% xyztest - 1x3 vector, a point to be tested if it is
%       inside the generated enclosing sphere.
% 
% Di - 3x3 array of interpoint distances

% test the farthest pair of points. do they form a diameter
% of the sphere?
if Di(1,2)>=max(Di(1,3),Di(2,3))
  center = mean(xyz([1 2],:),1);
  radius = Di(1,2)/2;
  isin = (norm(xyz(3,:) - center)<=radius) && (norm(xyztest - center)<=radius);
elseif Di(1,3)>=max(Di(1,2),Di(2,3))
  center = mean(xyz([1 3],:),1);
  radius = Di(1,3)/2;
  isin = (norm(xyz(2,:) - center)<=radius) && (norm(xyztest - center)<=radius);
elseif Di(2,3)>=max(Di(1,2),Di(1,3))
  center = mean(xyz([2 3],:),1);
  radius = Di(2,3)/2;
  isin = (norm(xyz(1,:) - center)<=radius) && (norm(xyztest - center)<=radius);
end
if isin
  % we found the minimal enclosing sphere already
  return
end

% If we drop down to here, no singularities should
% happen (I've already caught any degeneracies.)

% We transform the three points into a plane, then
% compute the enclosing sphere in that plane.

% translate to the origin
xyz0 = xyz(1,:);
xyzt = xyz(2:3,:) - [xyz0;xyz0];

rot = orth(xyzt');

% uv is composed of 2 points, in 2-d, plus we
% have the origin (after the translation)
uv = xyzt*rot;

A = 2*uv;
rhs = sum(uv.^2,2);
center = (A\rhs)';
radius = norm(center - uv(1,:));

% rotate and translate back
center = center*rot' + xyz0;

% test if the 4th point is enclosed also
isin = (norm(xyztest - center)<=radius);


