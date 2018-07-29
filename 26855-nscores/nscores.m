function STATS=nscores(varargin)
% NSCORES Executes the Van der Waerden version of non parametric tests (Normal
% scores tests).
% Named for the Dutch mathematician Bartel Leendert van der Waerden, the Van der
% Waerden test is a statistical test that k population distribution functions
% are equal. The Van Der Waerden test converts the ranks to quantiles of the
% standard normal distribution. These are called normal scores and the test is
% computed from these normal scores. The standard ANOVA assumes that the errors
% (i.e., residuals) are normally distributed. If this normality assumption is
% not valid, an alternative is to use a non-parametric test. The advantage of
% the Van Der Waerden test is that it provides the high efficiency of the
% standard ANOVA analysis when the normality assumptions are in fact satisfied,
% but it also provides the robustness of the non-parametric test when the
% normality assumptions are not satisfied.
% This function compute the Van der Waerden version of 5 tests:
% - Levene, Mann-Whitney-Wilcoxon and Wilcoxon tests when there are 2 groups;
% - Kruskal-Wallis and Friedman test whene there are more than 2 groups.
% 
% The function will use a GUI to select the proper test.
%
% Syntax: 	STATS=nscores(X)
%      
%     Inputs:
%           X - data matrix (Size of matrix must be n-by-2; data=column 1, group=column 2). 
%
%     Outputs:
%           - Z
%           - p-value
%
%        If STATS nargout was specified the results will be stored in the STATS
%        struct.
%
%      Example: 
%
%                             Sample
%                   -------------------------
%                      1        2        3    
%                   -------------------------
%                      8.84     8.65     7.89
%                      9.92    10.7 	 9.16
%                      7.2     10.24	 7.34
%                      9.25     8.62	10.28
%                      9.45     9.94	 9.12
%                      9.14    10.55	 9.24
%                      9.99    10.13	 8.4
%                      9.21	    9.78	 8.6
%                      9.06	    9.01	 8.04
%                                		 8.45
%                                        9.51
%                                        8.15
%                                        7.69
%                   -------------------------
%
%       Data matrix must be:
% x=[8.84 9.92 7.20 9.25 9.45 9.14 9.99 9.21 9.06 8.65 10.70 10.24 8.62 9.94 10.55 10.13 9.78 9.01 7.79 9.16 7.64 10.28 9.12 9.24 8.40 8.60 8.04 8.45 9.51 8.15 7.69; repmat(1,1,9) repmat(2,1,9) repmat(3,1,13)]';
%
%           Calling on Matlab:
%           - nscores(x(1:18)) a GUI will ask you what test to perform among Levene, Mann-Whitney-Wilcoxon or Wilcoxon tests
%           - nscores(x(1:17)) a GUI will ask you which test to perform between Levene and Mann-Whitney-Wilcoxon tests
%           - nscores(x(1:27,:)) a GUI will ask you which test to perform between Kruskal-Wallis and Friedman tests
%           - nscores(x) a GUI will inform you that the only test that is possible to perform is the Kruskal-Wallis test
%
%           Created by Giuseppe Cardillo
%           giuseppe.cardillo-edta@poste.it
%
% To cite this file, this would be an appropriate format:
% Cardillo G. (2010). NSCORES: Van der Waerden normal scores version of several
% non-parametric tests.
% http://www.mathworks.com/matlabcentral/fileexchange/26855

%Input Error handling
args=cell(varargin);
nu=numel(args);
if nu==0 || nu>2
    error('Warning: Max two input data are required')
end
default.values = {[],0.05};
default.values(1:nu) = args;
[x alpha] = deal(default.values{:});

if nu>=1 %only x
    if isempty(x)
        error('Warning: X matrix is empty...')
    end
    if isvector(x)
        error('Warning: x must be a matrix, not a vector.');
    end
    if ~all(isfinite(x(:))) || ~all(isnumeric(x(:)))
        error('Warning: all X values must be numeric and finite')
    end
    %check if x is a Nx2 matrix
    if size(x,2) ~= 2
        error('Warning: NSCORES requires a Nx2 input matrix')
    end
    %check if x(:,2) are all whole elements
    if ~all(x(:,2) == round(x(:,2)))
        error('Warning: all elements of column 2 of input matrix must be whole numbers')
    end
end
if nu==2
    if ~isscalar(alpha) || ~isnumeric(alpha) || ~isfinite(alpha) || isempty(alpha)
        error('Warning: it is required a numeric, finite and scalar ALPHA value.');
    end
    if alpha <= 0 || alpha >= 1 %check if alpha is between 0 and 1
        error('Warning: ALPHA must be comprised between 0 and 1.')
    end
end
clear args default nu


%check if max(x(:,2))>=2
k=max(x(:,2));
if k<2
    error('Warning: almost two groups are required...')
end

n=zeros(1,k);
for I=1:k
    n(I)=length(x(x(:,2)==I));
end

if k==2
    if isequal(n./n(1),ones(size(n)))
        tst = menu('SELECT THE TEST THAT YOU WANT TO PERFORM','LEVENE TEST','MANN-WHITNEY-WILCOXON TEST (UNPAIRED TEST)','WILCOXON TEST (PAIRED TEST)');
    else
        tst = menu('SELECT THE TEST THAT YOU WANT TO PERFORM','LEVENE TEST','MANN-WHITNEY-WILCOXON TEST (UNPAIRED TEST)');
    end
else
    if isequal(n./n(1),ones(size(n)))
        aw = menu('SELECT THE TEST THAT YOU WANT TO PERFORM','KRUSKAL-WALLIS TEST (ONE WAY ANOVA)','FRIEDMAN TEST (TWO-WAY ANOVA; WITHOUT REPLICATIONS)');
    else
        aw = menu('SELECT THE TEST THAT YOU WANT TO PERFORM','KRUSKAL-WALLIS TEST (ONE WAY ANOVA)');
    end
    tst=aw*2;
end

switch tst
    case 1 %Levene Test
        L=length(x); Matrix=zeros(L,8); %set the basic parameter
        Matrix(:,[1 2])=x;
        for I=1:k
            Matrix(Matrix(:,2)==I,3)=Matrix(Matrix(:,2)==I,1)-mean(Matrix(Matrix(:,2)==I,1));
        end
        Matrix(:,4)=tiedrank(Matrix(:,3)); %ranks
        Matrix(:,5)=Matrix(:,4)./(L+1); %transform ranks in quantile
        Matrix(:,6)=norminv(Matrix(:,5)); %normal scores
        Matrix(:,7)=Matrix(:,6).^2;
        Matrix(:,8)=Matrix(:,6).^4;
        [m,I]=min(n);
        A=[sum(Matrix(Matrix(:,2)==I,7)) sum(Matrix(:,7:8))];
        Z=(A(1)-(m/L*A(2)))/realsqrt(prod(n)/L/(L-1)*(A(3)-1/L*A(2)^2)); %Statistics
    case 2 %Mann-Whitney-Wilcoxon or Kruskal Wallis test
        L=length(x); Matrix=zeros(L,6); %set the basic parameter
        Matrix(:,[1 2])=x;
        Matrix(:,3)=tiedrank(Matrix(:,1)); %ranks
        Matrix(:,4)=Matrix(:,3)./(L+1); %transform ranks in quantile
        Matrix(:,5)=norminv(Matrix(:,4)); %normal scores
        Matrix(:,6)=Matrix(:,5).^2; %square of normal scores
        Zbar=zeros(1,k); %preallocate mean normal scores array
        for I=1:k
            Zbar(I)=mean(Matrix(Matrix(:,2)==I,5)); %mean normal scores
        end
        s2=sum(Matrix(:,6))/(L-1);
        Z=realsqrt(sum(n.*Zbar.^2)/s2); %Statistics
     case 3 %Wilcoxon test
        x1=x(x(:,2)==1); x2=x(x(:,2)==2);
        dff=x2-x1; %difference between x1 and x2
        nodiff = find(dff == 0);  %find null variations
        dff(nodiff) = []; %eliminate null variations
        if isempty(nodiff)==0 %tell me if there are null variations
            fprintf('There are %d null variations that will be deleted\n',length(nodiff))
            disp(' ')
        end
        if isempty(dff) %if all variations are null variations exit function
            disp('There are not variations. Van der Waerden - Wilcoxon test can''t be performed')
            return
        end
        clear nodiff %clear unnecessary variable
        %Ranks of absolute value of samples differences with sign
        R=tiedrank(abs(dff)); %ranks of diff
        P=(1+R./(length(R)+1))/2; %transform ranks in quantile
        Zp=norminv(P); %normal scores
        A=sign(dff).*Zp; %normal scores with sign
        Z=sum(A)/realsqrt(sum(A.^2)); %Statistics
    case 4 %Friedman test
        b=n(1); k=max(x(:,2)); %blocks and treatments
        y=reshape(x(:,1),b,k);
        Matrix=zeros(b,k); Rij=Matrix;
        for I=1:b
            Rij(I,:)=(tiedrank(y(I,:))); %ranks
        end
        Matrix=norminv(Rij./(k+1)); %normal scores
        s2=sum(sum(Matrix.^2));
        Z=realsqrt(sum(sum(Matrix).^2)*(k-1)/s2);
end

p=2*(1-normcdf(Z));  %p-value
%display results
tr=repmat('-',1,80); %set the divisor
fprintf('VAN DER WAERDEN VERSION OF ')
switch tst
    case 1
        fprintf('LEVENE TEST\n')
    case 2
        if k==2
            fprintf('MANN-WHITNEY-WILCOXON TEST\n')
        else
            fprintf('KRUSKAL-WALLIS TEST\n')
        end
    case 3
        fprintf('WILCOXON TEST\n')
    case 4
        fprintf('FRIEDMAN TEST FOR IDENTICAL TREATMENT EFFECTS:\n')
        disp('TWO-WAY BALANCED, COMPLETE BLOCK DESIGNS')
        disp(tr)
        fprintf('Number of observation: %i\n',b*k)
        fprintf('Number of blocks: %i\n',b)
        fprintf('Number of treatments: %i\n',k)
end
disp(tr)
fprintf('Z = %0.4f\tp-value (2-tailed) = %0.4f\n',Z,p)
disp(tr)

if p<alpha && (tst==2 || tst==4)
    disp(' ')
    disp('POST-HOC MULTIPLE COMPARISONS')
    disp(tr)
    if tst==2
        C=0.5*k*(k-1);
        alpha=alpha/C; %Bonferroni correction
        CD=tinv(1-alpha/2,L-k)*realsqrt(s2*(L-1-Z^2)/(L-k));
        Zdiff=zeros(k,k); mc=Zdiff; CDc=Zdiff;
        for J=1:k-1
            for I=2:k
                Zdiff(I,J)=abs(Zbar(I)-Zbar(J));
                CDc(I,J)=CD*realsqrt(1/sum(x(:,2)==I)+1/sum(x(:,2)==J));
                if Zdiff(I,J)>CDc(I,J)
                    mc(I,J)=1;
                end
            end
        end
        %display results
        disp('Absolute difference among normal scores')
        disp(Zdiff)
        disp('Critical Values')
        disp(CDc)
        disp('Absolute difference > Critical Value')
        disp(mc)
    elseif tst==4
        tmp=repmat(sum(Rij),k,1); Rdiff=abs(tmp-tmp'); %Generate a matrix with the absolute differences among ranks
        gl=(b-1)*(k-1);
        cv=tinv(1-alpha/2,gl)*realsqrt((2*b*s2/gl)*(1-Z.^2/(b*(k-1)))); %critical value
        mc=Rdiff>cv; %Find differences greater than critical value
        %display results
        fprintf('Critical value: %0.4f\n',cv)
        disp('Absolute difference among mean ranks')
        disp(tril(Rdiff))
        disp('Absolute difference > Critical Value')
        disp(tril(mc))
    end
end

if nargout
    STATS.Z=Z;
    STATS.pvalue=p;
end