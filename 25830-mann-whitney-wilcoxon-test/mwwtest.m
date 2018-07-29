function STATS=mwwtest(x1,x2)
%Mann-Whitney-Wilcoxon non parametric test for two unpaired groups.
%This file execute the non parametric Mann-Whitney-Wilcoxon test to evaluate the
%difference between unpaired samples. If the number of combinations is less than
%20000, the algorithm calculates the exact ranks distribution; else it 
%uses a normal distribution approximation. The result is not different from
%RANKSUM MatLab function, but there are more output informations.
%There is an alternative formulation of this test that yields a statistic
%commonly denoted by U. Also the U statistic is computed.
%
% Syntax: 	STATS=MWWTEST(X1,X2)
%      
%     Inputs:
%           X1 and X2 - data vectors. 
%     Outputs:
%           - T and U values and p-value when exact ranks distribution is used.
%           - T and U values, mean, standard deviation, Z value, and p-value when
%           normal distribution is used.
%        If STATS nargout was specified the results will be stored in the STATS
%        struct.
%
%      Example: 
%
%         X1=[181 183 170 173 174 179 172 175 178 176 158 179 180 172 177];
% 
%         X2=[168 165 163 175 176 166 163 174 175 173 179 180 176 167 176];
%
%           Calling on Matlab the function: mwwtest(X1,X2)
%
%           Answer is:
%
% MANN-WHITNEY-WILCOXON TEST
% --------------------------------------------------------------------------------
% Sample size is good enough to use the normal distribution approximation
%  
% T		    U		    mT		    sT		    zT		    p-value (1-tailed)
% --------------------------------------------------------------------------------
% 270.0000	150.0000	232.5000	24.1071		1.5348		0.0624
% --------------------------------------------------------------------------------
%
%           Created by Giuseppe Cardillo
%           giuseppe.cardillo-edta@poste.it
%
% To cite this file, this would be an appropriate format:
% Cardillo G. (2009). MWWTEST: Mann-Whitney-Wilcoxon non parametric test for two unpaired samples.
% http://www.mathworks.com/matlabcentral/fileexchange/25830

%Input Error handling
if ~isvector(x1) || ~isvector(x2)
   error('MWWTEST requires vector rather than matrix data.');
end 
if ~all(isfinite(x1)) || ~all(isnumeric(x1)) || ~all(isfinite(x2)) || ~all(isnumeric(x2))
    error('Warning: all X1 and X2 values must be numeric and finite')
end

L=[length(x1) length(x2)]; k=min(L); N=sum(L); N1=N+1; %set the basic parameter

[A,B]=tiedrank([x1(:); x2(:)]); %compute the ranks and the ties
%Compute the Mann-Whitney-Wilcon statistic summing the ranks of the sample with
%the less number of elements.
if L(1)<=L(2)
    T=sum(A(1:L(1)));
else
    T=sum(A(L(1)+1:end));
end

%There is an alternative formulation of this test that yields a statistic
%commonly denoted by U. U is related to T by the formula U=T-k*(k+1)/2,
%where k is the size of the smaller sample (or either sample if both contain
%the same number of individuals). For a presentation of the U statistic, see:
% S. Siegel and N. J. Castellan, Jr., Nonparametric Statistics for the
% Behavioral Sciences, 2d ed. McGraw-Hill, New York, 1988, Section 6.4, “The
% Wilcoxon-Mann-Whitney U Test.”  
%For a detailed derivation and discussion of the Mann-Whitney test as developed
%here, as well as its relationship to U, see:
% F. Mosteller and R. Rourke, Sturdy Statistics: Nonparametrics and Order
% Statistics, Addison-Wesley, Reading, MA, 1973, Chapter 3, “Ranking Methods for
% Two Independent Samples.” 
U=T-k*(k+1)/2;


tr=repmat('-',1,80); %set the divisor
disp('MANN-WHITNEY-WILCOXON TEST')
disp(tr)
%if the number of combinations to obtain the exact MWW distribution is >20000
%use the normal approximation
if round(exp(gammaln(N1)-gammaln(k+1)-gammaln(N1-k))) > 20000
    mT=k*N1/2; %mean
    sT=realsqrt(prod(L)/12*(N1-2*B/N/(N^2-1))); %standard deviation
    zT=(abs(T-mT)-0.5)/sT; %z-value with correction for continuity
    p=1-normcdf(zT); %p-value
    %display results
    disp('Sample size is good enough to use the normal distribution approximation')
    disp(' ')
    fprintf('T\t\tU\t\tmT\t\tsT\t\tzT\t\tp-value (1-tailed)\n')
    disp(tr)
    fprintf('%0.4f\t%0.4f\t%0.4f\t%0.4f\t\t%0.4f\t\t%0.4f\n',T,U,mT,sT,zT,p)
    if nargout
        STATS.method='Normal approximation';
        STATS.T=T;
        STATS.U=U;
        STATS.mean=mT;
        STATS.std=sT;
        STATS.z=zT;
        STATS.p=p;
    end
else
    z=1:N;
    M=combnk(z,k); %M is the matrix of all possible combinations of N elements taken k at time
    pdf=sum(z(M),2); %probability density function of the MWW distribution
    %to compute the p-value see how many values are more extreme of the observed
    %T and then divide for the total number of combinations
    p=length(pdf(pdf>=T))/length(pdf); 
    %display results
    disp('The exact Mann-Whitney-Wilcoxon distribution was used')
    disp(' ')
    fprintf('T\t\tU\tp-value (1-tailed)\n')
    disp(tr)
    fprintf('%0.4f\t%0.4f\t%0.4f\n',T,U,p)
    if nargout
        STATS.method='Exact distribution';
        STATS.T=T;
        STATS.U=U;
        STATS.p=p;
    end
end
disp(tr)
disp(' ')
