function y=cochcdf(X,k,v)
%Cochran's cumulative distribution function.
%Returns the Cochran's C cumulative distribution function
%with k variances and v degrees of freedom at the values in X.
% [Gives the p-value associated to the Cochran's statistics ratio  
% of the largest S^2 to their total (max(S^2)/sum(S^2)) (Cochran, 1941)].
%
%   Syntax: function y=cochcdf(X,k,v) 
%
%     Inputs:
% 	        X - Cochran's statistics.
% 	        k - number of variances.
% 	        v - number of degrees of freedom for each variance.
% The input quantities should be scalars.
%

%  Created by A. Trujillo-Ortiz and R. Hernandez-Walls
%             Facultad de Ciencias Marinas
%             Universidad Autonoma de Baja California
%             Apdo. Postal 453
%             Ensenada, Baja California
%             Mexico.
%             atrujo@uabc.mx
%
%  April 8, 2002.
%
%  To cite this file, this would be an appropriate format:
%  Trujillo-Ortiz, A. and R. Hernandez-Walls. (2003). Cochcdf: Cochran's cumulative 
%    distribution function. A MATLAB file. [WWW document]. URL http://www.mathworks.com/
%    matlabcentral/fileexchange/loadFile.do?objectId=3291&objectType=FILE
%
%  References:
% 
%  Cochran, W. G. (1941), The distribution of the largest of a set of
%      estimated variances as a fraction of their total. Annals of
%      Eugenics, 11:47-52.
%  Kreyszig, E. (1970), Introductory Mathematical Statistics.
%      NY:John Wiley, p. 206. 
%

alpha=0.05;
if nargin <  3,
   error('Requires three input arguments.');
end

[errorcode X k v] = distchck(3,X,k,v);

if errorcode > 0
   error('Requires non-scalar arguments to match in size.');
end
 
%Cochran's C function is resolved by the Simpson's 1/3 numerical integration method.
x=linspace(.000001,X,1000001);
DX=x(2)-x(1);
y=1/beta(.5*v,.5*v*(k-1));
y=y*(x.^((.5*v)-1));
y=y.*((1-x).^((.5*v*(k-1))-1));
N=length(x);
y=1-(k*(1-(DX.*(y(1)+y(N) + 4*sum(y(2:2:N-1))+2*sum(y(3:2:N-2)))/3.0)));
if y < 0;
   y = abs(y);
else
   y;
end;
