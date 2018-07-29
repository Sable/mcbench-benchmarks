function [t_fismat, t_error, stepsize, c_fismat, c_error] = ...
    anfisx(trn_data, in_fismat, t_opt, d_opt, chk_data, method)
%ANFISX Adaptive Neuro-Fuzzy training of Sugeno-type FIS.
%   
%   See anfis for syntax and explanation.
% 
%   It is completely based on MATLAB's anfis 
%   with some modifications, so it's compatible
%   with extendent fuzzy rule structure.
% 
%   Compare also code of this function
%   with code of the original anfis.
% 
%   Example:
%   x = (0 : 0.1 : 10)';
%   y = sin(2 * x) ./ exp(x / 5);
%   epoch_n = 20;
%   treeopts = {'minparent', 20};
%   in_fis  = genfis4(x, y, 'sugeno', 'auto', treeopts);
%   out_fis = anfisx([x y], in_fis, epoch_n);
%   plot(x, y, x, evalfisx(x, out_fis));
%   legend('Training Data', 'ANFIS Output');

%   Per Konstantin A. Sidelnikov, 2009.

error(nargchk(1, 6, nargin));
error(nargchk(0, 5, nargout));

% Change the following to set default train options.
default_t_opt = [...
    10;    % training epoch number
    0;  % training error goal
    0.01;   % initial step size
    0.9;    % step size decrease rate
    1.1;   % step size increase rate
    1]; % add a bias to handle zero firing error

% Change the following to set default display options.
default_d_opt = [ ...
    1; % display ANFIS information
    1;  % display error measure
    1;  % display step size
    1]; % display final result

% Default FIS type
default_fis_type = 'sugeno';

% Check method
if nargin < 6
    method = 1;
end
% Check checking data
if nargin < 5
    chk_data = [];
end
% Check display options
if nargin < 4
    d_opt = default_d_opt;
else
    if length(d_opt) < 5
        tmp = default_d_opt;
        tmp(1 : length(d_opt)) = d_opt;
        d_opt = tmp;
    end    
    nan_index = find(isnan(d_opt));
    d_opt(nan_index) = default_d_opt(nan_index);
end
% Check training options
if nargin < 3
    t_opt = default_t_opt;
else
    if length(t_opt) < 6
        tmp = default_t_opt;
        tmp(1 : length(t_opt)) = t_opt;
        t_opt = tmp;
    end
    nan_index = find(isnan(t_opt));
    t_opt(nan_index) = default_t_opt(nan_index);
end
% Check input FIS
if nargin < 2
    in_fismat = default_fis_type;
end

% If fismat or method are nan's or []'s, replace them with default settings
if isempty(in_fismat)
   in_fismat = default_fis_type;
elseif ~isstruct(in_fismat) && any(isnan(in_fismat))
   in_fismat = default_fis_type;
end 
if isempty(method)
   method = 1;
elseif any(isnan(method))
   method = 1;
elseif (method ~= 1) && (method ~= 0)
   method = 1;
end 

% Generate FIS matrix if necessary
if ~isstruct(in_fismat)
    in_fismat = genfis4(trn_data(:, 1 : end - 1), ...
        trn_data(:, end), in_fismat);
end

if t_opt(end) == 1 % adding bias if user has specified
    in_fismat.bias = 0;
end
    
% More input/output argument checking
if nargin < 5 && nargout > 3
    error('Too many output arguments!');
end
if length(t_opt) ~= 6
    error('Wrong length of t_opt!');
end
if length(d_opt) ~= 4
    error('Wrong length of d_opt!');
end

max_iRange = max([trn_data; chk_data], [], 1);
min_iRange = min([trn_data; chk_data], [], 1);
numInp = getfisx(in_fismat, 'numinputs');
numOutp = getfisx(in_fismat, 'numoutputs');

% Set input and output ranges to match training & checking data
for iInput = 1 : numInp    
    range = [min_iRange(1, iInput), ...
        max_iRange(1, iInput)];
    in_fismat = setfisx(in_fismat, 'input', iInput, 'range', range);
end
for iOutput = 1 : numOutp
    range = [min_iRange(1, iInput + iOutput), ...
        max_iRange(1, iInput + iOutput)];
    in_fismat = setfisx(in_fismat, 'output', iOutput, 'range', range);
end

% Make sure input MF's cover complete range
for iInput = 1 : numInp
   [oLow, oHigh, MFBounds] = localFindMFOrder(in_fismat.input(iInput).mf);
   % First ensure range limits are covered
   if all(isfinite(MFBounds(:, 1))) && ...
         in_fismat.input(iInput).mf(oLow(1)).params(1) > ...
         min_iRange(1, iInput)
      % Lower limit
      in_fismat.input(iInput).mf(oLow(1)).params(1) = ...
          (1 - sign(min_iRange(1, iInput)) * 0.1) * ...
          min_iRange(1, iInput) - eps;
   end
   if all(isfinite(MFBounds(:, 2))) && ...
         in_fismat.input(iInput).mf(oHigh(end)).params(end) < ...
         max_iRange(1, iInput)
      % Upper limit
      in_fismat.input(iInput).mf(oHigh(end)).params(end) = ...
          (1 + sign(min_iRange(1, iInput)) * 0.1) * ...
          max_iRange(1, iInput) + eps;
   end
   % Now ensure that whole data range is covered
   if ~any(all(~isfinite(MFBounds), 2))
      % Don't have any set with +- inf bounds
      for iMF = 1 : numel(oLow) - 1
         % Loop through sets and assign corner points to overlap
         if in_fismat.input(iInput).mf(oLow(iMF)).params(end) < ...
               in_fismat.input(iInput).mf(oLow(iMF+1)).params(1)
            in_fismat.input(iInput).mf(oLow(iMF)).params(end) = ...
                (1 + sign(min_iRange(1, iInput)) * 0.01) * ...
                in_fismat.input(iInput).mf(oLow(iMF + 1)).params(1) + eps;
         end
      end
   end   
end

% Start the real thing!
if nargout == 0
    anfisxmex(trn_data, in_fismat, t_opt, d_opt, chk_data, method);
    return;
elseif nargout == 1
    [t_fismat] = ...
        anfisxmex(trn_data, in_fismat, t_opt, d_opt, chk_data, method);
elseif nargout == 2
    [t_fismat, t_error] = ...
        anfisxmex(trn_data, in_fismat, t_opt, d_opt, chk_data, method);
elseif nargout == 3
    [t_fismat, t_error, stepsize] = ...
        anfisxmex(trn_data, in_fismat, t_opt, d_opt, chk_data, method);
elseif nargout == 4
    [t_fismat, t_error, stepsize, c_fismat] = ...
        anfisxmex(trn_data, in_fismat, t_opt, d_opt, chk_data, method);
elseif nargout == 5
    [t_fismat, t_error, stepsize, c_fismat, c_error] = ...
        anfisxmex(trn_data, in_fismat, t_opt, d_opt, chk_data, method);
end

if isfield(t_fismat, 'bias')
    t_fismat = rmfield(t_fismat, 'bias');
end
if (nargout > 3) && isfield(c_fismat, 'bias')
    c_fismat = rmfield(c_fismat, 'bias');
end

%--------------------------------------------------------------------------
function [orderLow, orderHigh, MFBounds] = localFindMFOrder(MF)
%Function to find the order in which the mf's cover the range
%orderLow is the order of the lower mf 'corners'
%orderHigh is the order of the higher mf 'corners'

MFBounds = zeros(numel(MF), 2);
for iMF = 1 : numel(MF)
   switch lower(MF(iMF).type)
      case {'trimf', 'trapmf', 'pimf'}
         MFBounds(iMF, :) = [MF(iMF).params(1), MF(iMF).params(end)];
      case 'smf'
         MFBounds(iMF, :) = [MF(iMF).params(1), Inf];
      case 'zmf'
         MFBounds(iMF, :) = [-Inf, MF(iMF).params(end)];
      otherwise
         MFBounds(iMF, :) = [-Inf, Inf];
   end         
end

[~, orderLow] = sort(MFBounds(:, 1), 1, 'ascend');
if nargout >= 2
   [~, orderHigh] = sort(MFBounds(:, 2), 1, 'ascend');
end