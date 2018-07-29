function b = round2(a, arg1, arg2)
%
% ROUND2 Round to a specified number of decimals.
%
%   ROUND2(A)   returns the same as ROUND(A).
%   ROUND2(A, 'even')  returns the same as ROUND(A). Elements with  
%   fractional part equal to 0.5 are rounded to even integers.  
%   ROUND2(A, N)   rounds the elements of A to decimals specified in N.   
%   ROUND2(A, N,'even')   rounds the elements of A to decimals specified  
%   in N.  Elements with 5 as the (N+1)-th digit after decimal are rounded
%   to even numbers.
% 
%   See also: ROUND, FIX, FLOOR, CEIL, FIX2.

n = 0;
flag = [];

if nargin == 2
    if ischar(arg1)
        flag = arg1;
    else
        n = arg1;
    end
end

if nargin > 2
    n = arg1;
    flag = arg2;
end

if  ~isempty(flag) && ~strcmpi(flag,'even')
    error('Invalid flag.')
end

% simpler case(round towards nearest integers)

if ~any(n) || isempty(a)
    b = roundfn(a); return
end

% general case(round to n decimals )

if ~isscalar(a) && ~isscalar(n) && ~isequal(size(a),size(n))
    error('Non-scalar inputs must be the same size')
end

t2n = 10.^floor(n);
b = roundfn(a.*t2n)./t2n;

    function b = roundfn(s)
        
        b = round(s);
        
        if ~isempty(flag)
            
            tf = @(r) round(10*abs(r - fix(r))) == 5;
            
            if isreal(s)
                k = tf(s);
                b(k) = 2*fix(b(k)/2);
            else
                x = real(b);
                y = imag(b);
                k = tf(real(s));
                x(k) = 2*fix(x(k)/2);
                k = tf(imag(s));
                y(k) = 2*fix(y(k)/2);
                b = complex(x,y);
            end
            
        end
        
    end

end