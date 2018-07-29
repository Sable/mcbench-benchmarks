function [M,X,L] = largefactorial(N,fmt)
% LARGEFACTORIAL computes the factorial.
%
% USAGE:
%   largefactorial(N)
%   largefactorial(N,fmt)
%   [M,X,L] = largefactorial(N);
%
% INPUT:
%   N is a positive integer or an array of positive integers.
%   fmt is the format in which the mantissa is printed. This argument is
%   optional; default format is '%g'.
%
% OUTPUT:
%   M is an array of doubles containing the mantissas of the results.
%   X is an array of integers containing the exponents of the results.
%   L is an array of doubles containing log10 of the factorials.
%
%   The factorial of N is M .* 10.^X, or equivalently 10.^L. Consequently,
%   [M,X,L]=largefactorial(N);10.^L produces the same result as MATLAB's
%   standard function factorial(N).
%
%   If no output is requested, an array of cellstrings representing the
%   result in the form 'Me+L' is returned. The fmt input is relevant only
%   in this case.
%
% EXAMPLE 1
%   largefactorial(1E6)
%       produces '8.26393e+5565708'
%
% EXAMPLE 2
%   N = [20:25];
%   [M,X,L] = largefactorial(N);
%   [N;M;X;L]   produces
%       20.0000   21.0000   22.0000   23.0000   24.0000   25.0000
%        2.4329    5.1091    1.1240    2.5852    6.2045    1.5511
%       18.0000   19.0000   21.0000   22.0000   23.0000   25.0000
%       18.3861   19.7083   21.0508   22.4125   23.7927   25.1906
%
% REMARK: The function implements a standard algorithm. It computes the log
% (wrt base 10) of the factorial as sum(log10(i)), where i = 1 ... n. The
% exponential of the factorial is then just the integer part of this sum.
% The mantissa is 10 to the fractional part.
% Computation takes a long time for large arguments. largefactorial(1E10)
% produces the result m = 2.325580, x = 95657055186, but takes almost 54
% minutes to compute (on my not so fast laptop computer).
% A fester algorithm is provided by the function logcatorial, which is also
% available on the FEX.
%
% Author: Yvan Lengwiler (yvan.lengwiler@unibas.ch)
% Date: May 10, 2007
%
% Acknowledgement: Urs Schwarz and John D'Errico (reviewers at MathCentral)
% for helpful comments.
%
% See also: FACTORIAL, LOGFACTORIAL (MathCentral file id 14920)

    % --- check validity of argument

    Nsort = N(:);   % This is not sorted yet, but will be sorted later. The
                    % same variable name is used to save memory.

    if any(fix(Nsort) ~= Nsort) || any(Nsort < 0) || ...
            ~isa(Nsort,'double') || ~isreal(Nsort)
        error('N must be a matrix of non-negative integers.')
    end

    % --- perform computation

    % We compute the smallest factorial first, and then compute only the
    % increments.
    [Nsort,map] = sort(N(:));
    Nsort = [0;Nsort];
    L = arrayfun(@sumlogIncrement, 1:numel(N));
    L = cumsum(L);  % aggregate increments
    L(map) = L;     % put results back into original ordering ("un-sort")

    % 10^L is the result we are after, so ...
    X = fix(L);      % ... X is the exponential of the factorial ...
    M = 10.^(L-X);   % ... and M is the mantissa.

    % --- package output

    if nargout == 0
        % give user a string if no output is requested
        if nargin < 2
            fmt = '%g';     % default format
        end
        S = arrayfun(@(j) ...
            cellstr(strcat(num2str(M(j),fmt), 'e+', int2str(X(j)))), ...
            1:numel(N));        % create strings of the form 'Me+X'
        M = reshape(S,size(N));
        clear X L
    else
        % put output into the right shape
        X = reshape(X,size(N));
        M = reshape(M,size(N));
        L = reshape(L,size(N));
    end

    % --- nested function -------------------------------------------------
    function s = sumlogIncrement(j)
        % sumlogIncrement(j) computes sum(log10(i)) for i =
        % Nsort(j)+1 ... Nsort(j+1).
        lengthInterval = Nsort(j+1)-Nsort(j);
        a = Nsort(j);
        if lengthInterval <= 1E7
            s = sum(log10(a+(1:lengthInterval)));
        else
            % MATLAB sometimes runs out of memory when allocating long
            % vectors. I try to catch this problem here, but ASSUME that a
            % vector of size 1E7 can always be allocated.
            % Another possibility would be to use try-catch, but a lot of
            % time is wasted this way because MATLAB actually has to run
            % out of memory for the error to be thrown, and that takes a
            % long time. To avoid this, I felt it is better not to let
            % MATLAB go through this wasteful process and just split up the
            % problem into more manageable pieces to begin with.
            % Two problems remain:
            % 1. MATLAB may still run out of memory if it is unable to
            %    assign [1:1E7].
            % 2. To compute the factorial of, say 1E9, the for-loop is
            %    executed 100 times. If MATLAB has enough memory to assign
            %    a vector with 1E9 components, the for-loop could be
            %    avoided and computation would be faster using
            %    sum(log10([1:1E9])).
            % Maybe a reviewer at MathCentral knows a better way of
            % avoiding these problems?
            seq = 1:1E7;                        % "short" sequence
            rounds = floor(lengthInterval/1E7);	% # of rounds
            partialSum = zeros(1,rounds);
            for r = 1:rounds
                partialSum(r) = sum(log10(seq+(r-1)*1E7+a));
            end
            s = sum(partialSum) + ...
                sum(log10(((rounds*1E7+1):lengthInterval)+a));
        end
    end

end
