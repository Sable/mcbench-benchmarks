function adjustbarbase(H,value)
%ADJUSTBARBASE adjusts the base value for bar and hist plots
%  ADJUSTBARBASE(VALUE) moves the base value for bar plots from 0
%  to VALUE.
%  ADJUSTBARBASE(H,VALUE) moves the base for patches H to
%  VALUE. The handles H should be the result of calling BAR.

% note: doesn't work for horizontal bar plots.

% Copyright 2009 The MathWorks, Inc.

if nargin == 0 
  error('need at least one argument');
elseif nargin == 1
  value = H;
  H = findobj(gca,'type','patch');
end

H=H(:)';
for h = H
  verts = get(h,'vertices');
  len = size(verts,1);
  nverts = (len-1)/5;
  inds = ones(len,1);
  inds(3:5:len) = 0;
  inds(4:5:len) = 0;
  verts(logical(inds),2) = value;
  set(h,'vertices',verts);
end
