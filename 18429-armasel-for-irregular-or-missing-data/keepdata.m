function [ti,xi] = keepdata(x,p)
%
% Keeps arbitrary fraction p of equidistant data x at times ti.
% Output contains data xi at time ti

if p > 1, error('p must be between 0 and 1'), end

N=length(x);
Nover=floor(p.*N);

% over is the array of remaining points with value 1 
over=zeros(1,N);

ti=zeros(1,Nover);
xi=zeros(1,Nover);

% Select at random Nover points
i = 0;
while (i < Nover)
   r = rand(1);
   k = round((N - 1) .* r) + 1;
   if (over(k) ~= 1)
      over(k) = 1;
      i = i + 1;
   end
end

% Generate output data
j = 1;
for i=1:N
   if (over(i) == 1)
      xi(j) = x(i);
      ti(j) = i;
      j = j + 1;
   end
end
fprintf('Over: %d\n', j-1);