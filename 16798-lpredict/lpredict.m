function [y a]=lpredict(x, np, npred, pos)
% LPREDICT estimates the values of a data set before/after the observed set.
%
% LPREDICT uses linear prediction to extrapolate data, typically a
% timeseries. Note that this is not the same as linear extrapolation. 
% A window of autocorrelation coefficients is moved beyond the data
% limits to extrapolate the data. For a discussion, see Press et. al. [1].
%
% The required coefficients are derived from a call to LPC in MATLAB's
% Signal Processing Toolbox
%
% Example:
% y=LPREDICT(x, np, npred, pos)
% [y, a]=LPREDICT(x, np, npred, pos)
%      x:       the input data series as a column vector or a matrix 
%                   with series organized in columns
%      np:      the number of predictor coefficients to use (>=2)
%      npred:   the number of data values to return in the output
%      pos:     a string 'pre' or 'post' (default: post)
%                   This determines whether extrapolation occurs before or
%                   after the observed series x.
%
%      y:       the output, appropriately sequenced for concatenation with
%                   input x
%      a:       the coefficients returned by LPC (organized in rows).
%                   These can be used to check the quality/stability of the
%                   fit to the observed data as described in the
%                   documenation to the LPC function.
%
% The output y is given by:
%       y(k) = -a(2)*y(k-1) - a(3)*y(k-2) - ... - a(np)*y(k-np)
%                where y(n) => x(end-n) for n<=0
% 
% Note that sum(-a(2:end))is always less than unity. The output will
% therefore approach zero as npred increases. This may be a problem if x
% has a large DC offset. Subtract the the column mean(s) of x from x on
% input and add them to the output column(s) to restore DC. For a more
% accurate DC correction, see [1].
%
% To pre-pend data, the input sequence is reversed and the output is
% similarly reversed before being returned. The output may always be
% vertically concatenated with the input to extend the timeseries e.g:
%       k=(1:100)';
%       x=exp(-k/100).*sin(k/5);
%       x=[lpredict(x, 5, 100, 'pre'); x; lpredict(x, 5, 100, 'post')];
% 
% 
% See also LPC
%
% References:
% [1] Press et al. (1992) Numerical Recipes in C. (Ed. 2, Section 13.6).
%
% Toolboxes Required: Signal Processing
%
% Revisions:    10.07 renamed to avoid filename clash with System ID
%                     Toolbox
%                     DC correction help text corrected.
%
% -------------------------------------------------------------------------
% Author: Malcolm Lidierth 10/07
% Copyright Š The Author & King's College London 2007
% -------------------------------------------------------------------------


% ---------------Argument checks---------------
if nargin<3
    error('Not enough input arguments');
end

if np<2
    error('np must be >=2');
end

if nargin<4
    pos='post';
end
%---------------------------------------------

%------------------MATRIX--------------------
% Deal with matrix input.
% Apply function to each column via recursive calls
cols=size(x,2);
if cols>1
    y=zeros(npred, cols);
    a=zeros(cols, np+1);
    for k=1:size(x,2)
        [y(:,k) a(k,:)]=lpredict(x(:,k), np, npred, pos);
    end
    return
end
%---------------------------------------------


% ---------------MAIN FUNCTION---------------
% Order input sequence
if nargin==4 && strcmpi(pos,'pre')
    x=x(end:-1:1);
end

% Get the forward linear predictor coefficients via the LPC
% function
try
    a=lpc(x,np);
catch
    % LPC missing?
    m=lasterror();
    if strcmp(m.identifier, 'MATLAB:UndefinedFunction')
        error('Requires the LPC function from the Signal Processing Toolbox');
    else
        rethrow(lasterror);
    end
end

% Negate coefficients, and get rid of a(1)
cc=-a(2:end);

% Pre-allocate output
y=zeros(npred,1);
% Seed y with the first value
y(1)=cc*x(end:-1:end-np+1);
% Next np-1 values
for k=2:min(np,npred)
    y(k)=cc*[y(k-1:-1:1); x(end:-1:end-np+k)];
end
% Now do the rest
for k=np+1:npred
    y(k)=cc*y(k-1:-1:k-np);
end

% Order the output sequence if required
if nargin==4 && strcmpi(pos,'pre')
    y=y(end:-1:1);
end

return
end
