function [AnDarksamtest] = AnDarksamtest(X,alpha)
%ANDARKSAMTEST Anderson-Darling k-sample procedure to test whether
% k sampled populations are identical
% 
% Anderson and Darling (1952,1954) introduced a goodness-of-fit statistic
%
%                         _inf            2
%                        /  {Fm(x) - Fo(x)}
%              ADm = m  /  ----------------- dFo(x)
%                 -inf_/    Fo(x){1 - Fo(x)}
%  
% to test the hypothesis that a random sample Fm(x) comes from a continuous
% population with a specified distribution function Fo(x). It is a 
% modification of the Kolmogorov-Smirnov (K-S) test and gives more weight
% to the tails than the K-S test.
%
% The corresponding two-sample version,
%
%                              _inf            2
%                  mn         /  {Fm(x) - Gn(x)}
%          ADmn = ----       /  ----------------- dHn(x)
%                   N  -inf_/    Hn(x){1 - Hn(x)}
%
% was proposed by Darling (1957) and studied in detail by Pettitt (1976). 
% Where Gn(x) is the empirical distribution function of the second 
% independent sample G(x) and Hn(x) = {mFm(x) + nGn(x)}/N, with N = m+n, is
% the empirical distribution function of the pooled sample. It is used to
% test the hypothesis that F = G.
%
% The Anderson-Darling k-sample test was introduced by Scholz and Stephens
% (1987) as a generalization of the two-sample Anderson-Darling test. It is
% a nonparametric statistical procedure, i.e., a rank test, and, thus, 
% requires no assumptions other than that the samples are true independent 
% random samples from their respective continuous populations (although 
% provisions for tied observations are made). It tests the hypothesis that
% the populations from which two or more independent samples of data were
% drawn are identical. This test can be used to decide whether data from
% different sources may be combined, because they are judged to come from
% one common distribution, i.e., the null hypothesis Ho of same population
% distributions cannot be rejected. In its opposite use, it can be seen as
% a generalization of a one-way ANOVA  for which the k-sample Kruskal-Wallis
% test (1952, 1953) is the most commonly used rank test.
%
% It is an omnibus test because of its effectiveness against all alternatives
% to the null hypothesis Ho's (all k populations being equal). For example,
% it is effective for changes in scale while locations are matched, which is
% a weakness of the Kruskal-Wallis test.
%
% The Anderson-Darling k-sample procedure assumes that i-th sample has a 
% continuous distribution function and we are interested in testing the null
% hypothesis that all sampled populations have the same distribution, without
% specifying the nature of that common distribution,
%
%                        Ho: F1 = F2 = ... = Fk
%
% without specifying the nature of that common distribution F. The statistic
% is,
%
%                _k _          _               2
%                \           /  {Fi(x) - Hn(x)}
%        ADK  =  /_ _   ni  /  ----------------- dHn(x)
%                i=1   Bn _/    Hn(x){1 - Hn(x)}
%
% where Bn = {x E R:Hn(x) < 1}.
%
% The computational formula for ADK* adjusted for ties is,
%
%                     _k _          _L _                2
%               n-1   \        1    \      {nFij - niHj}
%        ADK  = ----  /_ _  [ ----  /_ _  ---------------- ]
%               n^2   i=1      ni   j=1   Hj(n-Hj) - nhj/4
%               
%
% and the corresponding not adjusted for ties is
%
%                     _k _          L-1_               2
%                1    \        1    \       {nFij - niHj}
%        ADKn = ----  /_ _  [ ----  /_ _  ---------------- ]
%                n    i=1      ni   j=1        Hj(n-Hj)
%
% where:
%  k = number of groups (samples); i=1,2,...,k
%  ni = data values in the ith group; j=1,2,...ni
%  n = number total of observations (data); n=n1+n2+...+nk
%  xij = data in the i group and j observation within that group
%  z(j) = distinct values of all combined data ordered in ascendent way
%         denoted z(1),z(2),...,z(L)
%  L = lergest unique value, where it will be less than n with tied values
%  hj = number of values in the pooled sample equal to z(j)
%  Hj = number of values in the combined samples less than zj plus one half
%       the number of values in the combined samples equal to zj
%  Fij = number of values in the ith group which are less than zj plus one
%        half the number of values in this group which are equal to zj
%  
% Under Ho and assuming continuity of the common F distribution the mean of
% ADK is k-1 and the variance* is,
%                            
%                          an^3 + bn^2 + cn + d 
%               var(ADK) = --------------------- 
%                             (n-1)(n-2)(n-3)
%
% where,
%               a = (4g - 6)(k-1) + (10 - 6g)S
%               b = (2g -4)k^2 + 8Tk + (2g - 14T -4)S - 8T + 4g -6
%               c = (6T + 2g -2)k^2 + (4T - 4g + 6)k + (2T -6)S + 4T
%               d = (2T +6)k^2 - 4Tk
%                
% with,
%                   _k _               _n-1_
%                   \      1           \      1
%               S = /_ _  ---- ,   T = /_ _  ----  
%                          ni           i=1   i
%
% and
%                         _n-2_   _n-1_
%                         \       \        1
%                     g = /_ _    /_ _   ------  
%                         i=1     j=i+1  (n-i)j
%
% The observed k-sample Anderson-Darling statistic (ADK) is standardized
% using its exact sample mean and standard deviation to removes some of its
% dependence on the sample size. Then,
%
%                             ADK - (k-1)
%                      ADKs = ------------
%                               std(ADK)
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% *NOTE.-In some literature as in DOD-MIL-HDBK-17-1E_Vol 1, Ch. 8, Polymer
% Matrix Composites (1997) you can find this statistic with an equivalent
% mathematical expressions as:
%
%                         _k _          _L _                2
%                 n-1     \        1    \      {nFij - niHj}
%        ADK  = --------  /_ _  [ ----  /_ _  ---------------- ] ,
%               n^2(k-1)   i=1      ni   j=1   Hj(n-Hj) - nhj/4
%
%
%                              an^3 + bn^2 + cn + d 
%                 var(ADK) = ------------------------ ,
%                             (n-1)(n-2)(n-3)(k-1)^2
%
% and
%
%                                  ADK - 1
%                          ADKs = --------- .
%                                  std(ADK)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% The approximate P-value of the observed ADK statistic can be calculated
% using a spline interpolation method. For the interested users, we are
% including, as a comment, the mathematical procedure to get the ADK 
% critical value.
%
% The interpolation coefficients for each alpa-value,
%
%               alpha = [0.25,0.10 0.05 0.025 0.01]
% are:
%                  bo = [0.675,1.281,1.645,1.96,2.326]
%                  b1 = [-0.245,0.25,0.678,1.149,1.822]
%                  b2 = [-0.105,-0.305,-0.362,-0.391,-0.396]
%
% and the general formula interpolation is,
%
%                  qnt = bo + b1/sqrt(k-1) + b2/(k-1)
%
% We give the Anderson-Darling k-sample procedure with and without 
% adjustment for ties.
%
% Finally, we compare the P-value with the desired significance level alpha
% to facilitate a decision about the null hypothesis Ho. 
%
% Syntax: function AnDarksamtest(X,alpha) 
%      
% Inputs:
%      X - data matrix (Size of matrix must be n-by-2; data=column 1,
%          sample=column 2) 
%  alpha - significance level (default = 0.05)
%
% Output:
%        - Complete Anderson-Darling k-sample test
%
% Example: From the example given by Scholz and Stephens (1987, p.922). It
% is interested to test if the four sets of eight measurements each of the
% smoothness of a certain type of paper obtained by four independent 
% laboratories are homogeneous or identical to consider them
% unstructurated. We use an alpha-value = 0.05. Data are,
%
%  -----------------------------------------------------------------
%    Laboratory                      Smoothness
%  -----------------------------------------------------------------
%        1          38.7  41.5  43.8  44.5  45.5  46.0  47.7  58.0
%        2          39.2  39.3  39.7  41.4  41.8  42.9  43.3  45.8
%        3          34.0  35.0  39.0  40.0  43.0  43.0  44.0  45.0
%        4          34.0  34.8  34.8  35.4  37.2  37.8  41.2  42.8
%  -----------------------------------------------------------------
%
% Data vector is:
%  X=[38.7 1;41.5 1;43.8 1;44.5 1;45.5 1;46.0 1;47.7 1;58.0 1;
%  39.2 2;39.3 2;39.7 2;41.4 2;41.8 2;42.9 2;43.3 2;45.8 2;
%  34.0 3;35.0 3;39.0 3;40.0 3;43.0 3;43.0 3;44.0 3;45.0 3; 
%  34.0 4;34.8 4;34.8 4;35.4 4;37.2 4;37.8 4;41.2 4;42.8 4];
%
% Calling on Matlab the function: 
%            AnDarksamtest(X)
%
% Answer is:
%
% K-sample Anderson-Darling Test
% ----------------------------------------------------------------------------
% Number of samples: 4
% Sample sizes: 8 8 8 8
% Total number of observations: 32
% Number of ties (identical values): 3
% Mean of the Anderson-Darling rank statistic: 3
% Standard deviation of the Anderson-Darling rank statistic: 1.2037664
% ----------------------------------------------------------------------------
% Not adjusted for ties.
% ----------------------------------------------------------------------------
% Anderson-Darling rank statistic: 8.3558723
% Standardized Anderson-Darling rank statistic: 4.4492622
% Probability associated to the Anderson-Darling rank statistic = 0.0022547
% 
% With a given significance = 0.050
% The samples were drawn from different populations: data may be considered
% structurated with respect to the random of fixed effect in question.
% ----------------------------------------------------------------------------
% Adjusted for ties.
% ----------------------------------------------------------------------------
% Anderson-Darling rank statistic: 8.3926093
% Standardized Anderson-Darling rank statistic: 4.4797806
% Probability associated to the Anderson-Darling rank statistic = 0.0021700
% 
% With a given significance = 0.050
% The samples were drawn from different populations: data may be considered
% structurated with respect to the random of fixed effect in question.
% ----------------------------------------------------------------------------
%
% Created by A. Trujillo-Ortiz, R. Hernandez-Walls, K. Barba-Rojo, 
%             L. Cupul-Magana and R.C. Zavala-Garcia
%             Facultad de Ciencias Marinas
%             Universidad Autonoma de Baja California
%             Apdo. Postal 453
%             Ensenada, Baja California
%             Mexico.
%             atrujo@uabc.mx
%
% Copyright. November 1, 2007.
%
% ---Special thanks are given to Michael Singer, Department of Earth & 
%    Planetary Science, Institute for Computational Earth System Science,
%    University of California at Berkely, for encouraging us to create
%    this m-file--
% ---We are grateful to Fritz Scholz and Michael Stephens, the authors of
%    of this test for their valuable suggestions to improve the clarity of
%    the presentation.
%
%  To cite this file, this would be an appropriate format:
%  Trujillo-Ortiz, A., R. Hernandez-Walls, K. Barba-Rojo, L. Cupul-Magana
%    and R.C. Zavala-Garcia. (2007). AnDarksamtest:Anderson-Darling k-sample
%    procedure to test the hypothesis that the populations of the drawned
%    groups are identical. A MATLAB file. [WWW document]. URL http://
%    www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=17451
%
% References:
% Anderson, T.W. and Darling, D.A. (1952), Asymptotic Theory of Certain
%     Goodness of Fit Criteria Based on Stochastic Processes. Annals of
%     Mathematical Statistics, 23:193-212.
% Anderson, T.W. and Darling, D.A. (1954), A Test of Goodness of Fit. 
%     Journal of the American Statistical Association, 49:765-769.
% Darling, D.A. (1957), The Kolmogorov-Smirnov, Cramer-von Mises
%     Tests. Annals of Mathematical Statistics, 28:823-838.
% Kruskal, W.H. and Wallis, W.A. (1952), Use of ranks in one-criterion
%     variance analysis. Journal of the American Statistical Association,
%     47(260):583–621.
% Kruskal, W.H. and Wallis, W.A. (1953), Errata to Use of ranks in one-
%     criterion variance analysis. Journal of the American Statistical 
%     Association, 48:907-911.
% MIL-HDBK-17-1E (1997), The Composite Materials Handbook, Volume 1.
%     Polymer Matrix Composites: Guidelines for Characterization of
%     Structural Materials. Chapter 8, Department of Defense, 
%     Washington, D.C.
% Pettitt, A.N. (1976), A Two-Sample Anderson-Darling Rank Statistic.
%     Biometrika, 63:161-168.
% Scholz, F.W. and Stephens, M.A. (1987), K-Sample Anderson-Darling Tests.
%     Journal of the American Statistical Association, 82:918-924.
%

switch nargin
    case{2}
        if isempty(X) == false && isempty(alpha) == false
            if (alpha <= 0 || alpha >= 1)
                fprintf('Warning: Significance level error; must be 0 < alpha < 1 \n');
                return;
            end
        end
    case{1}
        alpha = 0.05;
    otherwise 
        error('Requires at least one input argument.');
end

X1 = X(:,1); %data vector
X2 = X(:,2); %grouping vector
k = max(X2); %number of samples (groups)
N = length(X1); %total number of data

if (k < 2),
    error('There must have at leat two samples.');
end

[c,v] = hist(sort(X1),sort(X1));
nc = find(c~=0);
c = [v(nc) c(nc)'];
hj = c(:,2); %number of values in combined samples equal to zj
hjn = c(1:end-1,2);
O = sort(X1);
zj = unique(O); %distinct values in the combined data set ordered
L = length(zj); 
zjn = zj(1:end-1); %distinct values in the combined data set ordered 
                   %for adjust for ties
Ln = length(zjn);

n=[];fij=0;Fij=0;Fijn=0;NN=0;DD=0;ADK1=0;ADK1n=0;
for i=1:k,
    r = find(X2 == i); 
    ni = length(r); %number of observations in sample i
    n = [n ni];
    if (any(ni==0)),
        error('One or more samples have no observations.');
    end
    rx = X1(r);
    [x1,x2] = ndgrid(rx,zj);
    [x1n,x2n] = ndgrid(rx,zjn);
    fij = sum(x1==x2);
    fijn = sum(x1n==x2n);
    Fij = [cumsum(fij)-(fij*.5)]'; %number of values in the ith group
                                   %which are less than zj plus one
                                   %half the number of values in this
                                   %group which are equal to zj. It is
                                   %adjusted for ties.
    
    Fijn = [cumsum(fijn)]'; %number of values in the ith group
                            %which are less than zj plus one
                            %half the number of values in this
                            %group which are equal to zj. It is
                            %not adjusted for ties.

    Hj = [cumsum(hj)-(hj*.5)]; %number of values in the combined samples less 
                           %than zj plus one half the number of values in
                           %the combined samples equal to zj. It is         
                           %adjusted for ties.

    Hjn = [cumsum(hjn)]; %number of values in the combined samples less 
                           %than zj plus one half the number of values in
                           %the combined samples equal to zj. It is not
                           %adjusted for ties.

    NN = (N*Fij-ni*Hj).^2;
    DD = (Hj.*(N-Hj))-(N*hj./4);
    ADK1 = ADK1 + (1/ni*sum(hj.*(NN./DD)));
    
    NNn = (N*Fijn-ni*Hjn).^2;
    DDn = Hjn.*(N-Hjn);
    ADK1n = ADK1n + (1/ni*sum(hjn.*(NNn./DDn)));
end

%k-sample Anderson-Darling observed statistic
ADK = ((N-1)/N^2)*ADK1; %adjusted for ties

ADKn = 1/N*ADK1n; %not adjusted for ties

%Exact sample variance of the k-sample Anderson-Darling
S = sum(1./n);
i = 1:N-1;
T = sum(1./i);

g=0;
for i = 1:N-2,
    g = g + (1./(N-i))*sum(1./((i+1):(N-1)));
end

a=0;b=0;c=0;d=0;
a = (4*g-6)*(k-1)+(10-6*g)*S;
b = (2*g-4)*k^2+8*T*k+(2*g-14*T-4)*S-8*T+4*g-6;
c = (6*T+2*g-2)*k^2+(4*T-4*g+6)*k+(2*T-6)*S+4*T;
d = (2*T+6)*k^2-4*T*k;

vADK = ((a*N^3)+(b*N^2)+(c*N)+d)/((N-1)*(N-2)*(N-3));

ADKs = (ADK-(k-1))/sqrt(vADK); %standardized k-sample Anderson-Darling 
                               %statistic

ADKsn = (ADKn-(k-1))/sqrt(vADK); %standardized k-sample Anderson-Darling 
                                 %statistic not adjusted for ties

%k-sample Anderson-Darling P-value calculation by an extrapolate-interpolate
%procedure
bo = [0.675,1.281,1.645,1.96,2.326];
b1 = [-0.245,0.25,0.678,1.149,1.822];
b2 = [-0.105,-0.305,-0.362,-0.391,-0.396];
qnt = bo+b1/sqrt(k-1)+b2/(k-1);
c0 = [1.0986123,2.1972246,2.9444390,3.6635616,4.5951199];

%not adjusted for ties
ext=0;
if (ADKs < qnt(1))|(ADKs >qnt(5)),
    ext = 1;
end
x = zeros(4,1);
yx = zeros(4,1);
if (ADKs <= qnt(3)),
    for i = 1:4,
        x(i) = qnt(i);
        yx(i) = c0(i);
    end
else
    for i = 1:4,
        x(i) = qnt(i+1);
        yx(i) = c0(i+1);
    end
end
y = yx;

Y = interp1(x,y,ADKs,'spline');
P = 1/(1+exp(Y));

%adjusted for ties
ext=0;
if (ADKsn < qnt(1))|(ADKsn >qnt(5)),
    ext = 1;
end
x = zeros(4,1);
yx = zeros(4,1);
if (ADKsn <= qnt(3)),
    for i = 1:4,
        x(i) = qnt(i);
        yx(i) = c0(i);
    end
else
    for i = 1:4,
        x(i) = qnt(i+1);
        yx(i) = c0(i+1);
    end
end
y = yx;

Y = interp1(x,y,ADKsn,'spline');
Pn = 1/(1+exp(Y));

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Optional k-sample Anderson-Darling critical value calculation procedure
% zc=norminv(1-alpha);
% 
% if (alpha == 0.25),
%     ADKc = 1 + sqrt(vADK)*(zc+(0.25/sqrt(k-1)) - (-0.105/(k-1)));
% elseif (alpha == 0.10),
%     ADKc = 1 + sqrt(vADK)*(zc+(-0.245/sqrt(k-1)) - (-0.305/(k-1)));
% elseif (alpha == 0.05),
%     ADKc = 1 + sqrt(vADK)*(zc+(0.678/sqrt(k-1)) - (0.362/(k-1)));
% elseif (alpha == 0.025),
%     ADKc = 1 + sqrt(vADK)*(zc+(1.149/sqrt(k-1)) - (-0.391/(k-1)));
% else (alpha == 0.01),
%     ADKc = 1 + sqrt(vADK)*(zc+(1.822/sqrt(k-1)) - (-0.396/(k-1)));
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(' ')
disp('K-sample Anderson-Darling Test')
disp('----------------------------------------------------------------------------')
fprintf('Number of samples: %i\n', k);
fprintf(['Sample sizes: ', repmat('%d ', 1, length(n)-1), '%d\n'], n);
fprintf('Total number of observations: %i\n', N);
fprintf('Number of ties (identical values): %i\n', N-L);
fprintf('Mean of the Anderson-Darling rank statistic: %i\n', k-1);
fprintf('Standard deviation of the Anderson-Darling rank statistic: %3.7f\n', sqrt(vADK));
disp('----------------------------------------------------------------------------')
disp('Not adjusted for ties.')
disp('----------------------------------------------------------------------------')
fprintf('Anderson-Darling rank statistic: %3.7f\n', ADKn);
fprintf('Standardized Anderson-Darling rank statistic: %3.7f\n', ADKsn);
fprintf('Probability associated to the Anderson-Darling rank statistic = %3.7f\n', Pn);
disp(' ')
fprintf('With a given significance = %3.3f\n', alpha);

if Pn >= alpha;
    disp('The populations from which the k-samples of data were drawn are identical:');
    disp('natural groupings have no significant effect (unstructurated).');
else
    disp('The samples were drawn from different populations: data may be considered'); 
    disp('structurated with respect to the random of fixed effect in question.');
end
disp('----------------------------------------------------------------------------')
disp('Adjusted for ties.')
disp('----------------------------------------------------------------------------')
fprintf('Anderson-Darling rank statistic: %3.7f\n', ADK);
fprintf('Standardized Anderson-Darling rank statistic: %3.7f\n', ADKs);
fprintf('Probability associated to the Anderson-Darling rank statistic = %3.7f\n', P);
disp(' ')
fprintf('With a given significance = %3.3f\n', alpha);
if P >= alpha;
    disp('The populations from which the k-samples of data were drawn are identical:');
    disp('natural groupings have no significant effect (unstructurated).');
else
    disp('The samples were drawn from different populations: data may be considered'); 
    disp('structurated with respect to the random of fixed effect in question.');
end
disp('----------------------------------------------------------------------------')

return,