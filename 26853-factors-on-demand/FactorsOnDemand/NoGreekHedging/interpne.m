function Vpred = interpne(V,Xi,nodelist,method)
% interpne: Interpolates and extrapolates using n-linear interpolation (tensor product linear)
% usage: Vpred = interpne(V,Xi)
% usage: Vpred = interpne(V,Xi,nodelist)
% usage: Vpred = interpne(V,Xi,nodelist,method)
%
% Note: Extrapolating long distances outside the support of V is rarely advisable.
%
% arguments: (input)
%  V - p-dimensional array to be interpolated/extrapolated at the list
%      of points in the array Xi.
%
%      Note: interpne will work in any number of dimensions >= 1
%
%  Xi - (n by p) array of n points to interpolate/extrapolate. Each
%      point is one row of the array Xi.
%
%  nodelist - (OPTIONAL) cell array of nodes in each dimension.
%      If nodelist is not provided, then by default I will assume:
%
%      nodelist{i} = 1:size(V,i)
%
%      The nodes in nodelist need not be uniformly spaced.
%
%  method - (OPTIONAL) chacter string, denotes the interpolation
%      method used. 
%      
%      DEFAULT: method = 'linear'
% 
%      'linear' --> n-d linear tensor product interpolation/extrapolation
%      'nearest' --> n-d nearest neighbor interpolation/extrapolation
%
%      Note: in 2-d, 'linear' is equivalent to a bilinear interpolant
%      in 3-d, it is commonly known as trilinear interpolation.
%
%
% arguments: (output)
%  Vpred - n by 1 array of interpolated/extrapolated values
%
%
% Example 1: 2d (bilinear) case
%  [x1,x2] = meshgrid(0:.2:1);
%  z = exp(x1+x2);
%  Xi = rand(100,2)*2-.5;
%  Zi = interpne(z,Xi,{0:.2:1, 0:.2:1},'linear');
%  surf(0:.2:1,0:.2:1,z)
%  hold on
%  plot3(Xi(:,1),Xi(:,2),Zi,'ro')
%
%
% My apology: this interface is not fully compatible with that of
% interpn. But in higher dimensions, the interpn interface is both
% a mess to use and to write.
%
%
% See also: interp1, interp2, interpn
%
% Author: John D'Errico
% e-mail address: woodchips@rochester.rr.com
% Release: 1.01
% Release date: 3/27/06

% get some sizes
vsize = size(V);
ndims = length(vsize);
[n,p] = size(Xi);
if ndims~=p
  error 'Xi is not compatible in size with the array V for interpolation.'
end

% default for nodelist
if (nargin<2) || isempty(nodelist)
  nodelist = cell(1,ndims);
  for i=1:ndims
    nodelist{i} = (1:vsize(i))';
  end
end
if length(nodelist)~=ndims
  error 'nodelist is incompatible with the size of V.'
end
nll = cellfun('length',nodelist);
if any(nll~=vsize)
  error 'nodelist is incompatible with the size of V.'
end

% get deltax for the node spacing
dx = nodelist;
for i=1:ndims
  nodelist{i} = nodelist{i}(:);
  dx{i} = diff(nodelist{i});
  if any(dx{i}<=0)
    error 'The nodes in nodelist must be monotone increasing.'
  end
end

% check for method
if (nargin<4) || isempty(method)
  method = 'linear';
end
if ~ischar(method)
  error 'method must be a character string if supplied.'
end
validmethod = {'linear' 'nearest'};
k = find(strncmp(method,validmethod,length(method)));
if isempty(k)
  error(['No match found for method = ',method])
end
method = validmethod{k};

% Which cell of the array does each point lie in?
% This includes extrapolated points, which are also taken
% to fall in a cell. histc will do all the real work.
ind = zeros(n,ndims);
for i = 1:ndims
  [junk,bin] = histc(Xi(:,i),nodelist{i});
  
  % catch any point along the very top edge.
  bin(bin==vsize(i)) = vsize(i) - 1;
  ind(:,i) = bin;
  k = find(bin==0);
  
  % look for any points external to the nodes
  if ~isempty(k)
    % bottom end
    ind(k(Xi(k,i)<nodelist{i}(1)),i) = 1;
    
    % top end
    ind(k(Xi(k,i)>nodelist{i}(end)),i) = vsize(i) - 1;
  end
end  % for i = 1:ndims

% where in each cell does each point fall?
t = zeros(n,ndims);
for i = 1:ndims
  t(:,i) = (Xi(:,i) - nodelist{i}(ind(:,i)))./dx{i}(ind(:,i));
end

sub = cumprod([1,vsize(1:(end-1))])';
base = 1+(ind-1)*sub;

% which interpolation method do we use?
switch method
  case 'nearest'
    % nearest neighbor is really simple to do.
    t = round(t);
    t(t>1) = 1;
    t(t<0) = 0;
    
    Vpred = V(base + t*sub);
    
  case 'linear'
    % tensor product linear is not too nasty.
    Vpred = zeros(n,1);
    % define the 2^ndims corners of a hypercube
    corners = (dec2bin(0:(2^ndims-1))== '1');
    nc = size(corners,1);
    for i = 1:nc
      s = V(base + corners(i,:)*sub);
      for j = 1:ndims
        % this will work for extrapolation too
        if corners(i,j) == 0
          s = s.*(1-t(:,j));
        else
          s = s.*t(:,j);
        end
      end
      Vpred = Vpred + s;
    end
    
end  % switch method



