function illusion(num)
% ILLUSION - Create an illusion for finding the dots.
% ILLUSION(NUM) - Create the illusion matrix with this size.
  
% Copyright (C) 2002 Eric M. Ludlam

if nargin==0
  num=10;
end

s=surface(meshgrid(ones(num,1),ones(num,1)))
set(s,'facec','k','edgec',[.5 .5 .5],'linewidth',6);
set(s,'marker','o','markersize',10,'markerfacec','white','markeredgec','n');
axis([1.1 num-.1 1.1 num-.1]);

title('Find the vertex with the black dot.');

% end