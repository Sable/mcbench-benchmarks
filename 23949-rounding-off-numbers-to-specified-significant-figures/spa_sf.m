function N=spa_sf(X,SF)
%
%spa_sf     Rounding Off Number(s) to Certain Significant Figures
%
%   N = spa_sf(X,SF) is the rounded off number(s) of X with the specified 
%   significant figures SF.  X could be a scalar or a vector; however, SF 
%   must be a scalar.
% 
%   Example 1)
%       X  = 3.14159265359;
%       SF = 3;
%       N  = spa_sf(X,SF)
%
%     > N  = 3.1400
%
%   Example 2)
%       X  = 3.14159265359; X=[X,X*2;X*3,X*4];
%       SF = 3;
%       N  = spa_sf(X,SF)
%
%     > N  =
%           3.1400    6.2800
%           9.4200   12.6000
%
%
% See also: num2str, str2num
%   

% Too simple!? :)
%
%   Yuzo Toya, 2007 (ytoya<at>uwo.ca)
% 

N= num2str(X,SF);
N= str2num(N);

% That's it!

