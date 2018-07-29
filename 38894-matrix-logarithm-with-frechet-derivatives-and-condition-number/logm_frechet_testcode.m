%%%%%%%%%%%%%%%%%%%% LOGM_FRECHET_TESTCODE %%%%%%%%%%%%%%%%%%%%%
% This script tests that the logarithm codes provided are      %
% working correctly and provides some examples of usage which  %
% can be modified by users. For more rigorous tests of its     %
% accuracy please see the paper referenced below.              %
%                                                              %
% For more details of usage please type 'help logm_frechet'    %
% or 'help logm_frechet_real'. The latter algorithm is only    %
% applicable when working with real matrices.                  %
%                                                              %
% Functions in this package:                                   %
%   logm_frechet                                               %
%   logm_frechet_real                                          %
%   logm_frechet_complex                                       %
%   normAm                                                     %
%                                                              %
% Codes needed to run these tests:                             %
% The Matrix Function Toolbox - available from                 %
%   http://www.maths.manchester.ac.uk/~higham/mftoolbox/       %
%                                                              %
% These algorithms are based upon the work in:                 %
%   A. H. Al-Mohy, N. J. Higham and S. D. Relton, Computing    %
%   the Frechet Derivative of the Matrix Logarithm and         %
%   Estimating the Condition Number, MIMS EPrint 2012.72,      %
%   The University of Manchester, July 2012.                   %
%                                                              %
% and correspond to Algorithms 5.1 and 6.1 of that paper.      %
%                                                              %
% Authors: N. J. Higham and S. D. Relton, September 29, 2012   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

A = ver;

if ~any(strcmp({A(1:end).Name}, 'Matrix Function Toolbox (MFT)'))
   error('LOGM_FRECHET:missingMFT',...
           ['Matrix Function Toolbox (MFT) must be installed.\n' ...
          'Obtain it from ' ...
          'http://www.maths.manchester.ac.uk/~higham/mftoolbox' ])
end   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Testing parameters
format short
warning('off')
matsize = 10;    % Size of the matrices to use
% rand('seed', 7); randn('seed', 7); 
rng(5);   % Seed random number generator.
testmats{1} = expm(gallery('prolate', matsize));
testmats{2} = expm(gallery('redheff', matsize));
testmats{3} = expm(gallery('cauchy', matsize));
testmats{4} = expm(gallery('chebspec', matsize));
testmats{5} = [-149 -50 -154;537 180 546; -27 -9 -25];% Bad matrix for log
numtests = length(testmats);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('This code gives some basic examples of usage and compares the new ')
disp('algorithm with current alternatives.')
disp('In the corresponding paper evidence is given that the new')
disp('algorithm is in fact more accurate and cheaper than other methods.')
disp(' ')
disp('Ways to call our code:')
disp('  S = logm_frechet(A)')
disp('  L = logm_frechet(A,E)')
disp('  [S, cond] = logm_frechet(A)')
disp('  [S, L] = logm_frechet(A,E)')
disp('  [S, L, cond] = logm_frechet(A,E)')
disp('where S is the logarithm, L the derivative and cond the condition number.')
disp(' ')
disp('For more information check the comments in this script and the help')
disp('documentation for logm_frechet.')

fprintf('\nNormwise relative errors are displayed:\n\n')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Logarithm Evaluation Tests - Real Matrices')
% We will show the relative errors in calculating exp(log(A))
% which should be equal to A.
% We compare against MATLAB's logm and funm from the MFToolbox.
disp('logm_frechet_real    logm             funm')
for test = 1:numtests
    A = testmats{test};
    nrmA = norm(A);
    
    S1 = logm_frechet(A);
    S2 = logm(A);
    S3 = funm(A, @log);
    
    err1 = norm(expm(S1) - A)/nrmA;
    err2 = norm(expm(S2) - A)/nrmA;
    err3 = norm(expm(S3) - A)/nrmA;
    
    fprintf('%9.2e         %9.2e        %9.2e\n', err1, err2, err3)
end
disp(' ')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Logarithm Evaluation Tests - Complex Matrices')
% Same as before but add a random imaginary part to each matrix
disp('logm_frechet       logm             funm')
for test = 1:numtests
    A = testmats{test} + 4i*randn(length(testmats{test}));
    nrmA = norm(A);
    
    S1 = logm_frechet(A);
    S2 = logm(A);
    S3 = funm(A, @log);
    
    err1 = norm(expm(S1) - A)/nrmA;
    err2 = norm(expm(S2) - A)/nrmA;
    err3 = norm(expm(S3) - A)/nrmA;
    
    fprintf('%9.2e         %9.2e        %9.2e\n', err1, err2, err3)
end
disp(' ')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Frechet Derivative Tests - Real Matrices')
% We show the relative errors in calculating the Frechet
% derivative in comparison to the 2n x 2n method from
% Higham - Functions of Matrices: Theory and Computation (3.16).
% We compare our method against logm_frechet_pade from the
% MFToolbox.
disp('logm_frechet_real     logm_frechet_pade')
for test = 1:numtests
    A = testmats{test};
    E = randn(length(A));
    % Now get "accurate" version.
    bigmat = logm_frechet([A, E; zeros(length(A)), A]);
    
    Lacc = bigmat(1:length(A), length(A)+1:end);
    nrmL = norm(Lacc);
    
    L1 = logm_frechet_real(A, E);
    L1a = logm_frechet(A, E);  
    if norm(L1-L1a,1), error('Error in logm_frechet.'), end
    L2 = logm_frechet_pade(A, E);
    
    err1 = norm(L1 - Lacc)/nrmL;
    err2 = norm(L2 - Lacc)/nrmL;
    
    fprintf('%9.2e                 %9.2e\n', err1, err2)
end
disp(' ')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Frechet Derivative Tests - Complex Matrices')
% Same as before but add a random imaginary part to each matrix
disp('logm_frechet          logm_frechet_pade')
for test = 1:numtests
    A = testmats{test} + 1i*randn(length(testmats{test}));
    E = randn(length(A));
    % Now get "accurate" version.
    bigmat = logm_frechet([A, E; zeros(length(A)), A]);
    Lacc = bigmat(1:length(A), length(A)+1:end);
    nrmL = norm(Lacc);
    
    L1 = logm_frechet(A, E); 
    L1a = logm_frechet_complex(A, E); 
    if norm(L1-L1a,1), error('Error in logm_frechet.'), end
    L2 = logm_frechet_pade(A, E);
    
    err1 = norm(L1 - Lacc)/nrmL;
    err2 = norm(L2 - Lacc)/nrmL;
    
    fprintf('%9.2e                 %9.2e\n', err1, err2)
end
disp(' ')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Condition Number Test')
A = testmats{1};
[X,cond1] = logm_frechet(A);
cond2 = logm_cond(A);
relerr = abs( (cond1-cond2)/cond1 );
fprintf('%9.2e,  %9.2e\n', cond1, cond2)
