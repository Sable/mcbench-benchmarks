function sp=horzcat(varargin)
% sympoly/horzcat: horizontal concatenation for sympoly objects and scalars
% usage: sp=[sp1,sp2,sp3,...];
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
C = sum(cellfun('size',varargin,2));

% expand sp up to the correct final size
if C>c1
  sp(r1,C) = sp(1);
end

for k=2:n
  spk=varargin{k};
  [rk,ck]=size(spk);
  
  % check for row comformance
  if r1~=rk
    error 'Objects do not conform for horizontal concatenation'
  end
  
  if ~isa(spk,'sympoly')
    spk=sympoly(spk);
  end
  
  for i=1:r1
    for j=1:ck
      sp(i,j+c1)=spk(i,j);
    end
  end
  
  c1 = c1 + ck;
  
end




