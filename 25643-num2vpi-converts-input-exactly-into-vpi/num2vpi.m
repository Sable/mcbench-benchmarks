% num2vpi converts numeric and character string integral inputs exactly into vpi
%*******************************************************************************
% 
%  MATLAB (R) is a trademark of The Mathworks (R) Corporation
% 
%  Function:    num2vpi
%  Filename:    num2vpi.m
%  Programmer:  James Tursa
%  Version:     1.0
%  Date:        October 23, 2009
%  Copyright:   (c) 2009 by James Tursa, All Rights Reserved
%
%  This code uses the BSD License:
%
%  Redistribution and use in source and binary forms, with or without 
%  modification, are permitted provided that the following conditions are 
%  met:
%
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%      
%  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
%  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
%  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
%  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
%  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
%  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
%  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
%  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
%  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
%  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
%  POSSIBILITY OF SUCH DAMAGE.
%
%--
% 
%  Syntax:
%
%  B = num2vpi(A)
%
%      A = a logical or numeric class variable (real), or
%        = a char array, each row giving a single integer value (real)
%      B = a vpi class variable
%
%  Description:
%
%  num2vpi converts A into a vpi class variable using the exact bit
%  representation of the A elements. For single and double floating point
%  inputs, num2vpi uses the FEX submission num2strexact to do the basic
%  conversion. For uint64 and int64, num2vpi does the conversion in two
%  uint32 pieces since vpi handles uint32 inputs but not uint64 or int64
%  inputs. The int64 conversion uses the typecast function. For logical
%  inputs, num2vpi does a simple conversion to uint8 first, since vpi
%  handles uint8 inputs but not logical inputs. For char inputs, each row
%  is interpreted as a single number. Decimal points and exponents are
%  allowed as long as the result is an integer. For all other input types,
%  the input is simply passed on through to vpi to do the conversion.
%
%  num2vpi requires the following submissions from the FEX:
%
%  num2strexact:
%  http://www.mathworks.com/matlabcentral/fileexchange/22239-num2strexact-e
%  xact-version-of-num2str
%
%  vpi:
%  http://www.mathworks.com/matlabcentral/fileexchange/22725-variable-preci
%  sion-integer-arithmetic
%
%  For older versions of MATLAB, you will also need this submission:
%
%  typecast:
%  http://www.mathworks.com/matlabcentral/fileexchange/17476-typecast-c-mex
%  -function
%
%  Examples:
%
%  >> num2vpi(1e30)
%  ans =
%     1000000000000000019884624838656
%
%  >> num2vpi('1e30')
%  ans =
%     1000000000000000000000000000000
%
%  >> num2vpi(1e100)
%  ans =
%     100000000000000001590289110975991804683608085639452813897813275577478
%  38772170381060813469985856815104                                        
%
%  >> num2vpi('1e100')
%  ans =
%     100000000000000000000000000000000000000000000000000000000000000000000
%  00000000000000000000000000000000                                        
%
%  >> num2vpi(['1.234e5';...
%              '2000e-3';...
%              '4.57e10'])
%  ans =
%     123400
%     2
%     45700000000
%
%  >> num2vpi(uint64(realmax))
%  ans =
%     18446744073709551615
%
%  The main point to gather from the examples is that for a double or
%  single input, num2vpi uses the utility function num2strexact to get the
%  exact floating point bit pattern of the number and turn that into an
%  integer string. The resulting integer is whatever the exact bit pattern
%  converts into using exact power of 2 conversions. The char string input,
%  on the other hand, simply takes the base number and adds or removes 0's
%  based on the value of the exponent to get the integer string.
%
%  The convention for missing digits is that they are 0. For example, the
%  following are all equivalent:
%
%  num2vpi('e')
%  num2vpi('0e')
%  num2vpi('e0')
%  num2vpi('0e0')
%
%**************************************************************************

function v = num2vpi(x)

%--------------------------------------------------------------------------
% Check for errors
%--------------------------------------------------------------------------

if( nargin ~= 1 )
    error('Need exactly one numeric input');
end
if( nargout > 1 )
    error('Too many outputs');
end
if( isempty(x) )
    v = vpi(x);
    return
end

%--------------------------------------------------------------------------
% If single or double, use num2strexact to get exact conversion from the
% IEEE floating point bit pattern.
%--------------------------------------------------------------------------

if( isa(x,'single') || isa(x,'double') )
    if( any(isinf(x)) || any(isnan(x)) )
        error('vpi inputs cannot be inf or nan');
    end
    if( ~isreal(x) )
        error('Input cannot be complex');
    end
    try
        sx = num2strexact(x(:)); % Convert all the elements to exact strings
    catch
        error('num2strexact error ... have you downloaded it from the FEX yet?');
    end
    nx = numel(x);
    if( nx == 1 ) % For scalar input, output is char, so turn it into cell
        sx = {sx};
    end
    v = vpi(zeros(nx,1)); % Preallocate the vpi result
    for k=1:nx            % For each cell
        s = sx{k};
        p = find(s=='.'); % Find the decimal point
        e = find(s=='e'); % Find the exponent
        if( ~isempty(p) ) % Has a decimal point
            if( ~isempty(e) )  % Has a decimal point and an exponent
                n = str2double(s(e+1:end)); % Get the value of the exponent
                if( p + n >= e - 1 )  % If adding 0's gets you beyond exponent
                    s = [s(1:p-1) s(p+1:e-1) repmat('0',1,n-(e-p-1))]; % Add the 0's
                else  % Not enough 0's, so number is fractional, not an integer
                    error('vpi input must be integer');
                end
            else % Has decimal point but no exponent, so must be fractional, not integer
                error('vpi input must be integer');
            end
        else
            if( ~isempty(e) ) % No decimal point, but has an exponent, so must be integer
                n = str2double(s(e+1:end)); % Get the value of the exponent
                s = [s(1:e-1) repmat('0',1,n)]; % Add the 0's
            end
        end
        v(k) = vpi(s); % Turn the altered char string into a vpi result
    end
    v = reshape(v,size(x)); % Reshape the final array exactly like the input
    
%--------------------------------------------------------------------------
% If uint64, split the input up into two uint32 pieces and then construct
% the vpi result as an arithmetic result of those two pieces. This is
% necessary because vpi will handle uint32 inputs but not uint64 inputs.
%--------------------------------------------------------------------------

elseif( isa(x,'uint64') )
    umask = uint64(uint32(realmax)); % Word with lower 32 bits set
    ulower = uint32(bitand(x,umask)); % Pick off lower 32 bits of x
    uupper = uint32(bitshift(x,-32)); % Pick off upper 32 bits of x
    v = vpi(uupper) * vpi(2^32) + vpi(ulower); % Constuct vpi result in pieces
    
%--------------------------------------------------------------------------
% If int64, split the input up into two uint32 pieces and then construct
% the vpi result as an arithmetic result of those two pieces. This is
% necessary because vpi will handle uint32 inputs but not uint64 inputs.
%--------------------------------------------------------------------------

elseif( isa(x,'int64') )
    try
        u = typecast(x,'uint64'); % Turn input into unsigned so bit manipulation works
    catch
        error('typecast error ... have you downloaded it from the FEX yet?');
    end
    umask = uint64(uint32(realmax)); % Word with lower 32 bits set
    ulower = uint32(bitand(u,umask)); % Pick off lower 32 bits of u
    uupper = uint32(bitshift(u,-32)); % Pick off upper 32 bits of u
    v = vpi(uupper) * vpi(2^32) + vpi(ulower); % Construct vpi result in pieces
    m = (uupper >= uint32(2^31)); % Logical result indicating which elements are negative
    v = v - vpi(uint8(m)) * vpi(2^32)^2; % Fix up the negative elements, assume 2's complement
    
%--------------------------------------------------------------------------
% If logical, convert to uint8 first.
%--------------------------------------------------------------------------

elseif( isa(x,'logical') )
    v = vpi(uint8(x)); % vpi won't take logical, but it will take uint8
    
%--------------------------------------------------------------------------
% If char, treat each row as a single number string.
%--------------------------------------------------------------------------
    
elseif( isa(x,'char') )
    nx = size(x,1); % Get number of rows
    v = vpi(zeros(nx,1)); % Preallocate the vpi result
    for k=1:nx            % For each cell
        s = lower(x(k,:));
        s = s(~isspace(s));
        p = find(s=='.'); % Find the decimal point
        if( numel(p) > 1 )
            error('Invalid input, too many decimal points');
        end
        e = find(s=='e'); % Find the exponent
        if( numel(e) > 1 )
            error('Invalid input, too many exponents');
        end
        d = find(s=='d'); % Find the exponent
        if( numel(d) > 1 )
            error('Invalid input, too many exponents');
        end
        if( ~isempty(e) && ~isempty(d) )
            error('Invalid input, too many exponents');
        end
        if( isempty(e) )
            e = d;
        end
        if( p > e )
            error('Invalid input, decimal point appears after exponent');
        end
        if( ~isempty(p) ) % Has a decimal point
            if( ~isempty(e) )  % Has a decimal point and an exponent
                if( e+1 > length(s) ) % If exponent number is missing, use 0
                    n = 0;
                else
                    try
                        n = str2double(s(e+1:end)); % Get the value of the exponent
                        if( isnan(n) || isinf(n) || ~isreal(n) )
                            error('Invalid exponent value');
                        end
                    catch
                        error('Unable to read exponent value');
                    end
                end
                if( n < 0 ) % Exponent number is negative, so getting rid of digits
                    if( any(s(p+1:e-1)~='0') )
                        error('vpi input must be integer');
                    end
                    m = p + n;
                    if( m < 2 )
                        if( p > 1 )
                            if( s(1) == '+' || s(1) == '-' )
                                q = 2;
                            else
                                q = 1;
                            end
                            if( any(s(q:p-1)~='0') )
                                error('vpi input must be integer');
                            end
                        end
                        s = '0';
                    else
                        if( any(s(m:p-1)~='0') )
                            error('vpi input must be integer');
                        end
                        s = s(1:m-1);
                    end
                else
                    if( p + n >= e - 1 )  % If adding 0's gets you beyond end of digits
                        s = [s(1:p-1) s(p+1:e-1) repmat('0',1,n-(e-p-1))]; % Add the 0's
                    else
                        if( any(s(p+1+n:e-1)~='0') )
                            error('vpi input must be integer');
                        end
                        s = [s(1:p-1) s(p+1:p+n)]; % Add the 0's
                    end
                end
            else % Has decimal point but no exponent, so must be fractional, not integer
                if( any(s(p+1:end)~='0') ) % If any digits past decimal point are nonzero
                    error('vpi input must be integer');
                else
                    s = s(1:p-1);
                end
            end
        else
            if( ~isempty(e) ) % No decimal point, but has an exponent
                if( e+1 > length(s) ) % If exponent number is missing, use 0
                    n = 0;
                else
                    try
                        n = str2double(s(e+1:end)); % Get the value of the exponent
                        if( isnan(n) || isinf(n) || ~isreal(n) )
                            error('Invalid exponent value');
                        end
                    catch
                        error('Unable to read exponent value');
                    end
                end
                if( n < 0 ) % Exponent number is negative, so getting rid of digits
                    m = e + n;
                    if( m <= 0 )
                        if( any(s(1:e-1)~='0') ) % If getting rid of any nonzero digits
                            error('vpi input must be integer');
                        else % Only got rid of 0 digits, so OK
                            s = '0';
                        end
                    else
                        if( any(s(m:e-1)~='0') ) % If getting rid of any nonzero digits
                            error('vpi input must be integer');
                        else % Only got rid of 0 digits, so OK
                            s = s(1:m-1);
                        end
                    end
                else
                    s = [s(1:e-1) repmat('0',1,n)]; % Add the 0's
                end
            end
        end
        if( isempty(s) )
            v(k) = vpi(0); % Convention: empty string is same as 0
        else
            if( length(s) == 1 && ( s(1) == '+' || s(1) == '-' ) )
                v(k) = vpi(0);
            elseif( s(1) == '+' )
                v(k) = vpi(s(2:end)); % Turn the altered char string into a vpi result
            else
                v(k) = vpi(s); % Turn the altered char string into a vpi result
            end
        end
    end
    
%--------------------------------------------------------------------------
% All other input classes, just pass through and let vpi handle them.
%--------------------------------------------------------------------------
    
else % Pass through and let vpi handle all other classes
    v = vpi(x);
end

end
