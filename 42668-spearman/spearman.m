function [rho,p,rsq,Pfit] = spearman(x,y)
% spearman - calculates the Spearman rank correlation coefficient
%
% Inputs:
%     x - first data series
%     y - second data series
%
% Outputs:
%   rho - Spearman's rank correlation coefficient
%     p - Corresponding p-value
%   rsq - Coefficient of determination r-square
%  Pfit - Polynomial Fit with linear regression
%
% Example: 
%    load count.dat
%    x = count(:,1);
%    y = count(:,2);
%    [rho,p,rsq] = spearman(x,y)
%
% Other m-files required: Statistics Toolbox
% Subfunctions: none
% MAT-files required: none
%
% See also: corr

% Reference:
% http://www.mathworks.com/support/solutions/en/data/1-1AXU4/index.html
% http://www.mathworks.com/help/matlab/data_analysis/linear-regression.html
% Author: Marco Borges, Ph.D. Student, Computer/Biomedical Engineer
% UFMG, PPGEE, Neurodinamica Lab, Brazil
% email address: marcoafborges@gmail.com
% Website: http://www.cpdee.ufmg.br/
% July 2013; Version: v1; Last revision: 2013-07-15
% Changelog:

%------------- BEGIN CODE --------------
[rho,p] = corr(x,y,'type','Spearman');
Pfit = polyfit(x,y,1);
yfit = polyval(Pfit,x);
yresid = y - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(y)-1) * var(y);
rsq = 1 - SSresid/SStotal;
end
%-------------- END CODE ---------------