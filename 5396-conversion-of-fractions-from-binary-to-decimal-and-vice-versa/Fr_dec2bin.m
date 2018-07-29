function [Fr_bin, str_Fr, Fr_dec] = Fr_dec2bin (dec)
% by Sundar Krishnan
% 2003, Edited in June, 2004
%
% Description :
% This function Fr_dec2bin.m will convert a POSITIVE Decimal system
% Fraction (dec) to Binary system Fraction Fr_bin.
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
% Outputs str_Fr and Fr_dec are intermediate results.
%
% See also : [Fr_dec, str_Fr, Fr_bin] = Fr_bin2dec (bin)
%
% Additional Test Cases involving pairs of dual tests
% are given towards the end.
%
%                                   ********************
%
% Usage Eg : (The foll have been tried out.)
% [Fr_bin, str_Fr, Fr_dec] = Fr_dec2bin (0.6796875)         % 0.1010111
% [Fr_bin, str_Fr, Fr_dec] = Fr_dec2bin (113.6796875)       % 1110001.1010111
% [Fr_bin, str_Fr, Fr_dec] = Fr_dec2bin (113.68359374)
%   = 1110001.10101110111111111
% [Fr_bin, str_Fr, Fr_dec] = Fr_dec2bin (1045.013671875)
%   = 10000010101.000000111
%
% [Fr_bin, str_Fr, Fr_dec] = Fr_dec2bin (0.013671875)       % 0.000000111
% [Fr_bin, str_Fr, Fr_dec] = Fr_dec2bin (0.0000131835937)
% [Fr_bin, str_Fr, Fr_dec] = Fr_dec2bin (10099300.131835937)
%   = 100110100001101001100100.0010000111000000
% [Fr_bin, str_Fr, Fr_dec] = Fr_dec2bin (1.0450137e+018)
%
% Also try this ! and enjoy the result :
% [Fr_bin, str_Fr, Fr_dec] = Fr_dec2bin (1.0450137e+100)
%
% [Fr_bin, str_Fr, Fr_dec] = Fr_dec2bin (2987.120089)
%   % = 101110101011.0001111010111110
% [Fr_bin, str_Fr, Fr_dec] = Fr_dec2bin (1167892987.120089)
%   % = 1000101100111001010000111111011.0001111010111110
%
%                                       &&&&&&&&&&&&
%
% Usage Eg : Check in pairs :
% Fr_dec = Fr_bin2dec (10000010100.0010000111)  % = 1.044125000000000e+003
% Fr_bin = Fr_dec2bin (1.044125000000000e+003)  % = 10000010100.001
% Fr_bin = Fr_dec2bin ( Fr_bin2dec (10000010100.0010000111) )
%   returns Fr_bin = 10000010100.001
%
% Fr_bin = Fr_dec2bin ( Fr_bin2dec (101110101011.00011111) )
%   returns Fr_bin = 101110101011.0001 (corr to 2987.0625)
%   instead of the expected (same) 101110101011.00011111
%
% Fr_bin = Fr_dec2bin ( Fr_bin2dec ...
%          (1000101100111001010000111111011.0001111010111110) )
%   returns Fr_bin = 1000101100111001000000000000000.00000000000000000
%   (corr to 1167884288)
%   instead of the expected (same)
%   1000101100111001010000111111011.0001111010111110
%   which itself was obtained with Fr_dec2bin (1167892987.120089)
%
% Fr_bin = Fr_dec2bin ( Fr_bin2dec (101110101011.0001111010111110) )
%   returns Fr_bin = 101110101011.0001 (corr to 2987.0625)
%   instead of the expected (same) 101110101011.0001111010111110
%   which itself was obtained with Fr_dec2bin (2987.120089)
%
%
%                                   ********************

% 1) Inits :
Fr_bin = 0 ;
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
% str_Fr = num2str (dec) ;
% if str_Fr > 1
%     precision = 48 ;
% else
%     precision = 16 ;
% end

precision = 16 ;            % See the note above.
str_Fr = num2str (dec, precision) ;
% Some egs of dec = 1045.0137 , 1.0450137e+018 , 0.131835937 , 0.0000131835937

% NOTE : For long input dec strings, pl note that even with precision > 16,
% say, with precision = 48, the input itself is accurately read
% only for the first 16 digits ; or, if it is converted to an exp format,
% then the input is accurately read only till 15 decimals after the dot.
% For eg, if dec = 116789292349873465787.120089,
% the whole integer part is taken as :
% 116789292349873470000 = % 1.1678929234987347e+016
% So, this will by itself creep in errors !

% In general, it is observed errors will creep in
% if the whole integer part > 999999999999999

%                                       &&&&&&&&&&&&

% 3) Now, if str_Fr above is in exp format, as for eg,
% '2.987062500000000e+003', we would like to get it in the form = 2987.0625
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
% For nos > 1e+016, num2str.m's output is in exp form.

if ~isempty ( findstr ( str_Fr, 'e') )
    
    exp_power = 0 ;
    [str_Fr_Bef_Exp, exp] = strtok ( str_Fr, 'e' ) ;
        % Some egs = str_Fr_Bef_Exp = 1.119996810555458,   exp = e-005
        
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
[bef_dec, Fr_dec] = strtok ( str_Fr, '.' ) ;

%                                       &&&&&&&&&&&&

% Now, we have bef_dec as the whole integer part, and
% the Fractional part starting "."

% 5) Convert first the whole integer part to binary
% by calling the std Matlab's fn dec2bin.m
bef_bin = dec2bin ( str2num (bef_dec) ) ;

%                                       &&&&&&&&&&&&

% 6) Now, finally, deal with the Fractional Part.

len_strFr = length (Fr_dec) ;
% eg of Fr_dec = '.123456789'  or  = '.000000001'  or  = '.12402343750000'

% The Fractional Part Fr_bin should start here with the dot :
% We will later concatenate bef_bin and Fr_bin
%
% Note : The part about the Fractional Part Fr_bin is not as starightforward
% as the Fractional part Fr_dec in the dual file Fr_bin2dec.m
% It is more complex due to the fact that we need to find the decreasing
% powers of 2 that will match with Fr_dec.

Fr_bin = '.' ;

Fr_dec_Current = str2num (Fr_dec) ;

for k = 1 : 16
    if Fr_dec_Current  >=  2^(-k)
        % Fr_bin = strcat ( Fr_bin,  repmat (['0'], 1, k - length(Fr_bin)), ...
        %     '1'  ) ; % Old round about code, but it seems it still works !
        Fr_bin = strcat ( Fr_bin,  '1'  ) ;
        
        Fr_dec_Current = Fr_dec_Current - 2^-(k) ;
        
        % Don't go beyond the pt where the current decremented balance
        % is 0 or negative. This will happen if input dec is <= 2^(-16) !
        if Fr_dec_Current <= 0    % Uncomment foll when you want to see details
            % fprintf ( '\n **********  Fr_dec_Current <= 0  ********** \n' ) ;
            % fprintf ( '\n *******  Pausing ... Prees any Key  ******* \n' ) ;
            % pause
            break ;
        end

    else
        % Fr_bin = strcat ( Fr_bin,  repmat (['0'], 1, k - length(Fr_bin)), ...
        %     '0'  ) ; % Old round about code, but it seems it still works !
        Fr_bin = strcat ( Fr_bin,  '0'  ) ;
    end
    
end % for k = 1 : 16

% k, Fr_bin, Fr_dec_Current     % Uncomment for testing

% Note that since precision is set to 16, the limit in our code is :
% 2^(-16) = 0.0000152587890625
% So, if a fraction is less than 2^(-16), we will have Fr_bin = "."
% at this point.

%                                       ++++++++++++

% 6-b) Also, check at the next level 2^(-k-1) ie, beyond the above k
% to add 1 at the end if Fr_dec_Current >= the half mark.!
% At the limit of k = 16 above, 2^(-17) = 0.00000762939453125

% However, we need to take caution if the no is lower than 2^(-16)
% in which case Fr_bin at this point, would be just '.0000000000000000'

if length(Fr_bin) == 17  &  all ( Fr_bin == '.0000000000000000' )
% Note for R13 : If short-circuiting double && were used (not in R12),
% the 2nd expr will NOT be evaluated if the 1st is false
% ie, if false AND X is always false, so X is not computed.

% However, it is observed that even with this single &,
% the 2nd expr is not computed if the 1st expr is false.

    if Fr_dec_Current >= 2^-(17)
        % Fr_bin = strcat ( Fr_bin,  repmat ( ['0'], 1, 16 ),  '1'  ) ; % Old
        Fr_bin = strcat ( Fr_bin,  '1'  ) ;
        
        Fr_dec_Current = Fr_dec_Current - 2^-(17) ;
        if Fr_dec_Current  >=  2^(-18)
            Fr_bin = strcat (  Fr_bin, '1' ) ;
        end
        
    else
        % Fr_bin = strcat ( Fr_bin,  repmat ( ['0'], 1, 17 ),  '1'  ) ;  % Old
        Fr_bin = strcat ( Fr_bin,  '0'  ) ;
        
        Fr_dec_Current = Fr_dec_Current - 2^-(18) ;
        if Fr_dec_Current  >=  2^(-19)
            Fr_bin = strcat (  Fr_bin, '1' ) ;
        end
    end
    
elseif Fr_dec_Current  >=  2^(-k-1)
    % At this point, normally, k should be 16
    % unless at some point above, Fr_dec_Current <= 0
    Fr_bin = strcat (  Fr_bin, '1' ) ;
    % fprintf ( '\n      ************  Last 1 added.  ************ \n' ) ;
end

%                                       &&&&&&&&&&&&

% 7) Concatenate the whole integer part and the fraction parts.
Fr_bin = strcat ( bef_bin, Fr_bin ) ;

% Fr_bin

% class_Fr_bin = class(Fr_bin)        % = char (Note)
% But note that the dual function :
% Fr_dec = Fr_bin2dec (bin) returns a double !


%                                   ********************

% 8) Some additional Test Cases :

% dec < 2^(-16) = 0.0000152587890625 (nearer to 2^-16 than 2^-17)
% [Fr_bin, str_Fr, Fr_dec] = Fr_dec2bin (0.0000131835937) 
%   = 0.000000000000000011 (16 0s, 1, 1)
%
% Fr_bin = Fr_dec2bin ( Fr_bin2dec ( 0.000000000000000011 ) )
%   = 0.000000000000000011 (16 0s, 1, 1)
% Fr_bin2dec ( 0.000000000000000011 ) = 0.000011444091796875
% (= 2^-17 + 2^-18)         in place of 0.0000131835937

%                                       ++++++++++++

% dec < 2^(-16) = 0.0000152587890625 (nearer to 2^-17 than 2^-16)
% [Fr_bin, str_Fr, Fr_dec] = Fr_dec2bin (0.0000101835937)
%   = 0.00000000000000001  (16 0s, 1)
%
% Fr_bin = Fr_dec2bin ( Fr_bin2dec ( 0.00000000000000001 ) )
%   = 0.00000000000000001  (16 0s, 1)
% Fr_bin2dec ( 0.00000000000000001 ) = 0.00000762939453125
% (= 2^-17)                in place of 0.0000101835937


%                                       ++++++++++++

% Midway betn 2^-17 and 2^-18 = 0.0000057220458984375
% dec < 2^(-17) = 0.00000762939453125   (nearer to 2^-18 than 2^-17)
% [Fr_bin, str_Fr, Fr_dec] = Fr_dec2bin (0.0000056835937)
%   = 0.00000000000000000 (17 0s)
%     
% Fr_bin = Fr_dec2bin ( Fr_bin2dec ( 0.00000000000000000 ) )
%   = 0.00000000000000000 (17 0s)
% Fr_bin2dec ( 0.00000000000000000 ) = 0.0
%                          in place of 0.0000056835937


%                                       ++++++++++++

% dec < 2^(-17) = 0.00000762939453125   (nearer to 2^-17 than 2^-18)
% [Fr_bin, str_Fr, Fr_dec] = Fr_dec2bin (0.0000070835937)
%   = 0.000000000000000001 (17 0s, 1)
%
% Fr_bin = Fr_dec2bin ( Fr_bin2dec ( 0.000000000000000001 ) )
%   = 0.000000000000000001 (17 0s, 1)
% Fr_bin2dec ( 0.000000000000000001 ) = 0.000003814697265625
% (= 2^-18)                 in place of 0.0000070835937


%                                       ++++++++++++

% dec < 2^(-17) = 0.00000762939453125   (nearer to 2^-18 than 2^-17)
% [Fr_bin, str_Fr, Fr_dec] = Fr_dec2bin (0.0000039935937)
%   = 0.00000000000000000  (17 0s)
%
% Fr_bin = Fr_dec2bin ( Fr_bin2dec ( 0.00000000000000000 ) )
%   = 0.00000000000000000 (17 0s)
% Fr_bin2dec ( 0.00000000000000000 ) = 0.0
%                          in place of 0.0000039935937
%                          in place of anything < (2^-17 - 2^-19)
%                          ie, < Midway betn 2^-17 and 2^-18
%                          ie, < 0.0000057220458984375

%                                       ++++++++++++

% dec = 0.00001652587890625  very slightly >  2^(-16) = 0.0000152587890625
% [Fr_bin, str_Fr, Fr_dec] = Fr_dec2bin (0.00001652587890625)
%   = 0.0000000000000001   (15 0s, 1)
%
% Fr_bin = Fr_dec2bin ( Fr_bin2dec ( 0.0000000000000001 ) )
%   = 0.0000000000000001   (15 0s, 1)
% Fr_bin2dec ( 0.0000000000000001 ) = 0.0000152587890625
%                         in place of 0.00001652587890625


%                                       ++++++++++++

% [Fr_bin, str_Fr, Fr_dec] = Fr_dec2bin (999 + 2^-11 + 2^-9)
%   = 1111100111.00000000101
%
% Fr_bin = Fr_dec2bin ( Fr_bin2dec ( 1111100111.00000000101 ) )
%   = 1111100111.00000000000000000
%
% Fr_bin2dec ( 1111100111.00000000101 ) = 999
% [Fr_dec, str_Fr, Fr_bin] = Fr_bin2dec ( 1111100111.00000000101 )
% gives Fr_dec = 999 in place of 999.00244140625 ,
% str_Fr = 1111100111 and an empty Fr_bin 
% because of the precision = 16 limit !
%
% However, Fr_bin2dec ( .00000000101 ) = 0.00244140625
% This shows that if the all the digits of the input bin are used
% for a pure fraction, the results are likely to be more accurate
% since we have more margin wrt the limit of 16 digits.

%                                       ++++++++++++

% [Fr_bin, str_Fr, Fr_dec] = Fr_dec2bin (879.0010365625)
%   = 1101101111.00000000010000111
%
% Fr_bin = Fr_dec2bin ( Fr_bin2dec ( 1101101111.00000000010000111 ) )
%   = 1101101111.00000000000000000
% Fr_bin2dec ( 1101101111.00000000010000111 ) = 879
%                                   in place of 879.0010365625

%                                       ++++++++++++

% [Fr_bin, str_Fr, Fr_dec] = Fr_dec2bin (879.0012765625)
%   = 1101101111.00000000010100111
%
% Fr_bin = Fr_dec2bin ( Fr_bin2dec ( 1101101111.00000000010100111 ) )
%   = 1101101111.00000000000000000
% Fr_bin2dec ( 1101101111.00000000010100111 ) = 879
%                                   in place of 879.0012765625

%                                       ++++++++++++

%                                   ********************

% 9) Some useful values :
% (Pl note that the char length below in each line may cross 80 chars !
% But wrapping will not look nice nor easy to understand !)
%
% 2^-9    = 0.001953125
% 2^-10   = 0.0009765625
% 2^-11   = 0.00048828125
% 2^(-14) = 0.00006103515625
% 2^(-15) = 0.000030517578125
% 2^(-16) = 0.0000152587890625
% 2^(-17) = 0.00000762939453125
% 2^(-18) = 0.000003814697265625
% 2^(-19) = 0.0000019073486328125
%
% The pgm was tested with these values during development.
% These values can be spot-tested by testing the result of Fr_dec2bin ( dec). For eg :
% Fr_dec2bin ( 0.000285828865257397324183692319802554 ) ; = 0.00000000000100101
%
% Test Base = 2^(-15) :
% 2^(-15) + 2^(-16)    = 0.0000457763671875                         0.0000000000000011
%
% 2^(-15) + 2^(-16.9)  = 0.0000386945607188132718216934686662547    0.00000000000000101
% 2^(-15) + 2^(-17)    = 0.00003814697265625                        0.00000000000000101
% 2^(-15) + 2^(-17.1)  = 0.0000376360549281067460325725041667934    0.0000000000000010
%
% 2^(-15) + 2^(-18)    = 0.000034332275390625                       0.0000000000000010
% 2^(-15) + 2^(-18.01) = 0.0000343059253518563686429336937594913    0.0000000000000010
% 2^(-15)              = 0.000030517578125


% Test Base = 2^(-14) :
% 2^(-14) + 2^(-15)    = 0.000091552734375                          0.000000000000011
% 2^(-14) + 2^(-15.1)  = 0.0000895090634624269841302900166671735    0.00000000000001011
%
% 2^(-14) + 2^(-15.55) = 0.0000826143426875777442749281116365005    0.0000000000000101
% 2^(-14) + 2^(-16)    = 0.0000762939453125                         0.0000000000000101
%
% 2^(-14) + 2^(-16.55) = 0.0000714572163143493310459230799506385    0.00000000000001001
% 2^(-14) + 2^(-17)    = 0.00006866455078125                        0.00000000000001001
%
% 2^(-14) + 2^(-18)    = 0.000064849853515625                       0.0000000000000100
% 2^(-14) + 2^(-18.01) = 0.0000648235034768563686429336937594913    0.0000000000000100
% 2^(-14)              = 0.00006103515625                           0.00000000000001


% Test Base = 2^(-13) :

% 2^(-13) + 2^(-14)    = 0.00018310546875                           0.00000000000011
% 2^(-13) + 2^(-14.01) = 0.00018268386812970189828693910015186      0.00000000000010111
% 2^(-13) + 2^(-14.1)  = 0.000179018126924853968260580033334347     0.00000000000010111
% 2^(-13) + 2^(-14.45) = 0.000166750662107715619528003885783119     0.00000000000010101
%
% 2^(-13) + 2^(-14.75) = 0.000158362033538901399741134642656265     0.0000000000001010
% 2^(-13) + 2^(-15)    = 0.000152587890625                          0.000000000000101
%
% 2^(-13) + 2^(-15.75) = 0.000140216173019450699870567321328132     0.0000000000001001
% 2^(-13) + 2^(-16)    = 0.0001373291015625                         0.0000000000001001
% 2^(-13)              = 0.0001220703125                            0.0000000000001


% Test Base = 2^(-12) :
% 2^(-12) + 2^(-13)    = 0.0003662109375                            0.0000000000011
% 2^(-12) + 2^(-13.55) = 0.000327517105514794648367384639605108     0.0000000000010101
%
% 2^(-12) + 2^(-14)    = 0.00030517578125                           0.00000000000101
% 2^(-12) + 2^(-14.55) = 0.000285828865257397324183692319802554     0.00000000000100101
%
% 2^(-12) + 2^(-15)    = 0.000274658203125                          0.000000000001001
% 2^(-12)              = 0.000244140625                             0.000000000001


% Test Base = 2^(-1) :
% 2^(-1) + 2^(-16)     = 0.5000152587890625                         0.1000000000000001
% 2^(-1) + 2^(-16.1)   = 0.500014236953606213492065145008334        0.10000000000000001

% 2^(-1) + 2^(-16.9)   = 0.500008176982593813271821693468666        0.10000000000000001
% 2^(-1) + 2^(-17)     = 0.50000762939453125                        0.10000000000000001
% 2^(-1) + 2^(-17.1)   = 0.500007118476803106746032572504167        0.1000000000000000 

% 2^(-1) + 2^(-17.99)  = 0.500003841230583407283053713600975        0.1000000000000000
% 2^(-1) + 2^(-18)     = 0.500003814697265625                       0.1000000000000000
% 2^(-1) + 2^(-18.01)  = 0.500003788347226856368642933693759        0.1000000000000000
% 2^(-1)               = 0.5                                        0.1


% Test Base = 2^(-16) :
% 2^(-16) + 2^(-16.99) = 0.0000229412502293145661074272019509372    0.00000000000000011
% 2^(-16) + 2^(-17)    = 0.00002288818359375                        0.00000000000000011
% 2^(-16) + 2^(-17.01) = 0.0000228354835162127372858673875189825    0.0000000000000001
%
% 2^(-16) + 2^(-17.99) = 0.0000191000196459072830537136009754686    0.0000000000000001
% 2^(-16) + 2^(-18)    = 0.000019073486328125                       0.0000000000000001
% 2^(-16) + 2^(-18.01) = 0.0000190471362893563686429336937594913    0.0000000000000001
%
% 2^(-16) + 2^(-19)    = 0.0000171661376953125                      0.0000000000000001
% 2^(-16)              = 0.0000152587890625                         0.0000000000000001

% Test Base = 2^(-17) :
% 2^(-17)              = 0.00000762939453125                        0.00000000000000001

% Test Base = 2^(-18) :
% 2^(-18)              = 0.000003814697265625                       0.0000000000000000

% Midway betn 2^-17 and 2^-18  =  0.0000057220458984375 is just above 0 ;
% 0.0000057220458984375  is the limit for this set of programmes.
% Anything < (2^-17 - 2^-19) ie, anything < 0.0000057220458984375 is 0.
%
%                                   ********************
