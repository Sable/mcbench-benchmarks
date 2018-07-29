function spd=det(sp)
% sympoly/det: determinant of a (square) sympoly array
% usage: spd=det(sp);
% 
% arguments:
%  sp - square matrix sympoly object
%
%  spd - scalar sympoly object containing the determinant

s=size(sp);
if s(1)~=s(2)
  error 'Must be a square array for the determinant'
end

n=s(1);
switch n
case 1
  % 1x1
  spd=sp;
  
case 2
  % 2x2
  spd=sp(1,1).*sp(2,2)-sp(1,2).*sp(2,1);

case 3
  % 3x3
  spd = sp(1,1).*sp(2,2).*sp(3,3) + sp(1,2).*sp(2,3).*sp(3,1) ... 
      + sp(1,3).*sp(2,1).*sp(3,2) - sp(3,1).*sp(2,2).*sp(1,3) ... 
      - sp(3,2).*sp(2,3).*sp(1,1) - sp(3,3).*sp(2,1).*sp(1,2);
  
otherwise
  % 4x4 and higher, use minors to compute the
  % determinant recursively
  spd=0;
  minorsigns = 1;
  for i=1:n
    j=1:n;
    j(i)=[];
    spd = spd + minorsigns.*sp(i,1).*det(sp(j,2:n));
    minorsigns = -minorsigns;
  end
  
end

