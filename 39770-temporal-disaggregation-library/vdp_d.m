% PURPOSE: Demo of vdp()
%          Estimation subject to transversal constraints
%          by means of a quadratic optimization criterion
%-----------------------------------------------------------------
% USAGE: vdp_d
%-----------------------------------------------------------------

close all; clear all; clc;

%-----------------------------------------------------------------
% Unbalanced vector 

y = [   220.00
        130.00
        200.00
        100.00
        450.00
         70.00
        120.00
        221.00 ];
     
[k,n]=size(y);
 
%-----------------------------------------------------------------
% Linear constraints
 
 A =[     1.00             0
          1.00             0
          1.00          1.00
          1.00             0
         -1.00             0
         -1.00             0
         -1.00             0
         -1.00         -1.00  ];

[k,m] = size(A);

%-----------------------------------------------------------------
% VCV matrix of estimates

% Vector of variances
% Note: Fixed estimation: s(5)=0 --> z(5)=y(5)

s = [10 5 25 55 0 15 10 12];  

Aux1 = (diag(sqrt(s)));

% Correlation matrix: C
C = zeros(k);
C(1,3) = 0.5;
Aux2 = tril(C');
C = C + Aux2 + diag(ones(1,k));

% VCV matrix: S
S = Aux1 * C * Aux1;

% Calling van der Ploeg function    

res = vdp(y,S,A);

% Check

format bank
disp (''); disp ('*** INITIAL AND FINAL DISCREPANCIES ***'); disp(''); 
[ A' * y  A' * res.z]

% Revision (as %)

p = 100 * ((res.z - y) ./ y);

% Final results:

disp ('');
disp ('*** INITIAL ESTIMATE, FINAL ESTIMATE, REVISION AS %, INITIAL VARIANCES, FINAL VARIANCES ***');
disp ('');

[y res.z p diag(S) diag(res.Sz)]

format short

