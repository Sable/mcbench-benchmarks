function y = Fseriesval(a,b,x,scale)
% FSERIESVAL Evaluates real Fourier series approximation at given data values
%
% Y = FSERIESVAL(A,B,X) the Fourier expansion of the form
%    y = A_0/2 + Sum_k[ A_k cos(kx) + B_k sin(kx) ]
% at the data values in the vector X.
%
% Y = FSERIESVAL(A,B,X,RESCALING) scales the X data to lie in the interval 
% [-pi,pi] if RESCALING is TRUE (default).  If RESCALING is FALSE, no 
% rescaling of X is performed.
%
% See also: Fseries

if nargin<3
    error('MATLAB:Fseriesval:MissingInputs','Required inputs are a, b, and x')
end
checkinputs();

% scale x to [-pi,pi]
if scale
    x1 = min(x);
    x2 = max(x);
    x = pi*(2*(x-x1)/(x2-x1) - 1);
end

% make design matrix
nx = x*(1:n);
F = [0.5*ones(size(x)),cos(nx),sin(nx)];

% evaluate fit
y = F*[a;b];

% transpose y back to a row, if x was a row
if xrow
    y = y';
end


    function checkinputs
        % coefficients
        if isnumeric(a) && isvector(a) && isnumeric(b) && isvector(b)
            % get number of terms in F series
            n = length(b);
            if length(a) ~= (n+1)
                throwAsCaller(MException('MATLAB:Fseriesval:InconsistentCoeffs','Inconsistent coefficient vectors'))
            end
        else
            throwAsCaller(MException('MATLAB:Fseriesval:WrongDataType','Coefficients must be numeric vectors'))
        end
        % x values
        if isnumeric(x) && isvector(x)
            % transpose x to a column if it is a row
            if size(x,2)>1
                x = x';
                xrow = true;
            else
                xrow = false;
            end
        else
            throwAsCaller(MException('MATLAB:Fseriesval:WrongDataType','x values must be a numeric vector'))
        end
        % optional scaling argument
        if exist('scale','var')
            if ~islogical(scale)
                throwAsCaller(MException('MATLAB:Fseriesval:WrongDataType','Scaling parameter must be logical (true/false)'))
            end
        else
            scale = true;
        end
    end

end
