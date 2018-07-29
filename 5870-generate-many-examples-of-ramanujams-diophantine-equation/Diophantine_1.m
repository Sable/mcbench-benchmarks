function [ x, y,  u, v,  N, LHS, RHS,  r,   a, b, c, d,   a2, b2, c2, d2,   ...
           Z_Real, Z_Imag,   Gxy, Guv, G_Gxy_Guv,   Gab, Gcd,               ...
           str_N_odd_even, str_b_d,   Calc_Error, error_Limit ] =           ...
           Diophantine_1 ( X_Real, X_Imag,  Y_Real, Y_Imag,  Ga2b2, Gc2d2,  ...
                           str_Det_fprt_Init ) 
%
% Subject  : A programme to generate more examples of Ramanujam's
%            Diophantine Equation Numbers
% Release  : R13
% Author   : Sundar Krishnan
% email id : sundark100@yahoo.com
% Date     : Read the article MATHEMATICAL MINIATURE 9.pdf in Aug 2003 ;
%            Skeleton Trial Programmes in Sep 2003 ;
%            Revisit and Fine Tuning in Sep 2004
%
% Introduction :
% --------------
% This programme is about finding many examples of Ramanujam's
% Diophantine Equation.
% For mathematical formulas used in making this programme, I have referred
% to the article MATHEMATICAL MINIATURE 9.pdf
% by John Butcher, butcher@math.auckland.ac.nz.
%
% To circumvent the problem of editing the Greek symbols, I have replaced
% them with suitable alphabets.
%
% The basic equation we are trying to solve is to get the numbers :
% x & y and u & v and N that satisfy the Diophantine equation :
% x^3 + y^3 = u^3 + v^3 = N
% where the four integers x, y, u, v have no common factor.
%
% For eg, the "lowest" Diophantine Number N of Ramanujam is :
% 1729 = 9^3 + 10^3 = 1^3 + 12^3          % see Usage Eg 1 below
%
% Other examples given in Butcher's article are :
%  9^3 + 15^3    =  2^3 + 16^3 =  4104    % see Usage Eg 3 below
% 33^3 + 15^3    =  2^3 + 34^3 = 39312    % see Usage Eg 4 below
%  6^3 + (-3)^3  =  5^3 + 4^3  =   189    % see Usage Eg 5 below
% (ie, 3^3 + 4^3 + 5^3 = 6^3)
%
% All these examples are covered in the various Usage Examples given below.
%
%                                    &&&&&&&&&&&&&&
%
% Derivation of Formulae, Notations followed and Step by Step Procedure :
% -----------------------------------------------------------------------
%
% If N is even, let us have :
% a2 = (x + y) / 2 ;    b2 = (x - y) / 2        % a', b' in the article
% c2 = (u + v) / 2 ;    d2 = (u - v) / 2        % c', d' in the article
%
% If N is odd, let us have :
% a2 = (x + y) ;        b2 = (x - y)
% c2 = (u + v) ;        d2 = (u - v)
%
% gcd (x, y,  u, v) = 1 => gcd (a2, b2,  c2, d2) = 1  % Theoretical Concept 1
%
% Let gcd (a2, b2) = Ga2b2                      % Myu  in the article
% and gcd (c2, d2) = Gc2d2                      % Veta in the article
%
% Note that gcd ( Ga2b2, Gc2d2 ) = 1                    % FULCRUM 1
%
% a = a2 / ( Ga2b2 * Gc2d2^3 ) ;    b = b2 / Ga2b2
% c = c2 / ( Gc2d2 * Ga2b2^3 ) ;    d = d2 / Gc2d2
%
%                                       ++++++++
%
% X_Mag  =  X_Real +  j * (sqrt(3) * X_Imag) ;        X_Sq  =  X_Mag^2 ;
%
% Y_Mag  =  Y_Real +  j * (sqrt(3) * Y_Imag) ;        Y_Sq  =  Y_Mag^2 ;
%
% Z_Mag  =  Z_Real +  j * (sqrt(3) * Z_Imag) ;        Z_Sq  =  Z_Mag^2 ;
%
% My interpretation : Initially assume the ratio "r" as 1 ;
% later, adjust r to get b and d as whole numbers.      % Logical Concept 1
% a = r * Y_Sq ;        c = r * X_Sq ;
%
% The "tricky" part here is to first assume r = 1
% and solve for Z_Real and Z_Imag using these 2 eqs.
% Gc2d2^3 * ( Y_Real^2 + 3 * Y_Imag^2 ) * r  =  ...
%     X_Real * Z_Real - 3 * X_Imag * Z_Imag
%
% Ga2b2^3 * ( X_Real^2 + 3 * X_Imag^2 ) * r  =  ...
%    Y_Real * Z_Real - 3 * Y_Imag * Z_Imag 
%
% ie, in matrix form, solve for Z_Real and Z_Imag :
% [ X_Real,  - 3 * X_Imag ;    Y_Real,  - 3 * Y_Imag ] * [ Z_Real ;  Z_Imag ]
% = [ Gc2d2^3 * ( Y_Real^2 + 3 * Y_Imag^2 ) * r ;
%     Ga2b2^3 * ( X_Real^2 + 3 * X_Imag^2 ) * r ] 
%
% Obtain b and d from :
% Gc2d2^6 * a^2  +  3 * b^2  =  X_Sq * Z_Sq 
%
% Ga2b2^6 * c^2  +  3 * d^2  =  Y_Sq * Z_Sq 
%
% Then, choose r in a way as to convert b and d to whole numbers.
% Also, correct a and c to reflect the change in r.
% Note that the "appropriate" roots b and d may be negative in some cases.
%
% Then, back-calculate to get a2, b2, c2, d2 :
%
% If a2 + b2 is odd, N is even, else N is odd.
% use appropriate formulae for obtaining x, y, u, v.
%
% If x^3 + y^3 and u^3 + v^3 don't match, try with negative roots -b, -d etc.
% But this probably may never happen - see below.
%
%                                    &&&&&&&&&&&&&&
%
% I wish to thank Prof John Butcher for his article which triggered
% and enabled me to write this Matlab code for "generating"
% Ramanujam's Diophantine Equation Numbers.
% I hope that this programme will be useful to many the world over.
% Time permitting, I may be improving on this programme to make it suitable
% for generating a series of Diophantine Numbers automatically.
% But the base groundwork is already laid now, and we need
% only to build further.
%
% Q1a : I am curious to know why Prof John Butcher has said that
% gcd (a, b) and gcd (c, d) should be 1.
% In the case of his own example : 9^3 + 15^3  =  2^3 + 16^3 =  4104,
% intermediate calculations give a = 12, b = 3, c = 9, d = 7.
% See Usage Eg Case 4 below. Obviously, gcd (a, b) = 3 (not 1).
% But, gcd (x, y,  u, v) = 1 (var name used in my programme is G_Gxy_Guv.)
%
% Also, in his second example : 33^3 + 15^3  =  2^3 + 34^3 = 39312,
% calculations give a = 3, b = 9, c = 9, d = 8. See Usage Eg Case 5 below.
% Obviously, gcd (a, b) = 3 (not 1). But, gcd (x, y,  u, v) = 1.
%
% Similarly, in his 3rd example too, gcd (a, b) = 3 (not 1) !
%
% In many of my own examples with randomly chosen values, I have mixed results:
% In Usage Eg 2, gcd (c, d) = 9 (not 1), but, gcd (x, y,  u, v) = 1.
% In Usage Eg 3, gcd (a, b) = 3 (not 1), but, gcd (x, y,  u, v) = 3 (not 1) !
% Egs 7 and 8 are similar to Eg 2 ; Egs 9, 10, and 11 are similar to Eg 3.
%
% Q1b) Therefore, I would like to know the condition or constraint,
% which when fulfilled, will ensure that we will certainly obtain
% x, y,  u, v such that gcd (x, y,  u, v) = 1
%
% Q2 : I would also like to know how the article's Theorem 1 is used
% in deriving the formulae for Diophantine Numbers.
% It says : ... "although beneath the surface" ...
%
%                                    &&&&&&&&&&&&&&
%
% % Usage Egs :
%
% % Usage Egs Case 6, Case 7 and Case 8 can be used as Regression Test Cases
% % after any modifications are done to this programme.
%
% % Case 1) : Ramanujam's Diophantine Equation : Lowest No 1729 :
% % 1729 = 9^3 + 10^3 = 1^3 + 12^3
% clc
% [ x, y,  u, v,  N, LHS, RHS,  r,   a, b, c, d,   a2, b2, c2, d2,   ...
%   Z_Real, Z_Imag,   Gxy, Guv, G_Gxy_Guv,   Gab, Gcd,               ...
%   str_N_odd_even, str_b_d,   Calc_Error, error_Limit ] =           ...
%       Diophantine_1 ( 1, 2,  4, 1,  1, 1,   'Y' ) 
%
% % 10, 9,  12, 1,  1729, 1729, 1729,   1,  19, 1, 13, 11,   19, 1, 13, 11,
% % 1, -3,   1, 1, 1,   1, 1,   N_ODD, Pos_Pos,   0, 1.729e-7
% %               ---  ---  
% 
% %                                    &&&&&&&&&&&&&&
% 
% % Case 2) : With my own randomly chosen values : (G_Gxy_Guv = 1)
% % 321236^3  +  (-78236)^3  =  418185^3  +  (-343305)^3  =  32670295158384000
% % But gcd (x, y,  u, v) = 1 ;    gcd (c, d) = 9 (NOT 1)
% clc
% [ x, y,  u, v,  N, LHS, RHS,  r,   a, b, c, d,   a2, b2, c2, d2,   ...
%   Z_Real, Z_Imag,   Gxy, Guv, G_Gxy_Guv,   Gab, Gcd,               ...
%   str_N_odd_even, str_b_d,   Calc_Error, error_Limit ] =           ...
%       Diophantine_1 ( 1, -2,  0, -3,  4, 5,   'Y' ) 
% 
% % Note that this is a good example for 2 reasons :
% % a) We had to toggle our first choice of N_ODD to N_EVN.
% % b) error_Limit had to be used because the computed Calc_Error is 8,
% % but checking with the Calculator gives a difference of 0.
% % But I corrected this later by taking factored cube.
% 
% % Note :
% Gcd          % = gcd ( c, d )     = 9 (not 1)      % See Q1a, b above.
% G_Gxy_Guv    % = gcd ( Gxy, Guv ) = 1              % But, = 3 in Case 3
% 
% % 321236, -78236,  418185, -343305,
% % 32670295158384000, 32670295158384000,
% % 3.267029515838401e16 (32670295158384000),   9,
% % (RHS error of +8 later corrected to 0)
% % 243, 49934, 117, 76149,   121500, 199736, 37440, 380745,
% % 2820.333333333334, 92.44444444444444,   4, 45, 1,   1, 9,
% %                                               ---     ***
% % N_EVN, Pos_Pos,   8 (0), 3000    % Calc_Error later corrected to 0
% %                  *******
% %
% %                                    &&&&&&&&&&&&&&
%
% % Case 3) : With my own randomly chosen values : (G_Gxy_Guv = 3)
% % 115821^3  +  (-72045Z)^3  =  267420^3  +  (-261804)^3  =  1179732995041536
% % But gcd (x, y,  u, v) = 3 (NOT 1) ;    gcd (a, b) = 3 (NOT 1)
% clc
% [ x, y,  u, v,  N, LHS, RHS,  r,   a, b, c, d,   a2, b2, c2, d2,   ...
%   Z_Real, Z_Imag,   Gxy, Guv, G_Gxy_Guv,   Gab, Gcd,               ...
%   str_N_odd_even, str_b_d,   Calc_Error, error_Limit ] =           ...
%       Diophantine_1 ( 1, 2,  3, 4,  3, 4,   'Y' ) 
%
% % Note :
% Gab          % = gcd ( a, b )     = 3 (not 1)      % See Q1a, b above.
% G_Gxy_Guv    % = gcd ( Gxy, Guv ) = 3              % But, = 1 in Case 1, 4, 5, 6
%
% % 115821, -72045,  267420, -261804,
% % 1179732995041536, 1179732995041536, 1179732995041536,   2,
% % 114, 31311, 26, 66153,   21888, 93933, 2808, 264612,
% % -6945, -1765.5,   9, 12, 3,   3, 1,   N_EVN, Pos_Pos,   0, 3000
% %                         ***  ***
%
% %                                    &&&&&&&&&&&&&&
%
% % Case 4) : Butcher's 2nd example :
% %  9^3 + 15^3  =  2^3 + 16^3 =  4104
% clc
% [ x, y,  u, v,  N, LHS, RHS,  r,   a, b, c, d,   a2, b2, c2, d2,   ...
%   Z_Real, Z_Imag,   Gxy, Guv, G_Gxy_Guv,   Gab, Gcd,               ...
%   str_N_odd_even, str_b_d,   Calc_Error, error_Limit ] =           ...
%       Diophantine_1 ( 0, 1,  1, 1,  1, 1,   'Y' ) 
%
% % Note :
% Gab          % = gcd ( a, b )     = 3 (not 1)      % See Q1a, b above.
% % But here, G_Gxy_Guv    % = gcd ( Gxy, Guv ) = 1  % But, = 3 in Case 3
%
% % 15, 9,  16, 2,  4104, 4104, 4104,  3,   12, 3, 9, 7,   12, 3, 9, 7,
% % -1, -1.33333333333333,   3, 2, 1,   3, 1,   N_EVN, Pos_Pos,   0, 4.104e-7
% %                               ---  *** 
%
% %                                    &&&&&&&&&&&&&&
%
% % Case 5) : Butcher's 3rd example :
% % 33^3 + 15^3  =  2^3 + 34^3 = 39312
% clc
% [ x, y,  u, v,  N, LHS, RHS,  r,   a, b, c, d,   a2, b2, c2, d2,   ...
%   Z_Real, Z_Imag,   Gxy, Guv, G_Gxy_Guv,   Gab, Gcd,               ...
%   str_N_odd_even, str_b_d,   Calc_Error, error_Limit ] =           ...
%       Diophantine_1 ( 0, 1,  1, 0,  1, 2,   'Y' ) 
%
% % Note :
% Gab          % = gcd ( a, b )     = 3 (not 1)      % See Q1a, b above.
% % But here, G_Gxy_Guv    % = gcd ( Gxy, Guv ) = 1  % But, = 3 in Case 3
%
% % 33, 15,  34, 2,  39312, 39312, 39312,  3,   3, 9, 9, 8,   24, 9, 18, 16,
% % 3, -2.66666666666667,   3, 2, 1,   3, 1,   N_EVN, Pos_Pos,   0, 3.9312e-6
% %                              ---  *** 
%
% %                                    &&&&&&&&&&&&&&
%
% % Case 6) : Butcher's 4th example :
% % 6^3 + (-3)^3  =  5^3 + 4^3  =   189        % ie, 3^3 + 4^3 + 5^3 = 6^3
% clc
% [ x, y,  u, v,  N, LHS, RHS,  r,   a, b, c, d,   a2, b2, c2, d2,   ...
%   Z_Real, Z_Imag,   Gxy, Guv, G_Gxy_Guv,   Gab, Gcd,               ...
%   str_N_odd_even, str_b_d,   Calc_Error, error_Limit ] =           ...
%       Diophantine_1 ( 0, 1,  -1, 0,  1, 1,   'Y' ) 
%
% % Note :
% Gab          % = gcd ( a, b )     = 3 (not 1)      % See Q1a, b above.
% % But here, G_Gxy_Guv    % = gcd ( Gxy, Guv ) = 1  % But, = 3 in Case 3
%
% % 6, -3,  5, 4,  189, 189, 189,  3,   3, 9, 9, 1,  3, 9, 9, 1,
% % -3, -0.33333333333333,   3, 1, 1,   3, 1,   N_ODD, Pos_Pos,   0, 1.89e-8
% %                               ---  *** 
%
% %                                    &&&&&&&&&&&&&&
%
% % Many more Usage Egs are given at the end.
%
%                                 ********************

% 1) Inputs' Defaults and Checks :

if nargin < 4
    error ('Diophantine_1.m needs atleast 4 input args.' ) ;
end

if nargin < 5
    Ga2b2 = 1 ;    % Default Value of gcd (a2, b2)
    Gc2d2 = 1 ;    % Default Value of gcd (c2, d2)

    % Default is that we do NOT want extra Print-outs.
    str_Det_fprt_Init = 'N' ;    
end

if nargin < 6
    Gc2d2 = 1 ;    % Default Value of gcd (c2, d2)

    str_Det_fprt_Init = 'N' ;
end

if nargin < 7
    str_Det_fprt_Init = 'N' ;
end

G_Ga2b2_Gc2d2 = gcd ( Ga2b2, Gc2d2 ) ;        % FULCRUM 1

if G_Ga2b2_Gc2d2 ~= 1
    fprintf ( '\n********************* NOTE ********************* \n' ) ;
    fprintf ( '\n**** Diophantine_1.m : ' ) ;
    fprintf ( 'gcd ( Ga2b2, Gc2d2 ) = %d **** \n', G_Ga2b2_Gc2d2 ) ;
    fprintf ( '\n********************* NOTE ********************* \n' ) ;
    % Note : Actually, we should exit here with an error stmt.
end

%                                    &&&&&&&&&&&&&&

% 2) Inits :
format long

% Constant repeatedly used in the programme :
root_3 = sqrt (3) ;

% Initially assume the ratio "r" as 1        % Logical Concept 1
r = 1 ;

% If there is no convergence, let us show it as N = -1
N = -1 ;

LHS = -1 ;
RHS = -1 ;

%                                    &&&&&&&&&&&&&&

% 3) Calculate X_Sq and Y_Sq :

X_Mag  =  abs ( X_Real  +  j * X_Imag * root_3 ) ;
X_Sq   =  X_Mag^2 ;

Y_Mag  =  abs ( Y_Real  +  j * Y_Imag * root_3 ) ;
Y_Sq   =  Y_Mag^2 ;

%                                    &&&&&&&&&&&&&&

% 4) Calculate a and c :

a = r * Y_Sq ;
c = r * X_Sq ;

%                                    &&&&&&&&&&&&&&

% 5a) Solve for s (Z_Real) and t (Z_Imag) :

% NOTE that if you choose a case like :
% ... = Diophantine_1 ( -3, -4,  -3, -4,  11, 7 ) 
% A_st will be singular !
% This will also lead to a problem below in : r = lcm ( Den_b, Den_d ) ;

A_st = [ X_Real,  -3 * X_Imag ;
         Y_Real,  -3 * Y_Imag ] ;
     
B_st = [ Gc2d2^3 * ( Y_Real^2 + 3 * Y_Imag^2 ) * r ;
         Ga2b2^3 * ( X_Real^2 + 3 * X_Imag^2 ) * r ] ;

% The 'mldivide' operator may only produce a single output.
% So, we do this in 3 steps.
st_Soln = A_st \ B_st ;

Z_Real = st_Soln(1) ;
Z_Imag = st_Soln(2) ;

%                                       ++++++++

% 5b) Compute Z_Mag and Z_Sq :

Z_Mag  =  abs ( Z_Real  +  j * Z_Imag * root_3 ) ;
Z_Sq   =  Z_Mag^2 ;

%                                    &&&&&&&&&&&&&&

% 6) The important logical step in this programme :

% 6a) Obtain b and d :

b_pos = sqrt ( ( X_Sq * Z_Sq  -  Gc2d2^6 * a^2 ) / 3 ) ;

d_pos = sqrt ( ( Y_Sq * Z_Sq  -  Ga2b2^6 * c^2 ) / 3 ) ;


% Because of sqrt, b_pos and d_pos may not come out exactly as
% whole integers in the calculations due to FP errors.
% We correct this below.

%                                       ++++++++

% 5b) Choose r in a way as to convert b and d to whole numbers.

[ Num_b, Den_b ]  =  rat (b_pos) ;
[ Num_d, Den_d ]  =  rat (d_pos) ;

r = lcm ( Den_b, Den_d ) ;        % Logical Concept 1

% Try with positive roots first.
% Note that the "appropriate" roots b and d may be negative in some cases.
b_pos = r * b_pos ;
d_pos = r * d_pos ;

%                                       ++++++++

% 5c) Correct a and c to reflect the change in r :
a = r * Y_Sq ;
c = r * X_Sq ;

%                                    &&&&&&&&&&&&&&

% 6) Because of sqrt, b_pos and d_pos may not come out exactly as
% whole integers in the calculations due to FP errors.

if abs ( a - round(a) ) < 1e-6 * abs (a)
    a = round(a) ;
else
    if str_Det_fprt_Init == 'Y'
        fprintf ( '\n    **** a is NOT a whole integer. ' ) ;
        fprintf ( 'a = %d **** \n' ) ;
    end
end

if abs ( c - round(c) ) < 1e-6 * abs (c)
    c = round(c) ;
else
    if str_Det_fprt_Init == 'Y'
        fprintf ( '\n    **** c is NOT a whole integer. ' ) ;
        fprintf ( 'c = %d **** \n' ) ;
    end
end

%                                       ++++++++

if abs ( b_pos - round(b_pos) ) < 1e-6 * abs (b_pos)
    b_pos = round(b_pos) ;
else
    if str_Det_fprt_Init == 'Y'    
        fprintf ( '\n    **** b_pos is NOT a whole integer. ' ) ;
        fprintf ( 'b_pos = %d **** \n' ) ;
    end
end

if abs ( d_pos - round(d_pos) ) < 1e-6 * abs (d_pos)
    d_pos = round(d_pos) ;
else
    if str_Det_fprt_Init == 'Y'    
        fprintf ( '\n    **** d_pos is NOT a whole integer. ' ) ;
        fprintf ( 'd_pos = %d **** \n' ) ;
    end
end


%                                    &&&&&&&&&&&&&&

% 7a) As per Butcher's article, gcd(a, b) and gcd(c, d) should be = 1.

Gab = gcd (a, b_pos) ;    % should be the same as gcd (a, b) calculated below
Gcd = gcd (c, d_pos) ;    % should be the same as gcd (c, d) calculated below

if Gab ~= 1 | Gcd ~= 1
    fprintf ( '\n********************* NOTE ********************* \n' ) ;
    fprintf ( '\n** Diophantine_1.m : gcd ( a, b_pos ) = %d ** \n', Gab ) ;
    fprintf ( '\n** Diophantine_1.m : gcd ( c, d_pos ) = %d ** \n', Gcd ) ;
    fprintf ( '\n********************* NOTE ********************* \n' ) ;
    % Note : Actually, we should exit here with an error stmt.
end

%                                    &&&&&&&&&&&&&&

% 8) Back calculate a2, b2, c2, d2 :
a2 = a * Ga2b2 * Gc2d2^3 ;
b2_pos = b_pos * Ga2b2 ;

c2 = c * Gc2d2 * Ga2b2^3 ; 
d2_pos = d_pos * Gc2d2 ;

%                                    &&&&&&&&&&&&&&

% 9) Because of sqrt in b_pos and d_pos, let us check
% a2, c2, b2_pos, d2_pos also for wholeness.

if abs ( a2 - round(a2) ) < 1e-6 * abs (a2)
    a2 = round(a2) ;
else
    if str_Det_fprt_Init == 'Y'
        fprintf ( '\n    **** a2 is NOT a whole integer. ' ) ;
        fprintf ( 'a2 = %d **** \n' ) ;
    end
end

if abs ( c2 - round(c2) ) < 1e-6 * abs (c2)
    c2 = round(c2) ;
else
    if str_Det_fprt_Init == 'Y'    
        fprintf ( '\n    **** c2 is NOT a whole integer. ' ) ;
        fprintf ( 'c2 = %d **** \n' ) ;
    end
end

%                                       ++++++++

if abs ( b2_pos - round(b2_pos) ) < 1e-6 * abs (b2_pos)
    b2_pos = round(b2_pos) ;
else
    if str_Det_fprt_Init == 'Y'
        fprintf ( '\n    **** b2_pos is NOT a whole integer. ' ) ;
        fprintf ( 'b2_pos = %d **** \n' ) ;
    end
end

if abs ( d2_pos - round(d2_pos) ) < 1e-6 * abs (d2_pos)
    d2_pos = round(d2_pos) ;
else
    if str_Det_fprt_Init == 'Y'
        fprintf ( '\n    **** d2_pos is NOT a whole integer. ' ) ;
        fprintf ( 'd2_pos = %d **** \n' ) ;
    end
end

%                                    &&&&&&&&&&&&&&

% 10) As a first choice, if a2 + b2 is even, N is odd, else N is even.
% N_ODD or N_EVN may be reqd to be decided again in xyuv_from_a2b2c2d2
% For eg, it is necessary to toggle the first choice in the case of Usage Eg 6.
%
% Note that a and b are positive because X_Sq and Y_Sq are pos,
% and r = 1 or lcm is also pos.
% So, a2 and b2 must also be pos.
if mod ( (a2 + b2_pos), 2 ) < 1e-6 * min ( abs (a2), abs (b2_pos) )
% mod is preferable to rem here : rem (-5, 2) = -1 ;  mod (-5, 2) = -1 + 2 = +1
% Note that mod ( 19.999999, 2 ) = 1.999999
    str_N_odd_even = 'N_ODD' ; 
else
    str_N_odd_even = 'N_EVN' ;

end

%                                    &&&&&&&&&&&&&&

% 11a) Calculate x & y and u & v using b2_pos and d2_pos :
b2 = b2_pos ;
d2 = d2_pos ;

[ x, y,  u, v ] = xyuv_from_a2b2c2d2 ( a2, b2,  c2, d2,  str_N_odd_even ) ;

% If the above choice of N_ODD or N_EVN was not correct, we will have
% a factor of 0.5 in either or both pairs : x, y or u, v
% So, we need to change the choice.
% To account for cascading FP errors, I have taken 0.25 instead of 0.5
if abs ( x - round(x) ) > 0.25 |  abs ( u - round(u) ) > 0.25 | ...
   abs ( y - round(y) ) > 0.25 |  abs ( v - round(v) ) > 0.25 

    if str_N_odd_even == 'N_ODD'
        str_N_odd_even = 'N_EVN' ;
    elseif str_N_odd_even == 'N_EVN'
        str_N_odd_even = 'N_ODD' ;
    end
    
    if str_Det_fprt_Init == 'Y'
        fprintf ( '\n**** Choice of str_N_odd_even toggled. **** \n' ) ;
        % Usage Eg 6 needs this toggling.
        str_N_odd_even
    end
    
    % Note that this final choice of N_EVN or N_ODD will stay valid even for
    % the other match tests between x^3 + y^3 and u^3 + v^3 below.

    % Don't forget to call xyuv_from_a2b2c2d2 again.
    [ x, y,  u, v ] = xyuv_from_a2b2c2d2 ( a2, b2,  c2, d2,  str_N_odd_even ) ;

end

%                                    &&&&&&&&&&&&&&

% 11b) Check with pos roots b2_pos and d2_pos if x^3 + y^3 and u^3 + v^3 match:

% LHS = x^3 + y^3 
% RHS = u^3 + v^3 

% As values of x and y increases, errors creep in the computation
% of x^3 + y^3 due to cascading FP errors.
% Instead, we factorise and try.

LHS = ( x + y ) * ( x^2 + y^2 - x*y ) ;    % instead of : LHS = x^3 + y^3 
RHS = ( u + v ) * ( u^2 + v^2 - u*v ) ;    % instead of : RHS = u^3 + v^3 

Calc_Error  =  abs ( LHS - RHS ) ;

% If LHS or RHS becomes very large like say, of the order of 1e20,
% a multiplying factor 1e-4 is not enough.
% For eg, in the case of Usage Eg 6, Calc_Error computed above is 8,
% but checking with the Calculator gives a difference of 0.
error_Limit = compute_error_Limit ( LHS, RHS ) ;

if str_Det_fprt_Init == 'Y'
    fprintf ( '\nCalc_Error with pos roots b_pos and d_pos = %d \n', ...
              Calc_Error ) ;
    error_Limit
end

% if x^3 + y^3 == u^3 + v^3        % ideal if no FP errors creep in !    
if Calc_Error < error_Limit        % if b_pos, d_pos
    
    b = b_pos ;
    d = d_pos ;
    
    str_b_d = 'Pos_Pos' ;
    
else
    % I discovered later during development that the solution will "converge"
    % in all (almost or really all ?) cases with pos roots b_pos and d_pos ;
    % it (probably) really makes no difference to the end result at all.
    % But since I had already written more than 50 % of the foll code, and
    % also tested it partly, I have let it remain - ofcourse after testing it
    % sufficiently - no harm in retaining it.
    % One secret ? : It was actually an error in my hand calculations which
    % initially prompted me to write the foll code for different signs
    % for b and d !
    
    % 11c) Check if x^3 + y^3 and u^3 + v^3 match with b2_neg and d2_pos :
    b2_neg = -b2_pos ;    b2 = b2_neg ;
    d2 = d2_pos ;
    
    [ x, y,  u, v ] = ...
        xyuv_from_a2b2c2d2 ( a2, b2,  c2, d2,  str_N_odd_even ) ;
    
    LHS = ( x + y ) * ( x^2 + y^2 - x*y ) ;    % instead of : LHS = x^3 + y^3 
    RHS = ( u + v ) * ( u^2 + v^2 - u*v ) ;    % instead of : RHS = u^3 + v^3 
    
    Calc_Error  =  abs ( LHS - RHS ) ;

    error_Limit = compute_error_Limit ( LHS, RHS ) ;
          
    if str_Det_fprt_Init == 'Y'
        fprintf ( '\nCalc_Error with b_neg and d_pos = %d \n', ...
                  Calc_Error ) ;
        error_Limit
    end
      
    if Calc_Error < error_Limit       % if b_neg, d_pos
        
        b = -b_pos ;    % b_neg = -b_pos ;
        d = d_pos ;
        
        str_b_d = 'Neg_Pos' ;
        
    else
        
        % 11d) Check if x^3 + y^3 and u^3 + v^3 match with b2_pos and d2_neg :
        b2 = b2_pos ;
        d2_neg = -d2_pos ;    d2 = d2_neg ;
        
        [ x, y,  u, v ] = ...
            xyuv_from_a2b2c2d2 ( a2, b2,  c2, d2,  str_N_odd_even ) ;
        
        LHS = ( x + y ) * ( x^2 + y^2 - x*y ) ;
        RHS = ( u + v ) * ( u^2 + v^2 - u*v ) ;
        
        Calc_Error  =  abs ( LHS - RHS ) ;
        
        error_Limit = compute_error_Limit ( LHS, RHS ) ;
              
        if str_Det_fprt_Init == 'Y'
            fprintf ( '\nCalc_Error with b_pos and d_neg = %d \n', ...
                      Calc_Error ) ;
            error_Limit
        end
          
        if Calc_Error < error_Limit  % if b_pos, d_neg
            
            b = b_pos ;
            d = -d_pos ;    % d_neg = -d_pos ;
            
            str_b_d = 'Pos_Neg' ;
            
        else
            
            % 11e) Check if x^3 + y^3 and u^3 + v^3 match
            % with b2_neg and d2_neg :
            b2_neg = -b2_pos ;    b2 = b2_neg ;
            d2_neg = -d2_pos ;    d2 = d2_neg ;
            
            b = -b_pos ;    % b_neg = -b_pos ;
            d = -d_pos ;    % d_neg = -d_pos ;
            
            str_b_d = 'Neg_Neg' ;
            
            [ x, y,  u, v ] = ...
                xyuv_from_a2b2c2d2 ( a2, b2,  c2, d2,  str_N_odd_even ) ;
            
            LHS = ( x + y ) * ( x^2 + y^2 - x*y ) ;
            RHS = ( u + v ) * ( u^2 + v^2 - u*v ) ;

            Calc_Error  =  abs ( LHS - RHS ) ;
        
            error_Limit = compute_error_Limit ( LHS, RHS ) ;
            
            if str_Det_fprt_Init == 'Y'
                fprintf ( '\nCalc_Error with b_neg and d_neg = %d \n', ...
                          Calc_Error ) ;
                error_Limit
            end
              
            if Calc_Error > error_Limit    % if b_neg, d_neg
                
                fprintf ( '\n\n**** NO MATCH found. INVESTIGATE. **** \n' ) ;
                
                fprintf ( '\n**** Values calculated so far :   **** \n' ) ;
                x, y,  u, v,  N, LHS, RHS,  r
                a, b, c, d,   a2, b2, c2, d2
                str_N_odd_even, str_b_d,   Calc_Error, error_Limit
                Gab = gcd (a, b) 
                Gcd = gcd (c, d) 

                Gxy = gcd (x, y) 
                Guv = gcd (u, v) 
                
                fprintf ( '\n************************************ \n\n' ) ;
            
                error ( 'Can''t find matching x & y and u & v ! INVESTIGATE.');
                
            end    % if b_neg, d_neg
            
        end    % if b_pos, d_neg
        
    end    % if b_neg, d_pos
    
end    % if b_pos, d_pos

%                                    &&&&&&&&&&&&&&

% 12) Compute N :

N = x^3 + y^3 ;

%                                    &&&&&&&&&&&&&&

% 13) Compute gcd of x, y  &  u, v  and  a, b  &  c, d :
% a, c,  b, d
% x, y,  u, v

Gxy = gcd (x, y) ;    % If these are not integers, we could get this error :
Guv = gcd (u, v) ;    % Error using ==> gcd : Requires integer input arguments.

Gab = gcd (a, b) ;    % should be the same as gcd (a, b_pos) calculated above
Gcd = gcd (c, d) ;    % should be the same as gcd (c, d_pos) calculated above 

%                                    &&&&&&&&&&&&&&

% 14) Check if gcd of (x, y,  u, v ) = 1
% gcd (x, y,  u, v) = 1 => gcd (a2, b2,  c2, d2) = 1  % Theoretical Concept 1

G_Gxy_Guv = gcd ( Gxy, Guv ) ;

if G_Gxy_Guv ~= 1
    fprintf ( '\n********************* NOTE ********************* \n' ) ;
    fprintf ( '\n**** Diophantine_1.m : gcd ( Gxy, Guv ) = %d **** \n', ...
              G_Gxy_Guv ) ;
    fprintf ( '\n********************* NOTE ********************* \n' ) ;          
    % Note : Actually, we should exit here with an error stmt.
end

% 7b) Similarly, we should exit if Gab ~= 1 | Gcd ~= 1   % Yes, it is NOT 14b !
% Note that this condition (eqvt) has already been addressed above as :
% gcd (a, b_pos) and gcd (c, d_pos).
if Gab ~= 1 | Gcd ~= 1
    fprintf ( '\n********************* NOTE ********************* \n' ) ;    
    fprintf ( '\n** Diophantine_1.m : gcd ( a, b ) = %d ** \n', Gab ) ;
    fprintf ( '\n** Diophantine_1.m : gcd ( c, d ) = %d ** \n', Gcd ) ;
    fprintf ( '\n********************* NOTE ********************* \n' ) ;    
    % Note : Actually, we should exit here with an error stmt.    
end

%                                    &&&&&&&&&&&&&&

fprintf ( '\n\n************  Pgm output begins here.  ************ \n ' ) ;

%                                    &&&&&&&&&&&&&&

%                                 ********************
%                                 ********************

% 16)
function [ error_Limit ] = compute_error_Limit ( LHS, RHS ) 

min_L_R = min ( abs (LHS), abs (RHS) ) ;

if min_L_R < 1e6
    error_Limit = 1e-10 * min_L_R ;
    % max = 1e-4 for 1e6 - 1
    
elseif min_L_R < 1e10
    error_Limit = max ( 1e-8 * min_L_R, 5e-4 ) ;
    % 5e-4 for 1e6 ; 100 for 1e10 - 1
    
elseif min_L_R < 1e15
    error_Limit = max ( 1e-12 * min_L_R, 300 ) ;
    % 300 for 1e10 ; 1000 for 1e15 - 1
    
elseif min_L_R < 1e20
    error_Limit = max ( 1e-16 * min_L_R, 3000 ) ;
    % 3000 for 1e15 ; 10000 for 1e20 - 1
    
elseif min_L_R < 1e25
    error_Limit = max ( 1e-19 * min_L_R, 30000 ) ;
    % 30000 for 1e20 ; 100000 for 1e25 - 1
    
else
    error_Limit = 2e6 ;
    
end

%                                 ********************
%                                 ********************

% 17)
function [ x, y,  u, v ] = ....
    xyuv_from_a2b2c2d2 ( a2, b2,  c2, d2,  str_N_odd_even )

% Note : As a first choice, if a2 + b2 is even, str_N_odd_even is supplied
% as N_ODD to this subfunction, and vice-versa.
% N_ODD or N_EVN may be reqd to be decided again based on the results.

if str_N_odd_even == 'N_ODD'
    
    x = ( a2 + b2 ) / 2 ;
    y = ( a2 - b2 ) / 2 ;
    
    u = ( c2 + d2 ) / 2 ;
    v = ( c2 - d2 ) / 2 ;
    
else
    
    x = ( a2 + b2 ) ;
    y = ( a2 - b2 ) ;
    
    u = ( c2 + d2 ) ;
    v = ( c2 - d2 ) ;
    
end

%                                 ********************
%                                 ********************

% Some more Usage Egs are given below.
% 
% % Case 7) : With my own randomly chosen values : (G_Gxy_Guv = 1)
% % 116244^3  +  (-115872)^3  =  37249^3  +  (-33217)^3  =  15031929519936
% 
% clear, clc
% [ x, y,  u, v,  N, LHS, RHS,  r,   a, b, c, d,   a2, b2, c2, d2,   ...
%   Z_Real, Z_Imag,   Gxy, Guv, G_Gxy_Guv,   Gab, Gcd,               ...
%   str_N_odd_even, str_b_d,   Calc_Error, error_Limit ] =           ...
%       Diophantine_1 ( -3, 5,  2, -3,  2, 1, 'Y' ) 
% 
% Gab        % = gcd ( a, b )     = 3 (not 1)     % See Q1a, b above.
% G_Gxy_Guv  % = gcd ( Gxy, Guv ) = 1
% 
% r % = 3
% 
% Z_Real % = 3453
% Z_Imag % = -692.6666666666666
% 
% % N_EVN, Pos_Pos
% 
% %                                    &&&&&&&&&&&&&&
% 
% % Case 8) : With my own randomly chosen values : (G_Gxy_Guv = 1)
% % (-107766)^3  +  (-634932)^3  =  (-2013055)^3  +  1991671^3
% % = -257217167508536664 (Calculator)   { -2.572171675085367e+017 (Matlab) }
% % ie, 2013055^3 = 107766^3  +  634932^3  +  1991671^3
% 
% % Since we have the successful special case of 3 negatives and 1 positive,
% % this is an important Regression Test Case.
%
% clear, clc
% [ x, y,  u, v,  N, LHS, RHS,  r,   a, b, c, d,   a2, b2, c2, d2,   ...
%   Z_Real, Z_Imag,   Gxy, Guv, G_Gxy_Guv,   Gab, Gcd,               ...
%   str_N_odd_even, str_b_d,   Calc_Error, error_Limit ] =           ...
%       Diophantine_1 ( -3, 1,  2, -3,  3, -11, 'Y' ) 
% 
% % -107766, -634932, -2013055, 1991671,
% % -257217167508536664, -257217167508536664, -257217167508536664,
% % 3,   93, 87861, 36, 182033,   -371349, 263583, -10692, -2002363,
% % 17637, -3883.333333333333,   18, 11, 1,   3, 1, N_EVN, Pos_Pos, 3000
%
% Gab        % = gcd ( a, b )     = 3 (not 1)     % See Q1a, b above.
% G_Gxy_Guv  % = gcd ( Gxy, Guv ) = 1
% 
% r % = 3
% 
% Z_Real % = 17637
% Z_Imag % = -3883.333333333333
% 
% % str_N_odd_even toggled from N_ODD to N_EVN, Pos_Pos
% 
% %                                    &&&&&&&&&&&&&&
%
% % Case 9) : With my own randomly chosen values : (G_Gxy_Guv = 343)
% % 327908^3  +  (-72716)^3  =  360493^3  +  (-228781)^3
% % =  3.487337281103962e+016
% % But gcd (x, y,  u, v) = 343 (NOT 1) ;    gcd (c, d) = 49 (NOT 1)
%
% clc
% [ x, y,  u, v,  N, LHS, RHS,  r,   a, b, c, d,   a2, b2, c2, d2,   ...
%   Z_Real, Z_Imag,   Gxy, Guv, G_Gxy_Guv,   Gab, Gcd,               ...
%   str_N_odd_even, str_b_d,   Calc_Error, error_Limit ] =           ...
%       Diophantine_1 ( 1, -4,  2, -3,  4, 7,   'Y' ) 
% 
% Gcd        % = gcd ( c, d )     = 49 (not 1)     % See Q1a, b above.
% 
% G_Gxy_Guv  % = gcd ( Gxy, Guv ) = 343  % = 3 in Case 2 ; = 1 in Case 1, 4, 5, 6
% 
% r % = 3
% 
% Z_Real % = 3871
% Z_Imag % = 1208.666666666667
% 
% % N_EVN, Pos_Pos
% 
% %                                    &&&&&&&&&&&&&&
% 
% % Case 10) : With my own randomly chosen values : (G_Gxy_Guv = 7)
% % 50932^3  +  (-21448)^3  =  102543^3  +  (-98511)^3  =  1.222546648901760e+014
% 
% clear, clc
% [ x, y,  u, v,  N, LHS, RHS,  r,   a, b, c, d,   a2, b2, c2, d2,   ...
%   Z_Real, Z_Imag,   Gxy, Guv, G_Gxy_Guv,   Gab, Gcd,               ...
%   str_N_odd_even, str_b_d,   Calc_Error, error_Limit ] =           ...
%       Diophantine_1 ( -3, -5,  9, 8,  2, 3 ) 
% 
% % Note :
% Gab        % = gcd ( a, b )     = 7 (not 1)     % See Q1a, b above.
% Gcd        % = gcd ( c, d )     = 7 (not 1)     % See Q1a, b above.
% 
% G_Gxy_Guv  % = gcd ( Gxy, Guv ) = 7  % = 3 in Case 2 ; = 1 in Case 1, 4, 5, 6
% 
% r % = 1
% 
% Z_Real % = 2968
% Z_Imag % = 1085
% 
% % N_EVN, Pos_Pos
% 
% %                                    &&&&&&&&&&&&&&
%
% % Case 11) :
% Diophantine_1 (  1, -2,  -3, -4,  3,  8,   'Y' ) 
% % 1483821^3 + 267219^3 = 4444392^3 + (-4388232)^3 = 3.286046473469061e+018
% % G_Gxy_Guv % = 3 ;
% % Gab % = 1
%
% %                                    &&&&&&&&&&&&&&
%
% % Cases of type : Can't find matching x & y and u & v ! INVESTIGATE.
% Diophantine_1 (  1, -2,   5, -3,  4,  7,   'Y' ) 
% Diophantine_1 ( -3, -4,   4,  3,  11, 7 ) 
%    
% %                                    &&&&&&&&&&&&&&
%    
% % A_st is singular for this case.    
% Diophantine_1 ( -3, -4,  -3, -4,  11, 7 ) 
%    
%                                 ********************
%                                 ********************
