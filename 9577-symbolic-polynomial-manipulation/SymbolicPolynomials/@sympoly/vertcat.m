function sp=horzcat(varargin)
% sympoly/horzcat: vertical concatenation for sympoly objects and scalars
% usage: sp=[sp1;sp2;sp3;...];
% 
% arguments:
%  sp,sp1,sp2, ... - sympoly objects or scalars or arrays

n=length(varargin);

sp=varargin{1};
if ~isa(sp,'sympoly')
  sp=sympoly(sp);
end
[r1,c1] = size(sp);

% first check the sizes
R = sum(cellfun('size',varargin,1));

% expand sp up to the correct final size
if R>r1
  sp(R,c1) = sp(1);
end

for k=2:n
  spk=varargin{k};
  [rk,ck]=size(spk);
  
  % check for row comformance
  if c1~=ck
    error 'Objects do not conform for vertical concatenation'
  end
  
  if ~isa(spk,'sympoly')
    spk=sympoly(spk);
  end
  
  for i=1:rk
    for j=1:ck
      sp(i+r1,j)=spk(i,j);
    end
  end
  
  r1 = r1 + rk;
  
end




