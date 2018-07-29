function [ Match_Rnded_Array_x, Match_Rnded_Array_y, Match_p, ...
           primes_N_6nPlus1, primes_N_NOT_6nPlus1 ] = find_x_y__p_1_mod_6 ( N )
%
% Author : Sundar Krishnan (sundark100@yahoo.com)
% Date   : Read the article MATHEMATICAL MINIATURE 9.pdf in Aug 2003 ;
%          Skeleton Trial Programmes in Sep 2003 ;
%          Revisit and Fine Tuning in Sep 2004
%
% Functional Description :
% ------------------------
% This function finds x and y pairs of numbers such that x2 + 3y2 = p where
% mod(p, 6) = 1
% This is stated as Theorem 1 in John Butcher's article miniature.pdf
% on Diophantine Equations :
% Theorem 1 : Let p > 3 be a prime. Then there exist integers x and y
% such that x2 + 3y2 = p iff 1 =eqvt mod (1, 6) ie, iff mod(p, 6) = 1.
%
% This programme will have close resemblance to the programmes :
% find_the_2_Squares_from_the_Sum.m and Prime_Fctrs_Of_Sum_Of_2_Sqrs.m
% which are part of my earlier submission : Product_Equals_Sum_Of_2_Squares.zip
%
% Normally ie, if length(ind_p) == 1, we expect that
% Match_p should coincide with primes_N_6nPlus1
%
% Refer to Diophantine_1.m for a way to generate many Diophantine Equation
% Numbers.
%
%                                    &&&&&&&&&&&&&&
%
% % Usage Egs :
%
% % Case 1 :
% clear, clc
% [ Match_Rnded_Array_x, Match_Rnded_Array_y, Match_p, ...
%       primes_N_6nPlus1, primes_N_NOT_6nPlus1 ] = find_x_y__p_1_mod_6 ( 100 );
% %                           OR
% [ Match_Rnded_Array_x, Match_Rnded_Array_y, Match_p ] = ...
%       find_x_y__p_1_mod_6 ( 100 ) ;
%
% Match_Rnded_Array_x
% % = [ 2     1     4     2     5     4     7     8     5     2     7 ]
% Match_Rnded_Array_y
% % = [ 1     2     1     3     2     3     2     1     4     5     4 ]
% Match_p
% % = [ 7    13    19    31    37    43    61    67    73    79    97 ]
% 
% %                                    &&&&&&&&&&&&&&
%
% % Case 2 :
% clear, clc
% [ Match_Rnded_Array_x, Match_Rnded_Array_y, Match_p ] = ...
%       find_x_y__p_1_mod_6 ( 500 )
% %                           OR
% [ Match_Rnded_Array_x, Match_Rnded_Array_y, Match_p, ...
%       primes_N_6nPlus1, primes_N_NOT_6nPlus1 ] = find_x_y__p_1_mod_6 ( 500 );
%
% %                                    &&&&&&&&&&&&&&
%
% % Case 3 :
% clear, clc
% [ Match_Rnded_Array_x, Match_Rnded_Array_y, Match_p ] = ...
%       find_x_y__p_1_mod_6 ( 1000 )
%
% %                                    &&&&&&&&&&&&&&
%
%                                 ********************

% 1) Inputs' Defaults and Checks :
Match_Rnded_Array_x = [ ] ;
Match_Rnded_Array_y = [ ] ;

Match_p = [ ] ;

err_flag = 0 ;

%                                           &&&&&&&&&&&&&&

% 2) Find the primes within N that are of type mod (p, 6) = 1 :
primes_N = primes (N) ;

% Let us see which primes are of the form 6n + 1 yielding pos int n :
res_6 = (primes_N - 1) / 6 ;

% res_6 ( round (res_6) == res_6 ) ;  % This is ideal, but to avoid FP errors :
ind_6 = find ( abs ( round (res_6) - res_6 ) <= 1e-10 * res_6 ) ;
% For N = 100 :  4     6     8    11    12    14    18    19    21    22    25

res_6 ( ind_6 ) ;
% For N = 100 :  1     2     3     5     6     7    10    11    12    13    16

primes_N_6nPlus1 = primes_N ( ind_6 ) ;
% For N = 100 :  7    13    19    31    37    43    61    67    73    79    97

%                                              ++++++++

ind_6_NOT = find ( abs ( round (res_6) - res_6 ) > 1e-10 * res_6 ) ;
% For N = 100 :  1     2     3     5     7     9    10    13    15    16    17    20    23    24

primes_N_NOT_6nPlus1 = primes_N ( ind_6_NOT ) ;
% For N = 100 :  2     3     5    11    17    23    29    41    47    53    59    71    83    89

%                                           &&&&&&&&&&&&&&

% 3) For each p in the list primes_N_6nPlus1, find the corresponding x and y
% such that x^2 + 3*y^2 = p
for i = 1 : length ( primes_N_6nPlus1 )
    
    p = primes_N_6nPlus1 (i) ;
    
    % The max x <= sqrt (p)
    max_mult = floor ( sqrt (p) ) ;
    % Eg : floor ( sqrt (97) ) = 9 ;       sqrt (97) = 2.8489
    
    for mult = 1 : max_mult
        Array_x (mult) = mult ;
        Array_y (mult) = sqrt ( ( p - mult^2 ) / 3 ) ;
    end
    
    % Array_x, Array_y, pause
    
    % These are for ideal cases :
    % Match_Rnded_Array_x = Array_x ( round (Array_y) == Array_y ) 
    % Match_Rnded_Array_y = Array_y ( round (Array_y) == Array_y ) 
    
    % But with possible FP errors :
    % Since Array_y has the factor of 3 and substarction etc,
    % we will check for round (Array_y)
    ind_p = find ( abs ( round (Array_y) - Array_y ) <= 1e-10 * Array_y ) ;
    
    % Q : Will we ever have different sets of x and y pairs for the same p ?
    % ie, will length(ind_p) be ever > 1 ?
    if length(ind_p) > 1
        fprintf ( '\n**** length(ind_p) > 1 for p = %d ****\n', p ) ;
        pause (3) ;
        
        % Normally ie, if length(ind_p) == 1, we expect that
        % Match_p should coincide with primes_N_6nPlus1
    end
    
    Match_Rnded_Array_x = [ Match_Rnded_Array_x, Array_x( ind_p ) ] ;
    Match_Rnded_Array_y = [ Match_Rnded_Array_y, Array_y( ind_p ) ] ;
    
    
    Match_p = [ Match_p, p * ones( 1, length(ind_p) ) ] ;
   
    % pause
end

%                                           &&&&&&&&&&&&&&

% 4) Verify :

for j = 1 : length (Match_Rnded_Array_x)
    if abs ( Match_Rnded_Array_x(j)^2 + 3 * Match_Rnded_Array_y(j)^2 ...
            - Match_p(j) ) > 1e-10 * Match_p(j)
        fprintf ( '\n**** p and LHS do not for p = %d ', Match_p(j) ) ;
        fprintf ( '\n**** at index = %d \n', j ) ;

        err_flag = 1 ;
    end
    
end

if err_flag == 1
    error ( 'Mismatch between p and LHS.' ) ;
end
        
