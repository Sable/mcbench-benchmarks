function [YY, I, Y0, LB, UB, ADX, NO] = hampel(X, Y, DX, T, varargin)
% HAMPEL    Hampel Filter.
%   HAMPEL(X,Y,DX,T,varargin) returns the Hampel filtered values of the 
%   elements in Y. It was developed to detect outliers in a time series, 
%   but it can also be used as an alternative to the standard median 
%   filter.
%
%   References
%   Chapters 1.4.2, 3.2.2 and 4.3.4 in Mining Imperfect Data: Dealing with 
%   Contamination and Incomplete Records by Ronald K. Pearson.
%
%   Acknowledgements
%   I would like to thank Ronald K. Pearson for the introduction to moving
%   window filters. Please visit his blog at:
%   http://exploringdatablog.blogspot.com/2012/01/moving-window-filters-and
%   -pracma.html
%
%   X,Y are row or column vectors with an equal number of elements.
%   The elements in Y should be Gaussian distributed.
%
%   Input DX,T,varargin must not contain NaN values!
%
%   DX,T are optional scalar values.
%   DX is a scalar which defines the half width of the filter window. 
%   It is required that DX > 0 and DX should be dimensionally equivalent to
%   the values in X.
%   T is a scalar which defines the threshold value used in the equation
%   |Y - Y0| > T*S0.
%
%   Standard Parameters for DX and T:
%   DX  = 3*median(X(2:end)-X(1:end-1)); 
%   T   = 3;
%
%   varargin covers addtional optional input. The optional input must be in
%   the form of 'PropertyName', PropertyValue.
%   Supported PropertyNames: 
%   'standard': Use the standard Hampel filter. 
%   'adaptive': Use an experimental adaptive Hampel filter. Explained under
%   Revision 1 details below.
% 
%   Supported PropertyValues: Scalar value which defines the tolerance of
%   the adaptive filter. In the case of standard Hampel filter this value 
%   is ignored.
%
%   Output YY,I,Y0,LB,UB,ADX are column vectors containing Hampel filtered
%   values of Y, a logical index of the replaced values, nominal data,
%   lower and upper bounds on the Hampel filter and the relative half size 
%   of the local window, respectively.
%
%   NO is a scalar that specifies the Number of Outliers detected.
%
%   Examples
%   1. Hampel filter removal of outliers
%       X           = 1:1000;                           % Pseudo Time
%       Y           = 5000 + randn(1000, 1);            % Pseudo Data
%       Outliers    = randi(1000, 10, 1);               % Index of Outliers
%       Y(Outliers) = Y(Outliers) + randi(1000, 10, 1); % Pseudo Outliers
%       [YY,I,Y0,LB,UB] = hampel(X,Y);
%
%       plot(X, Y, 'b.'); hold on;      % Original Data
%       plot(X, YY, 'r');               % Hampel Filtered Data
%       plot(X, Y0, 'b--');             % Nominal Data
%       plot(X, LB, 'r--');             % Lower Bounds on Hampel Filter
%       plot(X, UB, 'r--');             % Upper Bounds on Hampel Filter
%       plot(X(I), Y(I), 'ks');         % Identified Outliers
%
%   2. Adaptive Hampel filter removal of outliers
%       DX          = 1;                                % Window Half size
%       T           = 3;                                % Threshold
%       Threshold   = 0.1;                              % AdaptiveThreshold
%       X           = 1:DX:1000;                        % Pseudo Time
%       Y           = 5000 + randn(1000, 1);            % Pseudo Data
%       Outliers    = randi(1000, 10, 1);               % Index of Outliers
%       Y(Outliers) = Y(Outliers) + randi(1000, 10, 1); % Pseudo Outliers
%       [YY,I,Y0,LB,UB] = hampel(X,Y,DX,T,'Adaptive',Threshold);
%
%       plot(X, Y, 'b.'); hold on;      % Original Data
%       plot(X, YY, 'r');               % Hampel Filtered Data
%       plot(X, Y0, 'b--');             % Nominal Data
%       plot(X, LB, 'r--');             % Lower Bounds on Hampel Filter
%       plot(X, UB, 'r--');             % Upper Bounds on Hampel Filter
%       plot(X(I), Y(I), 'ks');         % Identified Outliers
%
%   3. Median Filter Based on Filter Window
%       DX        = 3;                        % Filter Half Size
%       T         = 0;                        % Threshold
%       X         = 1:1000;                   % Pseudo Time
%       Y         = 5000 + randn(1000, 1);    % Pseudo Data
%       [YY,I,Y0] = hampel(X,Y,DX,T);
%
%       plot(X, Y, 'b.'); hold on;    % Original Data
%       plot(X, Y0, 'r');             % Median Filtered Data
%
%   Version: 1.5
%   Last Update: 09.02.2012
%
%   Copyright (c) 2012:
%   Michael Lindholm Nielsen
%
%   --- Revision 5 --- 09.02.2012
%   (1) Corrected potential error in internal median function.
%   (2) Removed internal "keyboard" command.
%   (3) Optimized internal Gauss filter.
%
%   --- Revision 4 --- 08.02.2012
%   (1) The elements in X and Y are now temporarily sorted for internal
%       computations.
%   (2) Performance optimization.
%   (3) Added Example 3.
%
%   --- Revision 3 --- 06.02.2012
%   (1) If the number of elements (X,Y) are below 2 the output YY will be a
%       copy of Y. No outliers will be detected. No error will be issued.
%
%   --- Revision 2 --- 05.02.2012
%   (1) Changed a calculation in the adaptive Hampel filter. The threshold
%       parameter is now compared to the percentage difference between the
%       j'th and the j-1 value. Also notice the change from Threshold = 1.1
%       to Threshold = 0.1 in example 2 above.
%   (2) Checks if DX,T or varargin contains NaN values.
%   (3) Now capable of ignoring NaN values in X and Y.
%   (4) Added output Y0 - Nominal Data.
%
%   --- Revision 1 --- 28.01.2012
%   (1) Replaced output S (Local Scaled Median Absolute Deviation) with
%       lower (LB) and upper (UB) bounds on the Hampel filter.
%   (2) Added option to use an experimental adaptive Hampel filter.
%       The Principle behind this filter is described below.
%   a) The filter changes the local window size until the change in the 
%       local scaled median absolute deviation is below a threshold value 
%       set by the user. In the above example (2) this parameter is set to 
%       0.1 corresponding to a maximum acceptable change of 10% in the 
%       local scaled median absolute deviation. This process leads to three
%       locally optimized parameters Y0 (Local Nominal Data Reference 
%       value), S0 (Local Scale of Natural Variation), ADX (Local Adapted 
%       Window half size relative to DX).
%   b) The optimized parameters are then smoothed by a Gaussian filter with
%       a standard deviation of DX=2*median(XSort(2:end) - XSort(1:end-1)).
%       This means that local values are weighted highest, but nearby data 
%       (which should be Gaussian distributed) is also used in refining 
%       ADX, Y0, S0.
%   
%   --- Revision 0 --- 26.01.2012
%   (1) Release of first edition.

%% Error Checking
% Check for correct number of input arguments
if nargin < 2
    error('Not enough input arguments.');
end

% Check that the number of elements in X match those of Y.
if ~isequal(numel(X), numel(Y))
    error('Inputs X and Y must have the same number of elements.');
end

% Check that X is either a row or column vector
if size(X, 1) == 1
    X   = X';   % Change to column vector
elseif size(X, 2) == 1
else
    error('Input X must be either a row or column vector.')
end

% Check that Y is either a row or column vector
if size(Y, 1) == 1
    Y   = Y';   % Change to column vector
elseif size(Y, 2) == 1
else
    error('Input Y must be either a row or column vector.')
end

% Sort X
SortX   = sort(X);

% Check that DX is of type scalar
if exist('DX', 'var')
    if ~isscalar(DX)
        error('DX must be a scalar.');
    elseif DX < 0
        error('DX must be larger than zero.');
    end
else
    DX  = 3*median(SortX(2:end) - SortX(1:end-1));
end

% Check that T is of type scalar
if exist('T', 'var')
    if ~isscalar(T)
        error('T must be a scalar.');
    end
else
    T   = 3;
end

% Check optional input
if isempty(varargin)
    Option  = 'standard';
elseif numel(varargin) < 2
    error('Optional input must also contain threshold value.');
else
    % varargin{1}
    if ischar(varargin{1})
        Option      = varargin{1};
    else
        error('PropertyName must be of type char.');
    end
    % varargin{2}
    if isscalar(varargin{2})
        Threshold   = varargin{2};
    else
        error('PropertyValue value must be a scalar.');
    end
end

% Check that DX,T does not contain NaN values
if any(isnan(DX) | isnan(T))
    error('Inputs DX and T must not contain NaN values.');
end

% Check that varargin does not contain NaN values
CheckNaN    = cellfun(@isnan, varargin, 'UniformOutput', 0);
if any(cellfun(@any, CheckNaN))
    error('Optional inputs must not contain NaN values.');
end

% Detect/Ignore NaN values in X and Y
IdxNaN  = isnan(X) | isnan(Y);
X       = X(~IdxNaN);
Y       = Y(~IdxNaN);

%% Calculation
% Preallocation
YY  = Y;
I   = false(size(Y));
S0  = NaN(size(YY));
Y0  = S0;
ADX = repmat(DX, size(Y));

if numel(X) > 1
    switch lower(Option)
        case 'standard'
            for i = 1:numel(Y)
                % Calculate Local Nominal Data Reference value
                % and Local Scale of Natural Variation
                [Y0(i), S0(i)]  = localwindow(X, Y, DX, i);
            end
        case 'adaptive'
            % Preallocate
            Y0Tmp   = S0;
            S0Tmp   = S0;
            DXTmp   = (1:numel(S0))'*DX; % Integer variation of Window Half Size
            
            % Calculate Initial Guess of Optimal Parameters Y0, S0, ADX
            for i = 1:numel(Y)
                % Setup/Reset temporary counter etc.
                j       = 1;
                S0Rel   = inf;
                while S0Rel > Threshold
                    % Calculate Local Nominal Data Reference value
                    % and Local Scale of Natural Variation using DXTmp window
                    [Y0Tmp(j), S0Tmp(j)]    = localwindow(X, Y, DXTmp(j), i);
                    
                    % Calculate percent difference relative to previous value
                    if j > 1
                        S0Rel   = abs((S0Tmp(j-1) - S0Tmp(j))/(S0Tmp(j-1) + S0Tmp(j))/2);
                    end
                    
                    % Iterate counter
                    j   = j + 1;
                end
                Y0(i)   = Y0Tmp(j - 2);     % Local Nominal Data Reference value
                S0(i)   = S0Tmp(j - 2);     % Local Scale of Natural Variation
                ADX(i)  = DXTmp(j - 2)/DX;  % Local Adapted Window size relative to DX
            end
            
            % Gaussian smoothing of relevant parameters
            DX  = 2*median(SortX(2:end) - SortX(1:end-1));
            ADX = smgauss(X, ADX, DX);
            S0  = smgauss(X, S0, DX);
            Y0  = smgauss(X, Y0, DX);
        otherwise
            error('Unknown option ''%s''.', varargin{1});
    end
end

%% Prepare Output
UB      = Y0 + T*S0;            % Save information about local scale
LB      = Y0 - T*S0;            % Save information about local scale
Idx     = abs(Y - Y0) > T*S0;   % Index of possible outlier
YY(Idx) = Y0(Idx);              % Replace outliers with local median value
I(Idx)  = true;                 % Set Outlier detection
NO      = sum(I);               % Output number of detected outliers

% Reinsert NaN values detected at error checking stage
if any(IdxNaN)
    [YY, I, Y0, LB, UB, ADX]    = rescale(IdxNaN, YY, I, Y0, LB, UB, ADX);
end

%% Built-in functions
    function [Y0, S0] = localwindow(X, Y, DX, i)
        % Index relevant to Local Window
        Idx = X(i) - DX <= X & X <= X(i) + DX;

        % Calculate Local Nominal Data Reference Value
        Y0  = median(Y(Idx));
        
        % Calculate Local Scale of Natural Variation
        S0  = 1.4826*median(abs(Y(Idx) - Y0));
    end

    function M = median(YM)
        % Isolate relevant values in Y
        YM  = sort(YM);
        NYM = numel(YM);
        
        % Calculate median
        if mod(NYM,2)   % Uneven
            M   = YM((NYM + 1)/2);
        else            % Even
            M   = (YM(NYM/2)+YM(NYM/2+1))/2;
        end
    end

    function G = smgauss(X, V, DX)
        % Prepare Xj and Xk
        Xj  = repmat(X', numel(X), 1);
        Xk  = repmat(X, 1, numel(X));
        
        % Calculate Gaussian weight
        Wjk = exp(-((Xj - Xk)/(2*DX)).^2);
        
        % Calculate Gaussian Filter
        G   = Wjk*V./sum(Wjk,1)';
    end

    function varargout = rescale(IdxNaN, varargin)
        % Output Rescaled Elements
        varargout    = cell(nargout, 1);
        for k = 1:nargout
            Element     = varargin{k};
            
            if islogical(Element)
                ScaledElement   = false(size(IdxNaN));
            elseif isnumeric(Element)
                ScaledElement   = NaN(size(IdxNaN));
            end
            
            ScaledElement(~IdxNaN)  = Element;
            varargout(k)            = {ScaledElement};
        end
    end
end