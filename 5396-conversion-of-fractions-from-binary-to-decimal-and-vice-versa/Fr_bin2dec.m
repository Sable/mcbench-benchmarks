function [Fr_dec, str_Fr, Fr_bin] = Fr_bin2dec (bin)
% by Sundar Krishnan
% 2003, Edited in June, 2004
%
% Description :
% This function Fr_bin2dec.m will convert a POSITIVE Binary system
% Fraction (bin) to Decimal system Fraction Fr_dec.
% Matlab itself has bin2dec.m and dec2bin.m, but there seems to be
% no standard Matlab function when fractions are involved.
%
% This function Fr_bin2dec.m and it's companion / dual function Fr_dec2bin.m
% were developed mainly with a view to get  quick results
% while learning Arithmetic (Entropy) Coding in School.
% (Now, more comments have been added to better explain the programme.)
%
% The results of this function are limited in accuracy due to the
% "precision" used in the function num2str.m in addition to
% Floating Point limits and Rounding errors.
%
% Accumulation of errors due to these limits can be seen
% when Fr_bin2dec and Fr_dec2bin are tested back-to-back in pairs.
%
% After experiments, I observed that the best precision is 16. 
% If all the digits of the input bin are used for a pure fraction,
% the results are likely to be more accurate since we have more margin
% wrt the limit of 16 digits.
%
% Given below under "Usage Eg" are the many cases
% that have been tested during the development of this program,
% together with the results obtained in each case.
%
% Pl do forward me any new case that breaks the code 
% beyond the aforesaid limitations.
%
% Outputs str_Fr and Fr_bin are intermediate results.
%
% See also : function [Fr_bin, str_Fr, Fr_dec] = Fr_dec2bin (dec)
%
% Additional Test Cases involving pairs of dual tests
% are given towards the end of Fr_dec2bin.m
%
%                                   ********************
%
% Usage Eg : (The foll have been tried out.)
% [Fr_dec, str_Fr, Fr_bin] = Fr_bin2dec (.1010111)        %   0.67968750000000
% [Fr_dec, str_Fr, Fr_bin] = Fr_bin2dec (111.1010111)     %   7.67968750000000
% [Fr_dec, str_Fr, Fr_bin] = Fr_bin2dec (1110001.1010111) % 113.67968750000000
% [Fr_dec, str_Fr, Fr_bin] = Fr_bin2dec (1110001.1010111011111111)
%   = 1.136816406250000e+002  =  113.681640625
%   for what was started with Fr_dec2bin (113.68359374)
%   This is because the limits stop with str_Fr = 1110001.101011101 
%
% [Fr_dec, str_Fr, Fr_bin] = Fr_bin2dec (1010101.0000111) %  85.05468750000000
%
% [Fr_dec, str_Fr, Fr_bin] = Fr_bin2dec (10000010101.000000111)
%   gives Fr_dec = 1045, not 1045.013671875 due to 16 digits' limitation.
%
% [Fr_dec, str_Fr, Fr_bin] = Fr_bin2dec (0.000000111)     % 0.013671875
% [Fr_dec, str_Fr, Fr_bin] = Fr_bin2dec (.000000111)
%
% [Fr_dec, str_Fr, Fr_bin] = Fr_bin2dec (1.000000111)     % 1.013671875
% [Fr_dec, str_Fr, Fr_bin] = Fr_bin2dec (100.000000111)   % 4.013671875
%
% [Fr_dec, str_Fr, Fr_bin] = Fr_bin2dec (100.010101111)   % 4.341796875
% [Fr_dec, str_Fr, Fr_bin] = Fr_bin2dec (0.010101111)     % 0.341796875
%
% [Fr_dec, str_Fr, Fr_bin] = Fr_bin2dec (10000010101.100000111)
%   gives Fr_dec = 1045.5, not 1045.513671875 due to 16 digits' limitation.
%
% [Fr_dec, str_Fr, Fr_bin] = Fr_bin2dec (0.100000111)     % 0.513671875
% [Fr_dec, str_Fr, Fr_bin] = Fr_bin2dec (.100000111)
%
% [Fr_dec, str_Fr, Fr_bin] = Fr_bin2dec (0.0000111)       % 0.5546875
% [Fr_dec, str_Fr, Fr_bin] = Fr_bin2dec (.0000111)
%
% [Fr_dec, str_Fr, Fr_bin] = Fr_bin2dec (10000010101.0010000111)
%   gives Fr_dec = 1045.125, not 1045.1318359375 due to 16 digits' limit.
%
% [Fr_dec, str_Fr, Fr_bin] = Fr_bin2dec (0.0010000111)    % 0.1318359375
% [Fr_dec, str_Fr, Fr_bin] = Fr_bin2dec (.0010000111)
%
% [Fr_dec, str_Fr, Fr_bin] = Fr_bin2dec (.00000001)       % 0.00390625
% [Fr_dec, str_Fr, Fr_bin] = Fr_bin2dec (11.00000001)     % 3.00390625
%
% [Fr_dec, str_Fr, Fr_bin] = Fr_bin2dec (101110101011.00011111)
%   gives Fr_dec = 2987.0625 for what was started with Fr_dec2bin (2987.120089)
%   See below in "Check in pairs".
%
% [Fr_dec, str_Fr, Fr_bin] = Fr_bin2dec (101110101011.0001) % 2987.0625
% [Fr_dec, str_Fr, Fr_bin] = ...
%   Fr_bin2dec (1000101100111001010000111111011.0001111010111110)
%       gives Fr_dec = 1.167884288000000e+009 = 1167884288
%       for what was started with Fr_dec2bin (1167892987.120089)
%
% [Fr_dec, str_Fr, Fr_bin] = Fr_bin2dec (1000101100111001000000000000000.)
%  also gives Fr_dec = 1.167884288000000e+009 = 1167884288
%
%                                       &&&&&&&&&&&&
%
% Usage Eg : Check in pairs :
% Fr_bin = Fr_dec2bin (1.044125000000000e+003)  % = 10000010100.001
% Fr_dec = Fr_bin2dec (10000010100.001)         % = 1.044125000000000e+003
% Fr_dec = Fr_bin2dec (10000010100.0010000111)  % = 1.044125000000000e+003
% Fr_dec = Fr_bin2dec ( Fr_dec2bin (1.044125000000000e+003) )
%   returns the same Fr_dec = 1.044125000000000e+003
%
% Fr_dec = Fr_bin2dec ( Fr_dec2bin (2987.120089) )
%   returns Fr_dec = 2987.120086669922 instead of the expected 2987.120089
%
% Fr_dec = Fr_bin2dec ( Fr_dec2bin (2987.0625) )
%   returns the same Fr_dec = 2987.0625
%

%                                   ********************

% 1) Inits :
Fr_dec = 0 ;
exp_power  = 0 ;

%                                       &&&&&&&&&&&&

% 2) Use num2str to convert the input to string :
%
% After experiments, I observed that the best precision is 16. 
% For eg, with precision >= 17,
% str_Fr = num2str ( .1010111, 17 )  =  0.10101110000000001
% str_Fr = num2str ( .1010111, 16 )  =  0.1010111
%
% num2str.m's output will also contain "0" prefix before the decimal dot "."
% which we remove later.

% 2-a) Check if the input is greater than 1.
% If yes, can we use higher precision ?
% NO, I have found problems with precision > 16 even when the input  > 1 !
% So, commenting out the foll code, and retaining precision = 16 only.
% str_Fr = num2str (bin) ;
% if str_Fr > 1
%     precision = 48 ;
% else
%     precision = 16 ;
% end

precision = 16 ;            % See the note above.
str_Fr = num2str (bin, precision) ;
% Some egs of bin = 1110.1010111 , 111000.1010111 ,  1.11e-005

% NOTE : For long input dec strings, pl note that even with precision > 16,
% say, with precision = 48, the input is converted to exp format
% by taking only 15 decimals after the dot.
% For eg, if bin = 100110100001101001100100.0010000111,
% the whole integer part is taken as 1.001101000011010e+023
% So, this will by itself creep in errors !

%                                       &&&&&&&&&&&&

% 3) Now, if str_Fr above is in exp format, as for eg,
% '1.11e-005', we would like to get it in the form = 0.0000111
%
% I have observed that if the input no < 0.0001 (ie, < 0.0001000...)
% num2str.m's output is in the exp form ie, with powers less than e-005.
% For eg, dec = 0.000100000001 gives str_Fr = 0.000100000001
% But dec = 0.0000999999999999 gives str_Fr = 9.9999999999900001e-005
%
% Also, with precision = 16, num2str.m's output for nos > 1, upto 1.0e+015,
% is WITHOUT the exp form of power. For eg,
% with dec = 999999999999999.9999999999999999
% str_Fr = num2str (dec, 16)    % gives = 1.0e+015 = 1 0000 0000 0000 000
%
% For nos > 1e+015, num2str.m's output is in exp form.

if ~isempty ( findstr ( str_Fr, 'e') )
    
    exp_power = 0 ;
    [str_Fr_Bef_Exp, exp] = strtok ( str_Fr, 'e' ) ;
        % Some egs : str_Fr_Bef_Exp = 1.119996810555458,   exp = e-005
        
    [exp_power, ign ] = strtok ( exp, 'e' ) ;
        % exp starts with 'e', hence see LHS
        
    exp_power = abs ( str2num (exp_power) ) ;
    
    % Remove the dot at the 2nd place : (as in 1.119996810555458)
    % However, there is no dot when it's a pure fraction,
    % and is an exact submultiple of 2 !
    if length (str_Fr_Bef_Exp) >= 2  ;
        str_Fr_Bef_Exp (2) = [] ;
    end
    
    
    if exp (2) == '-'           % < 1e-005
        for k = 1 : exp_power - 1
            str_Fr_Init_Zeros(k) = '0' ;
        end
        
        str_Fr = strcat (  '0.', str_Fr_Init_Zeros, str_Fr_Bef_Exp ) ;

        
    elseif exp (2) == '+'       % > 1.0e+015
        
        str_Fr = str_Fr_Bef_Exp ;
        
        % Normally, the foll "if" loop should not be necessary
        % since exp format does not occur for powers <= 1.0e+015. Still ...
        if length ( str_Fr ) > exp_power + 1
            
            str_Fr ( end + 1 ) = str_Fr (end) ;
            
            for j = length (str_Fr) - 1  :  -1 :  ...
                    length (str_Fr) - (exp_power + 1) + 1
                
                str_Fr ( j ) = str_Fr (j-1) ;
            end
            
            str_Fr (exp_power + 2) = '.' ;
            
        end
        
        % Foll logic when exp_power > 1.0e+015, like for eg,
        % str_Fr = '1.0450137e+018'
        % implies str_Fr_Bef_Exp = 10450137 (length = 8)
        % ie, str_Fr should become 10450137 0000 0000 000 (length = 19)
        % ie, padding with 0s at the end is reqd.
        if length ( str_Fr ) < exp_power
            str_Fr = strcat ( str_Fr,  ...
                repmat ( ['0'], 1, exp_power - (length ( str_Fr ) - 1) ) ) ;
        end
        
    end
    
end

%                                       &&&&&&&&&&&&

% 4) Separate the whole integer and fraction parts of str_Fr.
[bef_dec, Fr_bin] = strtok ( str_Fr, '.' ) ;

%                                       &&&&&&&&&&&&

% Now, we have bef_dec as the whole integer part, and
% the Fractional part starting "."

% 5) Convert first the whole integer part to decimal
% by calling the std Matlab's fn bin2dec.m
Fr_dec = bin2dec (bef_dec) ;

%                                       &&&&&&&&&&&&

% 6) Now, finally, deal with the Fractional Part.
% The Fractional Part should start here with the dot :
len_strFr = length (Fr_bin) ;
% eg of Fr_bin = '.10101010'  or  = '.000000001'

for i = 2 : len_strFr       % Note that the 1st char is the decimal dot !
    Fr_dec = Fr_dec + 2^(-i+1) * str2num( Fr_bin(i) ) ;
end

% Fr_dec

% class_Fr_dec = class(Fr_dec)        % = double (Note)
% But note that the dual function :
% Fr_bin = Fr_dec2bin (dec) returns a string (char) !

%                                   ********************

% Additional Test Cases involving pairs of dual tests
% are given towards the end of Fr_dec2bin.m

%                                   ********************
