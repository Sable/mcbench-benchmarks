function dunn(varargin)
%Dunn procedure for multiple non parametric comparisons.
%This file is applicable for equal or unequal sample sizes
%
% Syntax: 	DUNN(X,CTRL)
%      
%     Inputs:
%           X - data matrix (Size of matrix must be n-by-2; data=column 1, sample=column 2). 
%           CTRL - The first sample is a control group (1); there is not a
%           control group (0). (default=0).
%     Outputs:
%           - Sum of ranks and Mean rank vectors for each group.
%           - Ties factor
%           - Q-value for each comparison.
%           - Q critical value.
%           - whether or not Ho is rejected.
%
%      Example: 
%
%                                 Sample
%                   ---------------------------------
%                       1       2       3       4
%                   ---------------------------------
%                      7.68    7.71    7.74    7.71
%                      7.69    7.73    7.75    7.71
%                      7.70    7.74    7.77    7.74
%                      7.70    7.74    7.78    7.79
%                      7.72    7.78    7.80    7.81
%                      7.73    7.78    7.81    7.85
%                      7.73    7.80    7.84    7.87
%                      7.76    7.81            7.91
%                   ---------------------------------
%                                       
%       Data matrix must be:
%    X=[7.68 1;7.69 1;7.70 1;7.70 1;7.72 1;7.73 1;7.73 1;7.76 1;7.71 2;7.73 2;7.74 2;7.74 2;
%    7.78 2;7.78 2;7.80 2;7.81 2;7.74 3;7.75 3;7.77 3;7.78 3;7.80 3;7.81 3;7.84 3;7.71 4;7.71 4;
%    7.74 4;7.79 4;7.81 4;7.85 4;7.87 4;7.91 4];
%
%
%           Calling on Matlab the function: dunn(X) (there is not a control group)
%
%           Answer is:
%
%           STEPDOWN DUNN TEST FOR NON PARAMETRIC MULTIPLE COMPARISONS
%  
%           Group     N            Sum of ranks         Mean rank
%            1        8                55.00                6.88
%            2        8               132.50               16.56
%            3        7               145.00               20.71
%            4        8               163.50               20.44
%  
%            Ties factor: 168
%  
%            Test        Q-value        Critical Q         Comment
%            3 vs 1      2.9493         2.6310             Reject Ho
%            3 vs 2      0.9159         2.6310             Fail to reject Ho
%            3 vs 4      No comparison made                Accept Ho
%            4 vs 1      2.8904         2.6310             Reject Ho
%            4 vs 2      0.8548         2.6310             Fail to reject Ho
%            2 vs 1      2.0645         2.6310             Fail to reject Ho
%  
%            Resuming...
%                 0     0     1     1
%                 0     0     0     0
%                 0     0     0     0
%                 0     0     0     0
%
%           Calling on Matlab the function: dunn(X,1) (sample 1 is the control group)
%
%           Answer is:
%
%              Group      N            Sum of ranks         Mean rank
%                1        8               55.00                6.88
%                2        8              132.50               16.56
%                3        7              145.00               20.71
%                4        8              163.50               20.44
%  
%               Ties factor: 168
%  
%               Test        Q-value        Critical Q         Comment
%               1 vs 2      2.1370         2.3940             Fail to reject Ho
%               1 vs 3      2.9493         2.3940             Reject Ho
%               1 vs 4      2.9918         2.3940             Reject Ho
%  
%               Resuming...
%                    0     0     1     1
%
%           Created by Giuseppe Cardillo
%           giuseppe.cardillo-edta@poste.it
%
% To cite this file, this would be an appropriate format:
% Cardillo G. (2006). Dunn�s Test: a procedure for multiple, not
% parametric, comparisons.
% http://www.mathworks.com/matlabcentral/fileexchange/12827

%Input Error handling
global I J Mr N f vcrit comp

args=cell(varargin);
nu=numel(args);
if nu>2 || nu<1
    error('Warning: One or two input values are required')
end
default.values = {[],0};
default.values(1:nu) = args;
[x ctrl] = deal(default.values{:});
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
    error('Warning: DUNN requires a Nx2 input matrix')
end
%check if x(:,2) are all whole elements
if ~all(x(:,2) == round(x(:,2)))
    error('Warning: all elements of column 2 of input matrix must be whole numbers')
end
if nu>1 %check the ctrl value
    if ~isscalar(ctrl) || ~isfinite(ctrl) || ~isnumeric(ctrl) || isempty(ctrl)
        error('Warning: it is required a scalar, numeric and finite CTRL value.')
    end
    if ctrl ~= 0 && ctrl ~= 1 %check if tst is 0 or 1
        error('Warning: CTRL must be 0 for multiple comparisons without a control group or 1 if a control group is present.')
    end
end
clear args default nu

disp('STEPDOWN DUNN TEST FOR NON PARAMETRIC MULTIPLE COMPARISONS')
disp(' ')
k=max(x(:,2)); %number of groups
N=crosstab(x(:,2)); %elements for each group
tot=sum(N); %total elements
R=ones(1,k); Mr=ones(k,2); %preallocation of sum of ranks and mean rank vectors
[r,t]=tiedrank(x(:,1)); %ranks and ties
f=(tot*(tot+1)/12)-(t/(6*(tot-1))); %costant denominator factor with ties correction

disp('Group     N            Sum of ranks         Mean rank')
for I=1:k
    R(I)=sum(r(x(:,2)==I)); %sum of ranks of each group
    Mr(I,1)=R(I)/N(I); %mean ranks of each group 
    Mr(I,2)=I;
    fprintf(' %d        %d          %11.2f         %11.2f\n',I,N(I),R(I),Mr(I,1))
end
disp(' ')
fprintf('Ties factor: %d\n',2*t)
disp(' ')
clear idx R r t %clear unnecessary variables

disp('Test        Q-value        Critical Q         Comment')
switch ctrl
    case 0 %Without control group
        kstar = 0.5*k*(k-1);
        alf = 1-0.95.^(1/kstar); %Sidak's value of alpha
        vcrit = -realsqrt(2)*erfcinv(2-alf); %critical value
        H=triu(ones(k,k),1); %preallocation of resuming matrix
        Mr=sortrows(Mr,-1); %sort the mean ranks;
        %In the second column of Mr there is the groups index. When sorted, this
        %index will be used by Qvalue function to point the correct N values
        %Compare the biggest mean rank with the lowest;
        %then check with the second and so on...
        %If there is no difference (Q<=vcrit) the intermediate comparisons
        %are unnecessary.
        for I=1:k-1
            comp=1; %Comparison checker
            for J=k:-1:I+1
                if comp %Comparison is necessary
                    Qvalue
                    if comp==0
                        H(min(Mr([I J],2)),max(Mr([I J],2)))=0;
                    end
                else %Comparison is not necessary
                    fprintf('%d vs %d      No comparison made                Accept Ho\n',Mr(I,2),Mr(J,2))
                    H(min(Mr([I J],2)),max(Mr([I J],2)))=0;
                end
            end
        end
    case 1 %With control group
        %Qcrit is the matrix of critical values (I don't know the Dunn
        %distribution in this case) as reported in Stanton A. Glantz.
        %Critical value is the kth value.
        I=1;
        Qcrit=[0 1.960 2.242 2.394 2.498 2.576 2.639 2.690 2.735 2.773 2.807 2.838 2.866 2.891 2.914 2.936 2.955 2.974 2.992 3.008 3.024 3.038 3.052 3.066 3.078];
        vcrit=Qcrit(k);
        clear Qcrit %clear unnecessary matrix
        H=ones(1,k); H(1)=0; %preallocation of resuming vector
        for J=2:k
            Qvalue
            if comp==0
                H(J)=0;
            end
        end
end
disp(' ')
disp('Resuming...')
disp(H)
return

function Qvalue
global I J Mr N f vcrit comp
num=abs(diff(Mr([I J]))); %Numerator is the absolute difference of the mean ranks
denom=sqrt(f*sum(1./N(Mr([I J],2)))); %Complete Denominator with ties correction
Q=num/denom; %Q value
if Q>vcrit
    fprintf('%d vs %d %11.4f    %11.4f             Reject Ho\n',Mr(I,2),Mr(J,2),Q,vcrit)
    comp=1; %more comparisons are required
elseif Q<=vcrit
    fprintf('%d vs %d %11.4f    %11.4f             Fail to reject Ho\n',Mr(I,2),Mr(J,2),Q,vcrit)
    comp=0; %No more intermediate comparisons are required
end
return
