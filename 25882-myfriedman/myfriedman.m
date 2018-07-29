function myfriedman(varargin)
% The Friedman test is a non-parametric statistical test developed by the U.S.
% economist Milton Friedman. Similar to the parametric repeated measures ANOVA,
% it is used to detect differences in treatments across multiple test attempts.
% The procedure involves ranking each row (or block) together, then considering
% the values of ranks by columns. Applicable to complete block designs, it is
% thus a special case of the Durbin test. The Friedman test is used for two-way
% repeated measures analysis of variance by ranks. In its use of ranks it is
% similar to the Kruskal-Wallis one-way analysis of variance by ranks. 
% When the number of blocks or treatments is large (i.e. n > 15 or k > 4), the
% probability distribution can be approximated by that of a chi-square
% distribution. If n or k is small, the  approximation to chi-square becomes
% poor and the p-value should be obtained from tables of Q specially prepared
% for the Friedman test. The MatLab function FRIEDMAN only uses the chi-square
% approximation. On the contrary, MYFRIEDMAN uses the exact distribution for
% small size samples else the F distribution and the chi-square distributions. 
% If the p-value is significant, a post-hoc multiple comparisons tests is
% performed. By itself, MYFRIEDMAN runs a demo
%
% Syntax: 	myfriedman(X,REPS)
%      
%     Inputs:
%           X - data matrix
%           REPS - If there is more than one observation per row-column pair,
%           then the argument REPS indicates the number of observations per
%           "cell". A cell contains REPS number of rows (default=1).
%           ALPHA - Significance levele (default=0.05)
%     Outputs:
%           - Used Statistic
%           - Multiple comparisons (eventually)
%
%      Example: 
%
%x=[115 142 36 91 28; 28 31 7 21 6; 220 311 108 51 117; 82 56 24 46 33; 256 298 124 46 84; 294 322 176 54 86; 98 87 55 84 25];
%
%           Calling on Matlab the function: myfriedman(x)
%
%           Answer is:
%
% FRIEDMAN TEST FOR IDENTICAL TREATMENT EFFECTS:
% TWO-WAY BALANCED, COMPLETE BLOCK DESIGNS
% --------------------------------------------------------------------------------
% Number of observation: 35
% Number of blocks: 7
% Number of treatments: 5
% Number of replicates: 1
% --------------------------------------------------------------------------------
% A (sum of squares of ranks): 385.0000
% C (correction factor): 315.0000
% --------------------------------------------------------------------------------
% Chi-square approximation (more conservative)
% Friedman test statistic T1 (uncorrected): 21.6000
% chi-square=T1 df=4 - p-value (2 tailed): 0.0002
% --------------------------------------------------------------------------------
% F-statistic approximation (less conservative)
% Friedman test statistic T2 (corrected): 20.2500
% F=T2 df-num=4 df-denom=24 - p-value (2 tailed): 0.0000
% --------------------------------------------------------------------------------
% The 5 treatments have not identical effects
%  
% POST-HOC MULTIPLE COMPARISONS
% --------------------------------------------------------------------------------
% Critical value: 6.3053
% Absolute difference among mean ranks
%      0     0     0     0     0
%      3     0     0     0     0
%     15    18     0     0     0
%     15    18     0     0     0
%     18    21     3     3     0
% 
% Absolute difference > Critical Value
%      0     0     0     0     0
%      0     0     0     0     0
%      1     1     0     0     0
%      1     1     0     0     0
%      1     1     0     0     0
%
%           Created by Giuseppe Cardillo
%           giuseppe.cardillo-edta@poste.it
%
% To cite this file, this would be an appropriate format:
% Cardillo G. (2009). MYFRIEDMAN: Friedman test for non parametric two way ANalysis Of VAriance
% http://www.mathworks.com/matlabcentral/fileexchange/25882

%Input Error handling
args=cell(varargin);
nu=numel(args);
if nu>3
    error('Warning: Max three input data are required')
end
default.values = {[115 142 36 91 28; 28 31 7 21 6; 220 311 108 51 117; 82 56 24 46 33; 256 298 124 46 84; 294 322 176 54 86; 98 87 55 84 25],1,0.05};
default.values(1:nu) = args;
[x reps alpha] = deal(default.values{:});
if nu>=1 %only x
    if isscalar(x)
        error('Warning: X must be a matrix')
    end
    if ~all(isfinite(x(:))) || ~all(isnumeric(x(:)))
        error('Warning: all values of X must be numeric and finite')
    end
end
if nu>=2
    if ~isscalar(reps) || ~isfinite(reps) || ~isnumeric(reps) || round(reps)~=reps
        error('Warning: it is required a scalar, numeric, finite and whole REPS value.')
    end
    if reps <= 0 
        error('Warning: REPS must be >0.')
    end
end
if nu==3
    if ~isscalar(alpha) || ~isnumeric(alpha) || ~isfinite(alpha) || isempty(alpha)
        error('Warning: it is required a numeric, finite and scalar ALPHA value.');
    end
    if alpha <= 0 || alpha >= 1 %check if alpha is between 0 and 1
        error('Warning: ALPHA must be comprised between 0 and 1.')
    end
end
clear args default nu


%Input error handling
[b,k]=size(x);
R=zeros(b,k); ties=zeros(b/reps,1); z=1; %array preallocation

for I=1:reps:b
    % Keep REPS rows and transform them into an array
    S=reshape(x(I:I+reps-1,:),1,k*reps); 
    % Rank the values
    [Sr,ts]=tiedrank(S);
    % Reshape the S array into REPSxk matrix and assign it to the proper R
    % slice.
    R(I:I+reps-1,:)=reshape(Sr,reps,k);
    if ts % check for ties
        ties(z)=1;
    end
    z=z+1;
end
T=sum(R); %The observed sum of ranks for each treatment
Te=b*(k*reps+1)/2; %The expected value of ranks sum under Ho
Tx=sum((T-Te).^2); % The Friedman statistic

N=b*k/reps;
A=sum(sum(R.^2));
C=N*reps^2*(k*reps+1)^2/4;
dAC=A-C;
%T1 is the chi square approximation...
if any(ties) %...with ties
    T1=(k-1)*Tx/dAC;
else %...without ties
    T1=12*Tx/(N*reps^2*(k*reps+1));
end
df=k-1; %chi-square degrees of freedom
P1=1-chi2cdf(T1,df);  %probability associated to the Chi-squared-statistic.
db=b-1;
T2=db*T1/(b*df-T1); %Transform chi-square into F
dfd=df*db; %denominator degrees of freedom
P2=1-fcdf(T2,df,dfd);  %probability associated to the F-statistic.
flag=0;

%display results
tr=repmat('-',1,80); %set the divisor
disp('FRIEDMAN TEST FOR IDENTICAL TREATMENT EFFECTS:')
disp('TWO-WAY BALANCED, COMPLETE BLOCK DESIGNS')
disp(tr)
fprintf('Number of observation: %i\n',b*k)
fprintf('Number of blocks: %i\n',b)
fprintf('Number of treatments: %i\n',k)
fprintf('Number of replicates: %i\n',reps)
disp(tr)
fprintf('A (sum of squares of ranks): %0.4f\n',A)
fprintf('C (correction factor): %0.4f\n',C)
disp(tr)
if (k==3 && b<=15) || (k==4 && b<=8) %Small size samples => exact distribution
    %This function uses only the critical value for alpha=0.05
    cvm=[NaN NaN 18 26 32 42 50 50 56 62 72 74 78 86 96;
        NaN 20 37 52 65 76 91 102 0 0 0 0 0 0 0];
    cv=cvm(df-1,b);
    if isnan(cv)
        disp('You must increase the number of subjects')
        disp(tr)
    else
        disp('Exact Friedman distribution for small size samples')
        fprintf('Friedman test statistic Fr: %0.4f\n', Tx)
        fprintf('Critical value for alpha=0.05 : %u\n',cv)
        disp(tr)
        if Tx>cv
            flag=1;
        end
    end
else
    fprintf('Chi-square approximation (more conservative)\n')
    fprintf('Friedman test statistic T1 (uncorrected): %0.4f\n',T1)
    fprintf('chi-square=T1 df=%i - p-value (2 tailed): %0.4f\n',df,P1)
    disp(tr);
    fprintf('F-statistic approximation (less conservative)\n')
    fprintf('Friedman test statistic T2 (corrected): %0.4f\n',T2)
    fprintf('F=T2 df-num=%i df-denom=%i - p-value (2 tailed): %0.4f\n',df,dfd,P2)
    disp(tr);
    if P2>alpha
        fprintf('The %i treatments have identical effects\n',k)
    else
        fprintf('The %i treatments have not identical effects\n',k)
        flag=1;
    end
end
if flag
    disp(' ')
    disp('POST-HOC MULTIPLE COMPARISONS')
    disp(tr)
    tmp=repmat(T,k,1); Rdiff=abs(tmp-tmp'); %Generate a matrix with the absolute differences among ranks
    cv=tinv(1-alpha/2,dfd)*realsqrt(2*(b*A-sum(T.^2))/dfd); %critical value
    mc=Rdiff>cv; %Find differences greater than critical value
    %display results
    fprintf('Critical value: %0.4f\n',cv)
    disp('Absolute difference among mean ranks')
    disp(tril(Rdiff))
    disp('Absolute difference > Critical Value')
    disp(tril(mc))
end