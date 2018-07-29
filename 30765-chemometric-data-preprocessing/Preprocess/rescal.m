function rx = rescal(x,mx,stdx)
% Rescals matrix using means and standard deviations
% If only mean was provided, it can also be used.
%
% rx = rescal(x,mx,stdx)
% or
% rx = rescal(x,mx)
%
% input:
% x     data to rescal
% mx    mean to consider
% stdx  standart deviation to consider
%
% output:
% rx    rescaled data
%
% By Cleiton A. Nunes
% UFLA,MG,Brazil


[m,n]=size(x);
if nargin == 3
  rx=(x.*stdx(ones(m,1),:))+mx(ones(m,1),:);
else
  rx=x+mx(ones(m,1),:);
end
