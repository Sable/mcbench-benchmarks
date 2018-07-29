function x = Bayes(a,b,c,d)
%BAYES Bayes' theorem: the discrete case.
% This m-file deals with the Bayes' theorem, as well as with the option of 
% the frequency visualization of a given sample.
%
% Rev. Thomas Bayes (1702-1761), developed a very interesting mathematical
% procedure after known as Bayes' theorem. The work entitled 'An essay 
% towards solving a Problem in the doctrine of Chances' was published in
% the Philosophical Transactions of the Royal Society of London in 1764 
% (53:370-418). It was not submitted by Bayes, but it was communicated 
% posthumously by his friend Richard Price in a letter to John Canton in 
% december 23, 1763. 
%
% Why Bayes didn’t publish? For he was not satisfied with the evaluation of
% what we know now as the Incomplete Beta function; failed to give a
% general solution to the problem (http://www.wyomingbioinformatics.org/
% ~achurban/docs/presentationBayesian.pdf).
%
% The complete paper in the original notation can be downloading from:
%          http://canoe.ens.fr/~ebrian/s1h-dhsrb/1764-bayes.pdf
% Also an excellent transcription of it from:
%          http://www.stat.ucla.edu/history/essay.pdf
%
% Bayes' theorem is a solution to a problem of 'inverse probability'. It 
% gives you the actual probability of an event given the measured test 
% probabilities. For example, you can:
%  -Correct for measurement errors. If you know the real probabilities and
%   the chance of a false positive and false negative, you can correct for
%   measurement errors.
%  -Relate the actual probability to the measured test probability. Bayes’
%   theorem lets you relate p(X|Y), the chance that an event X happened
%   given the indicator Y, and p(Y|X), the chance the indicator Y happened
%   given that event X occurred. 
%
% The Bayes' equation is:
%
%                       p(Y|X)p(X)               p(XY)
%       p(X|Y) = ------------------------- = --------------
%                p(Y|X)p(X) + p(Y|~X)p(~X)   p(XY) + p(~XY)
%
% Here, the sign ~ means complement [event(s)].
%
% The total probabilities schema is:
%
%                    X                     ~X
%          ----------------------------------------------
%      Y  |  p(XY)= p(Y|X)p(X)     p(~XY)= p(Y|~X)p(~X)  | p(Y)
%         |                                              |
%     ~Y  |  p(X~Y)= p(~Y|X)p(X)   p(~X~Y)= p(~Y|~X)p(~X)| p(~Y)
%          ----------------------------------------------                                         
%                   p(X)                  p(~X)
% 
% Note.-According to Eliezer S. Yudkowsky's web page [http://yudkowsky.net/
% rational/bayes], one thing that's confusing is about the '|' notation.
% Reading from left to right, '|' means 'given'; reading from right to left,
% '|' means 'implies' or 'leads to'.  Thus, moving your eyes from left to 
% right, X|Y reads 'X given Y' or 'the probability that an element is X, 
% given that the element is Y'.  Moving your eyes from right to left, X|Y
% reads 'Y implies X or 'the probability that an element containing Y is 
% X'.
%
% Syntax: function x = Bayes(a,b,c,d) 
%      
% Inputs:
% a - a priori probability (prior, marginal or actual)  
% b - First conditional probability, p(Y|X) [option=1]; first interaction
%     probability, p(XY) (true positive) [opion=2] or conditional 
%     probability, p(Y|X) [option=3]
% c - Second conditional probability, p(Y|~X) [option=1]; second interaction
%     probability, p(X~Y) (false positive) [opion=2] or interecation
%     probability, p(~XY) [option=3]
% d - Option = 1(default),2,or 3
% - It shows a dialog whether or not you are interested with the frequency
%   visualization of a given sample
%
% Output:
% x - chance positive test or positive result (posterior probability) 
% - frequency visualization of a given sample (optional)
%
% Example. From the example given on the Yudowsky's web page. To facilitate
%          early detection of breast cancer, women are screened using 
%          mammography, even if they have no obvious symptoms. It is 
%          considered the follow:
%          -The probability that one of these women has breast cancer is 1%
%          -If a woman has breast cancer, the probability is 80% that she
%           will have a positive mammography test
%          -If a woman does not have breast cancer, the probability is 9.6%
%           of a positive mammography test
%          -If it is taken a woman with no symptoms having positive 
%           mammography test
%          What is the probability that she actually has breast cancer?
%          Also we are interested with the frequency visualization of a
%          women sample of 852000
%
% Here we have p(X)=1/100, p(Y|X)=80/100, and p(~Y|X)=9.6/100. Then, we must
% to use option 1 (default).
%
% Calling on Matlab the function: 
%             Bayes(1/100,80/100,9.6/100)
%
% Answer is:
%
% You should have given the two conditional probabilities p(Y|X) and p(Y|~X).
% Where, ~Y is the complement event of Y.
%
% Do you want a frequency visualization of a sample? (y/n): y
% Give me the sample size: 852000
% 
% Sample size = 852000
% X = 8520
% ~X = 843480
% XY = 6816
% X~Y = 1.704000e+003
% ~XY = 8.097408e+004
% ~X~Y = 7.625059e+005
%
% ans =
%
%     0.0776
%
%--Next April 7, 2011 we will celebrate Thomas Bayes' 250th death anniversary--
%
% Created by A. Trujillo-Ortiz, R. Hernandez-Walls, F.A. Trujillo-Perez
%            and N. Castro-Castro
%            Facultad de Ciencias Marinas
%            Universidad Autonoma de Baja California
%            Apdo. Postal 453
%            Ensenada, Baja California
%            Mexico.
%            atrujo@uabc.mx
% Copyright. September 1, 2009.
%
% To cite this file, this would be an appropriate format:
% Trujillo-Ortiz, A., R. Hernandez-Walls, F.A. Trujillo-Perez and 
%   N. Castro-Castro (2009). Bayes:Bayes' theorem:the discrete case.
%   A MATLAB file. [WWW document]. URL http://www.mathworks.com/matlabcentral/
%   fileexchange/25203
%

if nargin < 4
    d == 1; %default
end

P = a; %a priori (prior or marginal) probability [actual]
disp(' ');
if d == 1
    disp('You should have given the two conditional probabilities p(Y|X) and p(Y|~X).');
    disp('Where, ~Y is the complement event of Y.');
    M = b; %First conditional probability, p(Y|X) 
    N = c; %Second conditional probability, p(Y|~X) 
    %The interaction probabilities are:
    A = P*M; %p(XY) [true positive]
    B = (1-P)*N; %p(~XY)[false positive]
    C = P*(1-M); %p(X~Y) [false negative]
    D = (1-P)*(1-N); %p(~X~Y) [true negative]
elseif d == 2
    disp('You should have given the two interaction probabilities p(XY) and p(~XY).');
    disp('Where, ~Y is the complement event of Y.');
    A = b; %First interaction probability, p(XY) [true positive]
    B = c; %Second interaction probability, p(X~Y) [false positive]
    Ac = 1-P; %p(~X)
    C = P-A; %false positive
    D = Ac-B; %true positive
else d == 3
    disp('You should have given, in this strictly order, one conditional probability [p(Y|X)] and');
    disp('one interecation probability [p(~XY)].');
    disp('Where, ~Y is the complement event of Y.');
    M = b; %Conditional probability, p(Y|X)
    A = P*M; %First interaction probability, p(XY)
    B = c; %Second interaction probability, p(~XY)
    Ac = 1-P; %p(~X)
    C = P-A; %false positive
    D = Ac-B; %true positive
end

x = A/(A+B); %chance positive test or positive result (posterior probability)

disp(' ');
i = input('Do you want a frequency visualization of a sample? (y/n): ','s');
if i == 'y'
    n = input('Give me the sample size: ');
    nX = a*n;
    nXc = n-nX;
    XY = A*n;
    XYc = C*n;
    XcY = B*n;
    XcYc = D*n;
    disp(' ');
    fprintf('Sample size = %2i\n', n);
    fprintf('X = %2i\n', nX);
    fprintf('~X = %2i\n', nXc);
    fprintf('XY = %2i\n', XY);
    fprintf('X~Y = %2i\n', XYc);
    fprintf('~XY = %2i\n', XcY);
    fprintf('~X~Y = %2i\n', XcYc);
else
end

x = A/(A+B); %chance positive test or positive result (posterior probability)

return,