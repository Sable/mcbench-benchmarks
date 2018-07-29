function [coeff, IDX] = ginicoeff(In,dim,nosamplecorr)

% GINICOEFF Calculate the Gini coefficient, a measure of statistical dispersion 
%   
%   GINICOEFF(IN) Calculate the Gini coeff for each column
%       - In can be a numeric vector/2D matrix of positive real values. 
%   
%   GINICOEFF(...,DIM) Calculate Gini coeff along the dimension selected by DIM
%       - dim: 1 column-wise computation(DEFAULT) 
%              2 row-wise computation
%   
%   GINICOEFF(...,NOSAMPLECORR) Don't apply sample correction
%       - nosamplecorr: true  or 1, apply correction (DEFAULT)
%                       false or 0, don't apply and divide by 'n' 
%
%    [COEFF, IDX] = ...
%       - coeff : n by 1 vector with gini coefficients where n is the number of 
%                 series in IN. The coefficient ranges from 1 (total inequality, 
%                 one unit receives everything) to 0 (total equality, everyone 
%                 receive the same amount).
%       - IDX   : n by 1 logical index. True means that the computation of the gini
%                 coefficient for that series has been skipped due to negative values
%                 or one-element series.
%
% NOTE: NaNs are ignored. The Gini coeff is not computed for those series with 
%       negative values or with just one element. A warning is issued if any series 
%       has negative values or is just a one-element series and IDX is not called 
%       explicitly.
%
% The formula can be expressed as:
% NUM = sum[(n+1-i)*Yi]  for i = 1,...,n; where Yi is monotonically increasing
% DEN = sum[Yi]
% G  = [n+1-2*(NUM/DEN)]*1/n      without sample correction 
% Gc = [n+1-2*(NUM/DEN)]*1/(n-1)  with sample correction (DEFAULT)
%
% Examples:
%   - In = [1,1,1,1,9,3,1,1,1,7,NaN];
%     G  = ginicoeff(In)
%
% Additional features:
% - <a href="matlab:web('http://www.mathworks.com/matlabcentral/fileexchange/26452-gini-coefficient','-browser')">FEX ginicoeff page</a>

% Author: Oleg Komarov (oleg.komarov@hotmail.it) 
% Tested on R14SP3 (7.1) and on R2009b
% 21 jan 2010 - Created 
% 05 feb 2010 - Per Jos (10584) suggestion: sample correction is now the default; if elements in a series < 2 --> NaN. Edited help. Added link to FEX page.
% 15 jun 2010 - NaNs were not ignored due to a misplacing in the lines of code

% CHECK
% ------------------------------------------------------------------------

% NINPUTS
error(nargchk(1,3,nargin));

% IN
if ~isnumeric(In); error('ginicoeff:fmtIn', 'IN should be numeric'); end

% DIM
if nargin == 1 || isempty(dim); dim = 1;
elseif ~(isnumeric(dim) && (dim == 1 || dim == 2))
    error('ginicoeff:fmtDim', 'DIM should be 1 or 2');
end

% NOSAMPLECORR
if nargin < 3 || isempty(nosamplecorr)
    nosamplecorr = false;
elseif  ~isscalar(nosamplecorr) || ~(islogical(nosamplecorr) || ismembc(nosamplecorr,[0,1]))
    error('ginicoeff:fmtnosamplecorr','nosamplecorr invalid format');
end

% IN VECTOR
if isvector(In); In = In(:); dim = 1; end 

% ENGINE
% ------------------------------------------------------------------------

% Negative values or one-element series (not admitted)
IDXnan = isnan(In);
IDX = any(In < 0,dim) | sum(~IDXnan,dim) < 2;
if dim == 1; In(:,IDX) = 0; else In(IDX,:) = 0; end
if nargout ~= 2 && any(IDX)
    warning('warnginicoeff:negValues','Check IDX for negative values or one-element series')
end

% Replace NaNs
In(IDXnan) = 0;

% Sort In
In = sort(In,dim,'ascend');

% Calculate frequencies for each series
freq = flipdim(cumsum(flipdim(~IDXnan,dim),dim),dim);

% Total numel
if dim == 1; totNum = freq(1,:); else totNum = freq(:,1); end

% Totals
tot = sum(In,dim);

% Gini's coefficient
coeff = totNum+1-2*(sum(In.*freq,dim)./tot);

% Sample correction
if nosamplecorr
    coeff = coeff./totNum;
else
    coeff = coeff./(totNum-1);
end